//
//  ColorUpdatable.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

// A protocol which denotes types which can update their colors.
protocol ColorUpdatable {
    
    // The theme for which to update colors.
    var theme: Theme { get set }
    
    // A function that is called when colors should be updated.
    func updateColors(for theme: Theme)
}
