//
//  MultipleImagePickView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/2.
//

import SwiftUI

struct MultipleImagePickView: View {
    let text: String
    @Binding var imgList: [Upload]
    
    @State private var showImagePicker: Bool = false // 展示图片选择
    
    var body: some View {
        HStack {
            Text("\(text)：")
            Spacer()
            // 选择图片
            Button { showImagePicker = true } label: {
                VStack { Image(systemName: "photo.fill") }
            }
            .buttonStyle(BorderlessButtonStyle())
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(filter: .any(of: [.images, .livePhotos]), selectionLimit: 9, delegate: ImagePickerView.Delegate(
                    isPresented: $showImagePicker,
                    // 取消的回调
                    didCancel: { phPickerViewController in
                        print("Did Cancel: \(phPickerViewController)")
                    },
                    // 选择图片后的回调
                    didSelect: { result in
                        let images = result.images
                        for img in images {
                            uploadImg(img: img) {}
                        }
                    },
                    // 失败的回调
                    didFail: { (imagePickerError) in
                        let phPickerViewController = imagePickerError.picker
                        let error = imagePickerError.error
                        print("Did Fail with error: \(error) in \(phPickerViewController)")
                    }))
            }
        }
    }
    
    // 上传图片
    private func uploadImg(img: UIImage, complete: @escaping () -> Void) {
        UploadApi.uploadImage(image: img) { result in
            switch result {
            case let .success(data):
                print(data.data!)
                self.imgList.append(data.data!)
                complete()
            case let .failure(error):
                print("图片上传失败 \(error.localizedDescription)")
            }
        }
    }
    
}
