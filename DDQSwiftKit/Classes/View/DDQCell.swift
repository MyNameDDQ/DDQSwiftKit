//
//  DDQCell.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import UIKit

public struct DDQCellSeparatorMargin {
    
    var left: CGFloat
    var right: CGFloat
}

public extension DDQCellSeparatorMargin {
    static var zero: DDQCellSeparatorMargin {
        return DDQCellSeparatorMargin(left: 0.0, right: 0.0)
    }
}

open class DDQCell: UITableViewCell {
    public enum DDQCellSeparatorStyle: Int {
        
        case none
        case top
        case bottom
    }

    private var ddqSeparator: UIView = UIView(frame: CGRect.zero)
    
    open var ddqCellDataSource: DDQCellModel? {
        didSet {
            
            self.ddqCellDidUpdateData()
            self.ddqCellLayoutSubviews(size: self.contentView.ddqSize)
            self.ddqCellSetNeedsLayout()
        }
    }
    
    open var ddqSeparatorStyle: DDQCellSeparatorStyle = .none {
        didSet {
            self.ddqCellSetNeedsLayout()
        }
    }
    
    open var ddqSeparatorMargin: DDQCellSeparatorMargin = .zero {
        didSet {
            self.ddqCellSetNeedsLayout()
        }
    }
    
    open var ddqSeparatorColor: UIColor = .ddqSeparatorColor() {
        didSet {
            self.ddqSeparator.backgroundColor = self.ddqSeparatorColor
        }
    }
    
    open var ddqSeparatorHeight: CGFloat = 1.0 {
        didSet {
            self.ddqCellSetNeedsLayout()
        }
    }
        
    private(set) open var ddqIsLayoutSubviews: Bool = false
    private(set) open var ddqIsInitialize: Bool = false
    
    open func ddqCellLayoutSubviewsWhenSetFrame() -> Bool {
        return false
    }
    
    open func ddqCellInitialize() {
        
        self.ddqIsInitialize = true
        self.contentView.addSubview(self.ddqSeparator)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.ddqSeparator.backgroundColor = self.ddqSeparatorColor
        self.contentView.backgroundColor = .ddqBackgroundColor()
    }
    
    open func ddqCellLayoutSubviews(size: CGSize) {
        self.ddqIsLayoutSubviews = true
    }
        
    open func ddqCellSetNeedsLayout() {
        if self.ddqIsLayoutSubviews {
            self.setNeedsLayout()
        }
    }
    
    open func ddqCellDidUpdateData() {}
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.ddqCellInitialize()
    }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.ddqCellInitialize()
    }
    
    open override var frame: CGRect {
        didSet {
            if self.ddqCellLayoutSubviewsWhenSetFrame() {
                self.ddqCellLayoutSubviews(size: frame.size)
            }
        }
    }
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        self.ddqCellInitialize()
    }
    
    open override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
                
        let width = self.contentView.ddqWidth - self.ddqSeparatorMargin.left - self.ddqSeparatorMargin.right
        var frame: CGRect = .init(x: self.ddqSeparatorMargin.left, y: 0.0, width: width, height: self.ddqSeparatorHeight)
        
        switch self.ddqSeparatorStyle {
            case .none:
                frame = CGRect.zero
                
            case .bottom:
                frame.origin.y = self.contentView.ddqHeight - self.ddqSeparatorHeight
                
            case .top:
                frame.origin.y = 0.0
        }
        
        self.ddqSeparator.frame = frame
        self.ddqCellLayoutSubviews(size: self.contentView.ddqSize)
    }
}
