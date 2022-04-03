//
//  NetworkManager.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import Foundation
import Alamofire
import UIKit

// 给类型取别名,增加代码的可读性
typealias NetworkRequestResult = Result<Data, Error>
typealias NetworkRequestCompletion = (NetworkRequestResult) -> Void

public let NetworkAPIBaseURL = "http://192.168.3.6:8080/"

// 网络模块,设计为单例模式
class NetworkManager {
    // 共享对象
    static let shared = NetworkManager()
    
    // 获取有token的请求头
    // 你应当在合适的时机, 将 token 存入 UserDefaults 中
    var commonHeaders: HTTPHeaders { ["token": UserDefaults.standard.string(forKey: "token") ?? ""] }
    
    private init() {} // 外部无法使用该类创建该对象
    
    // 封装http-get请求
    @discardableResult // 外部调用该函数可以没有返回值
    func requestGet(path: String,
                    parameters: Parameters?,
                    // @escaping,逃逸闭包: 一个闭包被作为一个参数传递给一个函数，并且在函数return之后才被唤起执行
                    completion: @escaping NetworkRequestCompletion) -> DataRequest {
        AF.request(NetworkAPIBaseURL + path,
                   parameters: parameters,
                   headers: commonHeaders,
                   requestModifier: { $0.timeoutInterval = 30 })
            .responseData { response in
                switch response.result {
                case let .success(data): completion(.success(data))
                case let .failure(error): completion(self.handleError(error))
                }
            }
    }
    
    // 封装http-post请求
    @discardableResult
    func requestPost(path: String,
                     parameters: Parameters?,
                     completion: @escaping NetworkRequestCompletion) -> DataRequest {
        AF.request(NetworkAPIBaseURL + path,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.prettyPrinted, // parameters的编码方式,默认为JSON
                   headers: commonHeaders,
                   requestModifier: { $0.timeoutInterval = 30 })
            .responseData { response in
                // 请求发送成功与失败
                switch response.result {
                case let .success(data): completion(.success(data))
                case let .failure(error): completion(self.handleError(error))
                }
            }
    }

    // 图片上传
    @discardableResult
    func uploadImg(image: UIImage,
                   to url: String,
                   params: [String: Any],
                   completion: @escaping NetworkRequestCompletion) -> DataRequest
    {
        AF.upload(multipartFormData: { multiPart in
            print(NetworkAPIBaseURL + url)
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(image.jpegData(compressionQuality: 0.9)!, withName: "file", fileName: "file.png", mimeType: "image/png")
        }, to: NetworkAPIBaseURL + url)
            .uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseData { response in
                switch response.result {
                case let .success(data): completion(.success(data))
                case let .failure(error): completion(.failure(error))
                }
            }
    }
    
    // 处理网络请求中的错误
    private func handleError(_ error: AFError) -> NetworkRequestResult {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code
            if  code == NSURLErrorNotConnectedToInternet ||
                    code == NSURLErrorTimedOut ||
                    code == NSURLErrorInternationalRoamingOff ||
                    code == NSURLErrorDataNotAllowed ||
                    code == NSURLErrorCannotFindHost ||
                    code == NSURLErrorCannotConnectToHost ||
                    code == NSURLErrorNetworkConnectionLost {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "网络连接有问题喔～"
                let currentError = NSError(domain: nserror.domain, code: code, userInfo: userInfo)
                return .failure(currentError)
            }
        }
        return .failure(error)
    }
    
}
