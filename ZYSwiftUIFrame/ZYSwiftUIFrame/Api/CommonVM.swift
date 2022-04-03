//
//  CommonVM.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import Foundation
import Alamofire

class CommonVM<T: Identifiable>: ObservableObject where T: Codable {
    // API
    let thisAPI: CommonApiObj<T>
    
    // 数据列表
    @Published var items: [T] = []
    @Published var page: Int = 1
    @Published var total: Int = 0
    
    // 下拉刷新, 上拉加载
    @Published var isRefreshing: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var isReloadData: Bool = false
    
    // 详情
    @Published var item: T
    
    // 过滤条件
    @Published var filterParams: Parameters = ["pageSize": 15]
    
    init (item: T, module: String) {
        self.item = item
        self.module = module
        self.thisAPI = CommonApiObj<T>(moduleUrl: module)
    }
    
    init (item: T, apiObj: CommonApiObj<T>) {
        self.item = item
        self.module = apiObj.moduleUrl
        self.thisAPI = apiObj
        
        self.fetchData {}
    }
    
    // 没有更多
    var noMore: Bool {
        items.count >= total
    }
    
    var module: String = String(describing: T.self).lowercasedFisterLetter()
    
    // 获取数据
    func fetchData(completion: @escaping () -> Void) {
        filterParams["page"] = 1
        thisAPI.list(parameters: filterParams) { res in
            switch res {
            case let .success(data):
                guard let res = data.data else {
                    print("CommonViewModel: 未从\(self.module)接口中获取到数据 \(data.message)")
                    return
                }
                self.items = res.records
                self.page = 2
                self.total = res.total
                
                completion()
            case let .failure(error):
                print("获取\(self.module)列表失败 \(error.localizedDescription)")
            }
        }
    }
    
    // 获取更多数据
    func fetchMoreData(completion: @escaping () -> Void) {
        filterParams["page"] = page
        thisAPI.list(parameters: filterParams) { res in
            switch res {
            case let .success(data):
                guard let res = data.data else {
                    print("未从\(self.module)接口获取到数据 \(data.message)")
                    return
                }
                if (self.items.count < res.total) {
                    self.items.append(contentsOf: res.records)
                    self.page = res.page + 1
                    self.total = res.total
                }
                completion()
            case let .failure(error):
                print("获取\(self.module)列表失败 \(error.localizedDescription)")
            }
        }
    }
    
    // 获取详情
    func fetchDetail(id: Int, completion: @escaping () -> Void) {
        thisAPI.detail(id: id) { result in
            switch result {
            case let .success(data):
                guard let resp = data.data else {
                    print("未从\(self.module)详情接口获取数据 \(data.message)")
                    return
                }
                self.item = resp
                // 处理特殊数据
                completion()
            case let .failure(error):
                print("加载\(self.module)详情失败 \(error.localizedDescription)")
            }
        }
    }
    
    // 更新数据
    func updateData(item: T, completion: @escaping (Result<String, Error>) -> Void) {
        thisAPI.update(obj: item) { result in
            switch result {
            case let .success(resp):
                if resp.code == 0 {
                    // 处理当前数据数组
                    if let idx = self.items.firstIndex(where: { $0.id == item.id }) {
                        self.items[idx] = item
                        completion(.success(""))
                    }
                    completion(.success(""))
                } else {
                    print("更新\(self.module)接口调用错误 \(resp.message)")
                    let error = NSError(domain: "ApiError", code: 0, userInfo: [NSLocalizedDescriptionKey: resp.message])
                    completion(.failure(error))
                }
            case let .failure(error):
                print("更新\(self.module)失败：\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // 新增数据
    func addData(item: T, completion: @escaping (Result<String, Error>) -> Void) {
        thisAPI.save(obj: item) { result in
            switch result {
            case let .success(resp):
                if resp.code == 0 {
                    // 新增完后刷新页面
                    self.fetchData {}
                    completion(.success(""))
                } else {
                    print("新增\(self.module)接口调用错误 \(resp.message)")
                    let error = NSError(domain: "ApiError", code: 0, userInfo: [NSLocalizedDescriptionKey: resp.message])
                    completion(.failure(error))
                }
            case let .failure(error):
                print("新增\(self.module)失败：\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // 删除数据
    func deleteData(item: T, completion: @escaping() -> Void) {
        thisAPI.delete(id: item.id as! Int) { result in
            switch result {
            case let .success(data):
                if data.code == 0 {
                    // 处理当前数据
                    let idx = self.items.firstIndex { $0.id == item.id }
                    self.items.remove(at: idx!)
                    completion()
                } else {
                    print("调用\(self.module)删除接口失败 \(data.message)")
                }
            case let .failure(error):
                print("删除\(self.module)失败 \(error.localizedDescription)")
            }
        }
    }
    
}
