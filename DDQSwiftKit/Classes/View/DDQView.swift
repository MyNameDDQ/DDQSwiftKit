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
        
        self.ddqIsInitialize = true
        self.backgroundColor = .ddqBackgroundColor()
    }
    
    open func ddqLayoutSubviews(size: CGSize) {
        self.ddqIsLayoutSubviews = true
    }
    
    open func ddqSetNeedsLayout() {
        if self.ddqIsLayoutSubviews {
            self.setNeedsLayout()
        }
    }
            
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.ddqViewInitialize()
    }
    
    required public init?(coder: NSCoder) {
    
        super.init(coder: coder)
        self.ddqViewInitialize()
    }
    
    open override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    open override func layoutSubviews() {
        
        super.layoutSubviews()
        self.ddqLayoutSubviews(size: self.ddqSize)
    }
            
    open override var frame: CGRect {
        didSet {
            if self.self.ddqLayoutSubviewsWhenSetFrame() {
                self.ddqLayoutSubviews(size: frame.size)
            }
        }
    }
}
