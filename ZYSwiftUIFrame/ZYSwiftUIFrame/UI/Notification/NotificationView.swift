//
//  NotificationView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/4.
//

import SwiftUI

struct NotificationView: View {
    @State var timeInterval = 1 // 设置消息推送时间
    
    @State var showHelp: Bool = false // 显示帮助页面
    
    var body: some View {
        Group {
            List {
                
                Section(header: Text("本地的前台消息推送")) {
                    Stepper(value: $timeInterval, in: 1...5, step: 1) {
                        Text("消息推送延时：\(timeInterval)秒")
                    }
                    Button(action: {
                        sendNotification(msg: Int.random(in: 1...4) > 2 ? "今天的需求改完了吗？客户催着明天要" : "小伙子好好干，升职加薪在等着你！")
                    }, label: {
                        Text("发送消息推送!")
                    })
                }
            }
        }
        .navigationTitle("本地消息推送")
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
                    该页面主要是对消息中心的使用：
                    
                    本地消息推送一般只有在后台生效
                    但是通过在 @main 界面进行一些配置
                    可以使得消息中心的推送在前台也生效...
                    (不确定未来何时会修复这个问题)
                    """)
                .padding()
            }
        })
        
    }
    
    // 发送消息到消息中心
    func sendNotification(msg: String){
        let content = UNMutableNotificationContent()
        content.title = "萌宅鹿给你发来一条消息："
        content.body = msg
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(self.timeInterval), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
            if let error = error {
                print("消息推送失败：\(error) ")
            }
        }
        
        UNUserNotificationCenter.current().add(request)  {error in
            if error != nil {
                print("无法添加到通知中心：\(error!)")
            }
        }
    }
}
