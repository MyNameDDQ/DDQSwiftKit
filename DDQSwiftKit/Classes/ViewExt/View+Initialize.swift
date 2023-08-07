//
//  View+Initialize.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/22.
//

import UIKit
import SDWebImage
import YYKit

/**
 view初始化
 */
public extension UIView {
    class func ddqView(backgroundColor: UIColor = .ddqBackgroundColor()) -> UIView {
        
        let view = self.init(frame: .zero)
        view.backgroundColor = backgroundColor
        view.clipsToBounds = true
        return view
    }
}

/**
 label初始化
 */
public extension UILabel {
    class func ddqLabel(text: String? = nil, font: UIFont? = nil, textColor: UIColor? = nil) -> UILabel {
        
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.font = .ddqFont()
        label.textColor = .ddqTextColor()
        label.backgroundColor = .ddqBackgroundColor()
        
        if let t = text {
            label.text = t
        }
        
        if let f = font {
            label.font = f
        }
        
        if let c = textColor {
            label.textColor = c
        }
        
        return label
    }
    
    class func ddqAttributedLabel(text: String, attributes: [NSAttributedString.Key: Any]? = nil) -> UILabel {
        
        let label = ddqLabel()
        let attributedText = NSAttributedString.init(string: text, attributes: attributes ?? ddqAttributes())
        return label
    }
}

/**
 button初始化
 */
public extension UIButton {
    
    typealias DDQButtonActionBlock = (_ button: UIButton) -> Void
    
    class func ddqButton(title: String? = nil, image: UIImage? = nil, backgroundImage: UIImage? = nil, titleColor: UIColor? = nil, event: UIButton.Event = .touchUpInside, action: DDQButtonActionBlock? = nil) -> UIButton {
        
        let button = UIButton.init(type: .custom)
        button.backgroundColor = .clear
        button.setTitleColor(.ddqTextColor(), for: .normal)
        button.titleLabel?.font = .ddqFont()

        if let t = title {
            button.setTitle(t, for: .normal)
        }
        
        if let i = image {
            button.setImage(i, for: .normal)
        }
        
        if let b = backgroundImage {
            button.setBackgroundImage(b, for: .normal)
        }
        
        if action != nil {
            button.addBlock(for: event) { (target: Any) in
                action!(target as! UIButton)
            }
        }
        
        if let tc = titleColor {
            button.setTitleColor(tc, for: .normal)
        }
        
        return button
    }

    class func ddqButton(title: String? = nil, image: UIImage? = nil, backgroundImage: UIImage? = nil, titleColor: UIColor? = nil, event: UIButton.Event = .touchUpInside, target: Any, selector: Selector) -> UIButton {
        
        let button = ddqButton(title: title, image: image, backgroundImage: backgroundImage, titleColor: titleColor, event: event)
        button.addTarget(target, action: selector, for: event)
        return button
    }
}

/**
 textField初始化
 */
public extension UITextField {
    class func ddqTextField(placeholder: String? = nil, placeholderAttrs: [NSAttributedString.Key: Any]? = nil, font: UIFont = .ddqFont(), textColor: UIColor = .ddqTextColor(), delegate: UITextFieldDelegate? = nil) -> UITextField {
        
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textColor = textColor
        textField.font = font
        
        if placeholderAttrs != nil && placeholder != nil {
            
            let attrPlaceholder: NSMutableAttributedString = .init(string: placeholder!, attributes: placeholderAttrs!)
            textField.attributedPlaceholder = attrPlaceholder
            
        } else if placeholder != nil {
            textField.placeholder = placeholder;
        }
        
        if delegate != nil {
            textField.delegate = delegate
        }
        
        return textField
    }    
}

/**
 image初始化
 */
public extension UIImageView {
    class func ddqImageView(imageName: String? = nil, image: UIImage? = nil) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        
        if let name = imageName {
            imageView.image = .ddqImage(imageName: name)
        }
        
        if let i = image {
            imageView.image = i
        }
        
        return imageView
    }
    
    class func ddqImageView(imageUrl: String?, placeholderName: String?) -> UIImageView {
        
        let imageView = ddqImageView()
        
        guard imageUrl != nil else {
            return imageView
        }
        
        imageView.sd_setImage(with: URL.init(string: imageUrl!), placeholderImage: .ddqImage(imageName: placeholderName))
        return imageView
    }
    
    class func ddqImageView(gift images: [Any]?) -> UIImageView {
        
        let imageView = ddqImageView()
        
        if images?.first is String {
            
            let images① = NSMutableArray()
            
            for objc in images! {
                
                let name = objc as! String
                let image = UIImage.ddqImage(imageName: name)
                images①.add(image!)
            }
            
            imageView.animationImages = images① as? [UIImage]
            imageView.startAnimating()
            return imageView
        
        } else if images?.first is UIImage {
            
            imageView.animationImages = images! as? [UIImage]
            imageView.startAnimating()
            return imageView
        
        } else {
            return imageView
        }
    }
    
    func ddqWithRendering(rendering: UIImage.RenderingMode) -> UIImageView {
        guard self.image != nil else {
            return self
        }
        
        let image = self.image?.withRenderingMode(rendering)
        self.image = image
        return self
    }
}

/**
 scrollView初始化
 */
public extension UIScrollView {
    class func ddqScrollView() -> UIScrollView {
        
        let scrollView = UIScrollView(frame: CGRect.zero)
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .ddqBackgroundColor()
        return scrollView
    }    
}

/**
 tableView初始化
 */
public extension UITableView {
    class func ddqTableView(style: Style = .grouped, delegate: UITableViewDelegate? = nil, dataSource: UITableViewDataSource? = nil) -> UITableView {
        
        let tableView = UITableView.init(frame: CGRect.zero, style: style)
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.contentInset = .zero
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        
        if let d = delegate {
            tableView.delegate = d
        }
        
        if let s = dataSource {
            tableView.dataSource = s
        }
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        tableView.backgroundColor = .ddqBackgroundColor()
        return tableView
    }
}

/**
 collectionView初始化
 */
public extension UICollectionView {
    class func ddqDefaultFlowLayout() -> UICollectionViewFlowLayout {
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = .zero
        return flowLayout
    }
    
    class func ddqCollectionView(flowLayout: UICollectionViewFlowLayout? = nil, delegate: UICollectionViewDelegate? = nil, dataSource: UICollectionViewDataSource? = nil) -> UICollectionView {
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout ?? ddqDefaultFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        if let d = delegate {
            collectionView.delegate = d
        }
        
        if let s = dataSource {
            collectionView.dataSource = s
        }
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }

        return collectionView
    }
}

/**
 textView初始化
 */
public extension UITextView {
    var ddqBeginningRect: CGRect {
        return self.caretRect(for: self.beginningOfDocument)
    }
    
    class func ddqTextView(font: UIFont = .ddqFont(), textColor: UIColor = .ddqTextColor(), delegate: UITextViewDelegate? = nil, container: NSTextContainer? = nil) -> UITextView {
        
        let textView: UITextView
        
        if container != nil {
            textView = UITextView.init(frame: CGRect.zero, textContainer: container)
        } else {
            textView = UITextView.init(frame: CGRect.zero)
        }
        
        textView.font = font
        textView.textColor = textColor
        return textView
    }
}

