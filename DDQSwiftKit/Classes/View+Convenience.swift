//
//  View+Convenience.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/22.
//

import UIKit

public var ddqScreenWidth: CGFloat {
    ddqScreen.bounds.width
}

public var ddqScreenHeight: CGFloat {
    ddqScreen.bounds.height
}

public var ddqKeyWindow: UIWindow? {
    UIApplication.shared.keyWindow
}

public var ddqRootViewController: UIViewController? {
    ddqKeyWindow?.rootViewController
}

public var ddqDevice: UIDevice {
    .current
}

public var ddqScreen: UIScreen {
    .main
}

@available(iOS 13.0, *)
public var ddqUserInterfaceStyle: UIUserInterfaceStyle {
    UITraitCollection.current.userInterfaceStyle
}

public var ddqIsLightStyle: Bool {
    if #available(iOS 13.0, *) {
        return UITraitCollection.current.ddqIsLightStyle
    }
    
    return true
}

extension UITraitCollection {
    @available(iOS 13.0, *)
    var ddqIsLightStyle: Bool {
        userInterfaceStyle != .dark
    }
}

public extension UIView {
    var ddqX: CGFloat {
        frame.minX
    }
    
    var ddqY: CGFloat {
        frame.minY
    }

    var ddqWidth: CGFloat {
        bounds.width
    }
    
    var ddqHeight: CGFloat {
        bounds.height
    }

    var ddqMaxY: CGFloat {
        frame.maxY
    }
    
    var ddqMaxX: CGFloat {
        frame.maxX
    }
    
    var ddqMidY: CGFloat {
        frame.midY
    }
    
    var ddqMidX: CGFloat {
        frame.midX
    }
    
    var ddqBoundsMaxY: CGFloat {
        bounds.maxY
    }
    
    var ddqBoundsMaxX: CGFloat {
        bounds.maxX
    }
    
    var ddqBoundsMidY: CGFloat {
        bounds.midY
    }
    
    var ddqBoundsMidX: CGFloat {
        bounds.midX
    }
    
    var ddqSize: CGSize {
        bounds.size
    }
            
    var ddqLayoutSafeInsets: UIEdgeInsets {
       
        var insets = UIEdgeInsets()
        let keyWindow = ddqKeyWindow
        
        if #available(iOS 11.0, *) {
            insets = safeAreaInsets
        } else {
            
            insets.top = keyWindow?.rootViewController?.topLayoutGuide.length ?? 0.0
            insets.bottom = keyWindow?.rootViewController?.bottomLayoutGuide.length ?? 0.0
        }
        
        return insets
    }
}

public extension UIView {
    func ddqSetOrigin(_ origin: CGPoint) {
        
        var frame = frame
        frame.origin = origin
        self.frame = frame
    }
    
    func ddqSetX(_ x: CGFloat) {
        ddqSetOrigin(CGPoint(x: x, y: ddqY))
    }
    
    func ddqSetY(_ y: CGFloat) {
        ddqSetOrigin(CGPoint(x: ddqX, y: y))
    }
    
    func ddqSetSize(_ size: CGSize) {
        
        var frame = frame
        frame.size = size
        self.frame = frame
    }
    
    func ddqSetWidth(_ width: CGFloat) {
        ddqSetSize(CGSize(width: width, height: ddqHeight))
    }
    
    func ddqSetHeight(_ height: CGFloat) {
        ddqSetSize(CGSize(width: ddqWidth, height: height))
    }
    
    func ddqSetLayer(radius: CGFloat? = nil, width: CGFloat? = nil, color: UIColor? = nil) {
        if let r = radius {
            layer.cornerRadius = r
        }
        
        if let w = width {
            layer.borderWidth = w
        }
        
        if let c = color {
            layer.borderColor = c.cgColor
        }
    }
    
    func ddqSetBezierLayer(corners: UIRectCorner = .allCorners, radii: CGSize = .init(width: 5.0, height: 5.0)) {
        
        let layer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii)
        layer.path = path.cgPath
        layer.frame = path.bounds
        path.close()
        layer.mask = layer
    }
}

public extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    
    static func *(_ p: CGPoint, scale: (x: CGFloat, y: CGFloat)) -> CGPoint {
        .init(x: p.x * scale.x, y: p.y * scale.y)
    }

    static func /(_ p: CGPoint, scale: (x: CGFloat, y: CGFloat)) -> CGPoint {
        .init(x: p.x / scale.x, y: p.y / scale.y)
    }
}

public extension CGSize {
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        .init(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func *(_ s: CGSize, scale: (x: CGFloat, y: CGFloat)) -> CGSize {
        .init(width: s.width * scale.x, height: s.height * scale.y)
    }

    static func /(_ s: CGSize, scale: (x: CGFloat, y: CGFloat)) -> CGSize {
        .init(width: s.width / scale.x, height: s.height / scale.y)
    }
}
