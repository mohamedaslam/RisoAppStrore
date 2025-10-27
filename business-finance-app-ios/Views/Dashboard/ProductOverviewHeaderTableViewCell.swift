//
//  ProductOverviewHeaderTableViewCell.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class ProductOverviewHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var contentContainerView       : UIView!
    @IBOutlet weak var accreditedValueLabel       : UILabel!
    @IBOutlet weak var accreditedTextLabel        : UILabel!
    @IBOutlet weak var approvedInvoicesTextLabel  : UILabel!
    @IBOutlet weak var approvedInvoicesValueLabel : UILabel!
    @IBOutlet weak var amountLeftTextLabel        : UILabel!
    @IBOutlet weak var amountLeftValueLabel       : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accreditedTextLabel.text = "ACCREDITED".localized
        approvedInvoicesTextLabel.text = "APPROVED INVOICES".localized
        amountLeftTextLabel.text = "LEFT".localized
    }
    
    func configure(with overview: ProductOverview?) {
        guard let overview = overview else {
            accreditedValueLabel.text = "-"
            amountLeftValueLabel.text = "-"
            approvedInvoicesValueLabel.text = "-"
            return
        }
    
        let accreditedSum = overview.totalAmount - overview.remainingAmount
        let leftAmount    = overview.remainingAmount
        accreditedValueLabel.text = accreditedSum.priceAsString()
        amountLeftValueLabel.text = leftAmount.priceAsString()
        approvedInvoicesValueLabel.text = "\(overview.approvedInvoicesCount)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        contentContainerView?.set(shadowType: .subtle)
    }
}
