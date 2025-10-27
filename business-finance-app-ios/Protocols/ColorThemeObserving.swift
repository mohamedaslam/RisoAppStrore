//
//  ColorThemeObserving.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation

protocol ColorThemeObserving {
    
    // Registers observance of 'didChangeColorTheme' custom notifications.
    func addDidChangeColorThemeObserver(notificationCenter: NotificationCenter)
    
    // Removes observence of 'didChangeColorTheme' custom notifications.
    func removeDidChangeColorThemeObserver(notificationCenter: NotificationCenter)
    
    // Responds to 'didChangeColorTheme' custom notifications.
    func didChangeColorTheme(notificaiton: Notification)
    
}

// Mark: - ColorThemeObserving

private extension ColorThemeObserving {
    
    // Returns the theme specified by the 'didChangeColorTheme' notification's 'userInfo'.
    func theme(from notification: Notification) -> Theme? {
        guard let theme = notification.object as? Theme else { return nil }
        return theme
    }
    
    func updateColors(from notification: Notification) {
        guard let theme = theme(from: notification) else { return }
        
        if var colorUpdatableObject = self as? ColorUpdatable,
            theme != colorUpdatableObject.theme {
            colorUpdatableObject.theme = theme
            colorUpdatableObject.updateColors(for: theme)
        }
    }
}
