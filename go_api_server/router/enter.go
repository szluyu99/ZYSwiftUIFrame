package router

import "github.com/gin-gonic/gin"

type RouterGroup struct {
	UserRouter
	MeetingRouter
	MessageRouter
	uploadAndDownloadRouter // 文件上传、下载
}

var RouterGroupApp = new(RouterGroup)

func CollectionRoutes(r *gin.Engine) *gin.Engine {
	RouterGroupApp.InitUserRouter(r)              // 注册用户路由
	RouterGroupApp.InitMeetingRouter(r)           // 注册会议路由
	RouterGroupApp.InitMessageRouter(r)           // 注册消息路由
	RouterGroupApp.InitUploadAndDownloadRouter(r) // 文件上传和下载

	// 允许访问本地文件
	r.Static("/uploads/file", "./uploads/file")

	return r
}
