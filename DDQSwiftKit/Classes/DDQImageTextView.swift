//
//  DDQImageTextView.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import UIKit

// 适用于图片与文字展示
open class DDQImageTextLayoutView: DDQLayoutView {
    public enum LayoutStyle {
        
        case LImageRText
        case LTextRImage
        case TImageBText
        case TTextBImage
    }
    
    open var imageView: UIImageView = .ddqImageView() // mainView
    open var titleLabel: UILabel = .ddqLabel(text: nil, font: nil, textColor: .black) // subView
    open var style: LayoutStyle = .TImageBText {
        didSet {
            
            _handleLayout()
            ddqSetNeedsLayout()
        }
    }
    
    open func setImage(image: UIImage?) {
        imageView.image = image
    }
    
    open func setTitle(title: String?) {
        titleLabel.text = title
    }
    
    open func setAttributedTitle(attributedTitle: NSAttributedString?) {
        titleLabel.attributedText = attributedTitle
    }
        
    public convenience init(title: String?, image: UIImage?) {
    
        self.init(frame: .zero)
        imageView.image = image
        titleLabel.text = title
    }
    
    open override func ddqViewInitialize() {
        
        super.ddqViewInitialize()
        _handleLayout()
    }
    
    private func _handleLayout() {
        
        mainView = nil
        subView = nil
        
        var main: UIView
        var sub: UIView
        
        switch style {
            case .TImageBText:
                main = imageView
                sub = titleLabel
                direction = .vertical

            case .LImageRText:
                main = imageView
                sub = titleLabel
                direction = .horizontal

            case .LTextRImage:
                main = titleLabel
                sub = imageView
                direction = .horizontal

            default:
                main = titleLabel
                sub = imageView
                direction = .vertical
        }
        
        mainView = main
        subView = sub
    }
}

