package utils

import (
	"errors"
	"fmt"
	"reflect"
)

// Transition 将ref的数据填充到target
//  ref {"id": 1, "username": "renhj", "age": 11, "password": "password"}
//  transition after
// 	target {"id": 1, "username": "renhj"}
func Transition(ref interface{}, target interface{}) error {
	tt := reflect.TypeOf(target)  // target 类型
	tv := reflect.ValueOf(target) // target 值
	tk := tt.Kind()               // target 种类

	if tk != reflect.Ptr {
		return errors.New("target must be ptr type! ")
	}
	tfn := tt.Elem().NumField() // target fields 数量

	rt := reflect.TypeOf(ref)  // ref 类型
	rv := reflect.ValueOf(ref) // ref 值
	rk := rt.Kind()            // ref 种类
	rkm := map[string]interface{}{}
	rvm := map[string]interface{}{}

	// 2、遍历ref，放到map里
	if rk == reflect.Ptr {
		rfn := rt.Elem().NumField()
		for i := 0; i < rfn; i++ {
			name := rt.Elem().Field(i).Name
			kind := rv.Elem().Field(i).Kind()
			value := rv.Elem().Field(i)
			rkm[name] = kind
			rvm[name] = value
		}
	} else {
		rfn := rt.NumField()
		for i := 0; i < rfn; i++ {
			name := rt.Field(i).Name
			kind := rv.Field(i).Kind()
			value := rv.Field(i)
			rkm[name] = kind
			rvm[name] = value
		}
	}

	// 3、遍历target，获取map里同名的值
	for i := 0; i < tfn; i++ {
		if tv.Elem().Field(i).Kind() != rkm[tt.Elem().Field(i).Name] {
			// 	判断同名的成员属性类型是否一致
			// return fmt.Errorf("[%s:%s] mismatch type [%s:%s]", tt.Name(), tt.Elem().Field(i).Name, rt.Name(), rt.Field(i).Name)
			continue
		}
		tv.Elem().Field(i).Set(rvm[tt.Elem().Field(i).Name].(reflect.Value))
	}

	return nil
}

func SimpleCopyProperties(dst, src interface{}) (err error) {
	// 防止意外panic
	defer func() {
		if e := recover(); e != nil {
			err = errors.New(fmt.Sprintf("%v", e))
		}
	}()

	dstType, dstValue := reflect.TypeOf(dst), reflect.ValueOf(dst)
	srcType, srcValue := reflect.TypeOf(src), reflect.ValueOf(src)

	// dst必须结构体指针类型
	if dstType.Kind() != reflect.Ptr || dstType.Elem().Kind() != reflect.Struct {
		return errors.New("dst type should be a struct pointer")
	}

	// src必须为结构体或者结构体指针
	if srcType.Kind() == reflect.Ptr {
		srcType, srcValue = srcType.Elem(), srcValue.Elem()
	}
	if srcType.Kind() != reflect.Struct {
		return errors.New("src type should be a struct or a struct pointer")
	}

	// 取具体内容
	dstType, dstValue = dstType.Elem(), dstValue.Elem()

	// 属性个数
	propertyNums := dstType.NumField()

	for i := 0; i < propertyNums; i++ {
		// 属性
		property := dstType.Field(i)
		// 待填充属性值
		propertyValue := srcValue.FieldByName(property.Name)

		// 无效，说明src没有这个属性 || 属性同名但类型不同
		if !propertyValue.IsValid() || property.Type != propertyValue.Type() {
			continue
		}

		if dstValue.Field(i).CanSet() {
			dstValue.Field(i).Set(propertyValue)
		}
	}

	return nil
}
