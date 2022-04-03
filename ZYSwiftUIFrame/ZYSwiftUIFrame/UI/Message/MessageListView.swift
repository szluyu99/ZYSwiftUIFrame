//
//  MessageListView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI

struct MessageListView: View {
    @StateObject var viewModel = MessageVM()
    
    var body: some View {
        ZYRefreshView(
            viewModel: viewModel,
            listItem: { item in ListItem(viewModel: viewModel, item: item)}
        )
            .navigationBarTitle("消息列表", displayMode: .inline)
    }
    
    // 刷新列表的具体条目需要自定义
    struct ListItem: View {
        @StateObject var viewModel: MessageVM
        var item: Message
        
        var body: some View {
            NavigationLink(destination: MessageDetailView(viewModel: viewModel, id: item.id)) {
                HStack {
                    Image(systemName: "bell.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text(item.theme)
                                .font(.headline)
                            Spacer()
                            Text(item.createdAt.prefix(10))
                                .font(.subheadline)
                                .opacity(0.5)
                        }
                        VStack {
                            Text(item.content)
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
                    Label("删除此消息", systemImage: "xmark.circle")
                }
            }
            .buttonStyle(.borderless)
            .foregroundColor(.black) // 消去 NavigationLink 的覆盖颜色样式
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
