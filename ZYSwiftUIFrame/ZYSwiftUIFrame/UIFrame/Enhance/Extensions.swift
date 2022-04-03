//
//  Extensions.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import Foundation
import SwiftUI

// 增强日期, 添加默认时间, 以及通用日期格式转换
extension Date {
    static var defaultDateStr: String {
        "1970-01-01 00:00:01"
    }
    static var defaultDate: Date {
        string2Date(defaultDateStr)
    }
}

// Date -> String
// 默认转换格式为 yyyy-MM-dd HH:mm:ss
func date2String(_ date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    let date = formatter.string(from: date)
    return date
}

// String -> Date
// 如果参数指定了格式则根据指定格式进行转换
// 如果没有指定格式, 分别尝试使用 yyyy-MM-dd HH:mm:ss 和 yyyy-MM-dd 进行转换
func string2Date(_ string:String, dateFormat:String? = nil) -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_CN")
    
    // 外面传入了参数
    if dateFormat != nil {
        formatter.dateFormat = dateFormat
        if let date = formatter.date(from: string) {
            return date
        }
    }
    
    // 外部没有传参, 按以下顺序格式化
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = formatter.date(from: string) {
        return date
    }

    formatter.dateFormat = "yyyy-MM-dd"
    if let date = formatter.date(from: string) {
        return date
    }
    
    return Date()
}

// 增强字符串
extension String {
    var isBlank: Bool {
        // 去除空格和换行
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
    /*
     * 首字母转小写
     */
    func lowercasedFisterLetter() -> String {
        return prefix(1).lowercased() + self.dropFirst()
    }
}

// 增强View：隐藏键盘
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
