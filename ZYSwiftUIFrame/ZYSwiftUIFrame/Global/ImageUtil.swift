//
//  ImageUtil.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/2.
//

import Foundation
import UIKit

// 网络图片工具类
class ImageUtil {
    /*
     * URL -> UIImage
     */
    static func downloadWebImage(urLStr: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urLStr) else {
            print("Invalid URL...")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("error: \(String(describing: error))")
            }
        }.resume()
    }
    
    /**
     * URL ---> 相册
     */
    static func saveImageToAlbumFromURL(urlStr: String,
                                        successHandler: (() -> Void)?,
                                        errorHandler: ((Error) -> Void)?) {
        let imageServer = ImageSaver()
        imageServer.successHandler = successHandler
        imageServer.errorHandler = errorHandler
        
        downloadWebImage(urLStr: urlStr) { image in
            imageServer.writeToPhotoAlbum(image: image)
        }
    }
    
    /**
     * UIImage ---> 相册
     */
    private func saveImageToAlbum(image: UIImage,
                          successHandler: (() -> Void)?,
                          errorHandler: ((Error) -> Void)?) {
        let imageServer = ImageSaver()
        imageServer.successHandler = successHandler
        imageServer.errorHandler = errorHandler
        imageServer.writeToPhotoAlbum(image: image)
    }
}


/**
 * 保存图片到本地
 */
class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?

    func writeToPhotoAlbum(image: UIImage) {
       UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveComplete), nil)
    }

    @objc func saveComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
       if let error = error {
           errorHandler?(error)
       } else {
           successHandler?()
       }
    }
}
