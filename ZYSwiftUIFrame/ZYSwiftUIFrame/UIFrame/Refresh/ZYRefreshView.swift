//
//  ZYRefreshView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI
import BBSwiftUIKit

// 通用的 刷新页面
struct ZYRefreshView<Model: Codable, ListItem: View>: View
where Model: Equatable, Model: Identifiable  {
    // 通用 ViewModel
    @StateObject var viewModel: CommonVM<Model>
    
    // 列表条目
    @ViewBuilder var listItem: (Model) -> ListItem
    
    var body: some View {
        if viewModel.total != 0 {
            BBTableView(viewModel.items) { item in
                listItem(item)
            }
            .bb_reloadData($viewModel.isReloadData)
            .bb_pullDownToRefresh(isRefreshing: $viewModel.isRefreshing) {
                DispatchQueue.main.asyncAfter(deadline: .now() + refreshTime) {
                    viewModel.fetchData {
                        viewModel.isRefreshing = false
                    }
                }
            }
            .bb_pullUpToLoadMore(bottomSpace: 40) {
                if viewModel.isLoadingMore{ return }
                viewModel.isLoadingMore = true
                DispatchQueue.main.asyncAfter(deadline: .now() + loadMoreTime) {
                    viewModel.fetchMoreData {
                        viewModel.isLoadingMore = false
                    }
                }
            }
        } else {
            Text("当前没有数据！")
        }

    }
}

