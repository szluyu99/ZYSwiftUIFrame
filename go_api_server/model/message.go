package model

type Message struct {
	BaseModel
	Theme       string `json:"theme" gorm:"comment:消息标题"`
	Content     string `json:"content" gorm:"comment:消息内容"`
	IsRead      int    `json:"isRead" gorm:"comment:是否已读"`
	ReceiveUser int    `json:"receiveUser" gorm:"comment:接收人id"`
	SendUser    int    `json:"sendUser" gorm:"comment:发送人id"`
}
