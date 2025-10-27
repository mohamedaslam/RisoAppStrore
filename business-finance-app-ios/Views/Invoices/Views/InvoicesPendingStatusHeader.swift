//
//  InvoicesPendingStatusHeader.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class InvoicesPendingStatusHeader: UIView {
    let textLabel: UILabel  = {
        let label           = UILabel()
        label.numberOfLines = 1
        label.font          = UIFont.appFont(ofSize: 13, weight: .semibold)
        label.textColor     = UIColor.App.Text.dark
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.App.Invoice.Status.pending.alpha(0.5)
        
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
