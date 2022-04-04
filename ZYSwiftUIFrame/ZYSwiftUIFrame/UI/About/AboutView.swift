//
//  About.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/2.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            HeadRow()
            Link(destination: URL(string: "https://luzhenyu.blog.csdn.net")!) {
                Text("个人博客")
            }
            Link(destination: URL(string: "https://github.com/szluyu99")!) {
                Text("GitHub: https://github.com/szluyu99")
            }
            Link(destination: URL(string: "https://gitee.com/szluyu99")!) {
                Text("Gitee: https://gitee.com/szluyu99")
            }
            Text("联系作者：可以通过博客私信我~")
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("个人信息", displayMode: .inline)
    }
    
    struct HeadRow: View {
        var body: some View {
            HStack {
                Image("head")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(8)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("萌宅鹿")
                        .font(.title)
                    Text("学校：江苏大学")
                        .font(.subheadline).opacity(0.5)
                    Text("专业：计算机研一")
                        .font(.subheadline).opacity(0.5)
                    Text("本职：后端开发 + 前端开发 ")
                        .font(.subheadline).opacity(0.5)
                }
            }
        }
    }
    
}

