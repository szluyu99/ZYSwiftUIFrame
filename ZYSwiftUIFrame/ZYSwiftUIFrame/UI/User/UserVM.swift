//
//  UserVM.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/2.
//

import Foundation

// 这个模块是本地生成的数据，无需向服务端发送请求
class UserVM: CommonVM<User> {
    init() {
        super.init(item: User(), apiObj: UserAPIObj(moduleUrl: "user"))
    }
    
    // 由于 User 用于无服务端的演示, 因此不会发送网络请求, 本地重写其基本方法
    // 以下操作全部为模拟行为, 真实网络请求请参考 "会议列表"
    
    @Published var nickname: String = ""
    
    // 获取数据
    override func fetchData(completion: @escaping () -> Void) {
        print("生成用户数据")
        var list: [User] = []
        for i in 0..<15 {
            list.append(User(username: "user00\(i)", password: "123456", nickname: "用户00\(i)", phone: "12345678999", headerImg: ""))
        }
        self.items = list
        super.total = 15
        completion()
    }
    
    // 获取数据详情
    override func fetchDetail(id: Int, completion: @escaping () -> Void) {
        print("获取数据详情")
        if let user = super.items.first(where: { $0.id == id}) {
            super.item = user
            completion()
        }
    }
    
    // 新增数据
    override func addData(item: User, completion: @escaping (Result<String, Error>) -> Void) {
        print("新增用户数据")
        super.items.insert(item, at: 0) // 往前添加元素
        self.total += 1
        completion(Result<String, Error>(catching: { return "" }))
    }
    
    // 更新数据
    override func updateData(item: User, completion: @escaping (Result<String, Error>) -> Void) {
        print("更新用户数据")
        if let idx = self.items.firstIndex(where: { $0.id == item.id }) {
            super.items[idx] = item
            completion(Result<String, Error>(catching: { return "" }))
        }
    }
    
    // 删除数据
    override func deleteData(item: User, completion: @escaping () -> Void) {
        print("删除用户数据")
        if let idx = super.items.firstIndex(of: item) {
            super.items.remove(at: idx)
            super.total -= 1
            completion()
        }
    }
    
    // 获取更多数据
    override func fetchMoreData(completion: @escaping () -> Void) {
        if (super.total >= 50) { return }
        print("获取更多用户数据")
        for i in 0..<10 {
            super.items.append(User(username: "newUser00\(self.total + i)", password: "123456", nickname: "新用户00\(self.total + i)", phone: "987654321", headerImg: ""))
        }
        super.total += 10
        completion()
    }
    
    // 搜索数据(模拟操作, 只能搜索一次, 真实效果参考 "会议列表")
    func filterData() {
        if nickname.isBlank {
            self.fetchData {}
        }
        super.items = super.items.filter {
            $0.nickname.contains(self.nickname)
        }
        self.total = self.items.count
    }
}
