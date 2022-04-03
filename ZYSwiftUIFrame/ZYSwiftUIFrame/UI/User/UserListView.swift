//
//  UserListView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/2.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserVM = UserVM()
    
    var body: some View {
        ZYListView(
            title: "用户列表", // 上方显示的标题
            viewModel: viewModel, // 模型视图层
            // 通过导航栏进行跳转的页面
            navContent: { UserDetailView(viewModel: viewModel, id: nil) }, // id 为 nil 表示新增
            listItem: { item in ListItem(viewModel: viewModel, item: item)}, // 具体的列表条目
            withHelp: true, // 显示帮助按钮, 若不想显示这里设置为 false
            withFilter: true, // 显示搜索按钮, 若不想显示这里设置为 false
            helpItem: { HelpContent() }, // 一些帮助信息
            filterItem: { ListHead(viewModel: viewModel) } // 搜索框
        )
    }
    
    struct ListItem: View {
        @StateObject var viewModel: UserVM
        var item: User
        
        var body: some View {
            // 查看详情页面
            NavigationLink(destination: UserDetailView(viewModel: viewModel, id: item.id)) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text(item.nickname)
                                .font(.headline)
                            Spacer()
                            Text(item.username)
                                .font(.subheadline)
                                .opacity(0.5)
                        }
                        VStack {
                            Text(item.phone)
                                .font(.subheadline)
                                .opacity(0.5)
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                }
                .padding(defaultListItemPadding)
            }
            .contextMenu {
                Button {
                    viewModel.deleteData(item: item) {}
                } label: {
                    Label("删除此用户", systemImage: "xmark.circle")
                }
            }
            .buttonStyle(.borderless)
            .foregroundColor(.black) // 消去 NavigationLink 的覆盖颜色样式
        }
    }
    
    struct ListHead: View {
        @StateObject var viewModel: UserVM
        
        var body: some View {
            HStack {
                Text("用户昵称：")
                TextField("请输入内容", text: $viewModel.nickname)
                    .padding(5)
                    .border(.selection)
                Button(action: {
                    viewModel.filterData()
                }, label: {
                    Text("搜索")
                })
            }
            .padding()
            .font(.system(size: 13)).opacity(0.7)
        }
    }
    
    struct HelpContent: View {
        var body: some View {
            VStack {
                Text("该页面主要用于演示一些基础功能：\n")
                    .font(.title3)
                Text("""
                     - 页面的 [下拉刷新]、[上拉加载更多]
                     - 点击页面条目进入 [修改界面]
                     - 点击顶部的 "加号" 进入 [新增界面]
                     - 长按页面条目可执行 [删除操作]
                     - 点击顶部的 “搜索” 执行 [过滤操作]
                     - 点击顶部的 "问号" 显示 [帮助信息]\n
                     """)
                    .font(.headline)
                Text("""
                     以上只是单机版的功能演示，较为简单
                     开启服务端版本的封装好了网络请求相关
                    """)
                    .font(.headline)
                    .foregroundColor(.gray)
                
            }
        }
    }
    
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
