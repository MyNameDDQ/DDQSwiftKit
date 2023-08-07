//
//  View+Guide.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/22.
//

import UIKit

/**
 工程中对颜色的处理
 */
public extension UIColor {
    class func ddqColorWithRGBAC(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat, component: CGFloat) -> UIColor {
        UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha).withAlphaComponent(component)
    }

    class func ddqColorWithRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        ddqColorWithRGBAC(red: red, green: green, blue: blue, alpha: 1.0, component: 1.0)
    }

    class func ddqColorWithRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        ddqColorWithRGBAC(red: red, green: green, blue: blue, alpha: alpha, component: 1.0)
    }

    class func ddqColorWithRGBC(red: CGFloat, green: CGFloat, blue: CGFloat, component: CGFloat) -> UIColor {
        ddqColorWithRGBAC(red: red, green: green, blue: blue, alpha: 1.0, component: component)
    }

    class func ddqColorWithHexAC(hexString: String?, alpha: CGFloat, component: CGFloat) -> UIColor {
        guard hexString != nil else {
            return clear
        }
        
        let colorString = hexString!.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: colorString)
        
        if colorString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        return ddqColorWithRGBAC(red: red, green: green, blue: blue, alpha: alpha, component: component)
    }

    class func ddqColorWithHexA(hexString: String?, alpha: CGFloat) -> UIColor {
        ddqColorWithHexAC(hexString: hexString, alpha: alpha, component: 1.0)
    }

    class func ddqColorWithHexC(hexString: String?, component: CGFloat) -> UIColor {
        ddqColorWithHexAC(hexString: hexString, alpha: 1.0, component: component)
    }

    class func ddqColorWithHex(hexString: String?) -> UIColor {
        ddqColorWithHexAC(hexString: hexString, alpha: 1.0, component: 1.0)
    }

    func ddqColorToHexString() -> String? {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
                 
        if alpha == 1.0 {
            return String(format: "#%02lX%02lX%02lX", Int(red * multiplier), Int(green * multiplier), Int(blue * multiplier))
        } else {
            return String(format: "#%02lX%02lX%02lX%02lX", Int(red * multiplier), Int(green * multiplier), Int(blue * multiplier), Int(alpha * multiplier))
        }
    }
}

/// 自定义一些常用的颜色
public extension UIColor {
    class func ddqTextColor() -> UIColor {
        if #available(iOS 13.0, *) {
            
            return UIColor.init { (collection) -> UIColor in
                return collection.ddqIsLightStyle ? ddqColorWithRGB(red: 53.0, green: 53.0, blue: 53.0) : white
            }
        }

        return ddqColorWithRGB(red: 53.0, green: 53.0, blue: 53.0)
    }
        
    class func ddqBackgroundColor() -> UIColor {
        if #available(iOS 13.0, *) {
            
            return UIColor.init { (collection) -> UIColor in
                return collection.ddqIsLightStyle ? white : black
            }
        }
        
        return white
    }
            
    class func ddqSeparatorColor() -> UIColor {
        if #available(iOS 13.0, *) {
            
            return UIColor.init { (collection) -> UIColor in
                return collection.ddqIsLightStyle ? ddqColorWithRGB(red: 205.0, green: 205.0, blue: 205.0) : white
            }
        }

        return ddqColorWithRGB(red: 153.0, green: 153.0, blue: 153.0)
    }
        
    class func ddqPlaceholderColor() -> UIColor {
        if #available(iOS 13.0, *) {
            
            return UIColor.init { (collection) -> UIColor in
                return collection.ddqIsLightStyle ? UIColor.lightGray.withAlphaComponent(0.7) : white
            }
        }

        return UIColor.lightGray.withAlphaComponent(0.7)
    }
}

/// 定义控件的默认间距。
public extension CGFloat {
    /// 4
    static var ddqSpacingS: CGFloat { 4.0 }
    
    /// 8
    static var ddqSpacingM: CGFloat { 8.0 }
    
    /// 16
    static var ddqSpacingB: CGFloat { 16.0 }
    
    /// 24
    static var ddqSpacingL: CGFloat { 24.0 }
    
    /// 32
    static var ddqSpacingXL: CGFloat { 32.0 }
    
    /// 40.0
    static var ddqSpacingXXL: CGFloat { 40.0 }
}

public extension UIEdgeInsets {
    
    /// 布局时的四边边距
    static var ddqEdgeInsets: UIEdgeInsets {
        
        let value: CGFloat = .ddqSpacingB
        return .init(top: value, left: value, bottom: value, right: value)
    }
    
    /// 布局内的控件间隔
    static var ddqSpacingInsets: UIEdgeInsets {
        
        let value: CGFloat = .ddqSpacingM
        return .init(top: value, left: value, bottom: value, right: value)
    }
}

public extension CGFloat {
    /// 16
    static var ddqTitleSize: CGFloat { 16.0 }
    
    /// 20
    static var ddqTitle2Size: CGFloat { 20.0 }
    
    /// 24
    static var ddqTitle3Size: CGFloat { 24.0 }

    /// 14
    static var ddqSubTitleSize: CGFloat { 14.0 }
    
    /// 15
    static var ddqBodySize: CGFloat { 15.0 }
    
    /// 12
    static var ddqSmallSize: CGFloat { 12.0 }
        
    /// 36
    static var ddqXLSize: CGFloat { 36.0 }
    
    /// 42
    static var ddqXXLSize: CGFloat { 42.0 }
}

extension CGFloat {
    // 默认6s比例
    func ddqScaleValue() -> CGFloat { ddqScaleValue(scale: UIScreen.main.bounds.width / 375.0) }
    
    // 布局时的比例
    func ddqScaleValue(scale: CGFloat) -> CGFloat { self * scale }
}

/**
 工程中的字体处理
 */
public extension UIFont {
    class func ddqFont(size: CGFloat, weight: Weight) -> UIFont { systemFont(ofSize: size, weight: weight) }

    class func ddqFont(size: CGFloat) -> UIFont { ddqFont(size: size, weight: .regular) }
    
    class func ddqFont() -> UIFont { ddqFont(size: .ddqTitleSize) }
    
    func ddqFont(offset: CGFloat) -> UIFont { .ddqFont(size: self.pointSize - offset) }
}
