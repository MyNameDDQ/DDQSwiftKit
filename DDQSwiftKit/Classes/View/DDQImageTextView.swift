//
//  DDQImageTextView.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import UIKit

// 适用于图片与文字展示
open class DDQImageTextLayoutView: DDQBasalLayoutView {
    public enum DDQImageTextLayoutStyle: Int {
        
        case LImageRText
        case LTextRImage
        case TImageBText
        case TTextBImage
    }
    
    open var imageView: UIImageView = .ddqImageView() // mainView
    open var titleLabel: UILabel = .ddqLabel(text: nil, font: nil, textColor: .black) // subView
    open var style: DDQImageTextLayoutStyle = .TImageBText {
        didSet {
            
            self._handleLayout()
            self.ddqSetNeedsLayout()
        }
    }
    
    open func setImage(image: UIImage?) {
        self.imageView.image = image
    }
    
    open func setTitle(title: String?) {
        self.titleLabel.text = title
    }
    
    open func setAttributedTitle(attributedTitle: NSAttributedString?) {
        self.titleLabel.attributedText = attributedTitle
    }
        
    public convenience init(title: String?, image: UIImage?) {
    
        self.init(frame: .zero)
        self.imageView.image = image
        self.titleLabel.text = title
    }
    
    open override func ddqViewInitialize() {
        
        super.ddqViewInitialize()
        self._handleLayout()
    }
    
    private func _handleLayout() {
        
        self.mainView = nil
        self.subView = nil
        
        var main: UIView
        var sub: UIView
        
        switch self.style {
            case .TImageBText:
                main = self.imageView
                sub = self.titleLabel
                self.direction = .upperAndLower

            case .LImageRText:
                main = self.imageView
                sub = self.titleLabel
                self.direction = .leftAndRight

            case .LTextRImage:
                main = self.titleLabel
                sub = self.imageView
                self.direction = .leftAndRight

            default:
                main = self.titleLabel
                sub = self.imageView
                self.direction = .upperAndLower
        }
        
        self.mainView = main
        self.subView = sub
    }
}

