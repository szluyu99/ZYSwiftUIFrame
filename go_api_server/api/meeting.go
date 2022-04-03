package api

import (
	"fmt"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/yusael/go_api_server/model/common/request"
	"github.com/yusael/go_api_server/model/common/response"
)

type MeetingApi struct{}

// 分页获取会议列表
func (m *MeetingApi) GetPageList(c *gin.Context) {
	var pageInfo request.PageInfo

	_ = c.ShouldBindJSON(&pageInfo)

	records, total, err := meetingService.GetMeetingList(pageInfo)
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

// 获取详情
func (m *MeetingApi) GetDetail(c *gin.Context) {
	id, _ := strconv.Atoi(c.Query("id"))
	meeting, err := meetingService.GetMeetingDetail(id)
	if err != nil {
		response.FailWithMessage("操作失败", c)
		return
	}
	response.OkWithDetail(meeting, "操作成功", c)
}

// 删除
func (m *MeetingApi) Delete(c *gin.Context) {
	id, _ := strconv.Atoi(c.Query("id"))

	if _, err := meetingService.GetMeetingDetail(id); err != nil {
		response.FailWithMessage("删除失败，没有这条数据", c)
		return
	}
	if err := meetingService.DeleteMeeting(id); err != nil {
		response.FailWithMessage(fmt.Sprintf("删除失败：%v", err), c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

// 新增 / 更新
func (m *MeetingApi) SaveOrUpdate(c *gin.Context) {
	var meetingReq request.ChangeMeetingInfo
	if err := c.ShouldBindJSON(&meetingReq); err != nil {
		response.FailWithMessage(fmt.Sprintf("传递参数有误：%s", err), c)
		return
	}
	if err := meetingService.SaveOrUpdateMeeting(&meetingReq); err != nil {
		response.FailWithMessage(fmt.Sprintf("操作失败：%s", err), c)
		return
	}
	response.OkWithMessage("操作成功", c)
}
