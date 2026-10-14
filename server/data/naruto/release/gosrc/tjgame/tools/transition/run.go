package transition

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net"
	"path"
	"strings"
	"sync"
	"sync/atomic"
	"time"
	"tjgame/document"
	"tjgame/document/scheme"
	"tjgame/server_framework/tj/log"
	"tjgame/server_framework/tj/service"
	"tjgame/services"
	"tjgame/services/cross"
	"tjgame/services/storage"
	"tjgame/tools/tunnel"

	"golang.org/x/crypto/ssh"

	"tjgame/mgo.v2/bson"

	mgo "tjgame/mgo.v2"
)

func transitionRoles(dbc service.IService, tunnel *tunnel.SSHTunnel) {
	servs := make(map[string]struct{})
	for _, role := range roles {
		key := role[0]
		if _, ok := servs[key]; !ok {
			servs[key] = struct{}{}
		}
	}

	// 1. prepare mongodb session
	mongodbSessions := make(map[string]*mgo.Session)
	ctx, cancel := context.WithCancel(context.Background())
	for key := range servs {
		mongodb := mongodbMap[strings.Replace(key, "game", "storage", 1)]
		if _, ok := mongodbSessions[mongodb]; ok {
			continue
		}
		session, err := mgo.Dial(forwardMongodb(ctx, tunnel, mongodb))
		if err != nil {
			panic(err)
		}
		session.SetPoolLimit(10)
		mongodbSessions[mongodb] = session
	}
	log.Infof("total mongodb session %d", len(mongodbSessions))

	// 2. copy roles
	total := len(roles)
	var num int64
	var wg sync.WaitGroup
	wg.Add(total)

	type args struct {
		key     string
		id      document.ID
		mongodb string
	}
	concurrence := 64
	jobs := make(chan args, concurrence)
	for i := 0; i < concurrence; i++ {
		go func() {
			for args := range jobs {
				key := args.key
				id := args.id
				mongodb := args.mongodb
				session := mongodbSessions[mongodb]
				db := dbNameFromMongoURL(mongodb)
				err := Transition(session, db, id, dbc)
				v := atomic.AddInt64(&num, 1)
				log.Infof("(%d/%d) Transition %s %v %v", v, total, key, id, err)
				wg.Done()
			}
		}()
	}

	for _, role := range roles {
		key := role[0]
		id := document.ID(bson.ObjectIdHex(role[1]))
		mongodb := mongodbMap[strings.Replace(key, "game", "storage", 1)]
		jobs <- args{
			key:     key,
			id:      id,
			mongodb: mongodb,
		}
	}
	close(jobs)
	wg.Wait()
	cancel()
}

func transitionAccounts(mongodb string, ids <-chan document.ID, dbc, rpcAccount service.IService, total int) {
	session, err := mgo.Dial(mongodb)
	if err != nil {
		return
	}
	session.SetPoolLimit(10)
	defer session.Close()

	var wg sync.WaitGroup
	wg.Add(total)

	concurrence := 64
	var count int64
	for i := 0; i < concurrence; i++ {
		go func() {
			for id := range ids {
				v := atomic.AddInt64(&count, 1)
				log.Infof("transitionAccount (%d/%d)", v, total)
				role := queryRole(id, dbc)
				if role == nil {
					log.Warningf("role %v not found", id)
					wg.Done()
					continue
				}
				name, err := CopyAccount(session, role.AccountId, rpcAccount)
				if err != nil {
					log.Warningf("CopyAccount %s error %s", role.AccountId, err)
					// delete
					resp, _ := service.Call(rpcAccount, "AccountQueryByName", name)
					r := resp.(storage.Response)
					if r.Model != nil {
						service.Call(rpcAccount, "DBDelete", "Account", r.Model.(*scheme.Account).ID, false)
						CopyAccount(session, role.AccountId, rpcAccount)
					}
				}
				wg.Done()
			}
		}()
	}
	wg.Wait()
}

