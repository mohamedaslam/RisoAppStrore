//
//  Foundation+Ext.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation
import CoreGraphics

extension Array where Element: NSAttributedString {
    func merged() -> NSAttributedString? {
        guard !self.isEmpty else { return nil }
        return self.reduce(NSMutableAttributedString()) { (r, e) in
            r.append(e)
            return r
        }
    }
}

extension Collection {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension Array {
    func value(at index: Int) -> Element? {
        guard (0..<self.count).contains(index) else { return nil }
        return self[index]
    }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValidEmail: Bool {
        let emailRegEx =
            "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension CGFloat {
    static var tiny: CGFloat {
        return 0.000001
    }
}

extension Int {
    init?(value: Any?) {
        if let intValue = value as? Int {
            self = intValue
        } else if let stringValue = value as? String, let intValue = Int(stringValue) {
            self = intValue
        } else {
            return nil
        }
    }
}

extension Double {
    init?(value: Any?) {
        if let doubleValue = value as? Double {
            self = doubleValue
        } else if let stringValue = value as? String, let doubleValue = Double(stringValue) {
            self = doubleValue
        } else {
            return nil
        }
    }
}

import UIKit.UIFont
extension String {
    func attributedWith(tracking: CGFloat, font: UIFont) -> NSAttributedString {
        let fontSize = font.pointSize
        let characterSpacing = (tracking * fontSize) / 1000.0
        let attributes: [NSAttributedString.Key : Any] = [
            .font : font,
            .kern : characterSpacing
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
}

extension Double {
    func priceAsString(locale: Locale = Locale(identifier: "de_DE")) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Float {
    func priceAsString(locale: Locale = Locale(identifier: "de_DE")) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Int {
    func priceAsString(locale: Locale = Locale(identifier: "de_DE")) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
