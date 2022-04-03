//
//  ZYListView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI
import BBSwiftUIKit

// 本项目中通用的带有 过滤框, 帮助按钮, 新增按钮 的可刷新页面
struct ZYListView<Model: Codable, NavContent: View, ListItem: View, HelpItem: View, FilterItem: View>: View
where Model: Equatable, Model: Identifiable  {
    
    // 页面名称
    let title: String
    // 是否有过滤框
    var withFilter: Bool
    // 是否有帮助提示
    var withHelp: Bool
    
    // 通用 ViewModel
    @StateObject var viewModel: CommonVM<Model>
    
    @ViewBuilder var navContent: NavContent // 要跳转 新增 / 更新 页面
    @ViewBuilder var listItem: (Model) -> ListItem // 列表条目
    @ViewBuilder var helpItem: HelpItem // 帮助信息
    @ViewBuilder var filterItem: FilterItem // 搜索条目
    
    // 默认没有 帮助提示 和 搜索框
    init (title: String, viewModel: CommonVM<Model>,
          @ViewBuilder navContent: () -> NavContent,
          @ViewBuilder listItem: @escaping (Model) -> ListItem)
    {
        self.title = title
        // 初始化 @StateObject
        _viewModel = StateObject(wrappedValue: viewModel)
        self.withFilter = true // 默认没搜索框
        self.withHelp = false // 默认没帮助框
        self.navContent = navContent()
        self.listItem = listItem
        self.helpItem = Text("") as! HelpItem // 没有帮助框不会展示出来
        self.filterItem = Text("") as! FilterItem // 没有搜索框不会展示出来
    }
        
    // 自定义有没有 帮助提示 和 搜索框
    init (title: String, viewModel: CommonVM<Model>,
          @ViewBuilder navContent: () -> NavContent,
          @ViewBuilder listItem: @escaping (Model) -> ListItem,
          withHelp: Bool,
          withFilter: Bool,
          @ViewBuilder helpItem: () -> HelpItem,
          @ViewBuilder filterItem: () -> FilterItem) {
        self.title = title
        // 初始化 @StateObject
        _viewModel = StateObject(wrappedValue: viewModel)
        self.navContent = navContent()
        self.listItem = listItem
        self.withHelp = withHelp
        self.helpItem = helpItem()
        self.withFilter = withFilter // 手动控制有没有搜索
        self.filterItem = filterItem()
    }
    
    // 每个列表页面基本都有的属性
    @State private var showFilter = false // 过滤框
    @State private var showAddView = false // 新增页面
    @State private var showHelpView = false // 帮助页面
    
    var body: some View {
        NavigationLink(destination: navContent, isActive: $showAddView) { EmptyView() }
        
        if showFilter {
            filterItem
        }
        
        Group {
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
        .navigationBarTitle(self.title, displayMode: .inline)
        .navigationBarItems(
            trailing: ZYNavBarView(helpContent: { helpItem } ,
                                   showAddView: $showAddView,
                                   showHelpView: withHelp ? $showHelpView: nil,
                                   showFilter: withFilter ? $showFilter : nil)
        )
        
    }
    
}
