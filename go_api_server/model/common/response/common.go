package response

type PageResult struct {
	Total    interface{} `json:"total"`
	Page     int         `json:"page"`
	PageSize int         `json:"pageSize"`
	Records  interface{} `json:"records"`
}
