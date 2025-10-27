//
//  ScanStepHeaderTableViewCell.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class ScanStepHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var stepLabel: UILabel! {
        didSet {
            guard let label = stepLabel else { return }
            label.font = UIFont.appFont(ofSize: 13, weight: .regular)
            label.textColor = UIColor.App.Text.light
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            guard let label = titleLabel else { return }
            label.font = UIFont.appFont(ofSize: 20, weight: .medium)
            label.textColor = UIColor.App.Text.dark
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = superview?.backgroundColor
    }
}
