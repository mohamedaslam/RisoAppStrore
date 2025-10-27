//
//  UIControl+Bamboots.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

// MARK: - Making `UIControl` conforms to `Loadable`
extension UIControl: Loadable {
    
    public func maskContainer() -> Containable? {
        return self
    }
    
    public func mask() -> Maskable? {
        let mask = ActivityIndicator()
        mask.backgroundColor = backgroundColor
        mask.color = tintColor
        return mask
    }
    
    /// Making it disabled when network request begins
    @objc public func begin() {
        isEnabled = false
        show()
    }
    
    /// Making it enabled when the last network request ends
    @objc public func end() {
        if let latestMask = self.maskContainer()?.latestMask() {
            if false == latestMask.isHidden {
                isEnabled = true
            }
        }
        hide()
    }
}
