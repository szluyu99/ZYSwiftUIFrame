//
//  Meeting.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

/**
 * 会议实体类
 */
struct Meeting: Codable, Identifiable, Equatable {
    static func == (lhs: Meeting, rhs: Meeting) -> Bool {
        return lhs.mtName == rhs.mtName
        && lhs.mtSummary == rhs.mtSummary
        && lhs.mtTheme == rhs.mtTheme
        && lhs.mtTime == rhs.mtTime
    }
    
    var id: Int? // id 可以为 nil 是为了区分 新增 和 更新
    @Default<String> var mtName: String
    @Default<String> var mtTheme: String
    @Default<String> var mtSummary: String
    @Default<String> var mtContent: String
    @Default<String> var mtMember: String
    @Default<String> var mtTime: String
    @Default<String> var remark: String
    @Default<Int> var createUser: Int
    
    var anList: [Upload] // 附件列表
    // 新增参数
    var annexIds: [Int]? // 附件Id数组
    
    init() {
        self.mtName = ""
        self.mtTheme = ""
        self.mtSummary = ""
        self.mtContent = ""
        self.mtMember = ""
        self.mtTime = ""
        self.remark = ""
        self.createUser = -1
        self.anList = []
        
        self.annexIds = []
    }

}
