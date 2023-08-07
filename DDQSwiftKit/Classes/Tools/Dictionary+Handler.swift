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
    
    func ddqArrayWithKey(key: String) -> [Any] {
        _toJson()[key].arrayObject ?? Array()
    }
    
    func ddqIntWithKey(key: String) -> Int {
        _toJson()[key].intValue
    }
    
    func ddqDoubleWithKey(key: String) -> Double {
        _toJson()[key].doubleValue
    }

    func ddqFloatWithKey(key: String) -> Float {
        _toJson()[key].floatValue
    }
    
    func ddqBoolWithKey(key: String) -> Bool {
        _toJson()[key].boolValue
    }
    
    func ddqStringWithKey(key: String) -> String {
        _toJson()[key].stringValue
    }
    
    func ddqDictionaryWithKey(key: String) -> [Key: Any] {
        _toJson()[key].dictionaryObject ?? Dictionary()
    }
}

public extension Dictionary {
    mutating func ddqAddEntries(other: [Key: Value]) {
        for (key, value) in other {
            self.updateValue(value, forKey: key)
        }
    }    
}
