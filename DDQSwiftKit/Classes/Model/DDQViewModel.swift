//
//  DDQViewModel.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/25.
//

import UIKit

open class DDQViewModel: NSObject {

    private var observer: NSObjectProtocol?
    static var oldValueKey: String = "DDQRegisterOldValueKey"
    static var newValueKey: String = "DDQRegisterNewValueKey"
    
    deinit {
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func ddqRegisterObserver(key: String, values: @escaping (_ contents: [String: Any]) -> Void) {
        
        var dic: [String: Any] = .init()
        let defaults = UserDefaults.standard
        dic.updateValue(defaults.object(forKey: key) ?? "", forKey: DDQViewModel.oldValueKey)
        
        self.observer = NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main) { note in
            
            let user = note.object as! UserDefaults
            dic.updateValue(user.object(forKey: key) ?? "", forKey: DDQViewModel.newValueKey)
            values(dic)
        }
    }
}
