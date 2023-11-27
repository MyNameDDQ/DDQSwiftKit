//
//  Alert+Handler.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/24.
//

import UIKit

public extension UIViewController {
    
    // 可以用在添加了textField等操作后
    // 当返回false时不会自动弹出
    typealias DDQAutoAlertReadyBlock = (_ alertController: UIAlertController) -> Bool
    
    func ddqAlert(style: UIAlertController.Style = .alert, title: String? = nil, message: String? = nil, actions: [UIAlertAction]? = nil, autoAlert: DDQAutoAlertReadyBlock? = nil) {
    
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: style)
        
        guard let buttons = actions else {
            
            let defaultAction = UIAlertAction.init(title: "好的", style: .default, handler: nil)
            alert.addAction(defaultAction)
            return
        }
        
        for button in buttons {
            alert.addAction(button)
        }
        
        guard let ready = autoAlert else {
            return
        }
        
        if ready(alert) {
            present(alert, animated: true, completion: nil)
        }
    }
    
    typealias DDQDefaultAlertConfirmBlock = () -> Void
    typealias DDQDefaultAlertCancelBlock = () -> Void
    
    func ddqAlert(style: UIAlertController.Style = .alert, title: String? = nil, message: String? = nil, confirm: DDQDefaultAlertConfirmBlock? = nil, cancel: DDQDefaultAlertCancelBlock? = nil, autoAlert: DDQAutoAlertReadyBlock?) {
        
        var actions: [UIAlertAction] = []
        
        if confirm != nil {
            
            let confirmAction = UIAlertAction.init(title: "确认", style: .destructive) { (_) in
                confirm!()
            }
            
            actions.append(confirmAction)
        }
        
        if cancel != nil {
            
            let cancelAction = UIAlertAction.init(title: "取消", style: .default) { (_) in
                cancel!()
            }
            
            actions.append(cancelAction)
        }
        
        ddqAlert(style: style, title: title, message: message, actions: actions, autoAlert: autoAlert)
    }
}
