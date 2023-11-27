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
        if ddqIsLayoutSubviews {
            setNeedsLayout()
        }
    }

    open func ddqItemLayoutSubviews(size: CGSize) {
        ddqIsLayoutSubviews = true
    }

    open func ddqItemInitialize() {
        
        ddqIsInitialize = true
        contentView.backgroundColor = .ddqBackgroundColor()
    }
    
    public override init(frame: CGRect) {
                
        super.init(frame: frame)
        ddqItemInitialize()
    }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        ddqItemInitialize()
    }
    
    open override var frame: CGRect {
        didSet {
            if ddqItemLayoutSubviewsWhenSetFrame() {
                ddqItemLayoutSubviews(size: frame.size)
            }
        }
    }
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        ddqItemInitialize()
    }
    
    open override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        ddqItemLayoutSubviews(size: contentView.ddqSize)
    }
}
