//
//  Colors.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
    
extension UIColor {
    struct Palette {
        static let egyptianBlue       = UIColor(hex: 0x0F429F)
        static let dodgerBlue         = UIColor(hex: 0x246AFF)
        static let catalinaBlue       = UIColor(hex: 0x273A5F)
        static let shipCove           = UIColor(hex: 0x838D9F)
        static let white              = UIColor(hex: 0xFFFFFF)
        static let black              = UIColor(hex: 0x000000)
        static let solitudeUltraLight = UIColor(hex: 0xEBEFF7)
        static let catskillWhite      = UIColor(hex: 0xE1E6F0)
        static let whiteLilac         = UIColor(hex: 0xF6F8FC)
        static let ripeLemon          = UIColor(hex: 0xF8E71C)
        static let flamingo           = UIColor(hex: 0xF15632)
        static let blueHaze           = UIColor(hex: 0xCCD3E1)
    }
    
    struct App {
        static let primary             = UIColor.Palette.egyptianBlue
        struct Text {
            static let dark            = UIColor.Palette.catalinaBlue
            static let light           = UIColor.Palette.shipCove
            static let extraLight      = UIColor.Palette.blueHaze
            static let focused         = UIColor.Palette.dodgerBlue
            static let error           = UIColor.Palette.flamingo
        }
        
        struct TabBar {
            static let barTintColor    = UIColor.Palette.white
            static let defaultState    = UIColor.Palette.shipCove
            static let selectedState   = UIColor.Palette.white
        }
        
        struct NavigationBar {
            static let barTintColor    = UIColor.Palette.egyptianBlue
            static let tintColor       = UIColor.Palette.white
        }
        
        struct Button {
            static let backgroundColor = UIColor.Palette.dodgerBlue
            static let tintColor       = UIColor.Palette.white
            static let disabled        = UIColor.Palette.solitudeUltraLight
        }
        
        struct TableView {
            static let separator       = UIColor.Palette.solitudeUltraLight
            static let grayBackground  = UIColor.Palette.whiteLilac
        }
        
        struct Controller {
            static let grayBackground  = UIColor.Palette.whiteLilac
        }
        
        struct TextField {
            static let border          = UIColor.Palette.catskillWhite
            static let error           = UIColor.Palette.flamingo
        }
        
        struct PageIndicator {
            static let selected        = UIColor.Palette.dodgerBlue
            static let `default`       = UIColor.Palette.catskillWhite
        }
        
        struct DisclosureIndicator {
            static let light           = UIColor.Palette.blueHaze
        }
        
        struct Invoice {
            struct Status {
                static let pending     = UIColor.Palette.ripeLemon
            }
        }
    }
}
