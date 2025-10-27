//
//  UIButton+Ext.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    func resetInsets() {
        imageEdgeInsets = .zero
        titleEdgeInsets = .zero
        contentEdgeInsets = .zero
    }
}
