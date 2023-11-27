//
//  DDQCell.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import UIKit

open class DDQCell: UITableViewCell {
    public struct SeparatorMargin {
        
        public var left: CGFloat
        public var right: CGFloat
        
        public static var zero: SeparatorMargin {
            return .init(left: 0.0, right: 0.0)
        }
        
        public init(left: CGFloat, right: CGFloat) {
            self.left = left
            self.right = right
        }
    }

    public enum SeparatorStyle {
        
        case none
        case top
        case bottom
    }

    private var ddqSeparator: UIView = UIView(frame: CGRect.zero)
    
    open var ddqDataSource: DDQCellModel? {
        didSet {
            
            ddqCellDidUpdateData()
            ddqCellLayoutSubviews(size: contentView.ddqSize)
            ddqCellSetNeedsLayout()
        }
    }
    
    open var ddqSeparatorStyle: SeparatorStyle = .none {
        didSet {
            ddqCellSetNeedsLayout()
        }
    }
    
    open var ddqSeparatorMargin: SeparatorMargin = .zero {
        didSet {
            ddqCellSetNeedsLayout()
        }
    }
    
    open var ddqSeparatorColor: UIColor = .ddqSeparatorColor() {
        didSet {
            ddqSeparator.backgroundColor = ddqSeparatorColor
        }
    }
    
    open var ddqSeparatorHeight: CGFloat = 1.0 {
        didSet {
            ddqCellSetNeedsLayout()
        }
    }
        
    private(set) open var ddqIsLayoutSubviews: Bool = false
    private(set) open var ddqIsInitialize: Bool = false
    
    open func ddqCellLayoutSubviewsWhenSetFrame() -> Bool {
        return false
    }
    
    open func ddqCellInitialize() {
        
        ddqIsInitialize = true
        contentView.addSubview(ddqSeparator)
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        ddqSeparator.backgroundColor = ddqSeparatorColor
        contentView.backgroundColor = .ddqBackgroundColor()
    }
    
    open func ddqCellLayoutSubviews(size: CGSize) {
        ddqIsLayoutSubviews = true
    }
        
    open func ddqCellSetNeedsLayout() {
        if ddqIsLayoutSubviews {
            setNeedsLayout()
        }
    }
    
    open func ddqCellDidUpdateData() {}
        
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ddqCellInitialize()
    }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        ddqCellInitialize()
    }
    
    open override var frame: CGRect {
        didSet {
            if ddqCellLayoutSubviewsWhenSetFrame() {
                ddqCellLayoutSubviews(size: frame.size)
            }
        }
    }
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        ddqCellInitialize()
    }
    
    open override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
                
        let width = contentView.ddqWidth - ddqSeparatorMargin.left - ddqSeparatorMargin.right
        var frame: CGRect = .init(x: ddqSeparatorMargin.left, y: 0.0, width: width, height: ddqSeparatorHeight)
        
        switch ddqSeparatorStyle {
            case .none:
                frame = .zero
                
            case .bottom:
                frame.origin.y = contentView.ddqHeight - ddqSeparatorHeight
                
            case .top:
                frame.origin.y = 0.0
        }
        
        ddqSeparator.frame = frame
        ddqCellLayoutSubviews(size: size)
    }
}
