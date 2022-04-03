//
//  ImageShowView.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/2.
//

import SwiftUI
import ImageViewerRemote
import SDWebImageSwiftUI

/**
 * 图片展示(网格)
 */
struct ImageShowView: View {
    @Binding var imgList: [Upload]
    
    // 图片展示
    var rows: Int { imgList.count / cols }
    var cols: Int { imgList.count == 8 ? 4 : min(imgList.count, 4) }
    var lastRowCols: Int { imgList.count % cols }
    
    // 图片操作
    @State var imgURL: String = "" // 当前点击的图片 URL
    @State var showImageViewer: Bool = false // 图片预览器
    @State var showSheet = false // 展示对图片的操作框
    
    // 消息提示
    @State private var alertMsg = ""
    @State private var showAlert = false
    
    var body: some View {
        if (imgList.count != 0) {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(0 ..< rows, id: \.self) { row in
                    self.rowBody(row: row, isLast: false)
                }
                if lastRowCols > 0 {
                    self.rowBody(row: rows, isLast: true)
                }
            }
            .fullScreenCover(isPresented: $showImageViewer) {
                EmptyView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // 图片预览
                    .overlay(ImageViewerRemote(imageURL: self.$imgURL, viewerShown: self.$showImageViewer))
                    .onTapGesture {
                        self.showSheet = true
                    }
                    .actionSheet(isPresented: $showSheet, content: {imgOptSheet})
                    .alert(isPresented: $showAlert, content: {
                        Alert(title: Text("消息提示"),
                              message: Text(self.alertMsg),
                              dismissButton: .default(Text("确定")))
                    })
            }
        }
    }
    
    func rowBody(row: Int, isLast: Bool) -> some View {
        HStack(spacing: 6) {
            ForEach(0 ..< (isLast ? self.lastRowCols : self.cols), id: \.self) { col in
                // 这里加上服务器前缀(根据需求决定要不要)
                WebImage(url: URL(string: NetworkAPIBaseURL + self.imgList[row * self.cols + col].url))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 60, maxWidth: 80, minHeight: 60, maxHeight: 80)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .onTapGesture {
                        // 这里加上服务器前缀(根据需求决定要不要)
                        self.imgURL = NetworkAPIBaseURL + self.imgList[row * self.cols + col].url
                        self.showImageViewer = true
                    }
            }
        }
    }
    
    // 点击图片进行的操作
    private var imgOptSheet: ActionSheet {
        let action = ActionSheet(title: Text("图片操作"), message: Text("请选择您的操作"),
                                 buttons: [.default(Text("保存图片到相册"), action: {
            self.showSheet = false
            ImageUtil.saveImageToAlbumFromURL(urlStr: self.imgURL, successHandler: {
                self.alertMsg = "保存成功！"
                self.showAlert = true
            }, errorHandler: {
                self.alertMsg = "保存失败！\($0.localizedDescription)"
                self.showAlert = true
            })
        }),.destructive(Text("删除图片"), action: {
            removeImg()
            self.showSheet = false
        }),.cancel(Text("取消"), action: {
            self.showSheet = false
        })])
        return action
    }
    
    // 删除列表中的图片
    private func removeImg() {
        // 这里加上服务器前缀(根据需求决定要不要)
        if let idx = imgList.firstIndex(where: { NetworkAPIBaseURL + $0.url == self.imgURL } ) {
            imgList.remove(at: idx)
            self.showImageViewer = false
        } else {
            print("图片删除失败")
        }
    }
}
