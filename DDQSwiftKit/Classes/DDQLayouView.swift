//
//  DDQBasalLayouView.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import UIKit

open class DDQLayoutView: DDQView {
    public struct LayoutScale {
        
        /// 定宽
        public var fixledWidth: CGFloat
        
        /// 宽高比
        public var scale: CGFloat
        
        /// 不使用比例
        public static let defaultScale: CGFloat = -1.0
        
        public static var normal: LayoutScale {
            get {
                .init(fixledWidth: 0.0)
            }
        }
        
        public init(fixledWidth: CGFloat, scale: CGFloat = defaultScale) {
            
            self.fixledWidth = fixledWidth
            self.scale = scale
        }
    }

    public enum Alignment {

        case top
        case left
        case bottom
        case right
        case center
    }
    
    /**
     布局时对齐方式
     默认top
     */
    open var alignment: Alignment = .top {
        didSet {
            ddqSetNeedsLayout()
        }
    }

    public enum Direction {

        case vertical
        case horizontal
    }
    
    /**
     布局时方向
     默认vertical
     */
    open var direction: Direction = .vertical {
        didSet {
            ddqSetNeedsLayout()
        }
    }

    public enum Fixled {

        case width
        case height
    }

    /**
     布局时定宽还是定高
     */
    open var fixled: Fixled = .width {
        didSet {
            ddqSetNeedsLayout()
        }
    }

    open var mainView: UIView? {
        willSet {
            mainView?.removeFromSuperview()
        }

        didSet {
            if let mainView = mainView {
                addSubview(mainView)
            }
        }
    }

    open var subView: UIView? {
        willSet {
            subView?.removeFromSuperview()
        }

        didSet {
            if let subView = subView {
                addSubview(subView)
            }
        }
    }

    open var backgroundView: UIView? {
        willSet {
            backgroundView?.removeFromSuperview()
        }

        didSet {
            if let backgroundView = backgroundView {
                insertSubview(backgroundView, at: 0)
            }
        }
    }
    
    /**
    主视图在布局时的比例
     */
    open var mainScale: LayoutScale = .normal {
        didSet {
            ddqSetNeedsLayout()
        }
    }
    
    /**
     子视图布局时的比例
     */
    open var subScale: LayoutScale = .normal {
        didSet {
            ddqSetNeedsLayout()
        }
    }

    // 主视图的布局边界
    open var edges: UIEdgeInsets = .zero {
        didSet {
            ddqSetNeedsLayout()
        }
    }

    // 副视图的布局边界
    open var spacings: UIEdgeInsets = .zero {
        didSet {
            ddqSetNeedsLayout()
        }
    }

    public convenience init(mainView: UIView, subView: UIView) {

        self.init()
        self.mainView = mainView
        self.subView = subView
        addSubview(mainView)
        addSubview(subView)
    }

    open override func ddqViewInitialize() {

        super.ddqViewInitialize()

        if let background = backgroundView {
            ddqAddSubViews(subViews: [background])
        }
    }

