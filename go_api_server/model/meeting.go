package model

import (
	"gorm.io/gorm"
)

type Meeting struct {
	BaseModel
	MtName     string `json:"mtName" gorm:"comment:会议名称"`
	MtTheme    string `json:"mtTheme" gorm:"comment:会议主题"`
	MtSummary  string `json:"mtSummary" gorm:"comment:会议概要"`
	MtContent  string `json:"mtContent" gorm:"comment:会议内容"`
	MtMember   string `json:"mtMember" gorm:"comment:参会人员"`
	MtTime     string `json:"mtTime" gorm:"comment:开会时间"`
	CreateUser int    `json:"createUser" gorm:"comment:创建人"`
	// 1 个会议可以有多个 图片
	// AnList string `json:"anList" gorm:"commit:附件列表"`
	AnList []UploadAndDownload `json:"anList"` // 外键
}

// 钩子函数: 在更新时进行调用
func (m *Meeting) BeforeUpdate(scope *gorm.DB) (err error) {
	return nil
}