func queryAccounts(ids <-chan document.ID, dbc, rpcAccount service.IService, wg *sync.WaitGroup, total int) {
	concurrence := 64
	var count int64
	for i := 0; i < concurrence; i++ {
		go func() {
			for id := range ids {
				v := atomic.AddInt64(&count, 1)

				role := queryRole(id, dbc)
				if role == nil {
					log.Warningf("role %v not found", id)
					wg.Done()
					continue
				}
				account := queryAccount(role.AccountId, rpcAccount)
				if account == nil {
					log.Infof("(%d/%d) account NotFound role %v uid %d name %s", v, total, role.ID, role.UID, role.Name)
				} else {
					log.Infof("(%d/%d) account %s role %v uid %d name %s", v, total, account.Name, role.ID, role.UID, role.Name)
				}
				wg.Done()
			}
		}()
	}
}

var (
	container  *service.Container
	once       sync.Once
	dev        = true
	keyfile    string
	account    string
	tunnelAddr string
	roles      = [][2]string{}
)

func init() {
	addrs, err := net.InterfaceAddrs()
	if err != nil {
		panic(err)
	}
	for _, address := range addrs {
		// 检查ip地址判断是否回环地址
		if ipnet, ok := address.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				addr := ipnet.IP.String()
				dev = strings.HasPrefix(addr, "192.168")
				break
			}
		}
	}
	fmt.Printf("dev %v\n\n", dev)
}

func startContainer() {
	once.Do(func() {
		option := service.ContainerOption{
			Name:            "container.test.1",
			Debug:           true,
			NSQLookupd:      "http://192.168.1.125:4161/",
			NSQTcpAddresses: []string{"192.168.1.125:4150", "192.168.1.125:4140"},
			Services:        []service.IOption{},
		}
		if !dev {
			option.NSQLookupd = "http://127.0.0.1:5161/"
			option.NSQTcpAddresses = []string{"127.0.0.1:5150"}
		}

		container = service.NewContainer(option, services.Factory)

		container.Init()
		container.Start()
	})
	time.Sleep(3 * time.Second)
	if dev { // 内网环境
		cross.ContainerServices(container, "storage.dev.1", "accountdb.dev.1")
	} else { // 外网体验服
		cross.ContainerServices(container, "storage.cn.1", "accountdb.trial.1")
	}
}

func forwardMongodb(ctx context.Context, tunnel *tunnel.SSHTunnel, url string) string {
	s := strings.Split(url, "@")[1]
	s = strings.Split(s, "/")[0]
	addr := s
	var err error
	if tunnel != nil {
		addr, err = tunnel.Forward(ctx, "localhost:", s)
		if err != nil {
			panic(err)
		}
	}
	log.Infof("%s --> %s", s, addr)
	return strings.Replace(url, s, addr, 1)
}

func init() {
	config := struct {
		MongoDir   string `json:"mongoDir"`
		TunnelAddr string `json:"tunnelAddr"`
		Account    string `json:"account"`
		Keyfile    string `json:"keyfile"`
	}{}
	data, err := ioutil.ReadFile("defines.json")
	if err == nil {
		err = json.Unmarshal(data, &config)
	}
	if err != nil {
		panic(err)
	}

	rr := make([][2]string, 0, 64)
	data, err = ioutil.ReadFile("roles.json")
	if err == nil {
		err = json.Unmarshal(data, &rr)
	}
	if err != nil {
		panic(err)
	}
	roles = rr
	keyfile = config.Keyfile
	account = config.Account
	tunnelAddr = config.TunnelAddr

	dir, err := ioutil.ReadDir(config.MongoDir)
	if err != nil {
		panic(err)
	}
	for _, fi := range dir {
		if !fi.IsDir() {
			ok := strings.HasSuffix(fi.Name(), ".json")
			if ok {
				LoadStorageDefines(path.Join(config.MongoDir, fi.Name()))
			}
		}
	}
	SlimMerged()
}

func rangeRoles() (int, <-chan document.ID) {
	total := len(roles)
	ids := make(chan document.ID, 24)
	go func() {
		for _, role := range roles {
			id := document.ID(bson.ObjectIdHex(role[1]))
			ids <- id
		}
		close(ids)
	}()
	return total, ids
}

