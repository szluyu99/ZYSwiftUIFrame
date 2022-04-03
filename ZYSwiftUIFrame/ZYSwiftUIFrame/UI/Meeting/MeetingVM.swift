//
//  MeetingVM.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import Foundation

class MeetingVM: CommonVM<Meeting> {
    // 搜索条件
    @Published var mtName: String = ""
    
    init() {
        super.init(item: Meeting(), apiObj: MeetingApiObj(moduleUrl: "meeting"))
    }
    
    func filterData() {
        filterParams = [:]
        if !mtName.isBlank {
            filterParams["keyword"] = mtName
        }
        
        // 每次筛选重置页数
        filterParams["pageIndex"] = 1
        
        print(filterParams)
        
        super.thisAPI.list(parameters: filterParams) { result in
            switch result {
            case let .success(data):
                print(data)
                guard let res = data.data else {
                    return
                }
                self.items = res.records
                print(res.records)
                self.page = res.page + 1
                self.total = res.total
            case let .failure(error):
                print("获取组织架构列表失败 \(error.localizedDescription)")
            }
        }
    }
}
