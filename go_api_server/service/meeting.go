package service

import (
	"fmt"
	"time"

	"github.com/yusael/go_api_server/global"
	"github.com/yusael/go_api_server/model"
	"github.com/yusael/go_api_server/model/common/request"
	"github.com/yusael/go_api_server/utils"
)

type MeetingService struct{}

// 分页获取会议列表
func (meetingService *MeetingService) GetMeetingList(info request.PageInfo) (records interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.DB.Model(&model.Meeting{})
	if err = db.Where("mt_name LIKE ?", fmt.Sprintf("%%%s%%", info.Keyword)).Count(&total).Error; err != nil {
		fmt.Println("GetMeetingList Service Error!")
		return
	}
	var meetingRecords []model.Meeting

	err = db.Preload("AnList").Limit(limit).Offset(offset).
		Where("mt_name LIKE ?", fmt.Sprintf("%%%s%%", info.Keyword)).Order("created_at desc").
		Find(&meetingRecords).Error
	return meetingRecords, total, err
}

// 删除会议
func (meetingService *MeetingService) DeleteMeeting(id int) (err error) {
	return global.DB.Where("id = ?", id).Delete(&model.Meeting{}).Error
}

// 获取会议详情
func (meetingServicem *MeetingService) GetMeetingDetail(id int) (meeting *model.Meeting, err error) {
	err = global.DB.Preload("AnList").Where("id = ?", id).First(&meeting).Error
	return meeting, err
}

// 新增 或 更新 会议
func (meetingService *MeetingService) SaveOrUpdateMeeting(meetingReq *request.ChangeMeetingInfo) (err error) {
	var meeting model.Meeting
	fmt.Println(meetingReq)
	// po -> vo
	utils.SimpleCopyProperties(&meeting, meetingReq)
	meeting.ID = meetingReq.ID
	meeting.Remark = meetingReq.Remark

	// 更新 文件记录
	global.DB.Model(model.UploadAndDownload{}).
		Where("meeting_id = ?", meetingReq.ID).Updates(map[string]interface{}{"meeting_id": 0})
	global.DB.Model(model.UploadAndDownload{}).
		Where("id IN ?", meetingReq.AnnexIds).Updates(map[string]interface{}{"meeting_id": meetingReq.ID})

	if meeting.ID == 0 { // 新增
		if err := global.DB.Create(&meeting).Error; err != nil {
			return err
		}
	} else { // 更新
		if _, err := meetingService.GetMeetingDetail(int(meeting.ID)); err != nil {
			return err
		}
		if err := global.DB.Model(&meeting).Where("id = ?", meeting.ID).Updates(meeting).Error; err != nil {
			return err
		}
	}
	return nil
}

// 初始化数据库数据: 有数据就不初始化, 没有数据则增加 20 条数据
func (meetingService *MeetingService) InitMeetingData() {
	var count int64
	if global.DB.Model(&model.Meeting{}).Count(&count); count != 0 {
		return
	}

	meetingList := make([]model.Meeting, 0)
	for i := 0; i < 30; i++ {
		meetingList = append(meetingList, model.Meeting{
			MtName:     fmt.Sprintf("会议名称%v", i),
			MtTheme:    fmt.Sprintf("会议主题%v", i),
			MtSummary:  fmt.Sprintf("会议概要%v", i),
			MtContent:  fmt.Sprintf("会议内容%v", i),
			MtMember:   fmt.Sprintf("成员%v", i),
			MtTime:     time.Now().Format("2006-01-02"),
			CreateUser: 0,
			AnList:     nil,
		})
	}
	if err := global.DB.Create(&meetingList).Error; err != nil {
		fmt.Println("InitMeetingData Error", err)
	}
}
