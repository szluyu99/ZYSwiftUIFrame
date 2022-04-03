//
//  CommonApiObj.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

/**
 * 实例变量的方式使用 API
 */
import Alamofire

class CommonApiObj<T> where T : Codable {
    
    var moduleUrl: String
    
    // 传入模块名
    init(moduleUrl: String) {
        self.moduleUrl = moduleUrl
    }
    
    // 获取基本信息列表
    func list(parameters: Parameters,
              completion: @escaping (Result<ServerResponse<DataList<T>>, Error>) -> Void) {
        BaseAPI.getList(path: "\(self.moduleUrl)/getPageList", parameters: parameters, completion: completion)
    }
    
    // 获取基本信息详情
    func detail(id: Int, completion: @escaping (Result<ServerResponse<T>, Error>) -> Void) {
        BaseAPI.getDetail(path: "\(self.moduleUrl)/detail?id=\(id)", id: id, completion: completion)
    }
    
    // 新增
    func save(obj: T, completion: @escaping (Result<ServerResponse<T>, Error>) -> Void) {
        BaseAPI.saveOrUpdate(path: "\(self.moduleUrl)/saveOrUpdate", obj: obj, completion: completion)
    }
    
    // 更新
    func update(obj: T, completion: @escaping(Result<ServerResponse<T>, Error>) -> Void) {
        BaseAPI.saveOrUpdate(path: "\(self.moduleUrl)/saveOrUpdate", obj: obj, completion: completion)
    }
    
//    // 新增 / 更新
//    func saveOrUpdate(obj: T, completion: @escaping (Result<ServerResponse<T>, Error>) -> Void) {
//        BaseAPI.saveOrUpdate(path: "\(self.moduleUrl)/saveOrUpdate", obj: obj, completion: completion)
//    }
//
    // 删除
    func delete(id: Int, completion: @escaping(Result<ServerResponse<T>, Error>) -> Void) {
        BaseAPI.delete(path: "\(self.moduleUrl)/delete?id=\(id)", id: id, completion: completion)
    }
    
}
