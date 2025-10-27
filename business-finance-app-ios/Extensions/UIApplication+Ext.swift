//
//  UIApplication+Ext.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

struct App {
    static var version: Any {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
    }
    
    static var build: Any {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!
    }
    
    static var environment: Environment {
        #if STA
            return .staging
        #else
            return .production
        #endif
    }
}
