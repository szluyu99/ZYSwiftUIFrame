//
//  UploadApi.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/2.
//

import Alamofire
import UIKit

class UploadApi: BaseAPI {
    // 上传图片
    static func uploadImage(image: UIImage, completion: @escaping (Result<ServerResponse<Upload>, Error>) -> Void) {
        NetworkManager.shared.uploadImg(image: image, to: "uploadAndDownload/upload", params: [:]) { result in
            switch result {
            case let .success(data):
                let parseResult: Result<ServerResponse<Upload>, Error> = super.parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
