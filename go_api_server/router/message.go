package router

import (
	"github.com/gin-gonic/gin"
	"github.com/yusael/go_api_server/api"
)

type MessageRouter struct{}

func (r *MessageRouter) InitMessageRouter(router *gin.Engine) {
	messageRouter := router.Group("/message")

	messageApi := api.ApiGroupApp.MessageApi
	{
		messageRouter.POST("/getPageList", messageApi.GetPageList)
		messageRouter.GET("/detail", messageApi.GetDetail)
		messageRouter.GET("/delete", messageApi.Delete)
	}
}
