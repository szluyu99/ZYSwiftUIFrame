//
//  MeetingDetailView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI

struct MeetingDetailView: View {
    @StateObject var viewModel: MeetingVM
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // 根据传入 id 是否为 nil 判断新增还是更新
    var id: Int?
    
    // 处理表单中的特殊类型, 如 日期类型
    @State private var mtTime = Date()
    
    @State var errorFlag = false // 错误弹窗
    @State var errorMsg = "" // 错误消息
    
    var disableForm: Bool {
        viewModel.item.mtName.isBlank || viewModel.item.mtTheme.isBlank || viewModel.item.mtSummary.isBlank || viewModel.item.mtContent.isBlank || viewModel.item.mtMember.isBlank
    }
    
    var body: some View {
        List {
            CommonTextEditor(text: "*会议名", value: $viewModel.item.mtName)
            CommonTextEditor(text: "*主题名", value: $viewModel.item.mtTheme)
            CommonTextEditor(text: "*概要名", value: $viewModel.item.mtSummary)
            CommonTextEditor(text: "*内容", value: $viewModel.item.mtContent)
            CommonTextEditor(text: "*参会人员", value: $viewModel.item.mtMember)
            CommonDatePicker(text: " 开会时间", value: $mtTime)
            RemarkField(remark: $viewModel.item.remark) { Text(" 备注：") }
            // 图片选择（多选）
            MultipleImagePickView(text: " 会议图片", imgList: $viewModel.item.anList)
            // 图片预览
            ImageShowView(imgList: $viewModel.item.anList)
            
            submitButton(disableForm: disableForm) { saveOrUpdate() }
            .alert(isPresented: $errorFlag) {
                Alert(title: Text("消息提示"), message: Text(errorMsg), dismissButton: .default(Text("知道了！")))
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(id != nil ? "会议信息详情" : "新增会议信息", displayMode: .inline)
        .gesture(
            DragGesture()
                .onChanged { _ in
                    hideKeyboard()
                }
        )
        .onAppear {
            echoData()
        }
    }
    
    // 更新界面需要回显数据
    private func echoData() {
        if let id = id { // 更新 - 回显数据
            viewModel.fetchDetail(id: id) {
                // 对一些比较特殊的数据进行处理, 如时间等
                processEchoData()
            }
        } else { // 新增 - 初始化数据
            viewModel.item = Meeting()
        }
    }
    
    private func processEchoData() {
        // 宣传时间
        if viewModel.item.mtTime.isBlank {
            self.mtTime = Date()
        } else {
            self.mtTime = string2Date(viewModel.item.mtTime)
        }
    }
    
    private func saveOrUpdate() {
        let item = buildSubmitData()
        
        if self.id == nil {
            // 新增
            viewModel.addData(item: item) { result in
                switch result {
                case .success:
                    self.presentationMode.wrappedValue.dismiss()
                case let .failure(error):
                    self.errorMsg = error.localizedDescription
                    self.errorFlag = true
                }
            }
        } else {
            // 更新
            viewModel.updateData(item: item) { result in
                // 有 BUG 待修复
                switch result {
                case .success:
                    self.presentationMode.wrappedValue.dismiss()
                case let .failure(error):
                    self.errorMsg = error.localizedDescription
                    self.errorFlag = true
                }
            }
        }
    }
    
    private func buildSubmitData() -> Meeting {
        var obj: Meeting = viewModel.item
        obj.mtTime = date2String(self.mtTime) // 会议时间
        obj.annexIds = obj.anList.map { $0.id }
        return obj
    }
    
    
}

//struct MeetingDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeetingDetailView()
//    }
//}
