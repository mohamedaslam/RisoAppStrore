//
//  UIView+Ext.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

enum ShadowType {
    case none
    case subtle
    
    var color: CGColor? {
        switch self {
        case .none:
            return nil
        case .subtle:
            return UIColor.Palette.catalinaBlue.cgColor
        }
    }
    var radius: CGFloat {
        switch self {
        case .none:
            return 0
        case .subtle:
            return 4
        }
    }
    var opacity: Float {
        switch self {
        case .none:
            return 0
        case .subtle:
            return 0.15
        }
    }
    var offset: CGSize {
        switch self {
        case .none:
            return .zero
        case .subtle:
            return CGSize(width: 0, height: 2)
        }
    }
}

extension UIView {
    func set(shadowType: ShadowType) {
        switch shadowType {
        case .none:
            layer.shadowPath = nil
            break
        case .subtle:
            layer.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: layer.cornerRadius
                ).cgPath
            break
        }
        
        clipsToBounds       = false
        layer.shadowColor   = shadowType.color
        layer.shadowOpacity = shadowType.opacity
        layer.shadowRadius  = shadowType.radius
        layer.shadowOffset  = shadowType.offset
    }
    
    func removeShadow() {
        set(shadowType: .none)
    }
}

extension UIView {
    func removeGestureRecognizers() {
        gestureRecognizers?.forEach { removeGestureRecognizer($0) }
    }
}

extension UIView {
    func constrainToEdges(_ subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0)
        
        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0)
        
        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0)
        
        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint])
    }
}

extension UIView {
    @available(iOS 11.0, *)
    func setContentAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior, searchChilds: Bool = true) {
        if let tableView = self as? UITableView {
            tableView.contentInsetAdjustmentBehavior = behavior
        } else if let collectionView = self as? UICollectionView {
            collectionView.contentInsetAdjustmentBehavior = behavior
        } else if let scrollView = self as? UIScrollView {
            scrollView.contentInsetAdjustmentBehavior = behavior
        }
        
        guard !subviews.isEmpty, searchChilds == true else { return }
        subviews.forEach { $0.setContentAdjustmentBehavior(behavior) }
    }
}
