//
//  EmptyStatus.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 26/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import StatusProvider

struct EmptyStatus {
    let title: String?
    let description: String?
    let image: UIImage?
    
    static func noInvoices(productName: String, dateText: String) -> EmptyStatus {
        return EmptyStatus(
            title: "",
            description: String(format: "invoicesOverview.emptyText".localized, productName, dateText),
            image: #imageLiteral(resourceName: "no-invoices-image")
        )
    }
}
