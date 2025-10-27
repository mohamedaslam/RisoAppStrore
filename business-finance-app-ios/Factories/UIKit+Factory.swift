//
//  UIKit+Factory.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

enum ButtonStyle {
    case filled
    case transparent
    
    var tintColor: UIColor {
        switch self {
        case .filled: return UIColor.Palette.white
        case .transparent: return UIColor.App.Button.backgroundColor
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .filled: return UIColor.App.Button.backgroundColor
        case .transparent: return UIColor.clear
        }
    }
    
    var disabledBackgroundColor: UIColor {
        return backgroundColor.alpha(0.6)
    }
    
    var font: UIFont {
        switch self {
        case .filled:      return UIFont.appFont(ofSize: 15, weight: .regular)
        case .transparent: return UIFont.appFont(ofSize: 13, weight: .regular)
        }
    }

    var shadowType: ShadowType {
        switch self {
        case .filled:      return .subtle
        case .transparent: return .none
        }
    }
}

extension UIButton {
    func set(style: ButtonStyle) {
        let button              = self
        button.tintColor        = style.tintColor
        button.titleLabel?.font = style.font
        button.backgroundColor  = style.backgroundColor
        button.setTitleColor(style.tintColor, for: UIControl.State())
//        let states: [UIControlState] = [.normal, .selected, .disabled, .highlighted]
//        states.forEach {
//            button.setTitleColor(style.titleColor(for: $0), for: $0)
//            button.setBackgroundImage(style.backgroundImage(for: $0), for: $0)
//        }
    }
}
