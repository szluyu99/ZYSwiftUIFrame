package model

import (
	"time"
)

type BaseModel struct {
	ID        uint      `json:"id" gorm:"primarykey"`     // 主键ID
	CreatedAt time.Time `json:"createdAt"`                // 创建时间
	UpdatedAt time.Time `json:"updatedAt"`                // 更新时间
	Remark    string    `json:"remark" gorm:"comment:备注"` // 备注
}
