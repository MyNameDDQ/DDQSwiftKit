//
//  DDQViewController.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/25.
//

import UIKit

/**
 统一一些写法和参数
 */
open class DDQViewController: UIViewController {
    public enum TableStyle {
        
        case none
        case grouped
        case plain
        case insetGrouped
    }
    
    /// 默认自带的tableView。
    /// ddqTableViewStyle返回值不为none时有值
    public var tableView: UITableView?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        ddqControllerInitialize()
    }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
        ddqControllerInitialize()
    }
        
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        ddqConfigSubviews()
        ddqConfigNavgationBar()
        ddqRegisterNotification()
    }
    
    open override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        if let tableView = tableView {
            tableView.ddqMake { make in
                make.ddqInsets(insets: ddqSafeInsets, targertView: view)
            }
        }
    }
    
    open func ddqTableViewStyle() -> TableStyle {
        .none
    }
        
    open func ddqControllerInitialize() {
        
        hidesBottomBarWhenPushed = true
        let style = ddqTableViewStyle()
        
        if style != .none {
            
            var tableStyle: UITableView.Style?
            
            switch style {
                case .grouped:
                    tableStyle = .grouped
                    
                case .insetGrouped:
                    if #available(iOS 13.0, *) {
                        tableStyle = .insetGrouped
                    } else {
                        tableStyle = .grouped
                    }
                    
                case .plain:
                    tableStyle = .plain
                
                case .none:
                    break
            }
            
            tableView = .ddqTableView(style: tableStyle!)
        }
    }
    
    open func ddqConfigSubviews() {
        if let tableView = tableView {
            view.ddqAddSubViews(subViews: [tableView])
        }
    }
        
    open func ddqConfigNavgationBar() {}
    
    open func ddqRegisterNotification() {}
}
