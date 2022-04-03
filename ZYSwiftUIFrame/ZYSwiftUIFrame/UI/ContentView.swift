//
//  ContentView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: MessageListView()) {
                    HStack {
                        Text("消息列表")
                        Spacer()
                        Text("（需要开启服务端）")
                            .foregroundColor(.red)
                    }
                }
                NavigationLink(destination: MeetingListView()) {
                    HStack {
                        Text("会议列表")
                        Spacer()
                        Text("（需要开启服务端）")
                            .foregroundColor(.red)
                    }
                }
                NavigationLink(destination: UserListView()) {
                    HStack {
                        Text("用户列表")
                        Spacer()
                        Text("（无需开启服务端）")
                    }
                }
                NavigationLink(destination: Text("地图相关（待完善）")) {
                    HStack {
                        Text("地图相关")
                        Spacer()
                        Text("（待完善...）")
                    }
                }
                NavigationLink(destination: AboutView()) {
                    Text("关于作者")
                }
            }
            .navigationTitle("萌宅鹿的 IOS 框架")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
