//
//  HUD+Handler.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import MBProgressHUD

public extension MBProgressHUD {
   
    static var ddqDefaultShowTimeInterval: TimeInterval { 1.5 }
    
    typealias DDQHUDCompletionBlock = (_ hud: MBProgressHUD) -> Void
    
    class func ddqShowHUD(info: String, inView: UIView? = nil, delay: TimeInterval = ddqDefaultShowTimeInterval, animated: Bool = true) {
        
        let view = _handleHUDSuperView(view: inView)
        
        if view == nil {
            return
        }
        
        let hud = _foundHUDView(view: view!)
        hud?.mode = .text
        hud?.label.numberOfLines = 3
        hud?.label.attributedText = NSAttributedString.init(string: info, attributes: [.font: UIFont.ddqFont(size: 17.0, weight: .black), .foregroundColor: UIColor.white])
        hud?.bezelView.blurEffectStyle = .dark
        hud?.hide(animated: animated, afterDelay: delay)
    }
        
    class func ddqWaitHUD(info: String? = nil, inView: UIView? = nil, completion: DDQHUDCompletionBlock? = nil) -> MBProgressHUD? {
        
        let view = _handleHUDSuperView(view: inView)
        
        if view == nil {
            return nil
        }

        let hud = _foundHUDView(view: view!)
        hud?.label.attributedText = NSAttributedString.init(string: info ?? "请稍候...", attributes: [.font: UIFont.ddqFont(size: 17.0, weight: .black), .foregroundColor: UIColor.white])
        hud?.bezelView.blurEffectStyle = .dark
        hud?.contentColor = .white
        
        hud?.completionBlock = {
            if completion != nil {
                completion!(hud!)
            }
        }
        
        return hud
    }
    
    private class func _handleHUDSuperView(view: UIView?) -> UIView? {
        
        let view1 = (view ?? ddqRootViewController?.view) ?? ddqKeyWindow
        return view1
    }
    
    private class func _foundHUDView(view: UIView, animated: Bool = true) -> MBProgressHUD? {
        
        var hud = MBProgressHUD.forView(view)
        
        if hud == nil {
            hud = MBProgressHUD.showAdded(to: view, animated: animated)
        } else {
            hud?.show(animated: animated)
        }
        
        return hud
    }
}
