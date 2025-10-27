//
//  Font.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 04/05/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit


extension UIFont {
    
    enum SFCompact: String {
        case medium   = "SFCompactDisplay-Medium"
        case semibold = "SFCompactDisplay-Semibold"
        
        func of(size: CGFloat) -> UIFont {
            return UIFont(name: rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
    
    enum SFUIText: String {
        case medium   = "SFUIText-Medium"
        case regular  = "SFUIText-Regular"
        case bold     = "SFUIText-Bold"
        case semibold = "SFUIText-Semibold"
        
        func of(size: CGFloat) -> UIFont {
            return UIFont(name: rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
    
   static func appFont(ofSize size: CGFloat, weight: UIFont.Weight, compact: Bool = false) -> UIFont {
        switch weight {
        case .bold:
            return SFUIText.bold.of(size: size)
        case .medium:
            return compact ? SFCompact.medium.of(size: size) : SFUIText.medium.of(size: size)
        case .regular:
            return SFUIText.regular.of(size: size)
        case .semibold:
            return compact ? SFCompact.semibold.of(size: size) : SFUIText.semibold.of(size: size)
        default:
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }
}
