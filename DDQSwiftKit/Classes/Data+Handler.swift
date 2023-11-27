//
//  Data+Handler.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import Foundation

public extension Dictionary {
    func ddqToData(options: JSONSerialization.WritingOptions = .fragmentsAllowed) -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    
    func ddqToJsonString(encoding: String.Encoding = .utf8) -> String? {
        guard let data = ddqToData() else {
            return nil
        }
        
        guard let jsonString = String.init(data: data, encoding: encoding) else {
            return nil
        }
                
        return jsonString.ddqTrimmingWhitespacesAndNewlines()
    }
}

public extension Array {
    func ddqToData(options: JSONSerialization.WritingOptions = .fragmentsAllowed) -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }

    func ddqToJsonString(encoding: String.Encoding = .utf8) -> String? {
        guard let data = ddqToData() else {
            return nil
        }
        
        guard let jsonString = String.init(data: data, encoding: encoding) else {
            return nil
        }
                
        return jsonString.ddqTrimmingWhitespacesAndNewlines()
    }
}

public extension String {
    func ddqToData(encoding: String.Encoding = .utf8) -> Data? {
        return data(using: encoding)
    }
    
    func ddqBase64StringToData() -> Data? {
        return Data.init(base64Encoded: self)
    }
    
    func ddqToMD5() -> String? {
        
        let _nsstring = self as NSString
        return _nsstring.md5()
    }
    
    func ddqToBase64() -> String? {
        return ddqToData()?.ddqToBase64()
    }
}

public extension Data {
    func ddqToBase64() -> String {
        return base64EncodedString()
    }
    
    func ddqToMD5(encoding: String.Encoding = .utf8) -> String? {
        return String.init(data: self, encoding: encoding)?.ddqToMD5()
    }
    
    func ddqToJson(options: JSONSerialization.ReadingOptions = .fragmentsAllowed) -> Any? {
        return try? JSONSerialization.jsonObject(with: self, options: options)
    }
}
