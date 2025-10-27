//
//  BaseTabBarController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    var client: Client {
        return ApplicationDelegate.client
    }
    
    var statusBarStyle: StatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle.uiKitValue
    }
}
