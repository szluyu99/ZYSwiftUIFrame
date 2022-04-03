package service

import (
	"fmt"

	"github.com/yusael/go_api_server/global"
	"github.com/yusael/go_api_server/model"
	"github.com/yusael/go_api_server/model/common/request"
)

type UserService struct{}

func (u *UserService) GetUserInfoList(info request.PageInfo) (records interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.DB.Model(&model.SysUser{})
	if err = db.Count(&total).Error; err != nil {
		fmt.Println("GetUserInfoList Service Error!")
		return
	}
	var userRecords []model.SysUser
	// Limit 指定获取记录的最大数量 Offset 指定在开始返回记录之前要跳过的记录数量
	err = db.Limit(limit).Offset(offset).Find(&userRecords).Error
	return userRecords, total, err
}
