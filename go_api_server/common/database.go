package common

import (
	"fmt"

	"github.com/spf13/viper"
	"github.com/yusael/go_api_server/global"
	"github.com/yusael/go_api_server/model"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/schema"
)

func InitDB() *gorm.DB {
	// 参考 https://github.com/go-sql-driver/mysql#dsn-data-source-name 获取详情
	// dsn := "user:pass@tcp(127.0.0.1:3306)/dbname?charset=utf8mb4&parseTime=True&loc=Local"
	// db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})

	host := viper.GetString("datasource.host")
	port := viper.GetString("datasource.port")
	database := viper.GetString("datasource.database")
	username := viper.GetString("datasource.username")
	password := viper.GetString("datasource.password")

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		username, password, host, port, database)
	DB, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
		SkipDefaultTransaction: true, // 跳过默认事务
		NamingStrategy: schema.NamingStrategy{
			SingularTable: true, // 使用单数表名, `User` 的表名为 `user`
		},
		DisableForeignKeyConstraintWhenMigrating: true, // 禁用外键, 使用逻辑外键
	})
	if err != nil {
		panic("failed to connect database, err: " + err.Error())
	}
	fmt.Println("connect database successfully!")

	DB.AutoMigrate(&model.UploadAndDownload{}, &model.SysUser{}, &model.Meeting{}, &model.Message{})
	global.DB = DB // 注册到全局对象
	return DB
}
