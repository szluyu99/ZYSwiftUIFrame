//
//  ZYSwiftUIFrameApp.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 设置消息推送可以在前台显示 ①
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound]) // 设置消息推送可以在前台显示 ②
    }
}

@main
struct ZYSwiftUIFrameApp: App {
    // 设置消息推送可以在前台显示 ③
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
