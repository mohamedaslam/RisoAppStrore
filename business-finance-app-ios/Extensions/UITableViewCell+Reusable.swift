//
//  UITableViewCell+Reusable.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

extension UITableViewCell: Reusable {}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
    }
}

extension UITableViewCell {
    class func empty() -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
}

extension UITableViewCell {
    class func dequeue(in tableView: UITableView) -> Self {
        return tableView.dequeueReusableCell()
    }
}
