//
//  User.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/2.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username
        && lhs.nickname == rhs.nickname
        && lhs.phone == rhs.phone
    }
    
    var id: Int? // id 可以为 nil 是为了区分 新增 和 更新
    @Default<String> var username: String
    @Default<String> var password: String
    @Default<String> var nickname: String
    @Default<String> var phone: String
    @Default<String> var headerImg: String

    init() {
        self.username = ""
        self.password = ""
        self.nickname = ""
        self.phone = ""
        self.headerImg = ""
    }
    
    init(username: String, password: String, nickname: String, phone: String, headerImg: String) {
        self.id = Int.random(in: 1...100000) // 随机数模拟 ID
        self.username = username
        self.password = password
        self.nickname = nickname
        self.phone = phone
        self.headerImg = headerImg
    }

}
