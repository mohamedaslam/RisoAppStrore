//
//  BaseViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import StatusProvider

enum StatusBarStyle {
    case lightContent
    case darkContent
    
    var uiKitValue: UIStatusBarStyle {
        switch self {
        case .lightContent: return .lightContent
        case .darkContent: return .default
        }
    }
}

class BaseViewController: UIViewController {
    private var keyboardDismissGestureRecognizer: UITapGestureRecognizer?
    
    var client: Client {
        return ApplicationDelegate.client
    }
    
    var statusBarStyle: StatusBarStyle = .lightContent {
        didSet {
            if let nav = navigationController as? BaseNavigationController {
                nav.statusBarStyle = statusBarStyle
            }
            
            if let tab = tabBarController as? BaseTabBarController {
                tab.statusBarStyle = statusBarStyle
            }
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle.uiKitValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        if #available(iOS 11.0, *) {
            view.setContentAdjustmentBehavior(.never)
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    
    func hideKeyboardWhenTappedAround() {
        if keyboardDismissGestureRecognizer == nil {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard)
            )
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
            keyboardDismissGestureRecognizer = tap
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        if let tapGR = keyboardDismissGestureRecognizer {
            view.removeGestureRecognizer(tapGR)
        }
    }
}

extension BaseViewController: StatusController {
    
    public var statusView: StatusView? {
        return EmptyStatusView()
    }
    
    func showEmptyStatus(for model: EmptyStatus) {
        let status = Status(title: model.title, description: model.description, actionTitle: nil, image: model.image) {
            self.hideStatus()
        }
        
        show(status: status)
    }
    
    func hideEmptyStatus() {
        self.hideStatus()
    }
}
