package router

import (
	"github.com/gin-gonic/gin"
	"github.com/yusael/go_api_server/api"
)

type MeetingRouter struct{}

func (r *MeetingRouter) InitMeetingRouter(router *gin.Engine) {
	meetingRouter := router.Group("/meeting")

	meetingApi := api.ApiGroupApp.MeetingApi
	{
		meetingRouter.POST("/getPageList", meetingApi.GetPageList)
		meetingRouter.GET("/detail", meetingApi.GetDetail)
		meetingRouter.GET("/delete", meetingApi.Delete)
		meetingRouter.POST("/saveOrUpdate", meetingApi.SaveOrUpdate)
	}
}
