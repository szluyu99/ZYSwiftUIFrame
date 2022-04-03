//
//  MessageDetailView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI

struct MessageDetailView: View {
    @StateObject var viewModel: MessageVM
    let id: Int
    
    var body: some View {
        List {
            Text(viewModel.item.theme)
                .font(.system(size: 24))
                .padding(.vertical, 7)
            VStack(alignment: .leading) {
                Text(viewModel.item.createdAt.prefix(10))
                    .font(.subheadline)
                    .opacity(0.5)
                Text(viewModel.item.content)
                    .font(.system(size: 18))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical)
            }
        }
        .navigationBarTitle("消息详情", displayMode: .inline)
        .onAppear {
            // 获取数据详情
            viewModel.fetchDetail(id: id) {}
        }
    }
}

//struct MessageDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageDetailView()
//    }
//}
