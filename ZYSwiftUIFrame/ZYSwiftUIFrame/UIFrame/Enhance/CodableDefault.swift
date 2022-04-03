//
//  CodableDefault.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

// 用于给 Codable 协议添加默认值
protocol DefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value { get }
}

@propertyWrapper
struct Default<T: DefaultValue> {
    var wrappedValue: T.Value
}

extension Default: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: Default<T>.Type, forKey key: Key) throws -> Default<T> where T: DefaultValue {
        // 判断 key 缺失的情况，提供默认值
        (try decodeIfPresent(type, forKey: key)) ?? Default(wrappedValue: T.defaultValue)
    }
}
extension KeyedEncodingContainer {
    mutating func encode<T>(_ value: Default<T>, forKey key: Key) throws where T : DefaultValue {
        try encodeIfPresent(value.wrappedValue, forKey: key)
    }
}

extension Int: DefaultValue {
    static var defaultValue = -1
}

extension String: DefaultValue {
    static var defaultValue = ""
}
