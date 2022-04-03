//
//  CommonText.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI

// 多行文本输入框 using...
struct CommonTextEditor: View {
    let text: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text("\(text)：")
                .frame(height: 40, alignment: .leading)
                .minimumScaleFactor(0.5)
            TextEditor(text: $value)
        }
    }
}

// 单行文本输入框 using...
struct CommonTextField: View {
    let text: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text("\(text)：")
                .frame(width: 100, alignment: .leading)
            TextField(text, text: $value)
        }
    }
}

// 日期选择框 using...
struct CommonDatePicker: View {
    let text: String
    @Binding var value: Date
    
    var body: some View {
        HStack {
            DatePicker(selection: $value, displayedComponents: [.date]) {
                Text("\(text)：")
                    .frame(height: 40)
            }
            .environment(\.locale, Locale.init(identifier: "zh_CN"))
        }
    }
}

// 多行文本（备注）
struct RemarkField<Content: View>: View {
    @Binding var remark: String
    @ViewBuilder var content: Content
    
    var body: some View {
        HStack {
            content
            TextEditor(text: $remark)
                .frame(minHeight: 100)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1))
        }
        .padding(.vertical)
    }
}

