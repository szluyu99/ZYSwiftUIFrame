package model

type SysUser struct {
	BaseModel
	Username  string `json:"username" gorm:"comment:用户登录名"`
	Password  string `json:"password" gorm:"comment:用户登录密码"`
	Nickname  string `json:"nickname" gorm:"comment:用户昵称"`
	Phone     string `json:"phone" gorm:"comment:用户手机号码"`
	HeaderImg string `json:"headerImg" gorm:"default:https://qmplusimg.henrongyi.top/gva_header.jpg;comment:用户头像"`
}
