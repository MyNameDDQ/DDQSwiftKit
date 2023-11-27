//
//  Dictionary+Handler.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import Foundation
import SwiftyJSON

public extension Dictionary where Key == String {
    private func _toJson() -> JSON {
        JSON.init(self)
    }
    
    func ddqArrayFor(_ key: String) -> [Any] {
        _toJson()[key].arrayObject ?? []
    }
    
    func ddqDictionaryFor(_ key: String) -> [String: Any] {
        _toJson()[key].dictionaryObject ?? [:]
    }

    func ddqStringFor(_ key: String) -> String {
        _toJson()[key].stringValue
    }

    func ddqIntFor(_ key: String) -> Int {
        _toJson()[key].intValue
    }
        
    func ddqDoubleFor(_ key: String) -> Double {
        _toJson()[key].doubleValue
    }

    func ddqFloatFor(_ key: String) -> Float {
        _toJson()[key].floatValue
    }
    
    func ddqBoolFor(_ key: String) -> Bool {
        _toJson()[key].boolValue
    }
    
    func ddqCGFloatFor(_ key: String) -> CGFloat {
        ddqFloatFor(key).ddqToCGFloat()
    }
    
    func ddqObjectFor<T>(_ key: String) -> T? {
        _toJson()[key].object as? T
    }
}

public extension Dictionary {
    
    /// 合并两个字典
    /// - Parameters:
    ///   - other: 新字典
    ///   - update: 字段冲突时，是否用other提供的数据更新
    mutating func ddqAddEntries(_ other: [Key: Value], update: Bool = true) {
        merge(other) { current, new in update ? new : current }
    }
    
    mutating func ddqRemoveForKeys(_ keys: [AnyHashable]) {
        for key in keys {
            removeValue(forKey: key as! Key)
        }
    }
    
    func ddqDictionaryForKeys(_ keys: [Key]) -> [Key: Value] {
        if isEmpty {
            return [:]
        }
        
        var dic: [Key: Value] = .init()
        
        for key in keys {
            if let value = self[key] {
                dic.updateValue(value, forKey: key)
            }
        }
        
        return dic
    }
}

public extension Dictionary where Key: Comparable {
    func ddqSortedKeys(_ ascending: Bool = true) -> [Key] {
        keys.map { $0 }.ddqSortedArray(ascending: ascending)
    }
}
