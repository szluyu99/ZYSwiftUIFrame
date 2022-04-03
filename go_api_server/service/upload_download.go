package service

import (
	"fmt"
	"math/rand"
	"mime/multipart"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/yusael/go_api_server/global"
	"github.com/yusael/go_api_server/model"
	"github.com/yusael/go_api_server/model/common/request"
)

type UploadAndDownloadService struct{}

// 创建文件上传记录
func (u *UploadAndDownloadService) Upload(file *model.UploadAndDownload) error {
	return global.DB.Create(&file).Error
}

// 查询文件上传记录
func (u *UploadAndDownloadService) FindFile(id uint) (model.UploadAndDownload, error) {
	var file model.UploadAndDownload
	err := global.DB.Where("id = ?", id).First(&file).Error
	return file, err
}

// 删除文件上传记录
func (u *UploadAndDownloadService) DeleteFile(id uint) (err error) {
	var fileFromDB model.UploadAndDownload
	// 找不到文件则没法删除
	fileFromDB, err = u.FindFile(id)
	if err != nil {
		return
	}
	// 删除本地文件
	os.Remove(fileFromDB.Url)
	// 删除数据库中记录
	return global.DB.Where("id = ?", id).Delete(&model.UploadAndDownload{}).Error
}

// 分页获取文件列表
func (u *UploadAndDownloadService) GetFileRecordList(info request.PageInfo) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.DB.Model(&model.UploadAndDownload{})
	var fileList []model.UploadAndDownload
	if err = db.Count(&total).Error; err != nil {
		return
	}
	err = db.Limit(limit).Offset(offset).Order("updated_at desc").Find(&fileList).Error
	return fileList, total, err
}

// 文件上传到本地
func (u *UploadAndDownloadService) UploadFile(fileHeader *multipart.FileHeader, c *gin.Context) (file model.UploadAndDownload, err error) {
	// 上传文件到指定路径
	fileName := time.Now().Format("2006_01_02_15_04_05_") + fmt.Sprintf("%v", rand.Int63n(1000)) + fileHeader.Filename
	dst := "uploads/file/" + fileName
	if err = c.SaveUploadedFile(fileHeader, dst); err != nil {
		fmt.Println("uploadService uploadFile Error: ", err)
		return
	}

	f := model.UploadAndDownload{
		Name: fileName,
		Url:  dst,
		Tag:  "普通文件",
		Key:  "普通文件",
	}
	err = u.Upload(&f)
	return f, err
}
