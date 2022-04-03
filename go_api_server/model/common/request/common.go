package request

type PageInfo struct {
	Page     int `json:"page"`     // 页码
	PageSize int `json:"pageSize"` // 每页大小

	Keyword string `json:"keyword"` // 搜索关键字
}
