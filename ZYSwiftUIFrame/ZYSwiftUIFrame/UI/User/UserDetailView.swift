//
//  UserDetailView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/2.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserVM
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // 根据传入 id 是否为 nil 判断新增还是更新
    var id: Int?
    
    var disableForm: Bool {
        viewModel.item.username.isBlank || viewModel.item.nickname.isBlank || viewModel.item.phone.isBlank
    }
    
    var body: some View {
        List {
            CommonTextField(text: "用户名", value: $viewModel.item.username)
            CommonTextField(text: "用户昵称", value: $viewModel.item.nickname)
            CommonTextField(text: "手机号", value: $viewModel.item.phone)
            submitButton(disableForm: disableForm) { saveOrUpdate() }
        }
        .onAppear {
            echoData()
        }
        .navigationTitle(id != nil ? "用户详情" : "新增用户")
    }
    
    // 更新界面需要回显数据
    private func echoData() {
        if let id = id { // 更新 - 回显数据
            viewModel.fetchDetail(id: id) {
                // 可以对一些特殊数据提前进行处理...
            }
        } else { // 新增 - 初始化数据
            viewModel.item = User()
        }
    }
    
    private func saveOrUpdate() {
        let item = viewModel.item
        
        // 本地项目不做过于真实的模拟, 仅仅演示出效果
        if self.id == nil { // 新增
            viewModel.addData(item: item) { result in
                self.presentationMode.wrappedValue.dismiss()
            }
        } else { // 更新
            viewModel.updateData(item: item) { result in
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView()
//    }
//}
