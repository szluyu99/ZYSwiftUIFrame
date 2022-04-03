//
//  Upload.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/4/2.
//

// 文件上传对象（图片）
struct Upload: Codable, Identifiable {
    @Default<Int> var id: Int
    @Default<String> var name: String
    @Default<String> var url: String
    @Default<String> var tag: String
    @Default<String> var key: String
    
//    enum CodingKeys: String, CodingKey {
//        case id, name, url, tag, key
//    }
    
    init() {
        self.id = 0
        self.name = ""
        self.url = ""
        self.tag = ""
        self.key = ""
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
//        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
//        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
//        tag = try container.decodeIfPresent(String.self, forKey: .tag) ?? ""
//        key = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
//    }
    
}
