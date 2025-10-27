//
//  Date+Ext.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation

extension Date {
    static func monthName(for monthValue: Int) -> String? {
        guard (1...12).contains(monthValue) else { return nil }
        
        let components = DateComponents(
            calendar: Calendar.current,
            month: monthValue,
            day: 15,
            hour: 12,
            minute: 0,
            second: 0
        )
        
        return components.date?.toFormat("MMMM")
    }
    
    static var currentYear: Int {
        let components   = Calendar.current.dateComponents([.year], from: Date())
        return components.year!
    }
    
    static var currentMonth: Int {
        let components   = Calendar.current.dateComponents([.month], from: Date())
        return components.month!
    }
}
