//
//  Message.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

/**
 * 消息实体类
 */
struct Message: Codable, Identifiable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.content == rhs.content
        && lhs.theme == rhs.theme
    }
    
    @Default<Int> var id: Int
    @Default<String> var theme: String // 标题
    @Default<String> var content: String // 内容
    @Default<Int> var receiveUser: Int // 接收人id
    @Default<Int> var sendUser: Int // 发送人id
    @Default<Int> var isRead: Int // 已读 0否1是
    @Default<String> var createdAt: String // 创建时间
    
    init() {
        self.id = -1
        self.receiveUser = -1
        self.sendUser = -1
        self.theme = ""
        self.content = ""
        self.isRead = 0
        self.createdAt = "暂时没有时间数据......"
    }
    
}
