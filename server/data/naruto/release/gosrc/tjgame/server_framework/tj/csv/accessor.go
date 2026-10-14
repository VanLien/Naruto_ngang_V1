package csv

import "strconv"

type Map map[interface{}]interface{}
type Slice []interface{}

func (m Map) GetMap(idx interface{}) Map {
	if v, ok := m[idx]; ok {
		return v.(Map)
	}
	return nil
}

func (m Map) GetSlice(idx interface{}) Slice {
	if v, ok := m[idx]; ok {
		return v.(Slice)
	}
	return nil
}

func (m Map) ToIntMap() map[int]int {
	ret := make(map[int]int)
	for k, v := range m {
		// interface is int64 type, See DecodeNaked
		ret[int(k.(int64))] = int(v.(int64))
	}
	return ret
}

func (m Map) ToIntFloatMap() map[int]float64 {
	ret := make(map[int]float64)
	for k, v := range m {
		// interface is int64 type, See DecodeNaked
		ret[int(k.(int64))] = v.(float64)
	}
	return ret
}

func (m Map) ToAttributeMap() map[int]AttributeCell {
	ret := make(map[int]AttributeCell)
	for k, v := range m {
		ret[int(k.(int64))] = NewAttributeCell(v)
	}
	return ret
}

func (s Slice) GetMap(idx int) Map {
	return s[idx].(Map)
}

func (s Slice) GetSlice(idx int) Slice {
	return s[idx].(Slice)
}

func (s Slice) ToIntSlice() []int {
	ints := make([]int, len(s))
	for i, v := range s {
		// interface is int64 type, See DecodeNaked
		ints[i] = int(v.(int64))
	}
	return ints
}

func (s Slice) ToFloat64Slice() []float64 {
	ints := make([]float64, len(s))
	for i, v := range s {
		switch vv := v.(type) {
		case float64: // interface is float64 type, See DecodeNaked
			ints[i] = vv
		case int64:
			ints[i] = float64(vv)
		default:
			panic("nonsupport")
		}
	}
	return ints
}

func (s Slice) ToStringSlice() []string {
	ss := make([]string, len(s))
	for i, v := range s {
		ss[i] = v.(string)
	}
	return ss
}

// 配表属性加成配置方式,支持
//{9=10%;10=10%;11=1000}
type AttributeCell struct {
	Value   float64
	Percent bool
}

func NewAttributeCell(v interface{}) AttributeCell {
	var cell AttributeCell
	switch vv := v.(type) {
	case string:
		cell.Percent = true
		if v, err := strconv.ParseFloat(vv[:len(vv)-1], 64); err != nil {
			panic(err)
		} else {
			cell.Value = v / 100
		}
	case int64:
		cell.Value = float64(vv)
	case float64:
		cell.Value = vv
	default:
		panic("unsupport")
	}
	return cell
}
