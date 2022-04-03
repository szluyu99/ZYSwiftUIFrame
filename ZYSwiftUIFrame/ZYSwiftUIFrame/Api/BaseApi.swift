//
//  BaseAPI.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import Foundation
import Alamofire

class BaseAPI {
    // 获取数据列表
    static func getList<T: Codable>(path: String, parameters: Parameters, completion: @escaping (Result<T, Error>) -> Void) {
        NetworkManager.shared.requestPost(path: path, parameters: parameters) { result in
            switch result {
            case let.success(data):
                let parseResult: Result<T, Error> = parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    // 获取数据详情（根据id）
    static func getDetail<T: Codable>(path: String, id: Int, completion: @escaping (Result<T, Error>) -> Void) {
        NetworkManager.shared.requestGet(path: path, parameters: nil) { result in
            switch result {
            case let .success(data):
                let parseResult: Result<T, Error> = parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    // 新增/修改 数据
    static func saveOrUpdate<T: Codable>(path: String, obj: T,
                                         completion: @escaping (Result<ServerResponse<T>, Error>) -> Void) {
        guard let parameters = model2Dic(obj) else {
            let error = NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "model2Dic Error"])
            completion(.failure(error))
            return
        }
        NetworkManager.shared.requestPost(path: path, parameters: parameters) { result in
            switch result {
            case let .success(data):
                let parseResult: Result<ServerResponse<T>, Error> = parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    // 删除数据
    static func delete<T: Codable>(path: String, id: Int, completion: @escaping (Result<T, Error>) -> Void) {
        NetworkManager.shared.requestGet(path: path, parameters: nil) { result in
            switch result {
            case let .success(data):
                let parseResult: Result<T, Error> = self.parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    // json -> model
    static func parseData<T: Decodable>(_ data: Data) -> Result<T, Error> {
        let decoder = JSONDecoder()
        
        let dataStr = String(data: data, encoding: .utf8)!
        print(dataStr)
        
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            let error = NSError(domain: "NetworkAPIError", code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Can not parse data"])
            return .failure(error)
        }
        return .success(decodedData)
    }
    
    // model -> dic
    static func model2Dic<T: Encodable>(_ model: T) -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(model) else {
            return nil
        }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
            return nil
        }
        return dict
    }

}
