//
//  UIView+Bamboots.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

internal extension UIView {
    
    /// Inner addSubView for Bamboots, making autolayout when addSubView
    ///
    /// - Parameters:
    ///   - subview: view to be added
    ///   - insets: insets between subview and view itself
    internal func addSubView(_ subview: UIView, insets: UIEdgeInsets) {
        
        self.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String : UIView] = ["subview": subview]
        let layoutStringH: String = "H:|-" + String(describing: insets.left) + "-[subview]-"
            + String(describing: insets.right) + "-|"
        let layoutStringV: String = "V:|-" + String(describing: insets.top) + "-[subview]-"
            + String(describing: insets.bottom) + "-|"
        let contraintsH: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: layoutStringH, options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:nil, views: views
        )
        let contraintsV: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: layoutStringV, options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:nil, views: views
        )
        
        self.addConstraints(contraintsH)
        self.addConstraints(contraintsV)
    }
}

// MARK: - Making `UIView` conforms to `Containable`
extension UIView: Containable {
    /// Return self as container for `UIView`
    ///
    /// - Returns: `UIView` itself
    @objc public func containerView() -> UIView? {
        return self
    }
}
