//
//  AppDelegate+Routing.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

enum ApplicationFlow {
    case onboarding
    case authentication
    case mainApp
}

extension AppDelegate {
    internal func configureWindow(root: UIViewController) {
        let windowFrame                 = UIScreen.main.bounds
        self.window                     = UIWindow(frame : windowFrame)
        self.window?.rootViewController = root
        self.window?.backgroundColor    = UIColor.App.primary
        self.window?.makeKeyAndVisible()
    }
    
    func handle(flow: ApplicationFlow) {
        switch flow {
        case .onboarding:
            let pages = OnboardingPage.getOnboardingPages()
            let controller = OnboardingPageViewController(pages: pages, canDismiss: true)
            let nav = BaseNavigationController(rootViewController: controller)
            nav.statusBarStyle = .lightContent
            _ = nav.view
            show(root: nav)
            break
        case .authentication:
            let controller = LoginViewController.instantiate()
            let nav = BaseNavigationController(rootViewController: controller)
            nav.statusBarStyle = .lightContent
            _ = nav.view
            show(root: nav)

            break
        case .mainApp:
            let tabBarController            = AppTabBarController()
            tabBarController.statusBarStyle = .lightContent
            show(root: tabBarController) {
                ApplicationDelegate.registerForPushNotifications()
            }
            break
        }
    }
    
    private func show(root: UIViewController,
                      duration: TimeInterval = 0.5,
                      completion: (() -> Void)? = nil) {
        guard let window = self.window else { return }
        UIView.transition(
            with: window,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = root
            },
            completion: { _ in completion? () }
        )
    }
}
