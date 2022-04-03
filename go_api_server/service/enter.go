package service

type ServiceGroup struct {
	UserService
	MeetingService
	MessageService
	UploadAndDownloadService
}

var ServiceGroupApp = new(ServiceGroup)
