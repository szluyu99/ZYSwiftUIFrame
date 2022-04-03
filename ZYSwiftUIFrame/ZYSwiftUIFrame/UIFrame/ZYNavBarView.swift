//
//  ZYNavBarView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import SwiftUI

/**
 * 上方导航的界面
 * 可以传入具体的帮助页面内容，不传有默认值
 */
private let defaultHelpView: Text = Text("长按 “查看详情” 按钮可以进行删除操作")

struct ZYNavBarView<HelpContent: View>: View {
    @ViewBuilder var helpContent: HelpContent
    
    // 新增按钮
    @Binding var showAddView: Bool
    
    // 是否展示过滤按钮
    @State var filterFlag: Bool = false
    var showFilter: Binding<Bool>? // 可选的 @Binding
    
    // 帮助按钮
    @State var helpFlag: Bool = false
    var showHelpView: Binding<Bool>?
    
    init (showAddView: Binding<Bool>) {
        self.helpContent = defaultHelpView as! HelpContent
        _showAddView = showAddView // 注意 @Binding 的初始化是这么做的
        self.filterFlag = false
    }
    
    init (@ViewBuilder helpContent: () -> HelpContent,
          showAddView: Binding<Bool>) {
        self.helpContent = helpContent()
        _showAddView = showAddView // 注意 @Binding 的初始化是这么做的
        self.filterFlag = false
    }
    
    init (showAddView: Binding<Bool>,
          showFilter: Binding<Bool>?) {
        self.helpContent = defaultHelpView as! HelpContent
        _showAddView = showAddView
        self.showFilter = showFilter
        if (self.showFilter != nil) {
            _filterFlag = .init(initialValue: true)
        } else {
            _filterFlag = .init(initialValue: false)
        }
    }
    
    init (@ViewBuilder helpContent: () -> HelpContent,
          showAddView: Binding<Bool>,
          showHelpView: Binding<Bool>?,
          showFilter: Binding<Bool>?) {
        self.helpContent = helpContent()
        _showAddView = showAddView
        self.showHelpView = showHelpView
        if (self.showHelpView != nil) {
            _helpFlag = .init(initialValue: true)
        } else {
            _helpFlag = .init(initialValue: false)
        }
        self.showFilter = showFilter
        if (self.showFilter != nil) {
            _filterFlag = .init(initialValue: true)
        } else {
            _filterFlag = .init(initialValue: false)
        }
        
    }
    
    var body: some View {
        HStack {
            // 帮助按钮
            if self.helpFlag {
                Button(action: { self.showHelpView?.wrappedValue = true }) {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(.black)
                }
                .sheet(isPresented: showHelpView!) {
                    helpContent // 外部传入页面
                }
            }
            // 过滤按钮
            if self.filterFlag {
                Button(action: {
                    withAnimation {
                        self.showFilter?.wrappedValue.toggle()
                    }
                }){
                    Image(systemName: "magnifyingglass.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(.black)
                }
            }
            // 新增按钮
            Button(action: { self.showAddView = true }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22)
                    .foregroundColor(.black)
            }
        }
    }
}
