//
//  Button.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 04/05/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class Button: UIButton {
    private(set) var style: ButtonStyle = ButtonStyle.filled

    var isDeactivated: Bool = false {
        didSet {
            isUserInteractionEnabled = !isDeactivated
            backgroundColor = isDeactivated ? style.disabledBackgroundColor : style.backgroundColor
            setTitleColor(style.tintColor, for: UIControl.State())
            tintColor = style.tintColor
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        set(shadowType: isDeactivated ? .none : style.shadowType)
    }
}
