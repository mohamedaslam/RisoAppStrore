//
//  UIViewController+Ext.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 08/06/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

extension UIViewController {
    var nav: UINavigationController? {
        return UIViewController.topmostParentNavigationController(for: self)
    }
    
    class func topmostParentNavigationController(for controller: UIViewController) -> UINavigationController? {
        guard let parent = controller.parent else { return nil }
        
        if let nav = parent as? UINavigationController {
            return nav
        } else {
            return topmostParentNavigationController(for: parent)
        }
    }
    
    func addAsChild(for parent: UIViewController, containerView: UIView, animated: Bool = false) {
        self.removeFromParent()
        self.willMove(toParent: parent)
        containerView.subviews.forEach { $0.removeFromSuperview() }
        if animated {
            UIView.transition(
                with: containerView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: { [unowned self] in
                    parent.addChild(self)
                    containerView.addSubview(self.view)
                }, completion: { _ in
                    self.view.frame = containerView.bounds
                    self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    self.didMove(toParent: parent)
            }
            )
        } else {
            parent.addChild(self)
            containerView.addSubview(self.view)
            self.view.frame = containerView.bounds
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.didMove(toParent: parent)
        }
    }
}

