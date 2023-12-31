//
//  View+Tools.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/22.
//

import UIKit
import YYKit
import SDWebImage
import MJRefresh

/**
 整理常用的与view相关的处理方法
 */
public extension UIView {
    func ddqAddSubViews(subViews views: [UIView]?) {
        guard let sub = views else {
            return
        }
        
        for view in sub {
            addSubview(view)
        }
    }
    
    func ddqRemoveSubViews(subViews views: [UIView]?) {
        guard let sub = views else {
            return
        }

        for view in sub {
            if subviews.contains(view) {
                view.removeFromSuperview()
            }
        }
    }
    
    func ddqRemoveAllSubViews() {
        ddqRemoveSubViews(subViews: subviews)
    }
    
    func ddqSubviewsWithClass(vClass: AnyClass?) -> [UIView]? {
        guard vClass != nil else {
            return nil
        }
       
        let filters = subviews.filter { (view) -> Bool in
            return type(of: view).isEqual(vClass)
        }
        
        return filters
    }
    
    func ddqRemoveSubViews(viewClass vClass: AnyClass?) {
        ddqRemoveSubViews(subViews: ddqSubviewsWithClass(vClass: vClass))
    }
    
    func ddqAddTapGestureRecognizer(action: @escaping(UITapGestureRecognizer) -> Void) -> UITapGestureRecognizer {

        let tap = UITapGestureRecognizer.init { (gr: Any) in
            action(gr as! UITapGestureRecognizer)
        }
        
        addGestureRecognizer(tap)
        return tap
    }

    func ddqAddLongPressGestureRecognizer(action: @escaping(UILongPressGestureRecognizer) -> Void) -> UILongPressGestureRecognizer {

        let longPress = UILongPressGestureRecognizer.init { (gr: Any) in
            action(gr as! UILongPressGestureRecognizer)
        }
        
        addGestureRecognizer(longPress)
        return longPress
    }

    func ddqAddSwipeGestureRecognizer(action: @escaping(UISwipeGestureRecognizer) -> Void) -> UISwipeGestureRecognizer {

        let swipe = UISwipeGestureRecognizer.init { (gr: Any) in
            action(gr as! UISwipeGestureRecognizer)
        }
        
        addGestureRecognizer(swipe)
        return swipe
    }

    func ddqAddPanGestureRecognizer(action: @escaping(UIPanGestureRecognizer) -> Void) -> UIPanGestureRecognizer {

        let pan = UIPanGestureRecognizer.init { (gr: Any) in
            action(gr as! UIPanGestureRecognizer)
        }
        
        addGestureRecognizer(pan)
        return pan
    }
}

/**
 整理label常用设置
 */
public extension UILabel {
    class func ddqAttributes() -> [NSAttributedString.Key: Any] {
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5.0
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .left
        return [.font: UIFont.ddqFont(), .foregroundColor: UIColor.ddqTextColor(), .paragraphStyle: paragraph.copy()]
    }
    
    func ddqGetSizeToFitHeight() -> CGFloat {
        
        let fontLineH = font.lineHeight
        
        if attributedText != nil {
            if numberOfLines == 0 {
                return CGFloat.greatestFiniteMagnitude
            }

            var lineSpacing: CGFloat = 0.0
            
            if let attributes = attributedText?.attributes {
                if let paragraph = attributes[NSAttributedString.Key.paragraphStyle.rawValue] as? NSParagraphStyle {
                    lineSpacing = paragraph.lineSpacing
                }
            }
            
            return fontLineH * numberOfLines.ddqToCGFloat() + (numberOfLines - 1).ddqToCGFloat() * lineSpacing
        }
        
        if numberOfLines == 0 {
            return .greatestFiniteMagnitude
        }
        
        return fontLineH * numberOfLines.ddqToCGFloat()
    }
    
    func ddqLabelSizeThatBounding(options: NSStringDrawingOptions = .usesLineFragmentOrigin, size: CGSize) -> CGSize {
        guard let attributd = attributedText else {
            return text?.boundingRect(with: size, options: options, attributes: nil, context: nil).size ?? CGSize.zero
        }
        
        return attributd.boundingRect(with: size, options: options, context: nil).size
    }
}

/**
 整理button常用设置
 */
