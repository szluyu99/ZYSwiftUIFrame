//
//  MapDemo.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/4.
//

import SwiftUI

struct MapDemo: View {
    @StateObject var locationViewModel = LocationViewModel() // 地理
    
    @State var address = "" // 地址名称
    @State var longitude = "" // 经度
    @State var latitude = "" // 纬度
    
    @State var showHelp: Bool = false // 显示帮助页面
    @State var errorFlag: Bool = false // 错误弹框
    @State var errorMsg: String = "" // 错误消息
    
    var body: some View {
        Group {
            List {
                HStack {
                    Text("当前地址：")
                    TextField("点击图标跳转高德地图", text: $address)
                    Spacer()
                    Image(systemName: "location.circle.fill")
                        .onTapGesture {
                            if (longitude.isBlank || latitude.isBlank) {
                                self.errorMsg = "经纬度为空，无法跳转！"
                                self.errorFlag = true
                            } else if address.isBlank {
                                self.errorMsg = "当前地址名称为空，请输入一个名称！"
                                self.errorFlag = true
                            } else {
                                // 跳转高德地图，没有高德地图则打开 Appp Sotre
                                MapNavigation.showLocation(address, lat: latitude, lng: longitude)
                            }
                        }
                        .alert(isPresented: $errorFlag) {
                            Alert(title: Text("消息提示"), message: Text(errorMsg), dismissButton: .default(Text("知道了！")))
                        }
                    
                }
                HStack {
                    Text("单位经度：")
                    TextField("点击图标获取", text: $longitude)
                    Spacer()
                    Image(systemName: "location.magnifyingglass")
                        .onTapGesture {
                            // 判断授权状态
                            switch locationViewModel.authorizationStatus {
                            case .notDetermined:
                                locationViewModel.requestPermission()
                            case .restricted:
                                self.errorMsg = "获取权限被拒绝，请在设置中开启"
                                self.errorFlag = true
                            case .denied:
                                self.errorMsg = "未获取到地理位置权限，请在设置中开启"
                                self.errorFlag = true
                            case .authorizedAlways, .authorizedWhenInUse:
                                // 已授权，点击获取当前位置
                                let co = locationViewModel.lastSeenLocation?.coordinate
                                let lng = co?.longitude ?? 0
                                let lat = co?.latitude ?? 0
                                longitude = (lng == 0) ? "" : String(lng)
                                latitude = (lat == 0) ? "" : String(lat)
                            default:
                                self.errorMsg = "未知错误！"
                                self.errorFlag = true
                            }
                        }
                }
                HStack {
                    Text("单位纬度：")
                    TextField("点击图标获取经纬度", text: $latitude)
                }
                HStack {
                    Text("地图更多用法参考：")
                    Spacer()
                    Link(destination: URL(string: "https://lbs.amap.com/api/amap-mobile/guide/ios/ios-uri-information")!) {
                        Text("高德 IOS 开发文档")
                    }
                }
            }
        }
        .navigationTitle("地图示例")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            Button(action: { self.showHelp = true }) {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22)
                    .foregroundColor(.black)
            }
            .sheet(isPresented: $showHelp) {
                Text("""
                    该页面主要是对高德地图 API 的使用：
                    
                    点击 [单位经度] 右边的图标
                    会尝试获取地理权限
                    授权以后再次点击
                    可以获取当前位置的经纬度
                    
                    点击 [当前地址] 右边的图标
                    尝试用高德地图打开下面的经纬度
                    如果没有高德地图
                    则跳转到 AppStore 中的高德安装页面
                    """)
                .padding()
            }
        })
    }
}

struct MapDemo_Previews: PreviewProvider {
    static var previews: some View {
        MapDemo()
    }
}
