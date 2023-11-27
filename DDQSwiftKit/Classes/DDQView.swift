//
//  DDQView.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import UIKit

open class DDQView: UIView {
    
    private(set) open var ddqIsInitialize: Bool = false
    private(set) open var ddqIsLayoutSubviews: Bool = false
    private(set) open var ddqIsSelected: Bool = false
        
    open func ddqLayoutSubviewsWhenSetFrame() -> Bool {
        return false
    }
    
    open func ddqViewInitialize() {
        
        ddqIsInitialize = true
        backgroundColor = .ddqBackgroundColor()
    }
    
    open func ddqLayoutSubviews(size: CGSize) {
        ddqIsLayoutSubviews = true
    }
    
    open func ddqSetNeedsLayout() {
        if ddqIsLayoutSubviews {
            setNeedsLayout()
        }
    }
            
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        ddqViewInitialize()
    }
    
    required public init?(coder: NSCoder) {
    
        super.init(coder: coder)
        ddqViewInitialize()
    }
    
    open override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    open override func layoutSubviews() {
        
        super.layoutSubviews()
        ddqLayoutSubviews(size: ddqSize)
    }
            
    open override var frame: CGRect {
        didSet {
            if ddqLayoutSubviewsWhenSetFrame() {
                ddqLayoutSubviews(size: frame.size)
            }
        }
    }
}
