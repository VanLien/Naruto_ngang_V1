package document

import (
	"encoding/hex"
	"errors"
	"fmt"
	"strconv"
	"tjgame/server_framework/tj/util"
	"tjgame/ugorji_go/codec"

	"tjgame/mgo.v2/bson"
)

//48 -> 24, temp fix
func fix(s string) string {
	if len(s) == 48 {
		i, err := hex.DecodeString(s)
		if err == nil {
			s = string(i)
		} else {
			return s
		}
	}
	if len(s) == 12 {
		id := bson.ObjectId(s)
		s = id.Hex()
	}
	return s
}

type ID bson.ObjectId

func NewID() ID {
	return ID(bson.NewObjectId())
}

func (id ID) GetMKey() (string, error) {
	i := bson.ObjectId(id)
	if !i.Valid() {
		return "", errors.New(fmt.Sprintf("id key %v length %d invalid", i, len(i)))
	}
	return bson.ObjectId(id).Hex(), nil
}

func (id *ID) SetMKey(s string) error {
	s = fix(s) // temp fix
	*id = ID(bson.ObjectIdHex(s))
	return nil
}

func (id ID) GetBSON() (interface{}, error) {
	if id == "" {
		return (*bson.ObjectId)(nil), nil
	}
	i := bson.ObjectId(id)
	if !i.Valid() {
		panic(fmt.Sprintf("%v invalid", id))
	}
	return i, nil
}

func (id *ID) SetBSON(raw bson.Raw) error {
	var s string
	if err := raw.Unmarshal(&s); err != nil {
		return err
	}
	if s != "" {
		i := bson.ObjectId(s)
		if !i.Valid() {
			return errors.New(fmt.Sprintf("id %v length %d invalid", i, len(i)))
		}
	}
	*id = ID(s)
	return nil
}

func (id ID) String() string {
	return fmt.Sprintf(`IDHex("%x")`, string(id))
}

func (id *ID) CodecEncodeSelf(e *codec.Encoder) {
	if id == nil || *id == "" {
		e.Encode(nil)
	} else {
		e.Encode(bson.ObjectId(*id))
	}
}

func (id *ID) CodecDecodeSelf(e *codec.Decoder) {
	var i bson.ObjectId
	if err := e.Decode(&i); err != nil {
		panic(err)
	}
	if i != "" && !i.Valid() {
		panic(fmt.Sprintf("id %v length %d invalid", i, len(i)))
	}
	*id = ID(i)
}

type DocumentID struct {
	ID ID `bson:"_id,omitempty" codec:"id,omitempty"`
}

func (d *DocumentID) GetID() ID {
	return d.ID
}

func (d *DocumentID) SetID(id ID) {
	d.ID = id
}

type Integer int

func (n Integer) GetMKey() (string, error) {
	return strconv.Itoa(int(n)), nil
}

func (n *Integer) SetMKey(s string) error {
	num, err := strconv.Atoi(s)
	if err != nil {
		return err
	}
	*n = Integer(num)
	return nil
}

// Raw represents msgpack raw formatted bytes
type Raw []byte

func (m *Raw) CodecEncodeSelf(e *codec.Encoder) {
	v := codec.Raw(*m)
	e.MustEncode(v)
}

func (m *Raw) CodecDecodeSelf(e *codec.Decoder) {
	var v codec.Raw
	e.MustDecode(&v)
	*m = Raw(v)
}

// deprecated, use document.Raw
type RawMap map[interface{}]interface{}

func (m *RawMap) SetBSON(raw bson.Raw) error {
	var data []byte
	err := raw.Unmarshal(&data)
	if err != nil {
		return err
	}
	*m = make(RawMap)
	return util.MsgUnpack(data, m)
}

func (m RawMap) GetBSON() (interface{}, error) {
	return util.MsgPack(m)
}

// 所有道具、碎片、卡牌等参数map形式的配置
type CardAward struct {
	ID        int            `bson:"id" codec:"id"`
	Star      int            `bson:"star,omitempty" codec:"star,omitempty"`
	Gender    int            `bson:"gender,omitempty" codec:"gender,omitempty"`
	Character int            `bson:"character,omitempty" codec:"character,omitempty"`
	NValue    map[string]int `bson:"nvalue,omitempty" codec:"nvalue,omitempty"`
}

type GoodsMap struct {
	Type1 map[Integer]int `bson:"type1,omitempty" codec:"type1,omitempty"`
	Type2 map[string]int  `bson:"type2,omitempty" codec:"type2,omitempty"`

	Card            *CardAward      `bson:"card,omitempty" codec:"card,omitempty"`
	Cards           []CardAward     `bson:"cards,omitempty" codec:"cards,omitempty"`
	Libs            []int           `bson:"libs,omitempty" codec:"libs,omitempty"`
	StarSkillPoints map[Integer]int `bson:"star_skill_points,omitempty" codec:"star_skill_points,omitempty"`
}

type WeightID struct {
	ID      ID
	Weights map[string]int
}

type SortIDRanks struct {
	Keys []string
	Ids  []WeightID
}

func (r *SortIDRanks) Len() int {
	return len(r.Ids)
}

func (r *SortIDRanks) Less(i, j int) bool {
	for _, key := range r.Keys {
		if r.Ids[i].Weights[key] == r.Ids[j].Weights[key] {
			continue
		}
		return r.Ids[i].Weights[key] < r.Ids[j].Weights[key]
	}
	return r.Ids[i].ID < r.Ids[j].ID
}

func (r *SortIDRanks) Swap(i, j int) {
	r.Ids[i], r.Ids[j] = r.Ids[j], r.Ids[i]
}
