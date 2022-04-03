package api

import (
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/yusael/go_api_server/model/common/response"
)

type UploadAndDownloadApi struct{}

// 上传文件
func (u *UploadAndDownloadApi) UploadFile(c *gin.Context) {
	fileHeader, err := c.FormFile("file")
	if err != nil {
		response.FailWithMessage("接收文件失败!", c)
		return
	}
	file, err := UploadAndDownloadService.UploadFile(fileHeader, c)
	if err != nil {
		response.FailWithMessage("修改数据库链接失败", c)
		return
	}
	response.OkWithDetail(file, "上传成功", c)
}

// 删除文件
func (u *UploadAndDownloadApi) DeleteFile(c *gin.Context) {
	id, err := strconv.Atoi(c.Query("id"))
	if err != nil {
		response.FailWithMessage("获取参数信息失败", c)
		return
	}
	if err := UploadAndDownloadService.DeleteFile(uint(id)); err != nil {
		response.FailWithMessage("删除文件失败", c)
		return
	}
	response.OkWithMessage("操作成功", c)
}
