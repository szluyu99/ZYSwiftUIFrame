package main

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/spf13/viper"
	"github.com/yusael/go_api_server/common"
	"github.com/yusael/go_api_server/router"
	"github.com/yusael/go_api_server/service"
)

func main() {
	// 初始化 Viper 的配置文件
	InitViperConfig()

	// 初始化数据库
	common.InitDB()
	// 初始化数据库数据
	InitDBData()

	r := gin.Default()
	r = router.CollectionRoutes(r) // 注册路由

	r.Run() // 监听并在 0.0.0.0:8080 上启动服务
}

// 读取配置文件
func InitViperConfig() {
	workDir, _ := os.Getwd()
	viper.SetConfigName("application")       // 文件名
	viper.SetConfigType("yml")               // 文件类型
	viper.AddConfigPath(workDir + "/config") // 文件路径
	if err := viper.ReadInConfig(); err != nil {
		fmt.Println("configuration reading failed: ", err)
		panic(err) // 程序终止运行
	}
	fmt.Println("configuration reading successed!")
}

// 初始化数据库数据
func InitDBData() {
	service.ServiceGroupApp.InitMessageData()
	service.ServiceGroupApp.InitMeetingData()
}
