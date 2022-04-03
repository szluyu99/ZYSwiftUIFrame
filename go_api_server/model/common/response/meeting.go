package response

import "github.com/yusael/go_api_server/model"

type MeetingResp struct {
	ID uint `json:"id" gorm:"primarykey"`
	// model.BaseModel
	MtName     string `json:"mtName" gorm:"comment:会议名称"`
	MtTheme    string `json:"mtTheme" gorm:"comment:会议主题"`
	MtSummary  string `json:"mtSummary" gorm:"comment:会议概要"`
	MtContent  string `json:"mtContent" gorm:"comment:会议内容"`
	MtMember   string `json:"mtMember" gorm:"comment:参会人员"`
	MtTime     string `json:"mtTime" gorm:"comment:开会时间"`
	CreateUser int    `json:"createUser" gorm:"comment:创建人"`
	// 1 个会议可以有多个 图片
	AnList []model.UploadAndDownload `json:"anList" gorm:"foreignKey:MeetingID"`
}
