package task

type TaskEnterOK struct {
}

// only s->c, run by server
func (t *TaskEnterOK) Run(record *Record) interface{} {
	record.conn.Close()
	return nil
}

func (TaskEnterOK) Url() string {
	return "/login/ok"
}

func (TaskEnterOK) New() Task {
	return &TaskEnterOK{}
}
