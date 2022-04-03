//
//  ServerResponse.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

/**
 * 通用响应实体
 */
struct ServerResponse<Model: Codable>: Codable {
    var code: Int
    var message: String
    var data: Model?
    var time: String
}

/*
 * 通用列表数据实体
 */
struct DataList<Model: Codable>: Codable {
    let total: Int
    var records: [Model]
    let page: Int
    let pageSize: Int
}
