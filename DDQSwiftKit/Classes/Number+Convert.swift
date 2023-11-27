//
//  Number+Convert.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/22.
//

import UIKit

public extension Int {
    func ddqToCGFloat() -> CGFloat {
        CGFloat(self)
    }
    
    func ddqToDouble() -> Double {
        Double(self)
    }
    
    func ddqToFloat() -> Float {
        Float(self)
    }
    
    func ddqToString(format: String = "%d") -> String {
        String(format: format, self)
    }
    
    func ddqToScaleValue() -> CGFloat {
        Double(self).ddqToCGFloat().ddqScaleValue()
    }
    
    func ddqToScaleValue(scale: CGFloat) -> CGFloat {
        Double(self).ddqToCGFloat().ddqScaleValue(scale: scale)
    }
    
    /// 人民币：分 -> 元
    func ddqToYuan() -> Double {
        ddqToDouble() / 100.0
    }
    
    /// 人民币：元 -> 分
    func ddqToFen() -> Double {
        ddqToDouble() * 100.0
    }
    
    func ddqToDateString(formatter: String? = nil) -> String {
        
        let date = Date(timeIntervalSince1970: ddqToDouble())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter ?? "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
}

public extension Double {
    func ddqToCGFloat() -> CGFloat {
        CGFloat(self)
    }
    
    func ddqToInt() -> Int {
        Int(self)
    }
    
    func ddqToFloat() -> Float {
        Float(self)
    }
    
    func ddqToString(format: String = "%f") -> String {
        String(format: format, self)
    }
    
    func ddqToScaleValue() -> CGFloat {
        ddqToCGFloat().ddqScaleValue()
    }
    
    func ddqToScaleValue(scale: CGFloat) -> CGFloat {
        ddqToCGFloat().ddqScaleValue(scale: scale)
    }
}

public extension Float {
    func ddqToCGFloat() -> CGFloat {
        CGFloat(self)
    }
    
    func ddqToInt() -> Int {
        Int(self)
    }
    
    func ddqToDouble() -> Double {
        Double(self)
    }
    
    func ddqToString(format: String = "%f") -> String {
        String(format: format, self)
    }
    
    func ddqToScaleValue() -> CGFloat {
        ddqToCGFloat().ddqScaleValue()
    }
    
    func ddqToScaleValue(scale: CGFloat) -> CGFloat {
        ddqToCGFloat().ddqScaleValue(scale: scale)
    }
}

public extension CGFloat {
    func ddqToDouble() -> Double {
        Double(self)
    }
    
    func ddqToInt() -> Int {
        Int(self)
    }
    
    func ddqToFloat() -> Float {
        Float(self)
    }
    
    func ddqToString(format: String = "%f") -> String {
        String(format: format, self)
    }
}

public extension String {
    func ddqToInt() -> Int {
        
        let nsstring = self as NSString
        return nsstring.integerValue
    }
    
    func ddqToDouble() -> Double {
        
        let nsstring = self as NSString
        return nsstring.doubleValue
    }
    
    func ddqToFloat() -> Float {
        
        let nsstring = self as NSString
        return nsstring.floatValue
    }

    func ddqToBool() -> Bool {
        
        let nsstring = self as NSString
        return nsstring.boolValue
    }
    
    func ddqToCGFloat() -> CGFloat {
        
        let nsstring = self as NSString
        return nsstring.doubleValue.ddqToCGFloat()
    }
}
