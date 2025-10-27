//
//  UICollectionView+Reusable.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

extension UICollectionViewCell: Reusable { }
