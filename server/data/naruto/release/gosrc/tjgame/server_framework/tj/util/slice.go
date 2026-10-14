package util

func SliceGet(miv interface{}, args ...interface{}) (interface{}, bool) {
	var iv interface{}
	m := miv.([]interface{})
	for i, k := range args {
		idx := -1
		switch v := k.(type) {
		case int:
			idx = v
		case int32:
			idx = int(v)
		case int64:
			idx = int(v)
		default:
			return nil, false
		}
		if 0 <= idx && idx < len(m) {
			iv = m[idx]
			if i >= len(args)-1 {
				continue
			}
			switch v := iv.(type) {
			case []interface{}:
				m = v
			default:
				return MapGet(iv, args[i+1:]...)
			}
		} else {
			return nil, false
		}
	}
	return iv, true
}

func SliceDelete(miv interface{}, index int) interface{} {
	m := miv.([]interface{})
	return append(m[:index], m[index+1:]...)
}

func SliceDeleteDisorder(miv interface{}, index int) interface{} {
	m := miv.([]interface{})
	m[index] = m[len(m)-1]
	return m[:len(m)-1]
}
