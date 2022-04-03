//
//  ButtonView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI

// 提交按钮 using
struct submitButton: View {
    var disableForm: Bool
    var action: () -> Void

    init (action: @escaping () -> Void) {
        self.action = action
        self.disableForm = false
    }
    
    init (disableForm: Bool, action: @escaping () -> Void) {
        self.action = action
        self.disableForm = disableForm
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Spacer()
                Text("提交")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 125, height: 45)
                Spacer()
            }
            .background(disableForm ? .gray : .orange)
            .cornerRadius(5)
        }
        .padding()
        .disabled(disableForm)
        .buttonStyle(BorderlessButtonStyle())
    }
}

// 查看详情按钮 using
struct detailButton<Content: View>: View {
    
    let content: Content
    @State var openDetail: Bool = false
    
    init (@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        // 导航栏跳转
        NavigationLink(destination: content, isActive: $openDetail) {
            Button(action: { openDetail = true }) {
                Text("查看详情")
                    .font(.system(size: 14))
                    .padding(8)
                    .border(Color.blue)
                    .cornerRadius(2)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        
        // sheet 弹窗
//        Button(action: { openDetail = true }) {
//            Text("查看详情")
//                .font(.system(size: 14))
//                .padding(8)
//                .border(Color.blue)
//                .cornerRadius(2)
//        }
//        .buttonStyle(BorderlessButtonStyle())
//        .sheet(isPresented: $openDetail) {
//            content
//        }
    }
}

