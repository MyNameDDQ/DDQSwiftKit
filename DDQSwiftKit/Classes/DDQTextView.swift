//
//  DDQTextView.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import UIKit

// 适用于双文字展示
open class DDQTextView: DDQLayoutView {
    
    open private(set) var titleLabel: UILabel = .ddqLabel()
    open private(set) var subTitleLabel: UILabel = .ddqLabel()
    
    public convenience init(title: String? = nil, subTitle: String? = nil) {
        
        self.init(frame: CGRect.zero)
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
        
    open override func ddqViewInitialize() {
        
        super.ddqViewInitialize()
        ddqAddSubViews(subViews: [titleLabel, subTitleLabel])
        
        mainView = titleLabel
        subView = subTitleLabel
    }
}
