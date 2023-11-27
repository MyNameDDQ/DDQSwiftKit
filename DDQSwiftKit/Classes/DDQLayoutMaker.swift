//
//  DDQLayoutMaker.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/22.
//

import UIKit

open class DDQLayoutMake {
    public struct CenterOffset {
        
        public var xOffset: CGFloat
        public var yOffset: CGFloat
        
        public static var zero: CenterOffset {
            return .init(xOffset: 0.0, yOffset: 0.0)
        }
        
        public init(xOffset: CGFloat, yOffset: CGFloat) {
            self.xOffset = xOffset
            self.yOffset = yOffset
        }
    }

    public enum Direction {
        
        case none
        case topToBottom
        case leftToRight
        case bottomToTop
        case rightToLeft
        case center
        case centerX
        case centerY
    }
        
    private enum LayoutType {
        
        case top
        case left
        case bottom
        case right
        case centerX
        case centerY
        case center
    }
    
    private(set) var view: UIView?
    private(set) var horDirection: Direction = .none
    private(set) var verDirection: Direction = .none
    private var origin: CGPoint = .zero

    public convenience init(view: UIView) {
        
        self.init()
        self.view = view
    }
    
    open func ddqTop(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        _handleInstallPoint(type: .top, property: property, value: value, offset: .zero)
        return self
    }
    
    open func ddqLeft(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        _handleInstallPoint(type: .left, property: property, value: value, offset: .zero)
        return self
    }

    open func ddqBottom(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        _handleInstallPoint(type: .bottom, property: property, value: value, offset: .zero)
        return self
    }

    open func ddqRight(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        _handleInstallPoint(type: .right, property: property, value: value, offset: .zero)
        return self
    }

    open func ddqCenter(property: DDQLayoutProperty, offset: CenterOffset) -> Self {

        _handleInstallPoint(type: .center, property: property, value: 0.0, offset: offset)
        return self
    }

    open func ddqCenterX(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        _handleInstallPoint(type: .centerX, property: property, value: value, offset: .zero)
        return self
    }
    
    open func ddqCenterY(property: DDQLayoutProperty, value: CGFloat) -> Self {
        
        _handleInstallPoint(type: .centerY, property: property, value: value, offset: .zero)
        return self
    }
    
    open func ddqSize(size: CGSize) {
        _handleInstallSize(size: size)
    }
    
    open func ddqSize(size: CGSize, scale: CGFloat) {
        ddqSize(size: CGSize(width: size.width * scale, height: size.height * scale))
    }
    
    open func ddqSizeToFit() {
        
        view?.sizeToFit()
        ddqSize(size: view?.ddqSize ?? .zero)
    }

    open func ddqSizeThatFits(size: CGSize) {
        ddqSizeThatFits(size: size, scale: 1.0)
    }
    
    open func ddqSizeThatFits(size: CGSize, scale: CGFloat) {
        
        let fitSize = view?.sizeThatFits(size)
        ddqSize(size: CGSize(width: (fitSize?.width ?? 0.0) * scale, height: (fitSize?.height ?? 0.0) * scale))
    }
        
    open func ddqWidth(width: CGFloat) {
        ddqSize(size: CGSize(width: width, height: view?.ddqHeight ?? 0.0))
    }
    
    open func ddqHeight(height: CGFloat) {
        ddqSize(size: CGSize(width: view?.ddqWidth ?? 0, height: height))
    }

    open func ddqInsets(insets: UIEdgeInsets, targertView: UIView?) {
        
        let view = targertView ?? view?.superview
        
        guard view != nil else {
            return
        }
        
        let size: CGSize = .init(width: view!.ddqWidth - insets.left - insets.right, height: view!.ddqHeight - insets.top - insets.bottom)
        ddqLeft(property: view!.ddqLeft, value: insets.left).ddqTop(property: view!.ddqTop, value: insets.top).ddqSize(size: size)
    }
        
    open func ddqUpdate() {
        ddqSize(size: view?.ddqSize ?? CGSize.zero)
    }
    
    private func _handleInstallPoint(type: LayoutType, property: DDQLayoutProperty, value: CGFloat, offset: CenterOffset) {
        guard view != nil else {
            return
        }
        
        var frame = view!.frame
        let propertyValue = _getValueWithProperty(property: property)
        let value = propertyValue + value
        
        switch type {
            case .top:
                verDirection = .topToBottom
                frame.origin.y = value
                
            case .left:
                horDirection = .leftToRight
                frame.origin.x = value
                
            case .bottom:
                verDirection = .bottomToTop
                frame.origin.y = value
                
            case .right:
                horDirection = .rightToLeft
                frame.origin.x = value
                
            case .centerX:
                horDirection = .centerX
                frame.origin.x = value

            case .centerY:
                verDirection = .centerY
                frame.origin.y = value
                
            case .center:
                horDirection = .center
                verDirection = .center
                
                let layoutView = property.layoutView
                let isSuper = view?.superview == layoutView
                let x = isSuper ? layoutView.ddqBoundsMidX : layoutView.ddqMidX
                let y = isSuper ? layoutView.ddqBoundsMidY : layoutView.ddqMidY
                frame.origin = CGPoint(x: x + offset.xOffset, y: y + offset.yOffset)
        }
        
        origin = frame.origin
        view!.frame = frame
    }
    
    private func _getValueWithProperty(property: DDQLayoutProperty?) -> CGFloat {
        guard property != nil else {
            return 0.0
        }
        
        var value: CGFloat = 0.0
        let layoutView = property!.layoutView
        let isSuper = layoutView == view?.superview
        
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
        guard view != nil else {
            return
        }
        
        var newX = origin.x
        var newY = origin.y
        
        switch horDirection {
            case .rightToLeft:
                newX -= size.width

            case .centerX:
                newX -= size.width * 0.5
                
            case .center:
                newX -= size.width * 0.5

            default:
                break
        }
        
        switch verDirection {
            case .bottomToTop:
                newY -= size.height

            case .centerY:
                newY -= size.height * 0.5

            case .center:
                newY -= size.height * 0.5

            default:
                break
        }
        
        var frame = view!.frame
        frame.origin = CGPoint(x: newX, y: newY)
        frame.size = size
        view!.frame = frame
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

