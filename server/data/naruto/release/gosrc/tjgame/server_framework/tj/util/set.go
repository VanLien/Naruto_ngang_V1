package util

var exists = struct{}{}

type Set struct {
	m map[interface{}]struct{}
}

func (s *Set) Add(items ...interface{}) {
	for _, item := range items {
		s.m[item] = exists
	}
}

func (s *Set) Discard(item interface{}) {
	delete(s.m, item)
}

func (s *Set) Contains(item interface{}) bool {
	_, ok := s.m[item]
	return ok
}

func (s *Set) Size() int {
	return len(s.m)
}

func (s *Set) Clear() {
	s.m = make(map[interface{}]struct{})
}

func (s *Set) Equal(other *Set) bool {
	if s.Size() != other.Size() {
		return false
	}
	for item := range s.m {
		if !other.Contains(item) {
			return false
		}
	}
	return true
}

func (s *Set) Range(f func(interface{}) bool) {
	for item := range s.m {
		if !f(item) {
			break
		}
	}
}

func (s *Set) Intersect(o *Set) *Set {
	ret := &Set{
		m: make(map[interface{}]struct{}, 0),
	}
	for k := range s.m {
		if o.Contains(k) {
			ret.Add(k)
		}
	}
	return ret
}

func NewSet(items ...interface{}) *Set {
	s := &Set{
		m: make(map[interface{}]struct{}, len(items)),
	}
	s.Add(items...)
	return s
}

func NewSetByStringSlice(ss []string) *Set {
	s := &Set{
		m: make(map[interface{}]struct{}, len(ss)),
	}
	for _, v := range ss {
		s.Add(v)
	}
	return s
}
