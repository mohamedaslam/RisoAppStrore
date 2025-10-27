//
//  BaseNavigationController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    var statusBarStyle: StatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle.uiKitValue
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let button = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.visibleViewController?.navigationItem.backBarButtonItem = button
        super.pushViewController(viewController, animated: animated)
    }
}

extension UINavigationController {
    func pushAndHideTabBar(_ viewController: UIViewController, animated: Bool = true) {
        viewController.hidesBottomBarWhenPushed = true
        self.pushViewController(viewController, animated: animated)
    }
}
