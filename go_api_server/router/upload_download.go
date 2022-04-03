package router

import (
	"github.com/gin-gonic/gin"
	"github.com/yusael/go_api_server/api"
)

type uploadAndDownloadRouter struct{}

func (f *uploadAndDownloadRouter) InitUploadAndDownloadRouter(router *gin.Engine) {
	fileUploadAndDownloadRouter := router.Group("/uploadAndDownload")

	uploadAndDownloadApi := api.ApiGroupApp.UploadAndDownloadApi
	{
		fileUploadAndDownloadRouter.POST("upload", uploadAndDownloadApi.UploadFile)
		fileUploadAndDownloadRouter.GET("delete", uploadAndDownloadApi.DeleteFile)
	}
}
