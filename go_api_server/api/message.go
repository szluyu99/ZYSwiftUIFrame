package api

import (
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/yusael/go_api_server/model/common/request"
	"github.com/yusael/go_api_server/model/common/response"
)

type MessageApi struct{}

// 分页获取消息列表
func (m *MessageApi) GetPageList(c *gin.Context) {
	var pageInfo request.PageInfo
	_ = c.ShouldBindJSON(&pageInfo)

	records, total, err := messageService.GetMessageList(pageInfo)
	if err != nil {
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetail(response.PageResult{
		Total:    total,
		Page:     pageInfo.Page,
		PageSize: pageInfo.PageSize,
		Records:  records,
	}, "获取成功", c)
}

// 获取消息详情
func (m *MessageApi) GetDetail(c *gin.Context) {
	id, _ := strconv.Atoi(c.Query("id"))
	message, err := messageService.GetMessageDetail(id)
	if err != nil {
		response.FailWithMessage("数据不存在", c)
		return
	}
	response.OkWithDetail(message, "操作成功", c)
}

// 删除消息
func (m *MessageApi) Delete(c *gin.Context) {
	id, _ := strconv.Atoi(c.Query("id"))
	if err := messageService.DeleteMessageDetail(id); err != nil {
		response.FailWithMessage("操作失败", c)
		return
	}
	response.OkWithMessage("操作成功", c)
}
