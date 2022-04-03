package service

import (
	"fmt"
	"strings"

	"github.com/yusael/go_api_server/global"
	"github.com/yusael/go_api_server/model"
	"github.com/yusael/go_api_server/model/common/request"
)

type MessageService struct{}

func (m *MessageService) GetMessageList(info request.PageInfo) (records interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.DB.Model(&model.Message{})
	if err = db.Count(&total).Error; err != nil {
		fmt.Println("GetMessageList Service Error!")
		return
	}
	var messageRecords []model.Message
	err = db.Limit(limit).Offset(offset).Find(&messageRecords).Error
	return messageRecords, total, err
}

func (m *MessageService) GetMessageDetail(id int) (message model.Message, err error) {
	err = global.DB.Where("id = ?", id).First(&message).Error
	return message, err
}

func (m *MessageService) DeleteMessageDetail(id int) (err error) {
	err = global.DB.Where("id = ?", id).Delete(&model.Message{}).Error
	return err
}

// 初始化数据库数据: 有数据就不初始化, 没有数据则增加 50 条数据
func (m *MessageService) InitMessageData() {
	var count int64
	if global.DB.Model(&model.Message{}).Count(&count); count != 0 {
		return
	}

	messageList := make([]model.Message, 0)
	for i := 0; i < 50; i++ {
		messageList = append(messageList, model.Message{
			Theme:       fmt.Sprintf("消息主题%v", i),
			Content:     strings.Repeat(fmt.Sprintf("这是消息的具体内容%v", i), 5),
			IsRead:      0,
			ReceiveUser: 0,
			SendUser:    0,
		})
	}
	if err := global.DB.Create(&messageList).Error; err != nil {
		fmt.Println("InitMessageData Error!")
	}
}
