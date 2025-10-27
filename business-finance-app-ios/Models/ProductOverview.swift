//
//  ProductOverview.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Gloss

struct ProductOverview: Equatable {
    let product               : Product
    let totalAmount           : Double
    let totalAmountSpent      : Double
    let remainingAmount       : Double
    let approvedInvoicesCount : Int
    let approvedInvoicesCountMonth : Double
    let accreditedAmountMonth : Double
}

extension ProductOverview: JSONDecodable {
    init?(json: JSON) {
        guard let product: Product = "product" <~~ json else {
            return nil
        }
        self.product = product
        self.totalAmount           = "total_amount" <~~ json ?? 0
        self.totalAmountSpent      = "total_amount_spent" <~~ json ?? 0
        self.remainingAmount       = "remaining_amount"  <~~ json ?? 0
        self.approvedInvoicesCount = "approved_invoices_count" <~~ json ?? 0
        self.approvedInvoicesCountMonth = "approved_invoices_count_month" <~~ json ?? 0
        self.accreditedAmountMonth = "accredited_amount_month" <~~ json ?? 0
    }
}
