//
//  Controller+Tools.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/25.
//

import UIKit

public extension UIViewController {
    func ddqPop(to: UIViewController? = nil, animated: Bool = true) {
        guard let nav = self.navigationController else {
            return
        }
        
        if to != nil {
            nav.popToViewController(to!, animated: animated)
        } else {
            nav.popViewController(animated: animated)
        }
    }

    func ddqPop(cClass: AnyClass, animated: Bool = true) {
        guard let nav = self.navigationController else {
            return
        }
        
        var target: UIViewController?
        
        for controller in nav.viewControllers {
            if controller.self.isEqual(cClass) {
                
                target = controller
                break
            }
        }
        
        guard let controller = target else {
            return
        }
        
        self.ddqPop(to: controller, animated: animated)
    }
    
    func ddqPop(index: Int, animated: Bool = true) {
        guard let nav = self.navigationController else {
            return
        }
        
        if !nav.viewControllers.ddqIsBeyond(index: index) {
            self.ddqPop(to: nav.viewControllers[index], animated: animated)
        }
    }
    
    func ddqPush(to: UIViewController, title: String? = nil, animated: Bool = true) {
        guard let nav = self.navigationController else {
            return
        }
                    
        to.title = title
        to.hidesBottomBarWhenPushed = true
        nav.pushViewController(to, animated: animated)
    }
    
    func ddqPush(toClass: AnyClass, nib: Bool = false, nibName: String? = nil, nibBundle: Bundle? = nil, title: String? = nil, animated: Bool = true) {
        if toClass.isSubclass(of: UIViewController.self) {
            if let a = toClass as? UIViewController.Type {
                
                let vc: UIViewController
                
                if nib {
                    
                    let name = nibName ?? String(describing: a)
                    vc = a.init(nibName: name, bundle: nibBundle)
                    
                } else {
                    vc = a.init()
                }
                
                self.ddqPush(to: vc, title: title, animated: animated)
            }
        }
    }
}

public extension UIViewController {
    var ddqSafeInsets: UIEdgeInsets {
        if #available(iOS 13.0, *) {
            return self.view.safeAreaInsets
        } else {
            return .init(top: self.topLayoutGuide.length, left: 0.0, bottom: self.bottomLayoutGuide.length, right: 0.0)
        }
    }
}
