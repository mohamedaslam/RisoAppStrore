//
//  AppDelegate+Appearance.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

enum NavigationBarAppearance {
    case lightContent
    case `default`
    
    var tintColor: UIColor {
        switch self {
        case .lightContent:
            return UIColor.white
        case .default:
            return UIColor.App.Text.dark
        }
    }
    
    var barTintColor: UIColor {
        switch self {
        case .lightContent:
            return UIColor.App.NavigationBar.barTintColor
        case .default:
            return UIColor.clear
        }
    }
    
    var font: UIFont {
        switch self {
        case .lightContent:
            return UIFont.appFont(ofSize: 17, weight: .regular)
        case .default:
            return UIFont.appFont(ofSize: 17, weight: .regular)
        }
    }
}
extension AppDelegate {
    /**
     Sets up the global appearance for UINavigationBar class and its subclasses
     */
    
    func setupNavigationBarAppearance(with navAppearance: NavigationBarAppearance) {
        let appearance                              = UINavigationBar.appearance()
        appearance.isTranslucent                    = false
        appearance.barTintColor                     = navAppearance.barTintColor
        appearance.tintColor                        = navAppearance.tintColor
        appearance.shadowImage                      = UIImage()
        appearance.titleTextAttributes              = [
            .font: navAppearance.font,
            .foregroundColor: navAppearance.tintColor
        ]
        
        let itemAppearance                          = UIBarButtonItem.appearance()
        itemAppearance.tintColor                    = navAppearance.tintColor
        
        itemAppearance.setTitleTextAttributes(
            [
                .font: navAppearance.font,
                .foregroundColor: navAppearance.tintColor
            ],
            for: UIControl.State()
        )
        if #available(iOS 13.0, *){
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = .App.primary
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = navBarAppearance
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = navBarAppearance
        }
    }

    /**
     Sets up the global appearance for UITabBar class and its subclasses
     */
    
    func setupTabBarAppearance() {
        UITabBar.appearance().isTranslucent = false
    }
}
