//
//  DDQViewModel.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/25.
//

import UIKit

public var ddqUserDefault: UserDefaults {
    .standard
}

public var ddqNotificationCenter: NotificationCenter {
    .default
}

open class DDQViewModel: NSObject {

    private var observers: [NSObjectProtocol] = []
    public static var oldValueKey: String = "DDQRegisterOldValueKey"
    public static var newValueKey: String = "DDQRegisterNewValueKey"
    
    deinit {
        ddqRemoveObserver()
    }
    
    open func ddqRemoveObserver() {
        self.observers.enumerated().forEach { objc in
            ddqNotificationCenter.removeObserver(objc)
        }
    }
    
    open func ddqRegisterObserver(key: String, values: @escaping (_ contents: [String: Any]) -> Void) {
        
        var dic: [String: Any] = .init()
        let defaults = ddqUserDefault
        dic.updateValue(defaults.object(forKey: key) ?? "", forKey: DDQViewModel.oldValueKey)
        
        let observer = ddqNotificationCenter.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main) { note in
            if let user = note.object as? UserDefaults {
                
                let objc = user.object(forKey: key) ?? ""
                dic.updateValue(objc, forKey: DDQViewModel.newValueKey)
                values(dic)
                dic.updateValue(objc, forKey: DDQViewModel.oldValueKey)
            }
        }
        
        self.observers.append(observer)
    }
}