public extension UIButton {
    func ddqSet(title: String? = nil, titleState: UIControl.State = .normal, image: UIImage? = nil, imageState: UIControl.State = .normal, backgroundImage: UIImage? = nil, backgroundState: UIControl.State = .normal, event: UIButton.Event = .touchUpInside, action: DDQButtonActionBlock? = nil) {
        
        if let t = title {
            setTitle(t, for: titleState)
        }
        
        if let i = image {
            setImage(i, for: imageState)
        }

        if let b = backgroundImage {
            setBackgroundImage(b, for: backgroundState)
        }

        if action != nil {
            
            addBlock(for: event) { (button) in
                action!(button as! UIButton)
            }
        }
    }
    
    func ddqSet(title: String? = nil, titleState: UIControl.State = .normal, image: UIImage? = nil, imageState: UIControl.State = .normal, backgroundImage: UIImage? = nil, backgroundState: UIControl.State = .normal, event: UIButton.Event = .touchUpInside, target: Any, selector: Selector) {
        
        ddqSet(title: title, titleState: titleState, image: image, imageState: imageState, backgroundImage: backgroundImage, backgroundState: backgroundState)
        addTarget(target, action: selector, for: event)
    }
    
    func ddqSetWebImage(url: String?, state: UIControl.State = .normal, completed: SDExternalCompletionBlock? = nil) {
        sd_setImage(with: URL(string: url ?? ""), for: state, completed: completed)
    }
}

/**
 image的常用设置
 */
public extension UIImage {
    class func ddqImage(imageName: String? = nil, mode: UIImage.RenderingMode = .automatic) -> UIImage? {
        
        var image: UIImage?
        
        if imageName != nil {
            image = .init(named: imageName!)
        } else {
            image = .init()
        }
        
        return image?.withRenderingMode(mode);
    }
    
    func ddqScaleImageToSize(_ size: CGSize) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func ddqScaleImageForWidth(_ width: CGFloat) -> UIImage? {
        
        let height = width * size.height / size.width
        return ddqScaleImageToSize(CGSize(width: width, height: height))
    }
    
    // 将图片压缩至对应大小，传kb
    func ddqScaleImageToBitSize(_ size: Int) -> UIImage? {
        
        let bit: Int = size * 1024
        var startQuality: CGFloat = 0.95
        let minQuality: CGFloat = 0.1
        let type: YYImageType = .JPEG
        var imageData: Data = YYImageEncoder.encode(self, type: type, quality: startQuality) ?? Data.init()
        
        while imageData.count > bit || startQuality > minQuality {
            
            startQuality -= 0.1
            imageData = YYImageEncoder.encode(self, type: type, quality: startQuality) ?? Data.init()
        }
        
        return UIImage(data: imageData, scale: UIScreen.main.scale)
    }
    
    // 不能超过32k
    func ddqScaleImageToWeChatSize() -> UIImage? {
        return ddqScaleImageToBitSize(32)
    }
    
    func ddqScaleImageToQuality(_ q: CGFloat) -> UIImage? {
        if let imageData: Data = sd_imageData(as: .JPEG, compressionQuality: q.ddqToDouble()) {
            return UIImage.init(data: imageData, scale: UIScreen.main.scale)
        }
        
        return nil
    }
    
    func ddqToBase64String() -> String? {
        if let imageData = sd_imageData() {
            return imageData.base64EncodedString()
        }
        
        return nil
    }
    
    class func ddqImageWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
        
        let view = UIView.ddqView(backgroundColor: color)
        view.frame = .init(origin: .zero, size: size)
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        if let context = UIGraphicsGetCurrentContext() {
         
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        return image
    }
    
    fileprivate class func _imageDefaultSize() -> CGSize {
        return .init(width: ddqScreenWidth, height: 44.0)
    }
    
    @available(iOS 13.0, *)
    class func ddqImageWithUserStyle(style: UIUserInterfaceStyle, size: CGSize) -> UIImage {
        return style == .light ? ddqImageWithColor(.white, size: size) ?? .init() : ddqImageWithColor(.black, size: size) ?? .init()
    }
    
    @available(iOS 13.0, *)
    class func ddqImageWithUserStyle(style: UIUserInterfaceStyle) -> UIImage {
        return ddqImageWithUserStyle(style: style, size: _imageDefaultSize())
    }
    
    class func ddqImageInUserStyle() -> UIImage {
        if #available(iOS 13.0, *) {
            return ddqImageWithUserStyle(style: UITraitCollection.current.userInterfaceStyle, size: _imageDefaultSize())
        }
        
        return ddqImageWithColor(.white, size: _imageDefaultSize()) ?? .init()
    }
}

