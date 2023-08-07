//
//  DDQCollectionViewCell.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import UIKit

open class DDQCollectionViewCell: UICollectionViewCell {
        
    private(set) var ddqIsLayoutSubviews: Bool = false
    private(set) var ddqIsInitialize: Bool = false
    open func ddqItemLayoutSubviewsWhenSetFrame() -> Bool {
        return false
    }
    
    open func ddqItemSetNeedLayout() {
        if self.ddqIsLayoutSubviews {
            self.setNeedsLayout()
        }
    }

    open func ddqItemLayoutSubviews(size: CGSize) {
        self.ddqIsLayoutSubviews = true
    }

    open func ddqItemInitialize() {
        
        self.ddqIsInitialize = true
        self.contentView.backgroundColor = .ddqBackgroundColor()
    }
    
    override init(frame: CGRect) {
                
        super.init(frame: frame)
        self.ddqItemInitialize()
    }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.ddqItemInitialize()
    }
    
    open override var frame: CGRect {
        didSet {
            if self.ddqItemLayoutSubviewsWhenSetFrame() {
                self.ddqItemLayoutSubviews(size: frame.size)
            }
        }
    }
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        self.ddqItemInitialize()
    }
    
    open override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        self.ddqItemLayoutSubviews(size: self.contentView.ddqSize)
    }
}
