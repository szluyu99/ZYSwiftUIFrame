//
//  MapNavigation.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/4.
//

import Foundation
import StoreKit

// 跳转高德地图
struct MapNavigation {
    // 根据经纬度、名称，打开高德地图导航进行跳转
    static func showLocation(_ name: String, lat: String, lng: String) {
        
        let urlStr =  "iosamap://viewMap?sourceApplication=application&poiname=\(name)&lat=\(lat)&lon=\(lng)&dev=1"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlStr!)
        
        if UIApplication.shared.canOpenURL(url!) {
            // 跳转高德地图
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // 跳转应用商店
            let urlString = URL(string:"itms-apps://itunes.apple.com/app/id461703208")
            UIApplication.shared.open(urlString!, options: [:], completionHandler: nil)
        }
    }
}
