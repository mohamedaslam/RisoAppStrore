//
//  UITextField+Ext.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

extension UITextField {
    func attachDismissTooblar(doneButtonTitle: String) {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.barTintColor = .white
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: doneButtonTitle, style: .plain, target: self, action: #selector(hideKeyboard))
        ]
        toolbar.tintColor = UIColor.App.Text.dark
        toolbar.items?.forEach {
            $0.setTitleTextAttributes([.foregroundColor : UIColor.App.Text.dark], for: UIControl.State())
        }
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc
    private func hideKeyboard() {
        resignFirstResponder()
        superview?.endEditing(true)
    }
}