public extension UIImageView {
    func ddqSetRendering(rendering: UIImage.RenderingMode) {
        
        let image = image?.withRenderingMode(rendering)
        self.image = image
    }
    
    func ddqSetWebImage(_ url: String, placeholder: UIImage? = nil, placeholderName: String? = nil, completed: SDExternalCompletionBlock? = nil) {
        
        var image = placeholder
        
        if image == nil {
            image = .ddqImage(imageName: placeholderName)
        }
        
        sd_setImage(with: URL(string: url), placeholderImage: image, completed: completed)
    }
}

/**
 scrollView的常用设置
 */
public extension UIScrollView {
    enum DDQMJHeaderRefresh: Int {
        
        case none
        case normal
        case gif
        case state
    }

    enum DDQMJFooterRefresh: Int {
        
        case none
        case auto
        case back
        case autoNormal
        case backNormal
        case autoGIF
        case backGIF
        case autoState
        case backState
    }
    
    typealias DDQMJRefreshHeaderBlock = (_ view: UIScrollView) -> Void
    typealias DDQMJRefreshFooterBlock = (_ view: UIScrollView) -> Void
    
    func ddqSetRefresh(header: DDQMJHeaderRefresh, footer: DDQMJFooterRefresh, headerAction: DDQMJRefreshHeaderBlock?, footerAction: DDQMJRefreshFooterBlock?) {
        if header != .none {
            
            var hClass = MJRefreshHeader.self
            
            switch header {
                case .normal:
                    hClass = MJRefreshNormalHeader.self
                    
                case .state:
                    hClass = MJRefreshStateHeader.self
                    
                case .gif:
                    hClass = MJRefreshGifHeader.self
                    
                default:
                    break
            }
            
            let headerC = hClass.init {
                if headerAction !=  nil {
                    headerAction!(self)
                }
            }
            
            mj_header = headerC
        }
        
        if footer != .none {
            
            var fClass = MJRefreshFooter.self
            
            switch footer {
                case .auto:
                    fClass = MJRefreshAutoFooter.self
                                    
                case .autoNormal:
                    fClass = MJRefreshAutoNormalFooter.self
                    
                case .autoGIF:
                    fClass = MJRefreshAutoGifFooter.self
                    
                case .autoState:
                    fClass = MJRefreshAutoStateFooter.self

                case .back:
                    fClass = MJRefreshBackFooter.self
                    
                case .backGIF:
                    fClass = MJRefreshBackGifFooter.self

                case .backState:
                    fClass = MJRefreshBackStateFooter.self

                case .backNormal:
                    fClass = MJRefreshBackNormalFooter.self
                
                default:
                    break
            }
            
            let footerC = fClass.init {
                if footerAction !=  nil {
                    footerAction!(self)
                }
            }
            
            mj_footer = footerC
        }
    }
    
    func ddqEndRefresh(_ noMoreData: Bool = false) {
        if mj_header?.isRefreshing == true {
            
            mj_header?.endRefreshing()
            
            if mj_footer != nil {
                mj_footer?.resetNoMoreData()
            }
        }
        
        if mj_footer?.isRefreshing == true {
            mj_footer?.endRefreshing()
        }
        
        if noMoreData {
            mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    
    var ddqIsRefreshing: Bool {
        if mj_footer?.isRefreshing == true {
            return true
        }
        
        if mj_header?.isRefreshing == true {
            return true
        }
        
        return false
    }
    
    func ddqRemoveHeaderFooter() {
        
        mj_header?.endRefreshing()
        mj_header = nil
        mj_footer?.endRefreshing()
        mj_footer = nil
    }
}

public extension UIView {
    
    typealias DDQAnimations = (_ target: UIView) -> Void
        
    func ddqAnimated(duration: TimeInterval = .animationInterval, delay: TimeInterval = 0.0, options: AnimationOptions = .curveEaseInOut, _ animations: DDQAnimations?, completion: ((Bool) -> Void)? = nil) {
        if let c = animations {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
                c(self)
            }, completion: completion)
        }
    }
    
    static func ddqAnimated(duration: TimeInterval = .animationInterval, delay: TimeInterval = 0.0, options: AnimationOptions = .curveEaseInOut, _ animations: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        if let c = animations {
            animate(withDuration: duration, delay: delay, options: options, animations: {
                c()
            }, completion: completion)
        }
    }
}

public extension TimeInterval {
    static var animationInterval: TimeInterval { 0.25 }
}
