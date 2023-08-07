//
//  DDQLayoutMaker.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/22.
//

import UIKit

public struct DDQLayoutCenterOffset {
    
    var xOffset: CGFloat
    var yOffset: CGFloat
}

public extension DDQLayoutCenterOffset {
    static var zero: DDQLayoutCenterOffset {
        return DDQLayoutCenterOffset(xOffset: 0.0, yOffset: 0.0)
    }
}

open class DDQLayoutMake {
    public enum DDQLayoutDirection: Int {
        
        case none
        case topToBottom
        case leftToRight
        case bottomToTop
        case rightToLeft
        case center
        case centerX
        case centerY
    }
        
    private enum DDQLayoutType: Int {
        
        case top
        case left
        case bottom
        case right
        case centerX
        case centerY
        case center
    }
    
    private(set) var view: UIView?
    private(set) var horDirection: DDQLayoutDirection = .none
    private(set) var verDirection: DDQLayoutDirection = .none
    private var origin: CGPoint = .zero

    public convenience init(view: UIView) {
        
        self.init()
        self.view = view
    }
    
    open func ddqTop(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        self._handleInstallPoint(type: .top, property: property, value: value, offset: .zero)
        return self
    }
    
    open func ddqLeft(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        self._handleInstallPoint(type: .left, property: property, value: value, offset: .zero)
        return self
    }

    open func ddqBottom(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        self._handleInstallPoint(type: .bottom, property: property, value: value, offset: .zero)
        return self
    }

    open func ddqRight(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        self._handleInstallPoint(type: .right, property: property, value: value, offset: .zero)
        return self
    }

    open func ddqCenter(property: DDQLayoutProperty, offset: DDQLayoutCenterOffset) -> Self {

        self._handleInstallPoint(type: .center, property: property, value: 0.0, offset: offset)
        return self
    }

    open func ddqCenterX(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        self._handleInstallPoint(type: .centerX, property: property, value: value, offset: .zero)
        return self
    }
    
    open func ddqCenterY(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        self._handleInstallPoint(type: .centerY, property: property, value: value, offset: .zero)
        return self
    }
    
    open func ddqSize(size: CGSize) {
        self._handleInstallSize(size: size)
    }
    
    open func ddqSizeToFit() {
        
        self.view?.sizeToFit()
        self.ddqSize(size: self.view?.ddqSize ?? .zero)
    }

    open func ddqSizeThatFits(size: CGSize) {
        ddqSizeThatFits(size: size, scale: 1.0)
    }
    
    open func ddqSizeThatFits(size: CGSize, scale: CGFloat) {
        
        let fitSize = self.view?.sizeThatFits(size)
        ddqSize(size: CGSize(width: (fitSize?.width ?? 0.0) * scale, height: (fitSize?.height ?? 0.0) * scale))
    }
        
    open func ddqWidth(width: CGFloat) {
        ddqSize(size: CGSize(width: width, height: self.view?.ddqHeight ?? 0.0))
    }
    
    open func ddqHeight(height: CGFloat) {
        ddqSize(size: CGSize(width: self.view?.ddqWidth ?? 0, height: height))
    }

    open func ddqInsets(insets: UIEdgeInsets, targertView: UIView?) {
        
        let view = targertView ?? self.view?.superview
        
        guard view != nil else {
            return
        }
        
        let size: CGSize = .init(width: view!.ddqWidth - insets.left - insets.right, height: view!.ddqHeight - insets.top - insets.bottom)
        self.ddqLeft(property: view!.ddqLeft, value: insets.left).ddqTop(property: view!.ddqTop, value: insets.top).ddqSize(size: size)
    }
        
    open func ddqUpdate() {
        self.ddqSize(size: self.view?.ddqSize ?? CGSize.zero)
    }
    
    private func _handleInstallPoint(type: DDQLayoutType, property: DDQLayoutProperty, value: CGFloat, offset: DDQLayoutCenterOffset) {
        guard self.view != nil else {
            return
        }
        
        var frame = self.view!.frame
        let propertyValue = self._getValueWithProperty(property: property)
        let value = propertyValue + value
        
        switch type {
            case .top:
                self.verDirection = .topToBottom
                frame.origin.y = value
                
            case .left:
                self.horDirection = .leftToRight
                frame.origin.x = value
                
            case .bottom:
                self.verDirection = .bottomToTop
                frame.origin.y = value
                
            case .right:
                self.horDirection = .rightToLeft
                frame.origin.x = value
                
            case .centerX:
                self.horDirection = .centerX
                frame.origin.x = value

            case .centerY:
                self.verDirection = .centerY
                frame.origin.y = value
                
            case .center:
                self.horDirection = .center
                self.verDirection = .center
                
                if let layoutView = property.layoutView {
                    
                    let isSuper = self.view?.superview == layoutView
                    let x = isSuper ? layoutView.ddqBoundsMidX : layoutView.ddqMidX
                    let y = isSuper ? layoutView.ddqBoundsMidY : layoutView.ddqMidY
                    frame.origin = CGPoint(x: x + offset.xOffset, y: y + offset.yOffset)
                }
        }
        
        self.origin = frame.origin
        self.view!.frame = frame
    }
    
    private func _getValueWithProperty(property: DDQLayoutProperty?) -> CGFloat {
        guard property != nil else {
            return 0.0
        }
        
        guard property!.layoutView != nil else {
            return 0.0
        }
        
        var value: CGFloat = 0.0
        let layoutView = property!.layoutView!
        let isSuper = layoutView == self.view?.superview
        
        switch property?.aligment {
            case .top:
                value = isSuper ? 0.0 : layoutView.ddqY
                
            case .left:
                value = isSuper ? 0.0 : layoutView.ddqX
                
            case .bottom:
                value = isSuper ? layoutView.ddqBoundsMaxY : layoutView.ddqMaxY
                
            case .right:
                value = isSuper ? layoutView.ddqBoundsMaxX : layoutView.ddqMaxX
                
            case .centerX:
                value = isSuper ? layoutView.ddqBoundsMidX : layoutView.ddqMidX
                
            case .centerY:
                value = isSuper ? layoutView.ddqBoundsMidY : layoutView.ddqMidY
                
            default:
            break
        }
        
        return value
    }
    
    private func _handleInstallSize(size: CGSize) {
        guard self.view != nil else {
            return
        }
        
        var newX = self.origin.x
        var newY = self.origin.y
        
        switch self.horDirection {
            case .rightToLeft:
                newX -= size.width

            case .centerX:
                newX -= size.width * 0.5
                
            case .center:
                newX -= size.width * 0.5

            default:
                break
        }
        
        switch self.verDirection {
            case .bottomToTop:
                newY -= size.height

            case .centerY:
                newY -= size.height * 0.5

            case .center:
                newY -= size.height * 0.5

            default:
                break
        }
        
        var frame = self.view!.frame
        frame.origin = CGPoint(x: newX, y: newY)
        frame.size = size
        self.view!.frame = frame
    }
}

public extension UIView {
    
    typealias DDQLayoutMakeBlock = (DDQLayoutMake) -> Void
    
    func ddqMake(make: DDQLayoutMakeBlock) {
        
        let install = DDQLayoutMake(view: self)
        make(install)
    }
    
    func ddqReturnMake(make: DDQLayoutMakeBlock) -> DDQLayoutMake {
        
        let install = DDQLayoutMake(view: self)
        make(install)
        return install
    }
}

