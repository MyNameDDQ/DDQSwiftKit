//
//  DDQLayoutProperty.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/22.
//

import UIKit

public struct DDQLayoutProperty {
    enum DDQLayoutAligment: Int {
        
        case left
        case right
        case top
        case bottom
        case centerX
        case centerY
        case center
    }
    
    var aligment: DDQLayoutAligment = .left
    var layoutView: UIView?
    
    init(view: UIView, aligment: DDQLayoutAligment) {
        
        self.layoutView = view
        self.aligment = aligment
    }
}

public extension UIView {
    var ddqLeft: DDQLayoutProperty {
        DDQLayoutProperty(view: self, aligment: .left)
    }
    
    var ddqRight: DDQLayoutProperty {
        DDQLayoutProperty(view: self, aligment: .right)
    }
    
    var ddqTop: DDQLayoutProperty {
        DDQLayoutProperty(view: self, aligment: .top)
    }
    
    var ddqBottom: DDQLayoutProperty {
        DDQLayoutProperty(view: self, aligment: .bottom)
    }
    
    var ddqCenterX: DDQLayoutProperty {
        DDQLayoutProperty(view: self, aligment: .centerX)
    }
    
    var ddqCenterY: DDQLayoutProperty {
        DDQLayoutProperty(view: self, aligment: .centerY)
    }
    
    var ddqCenter: DDQLayoutProperty {
        DDQLayoutProperty(view: self, aligment: .center)
    }
}
