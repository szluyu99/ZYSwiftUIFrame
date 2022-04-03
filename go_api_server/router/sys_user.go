package router

import (
	"github.com/gin-gonic/gin"
	"github.com/yusael/go_api_server/api"
)

type UserRouter struct{}

func (r *UserRouter) InitUserRouter(router *gin.Engine) {
	userRouter := router.Group("/user")

	userRouter.POST("/getPageList", api.ApiGroupApp.UserApi.GetPageList)
}
