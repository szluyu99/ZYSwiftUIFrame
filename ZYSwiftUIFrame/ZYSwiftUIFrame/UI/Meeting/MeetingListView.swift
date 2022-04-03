//
//  MeetingListView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI

struct MeetingListView: View {
    @StateObject var viewModel: MeetingVM = MeetingVM()
    var body: some View {
        ZYListView(
            title: "会议列表", // 上方显示的标题
            viewModel: viewModel, // 模型视图层
            // 通过导航栏进行跳转的页面
            navContent: { MeetingDetailView(viewModel: viewModel, id: nil) }, // id 为 nil 表示新增
            listItem: { item in ListItem(viewModel: viewModel, item: item)}, // 具体的列表条目
            withHelp: true,
            withFilter: true,
            helpItem: { Text("长按 “查看详情” 按钮可以进行删除操作") },
            filterItem: { ListHead(viewModel: viewModel) } // 搜索框
        )
    }
    
    struct ListItem: View {
        @StateObject var viewModel: MeetingVM
        var item: Meeting
        
        var body: some View {
            VStack {
                HStack {
                    if item.mtName.isBlank {
                        Text("未命名")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                    } else {
                        Text(item.mtName)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    // 指定了 id 则为更新
                    detailButton { MeetingDetailView(viewModel: viewModel, id: item.id)}
                }
                Spacer()
                HStack {
                    Text("会议主题：\(item.mtTheme)")
                        .font(.caption)
                        .opacity(0.5)
                        .lineLimit(1)
                    Spacer()
                }
                HStack {
                    Text("会议概要：\(item.mtSummary)")
                        .font(.caption)
                        .opacity(0.5)
                        .lineLimit(1)
                    Spacer()
                    Text("会议时间：\(String(item.mtTime.prefix(10)))")
                        .font(.caption)
                        .opacity(0.5)
                        .lineLimit(1)
                }
                .padding(.vertical, 1)
                Divider()
            }
            .padding(defaultListItemPadding)
            .contextMenu {
                Button { viewModel.deleteData(item: item) {} } label: {
                    Label("删除此会议纪要", systemImage: "xmark.circle")
                }
            }
        }
    }
    
    struct ListHead: View {
        @StateObject var viewModel: MeetingVM
        
        var body: some View {
            HStack {
                Text("会议名称：")
                TextField("请输入内容", text: $viewModel.mtName)
                    .padding(5)
                    .border(.selection)
                    .onChange(of: viewModel.mtName) { _ in
                        viewModel.filterData()
                    }
                //                Button(action: {
                //                    viewModel.filterData()
                //                }, label: {
                //                    Text("搜索")
                //                })
            }
            .padding()
            .font(.system(size: 13)).opacity(0.7)
        }
    }
}

struct MeetingListView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingListView()
    }
}
