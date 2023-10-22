//
//  View+Convenience.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/22.
//

import UIKit

public var ddqScreenWidth: CGFloat {
    UIScreen.main.bounds.width
}

public var ddqScreenHeight: CGFloat {
    UIScreen.main.bounds.height
}

public var ddqKeyWindow: UIWindow? {
    UIApplication.shared.keyWindow
}

public var ddqRootViewController: UIViewController? {
    ddqKeyWindow?.rootViewController
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
        self.userInterfaceStyle != .dark
    }
}

public extension UIView {
    var ddqX: CGFloat {
        self.frame.minX
    }
    
    var ddqY: CGFloat {
        self.frame.minY
    }

    var ddqWidth: CGFloat {
        self.bounds.width
    }
    
    var ddqHeight: CGFloat {
        self.bounds.height
    }

    var ddqMaxY: CGFloat {
        self.frame.maxY
    }
    
    var ddqMaxX: CGFloat {
        self.frame.maxX
    }
    
    var ddqMidY: CGFloat {
        self.frame.midY
    }
    
    var ddqMidX: CGFloat {
        self.frame.midX
    }
    
    var ddqBoundsMaxY: CGFloat {
        self.bounds.maxY
    }
    
    var ddqBoundsMaxX: CGFloat {
        self.bounds.maxX
    }
    
    var ddqBoundsMidY: CGFloat {
        self.bounds.midY
    }
    
    var ddqBoundsMidX: CGFloat {
        self.bounds.midX
    }
    
    var ddqSize: CGSize {
        self.bounds.size
    }
            
    var ddqLayoutSafeInsets: UIEdgeInsets {
       
        var insets = UIEdgeInsets()
        let keyWindow = ddqKeyWindow
        
        if #available(iOS 11.0, *) {
            insets = self.safeAreaInsets
        } else {
            
            insets.top = keyWindow?.rootViewController?.topLayoutGuide.length ?? 0.0
            insets.bottom = keyWindow?.rootViewController?.bottomLayoutGuide.length ?? 0.0
        }
        
        return insets
    }
}

public extension UIView {
    func ddqSetOrigin(_ origin: CGPoint) {
        
        var frame = self.frame
        frame.origin = origin
        self.frame = frame
    }
    
    func ddqSetX(_ x: CGFloat) {
        self.ddqSetOrigin(CGPoint(x: x, y: self.ddqY))
    }
    
    func ddqSetY(_ y: CGFloat) {
        self.ddqSetOrigin(CGPoint(x: self.ddqX, y: y))
    }
    
    func ddqSetSize(_ size: CGSize) {
        
        var frame = self.frame
        frame.size = size
        self.frame = frame
    }
    
    func ddqSetWidth(_ width: CGFloat) {
        self.ddqSetSize(CGSize(width: width, height: self.ddqHeight))
    }
    
    func ddqSetHeight(_ height: CGFloat) {
        self.ddqSetSize(CGSize(width: self.ddqWidth, height: height))
    }
    
    func ddqSetLayer(radius: CGFloat? = nil, width: CGFloat? = nil, color: UIColor? = nil) {
        if let r = radius {
            self.layer.cornerRadius = r
        }
        
        if let w = width {
            self.layer.borderWidth = w
        }
        
        if let c = color {
            self.layer.borderColor = c.cgColor
        }
    }
    
    func ddqSetBezierLayer(corners: UIRectCorner = .allCorners, radii: CGSize = .init(width: 5.0, height: 5.0)) {
        
        let layer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: radii)
        layer.path = path.cgPath
        layer.frame = path.bounds
        path.close()
        self.layer.mask = layer
    }
}
