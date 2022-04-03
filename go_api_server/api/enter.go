package api

import "github.com/yusael/go_api_server/service"

type ApiGroup struct {
	UserApi              UserApi
	MeetingApi           MeetingApi
	MessageApi           MessageApi
	UploadAndDownloadApi UploadAndDownloadApi
}

var ApiGroupApp = new(ApiGroup)

var (
	userService              = service.ServiceGroupApp.UserService
	meetingService           = service.ServiceGroupApp.MeetingService
	messageService           = service.ServiceGroupApp.MessageService
	UploadAndDownloadService = service.ServiceGroupApp.UploadAndDownloadService
)