func Run(model, filename string) {
	startContainer()
	defer container.Stop()

	dbc := container.GetServices("^storage")[0]
	rpcAccount := container.GetServices("^accountdb")[0]

	gmTunnel := tunnel.NewSSHTunnel(tunnelAddr, &ssh.ClientConfig{
		User:            "root",
		Auth:            []ssh.AuthMethod{tunnel.PrivateKeyFile(keyfile)},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
	})

	transitionRole := false
	transitionAccount := false
	queryAccount := false

	switch model {
	case "all":
		transitionRole = true
		transitionAccount = true
		queryAccount = true
	case "account":
		transitionRole = false
		transitionAccount = true
		queryAccount = true
	case "query":
		transitionRole = false
		transitionAccount = false
		queryAccount = true
	default:
		panic("only all/account/query")
	}

	// transition Role
	s1 := time.Now()
	if transitionRole {
		transitionRoles(dbc, gmTunnel)
	}
	s2 := time.Now()

	// transition Account
	{
		if transitionAccount {
			mongodb := mongodbMap[account]
			ctx, cancel := context.WithCancel(context.Background())
			if !strings.Contains(account, "dev") {
				mongodb = forwardMongodb(ctx, gmTunnel, mongodb)
			}
			total, ids := rangeRoles()
			transitionAccounts(mongodb, ids, dbc, rpcAccount, total)
			cancel()
		}
	}
	s3 := time.Now()
	gmTunnel.Stop()

	// Account Query
	{
		if queryAccount {
			total, ids := rangeRoles()
			var wg sync.WaitGroup
			wg.Add(total)
			queryAccounts(ids, dbc, rpcAccount, &wg, total)
			wg.Wait()
		}
	}
	s4 := time.Now()

	log.Infof("transitionRoles %s", s2.Sub(s1))
	log.Infof("transitionAccounts %s", s3.Sub(s2))
	log.Infof("queryAccounts %s", s4.Sub(s3))
}

func Download(serv, rid string, uid int, filename string) {
	mongodb := mongodbMap[strings.Replace(serv, "game", "storage", 1)]
	db := ""
	if strings.Contains(serv, "dev") {
		db = "game_dev" + strings.Split(serv, ".")[2]
	} else {
		db = dbNameFromMongoURL(mongodb)
	}
	session, err := mgo.Dial(mongodb)
	if err != nil {
		panic(err)
	}

	delivery := &Delivery{
		session: session,
		dbName:  db,
		db:      session.DB(db),
	}
	if rid != "" {
		delivery.id = document.ID(bson.ObjectIdHex(rid))
	} else {
		delivery.uid = uid
	}

	// acquire role
	err = delivery.acquire(false)

	// acquire account
	if err == nil {
		mongodb = mongodbMap[account]
		session, err := mgo.Dial(mongodb)
		if err != nil {
			panic(err)
		}
		err = delivery.acquireAccount(session)
	}

	if err == nil {
		_, err = dump(delivery.payload, filename)
	}

	if err != nil {
		panic(err)
	}
}

func Upload(filename string) {
	startContainer()
	defer container.Stop()
	dbc := container.GetServices("^storage")[0]
	rpcAccount := container.GetServices("^accountdb")[0]

	// upload role data
	id, account, err := upload(filename, dbc)
	if err != nil {
		log.Infof("update role error %v", err)
		return
	}

	// upload account
	_, err = service.Call(rpcAccount, "Transition", "Account", account.ID, account)
	if err != nil {
		log.Warningf("CopyAccount %s error %s", account.ID, err)
		// delete
		resp, _ := service.Call(rpcAccount, "AccountQueryByName", account.Name)
		r := resp.(storage.Response)
		if r.Model != nil {
			service.Call(rpcAccount, "DBDelete", "Account", r.Model.(*scheme.Account).ID, false)
			service.Call(rpcAccount, "Transition", "Account", id, account)
		}
	}
	ids := make(chan document.ID, 1)
	ids <- id
	close(ids)

	var wg sync.WaitGroup
	wg.Add(1)
	queryAccounts(ids, dbc, rpcAccount, &wg, 1)
	wg.Wait()
}

func upload(filename string, s service.IService) (document.ID, *scheme.Account, error) {
	payload, err := load(filename)
	if err == nil {
		_, _, area := service.SplitServiceName(s.Name())
		payload.Role.Name = fmt.Sprintf("%s.%d", payload.Role.Name, payload.Role.Area)
		payload.Role.Area = area
		err = payload.commit(s)
	}
	if payload == nil {
		return "", nil, err
	}
	return payload.Role.ID, payload.Account, err
}
