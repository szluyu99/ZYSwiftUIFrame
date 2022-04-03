package api

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/yusael/go_api_server/model/common/request"
	"github.com/yusael/go_api_server/model/common/response"
)

type UserApi struct{}

// 分页获取用户列表
func (u *UserApi) GetPageList(c *gin.Context) {
	var pageInfo request.PageInfo
	_ = c.ShouldBindJSON(&pageInfo)

	records, total, err := userService.GetUserInfoList(pageInfo)
	if err != nil {
		fmt.Println("分页获取用户列表失败!")
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetail(response.PageResult{
		Records:  records,
		Total:    total,
		Page:     pageInfo.Page,
		PageSize: pageInfo.PageSize,
	}, "获取成功", c)
}
