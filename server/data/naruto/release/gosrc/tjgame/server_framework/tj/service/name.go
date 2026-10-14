package service

import (
	"fmt"
	"strconv"
	"strings"
)

func MakeServiceName(service, language string, id int) string {
	if id <= 0 {
		panic("services id must be a positive number")
	}
	if strings.IndexByte(service, '.') > -1 || strings.IndexByte(language, '.') > -1 {
		panic("services or language may be contain dot")
	}
	return fmt.Sprintf("%s.%s.%d", service, language, id)
}

func SplitServiceName(name string) (string, string, int) {
	ss := strings.Split(name, ".")
	if len(ss) < 1 || len(ss) > 3 {
		panic("services name error")
	}

	if len(ss) == 1 {
		return name, "", 0
	} else if len(ss) < 3 {
		return ss[0], ss[1], 0
	}

	id, err := strconv.Atoi(ss[2])
	if err != nil {
		panic(err)
	}
	return ss[0], ss[1], id
}

func Game2PVPService(name string) string {
	return TransformName(name, "pvp")
}

func Gamemerge2PVPService(name string, service string) string {
	key, language, id := SplitServiceName(name)
	f := strings.HasSuffix(key, "merge")
	if f {
		service = service + "merge"
	}
	return MakeServiceName(service, language, id)
}

func TransformName(name string, service string) string {
	_, language, id := SplitServiceName(name)
	return MakeServiceName(service, language, id)
}

func TransformNames(names []string, service string, merge bool) []string {
	services := make([]string, 0, len(names)*2)
	for _, name := range names {
		if merge {
			services = append(services, name)
		}
		services = append(services, TransformName(name, service))
	}
	return services
}