    open override func sizeToFit() {

        super.sizeToFit()
        let fitSize = sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        frame = .init(origin: .zero, size: fitSize)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {

        super.sizeThatFits(size)
        fitSize = size
        isSizeThatFit = true
        ddqLayoutSubviews(size: size)
        return sizeToFitFrame.size
    }

    open func sizeThatFitsInWidth(w: CGFloat) -> CGSize {
        sizeThatFits(.init(width: w, height: .greatestFiniteMagnitude))
    }

    open func sizeThatFitsInHeight(h: CGFloat) -> CGSize {
        sizeThatFits(.init(width: .greatestFiniteMagnitude, height: h))
    }

    open override func ddqLayoutSubviewsWhenSetFrame() -> Bool {
        true
    }

    private var sizeToFitFrame: CGRect = .zero
    private var isSizeThatFit: Bool = false
    private var fitSize: CGSize = .zero

    open override func ddqLayoutSubviews(size: CGSize) {

        super.ddqLayoutSubviews(size: size)
        
        guard let mainV = mainView else { return }

        guard let subV = subView else { return }

        if let backgroundView = backgroundView {
            backgroundView.frame.size = size
        }

        let _insets = edges
        let _spacings = spacings
        let _alignment = alignment
        let _direction = direction
        
        var mainSize: CGSize = .zero
        var subSize: CGSize = .zero
        var boundRect: CGRect = .zero
                    
        let _fixled = fixled
        var boundSize = size
        
        if isSizeThatFit {
            boundSize = fitSize
        }

        var layoutW = boundSize.width - _insets.left - _insets.right
        var layoutH = boundSize.height - _insets.top - _insets.bottom
        var mainFitW = 0.0
        var mainFitH = 0.0
        var subFitW = 0.0
        var subFitH = 0.0
        let mainIsFixled = mainScale.fixledWidth > 0
        let subIsFixled = subScale.fixledWidth > 0
        let mainUseScale = mainScale.scale != LayoutScale.defaultScale
        let subUseScale = subScale.scale != LayoutScale.defaultScale
        
        if _fixled == .width {
            if _direction == .horizontal {
                layoutW -= _spacings.left
            }
            
            mainFitW = mainIsFixled ? mainScale.fixledWidth : layoutW
            subFitW = subIsFixled ? subScale.fixledWidth : layoutW

            mainFitH = mainUseScale ? mainFitW * mainScale.scale : .greatestFiniteMagnitude
            subFitH = subUseScale ? subFitW * subScale.scale : .greatestFiniteMagnitude

        } else {
            if _direction == .vertical {
                layoutH -= _spacings.top
            }
            
            mainFitW = mainIsFixled ? mainScale.fixledWidth : .greatestFiniteMagnitude
            subFitW = subIsFixled ? subScale.fixledWidth : .greatestFiniteMagnitude

            mainFitH = mainUseScale ? mainFitW * mainScale.scale : layoutH
            subFitH = subUseScale ? subFitW * subScale.scale : layoutH
        }
        
        let mainFitSize: CGSize = .init(width: mainFitW, height: mainFitH)
        let subFitSize: CGSize = .init(width: subFitW, height: subFitH)
        mainSize = mainUseScale ? mainFitSize : mainV.sizeThatFits(mainFitSize)
        subSize = subUseScale ? subFitSize : subV.sizeThatFits(subFitSize)
                
        let maxW = max(mainSize.width, subSize.width)
        let maxH = max(mainSize.height, subSize.height)
        
        if _direction == .vertical {
            boundRect.size = .init(width: _insets.left + maxW + _insets.right, height: _insets.top + mainSize.height + _spacings.top + subSize.height + _insets.bottom)
        } else {
            boundRect.size = .init(width: _insets.left + mainSize.width + _spacings.left + subSize.width + _insets.right, height: _insets.top + maxH + _insets.bottom)
        }
        
        sizeToFitFrame = boundRect
        let view: UIView = .init(frame: boundRect)
        
        if _direction == .vertical {
            
            mainV.ddqMake { make in
                switch _alignment {
                case .center:
                    _ = make.ddqCenterX(property: view.ddqCenterX, value: 0.0).ddqTop(property: view.ddqTop, value: _insets.top)
                case .right:
                    _ = make.ddqRight(property: view.ddqRight, value: _insets.right).ddqTop(property: view.ddqTop, value: _insets.top)
                    
                default:
                    _ = make.ddqLeft(property: view.ddqLeft, value: _insets.left).ddqTop(property: view.ddqTop, value: _insets.top)
                }
                
                if mainUseScale {
                    make.ddqSize(size: mainFitSize)
                } else {
                    make.ddqSizeThatFits(size: mainFitSize)
                }
            }
            
            subV.ddqMake { make in
                switch _alignment {
                case .center:
                    _ = make.ddqCenterX(property: mainV.ddqCenterX, value: 0.0).ddqTop(property: mainV.ddqBottom, value: _spacings.top)
                    
                case .right:
                    _ = make.ddqRight(property: mainV.ddqRight, value: 0.0).ddqTop(property: mainV.ddqBottom, value: _spacings.top)
                    
                default:
                    _ = make.ddqLeft(property: mainV.ddqLeft, value: 0.0).ddqTop(property: mainV.ddqBottom, value: _spacings.top)
                }
                
                if subUseScale {
                    make.ddqSize(size: subFitSize)
                } else {
                    make.ddqSizeThatFits(size: subFitSize)
                }
            }
        } else {
            
            mainV.ddqMake { make in
                switch _alignment {
                case .center:
                    _ = make.ddqCenterY(property: view.ddqCenterY, value: 0.0).ddqLeft(property: view.ddqLeft, value: _insets.left)
                    
                case .bottom:
                    _ = make.ddqBottom(property: view.ddqBottom, value: _insets.bottom).ddqLeft(property: view.ddqLeft, value: _insets.left)
                    
                default:
                    _ = make.ddqLeft(property: view.ddqLeft, value: _insets.left).ddqTop(property: view.ddqTop, value: _insets.top)
                }
                
                if mainUseScale {
                    make.ddqSize(size: mainFitSize)
                } else {
                    make.ddqSizeThatFits(size: mainFitSize)
                }
            }
            
            subV.ddqMake { make in
                switch _alignment {
                case .center:
                    _ = make.ddqCenterY(property: mainV.ddqCenterY, value: 0.0).ddqLeft(property: mainV.ddqRight, value: _spacings.left)
                    
                case .bottom:
                    _ = make.ddqBottom(property: mainV.ddqBottom, value: 0.0).ddqLeft(property: mainV.ddqRight, value: _spacings.left)
                    
                default:
                    _ = make.ddqTop(property: mainV.ddqTop, value: 0.0).ddqLeft(property: mainV.ddqRight, value: _spacings.left)
                }
                
                if subUseScale {
                    make.ddqSize(size: subFitSize)
                } else {
                    make.ddqSizeThatFits(size: subFitSize)
                }
            }
        }
    }
}
