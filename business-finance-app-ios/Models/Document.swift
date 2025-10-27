//
//  Invoice.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Gloss
import SwiftDate

enum InvoiceStatus: Int {
    case new        = 1
    case transcribe = 2
    case approved   = 3
    case rejected   = 4
}

/*
 {
 "id": 1,
 "user_id": 1,
 "product_id": 5,
 "company_id": 1,
 "location_id": 1,
 "user_product_id": 1,
 "status": 3,
 "amount_on_invoice": null,
 "amount": null,
 "supplier_city": "",
 "supplier_country": "",
 "supplier_name": "",
 "supplier_street": "",
 "supplier_tax_number": null,
 "supplier_zip": "",
 "comments": "",
 "review_date": null,
 "created_at": "2018-04-24 04:58:06",
 "updated_at": "2018-04-24 05:10:36",
 "date_on_receipt": "2018-04-23 00:00:00",
 "date_uploaded": "2018-04-24 04:58:06",
 "vat_number": null,
 "rejection_reason": null
 }
 */

struct Document: Equatable {
    let id                : Int
    let name              : String
    let price             : Double
    let date              : Date?
    let location          : String?
    let comments          : String?
    let rejectionComments : String?
    let status            : InvoiceStatus
}

extension Document: JSONDecodable {
    init?(json: JSON) {
        guard
            let id: Int = "id" <~~ json,
            let rawStatus: Int = "status" <~~ json,
            let status = InvoiceStatus(rawValue: rawStatus) else {
                return nil
        }
        
        self.id                = id
        self.status            = status
        self.name              = "supplier_name" <~~ json ?? ""
        self.comments          = "comments" <~~ json
        self.rejectionComments = "rejection_reason" <~~ json
        
        if let amount: String = "amount" <~~ json, let doubleAmount = Double(amount) {
            self.price = doubleAmount
        } else if let amount: Int = "amount" <~~ json {
            self.price = Double(amount)
        } else if let amount: Double = "amount" <~~ json {
            self.price = amount
        } else {
            self.price = 0.0
        }
        
        self.location          = "supplier_city" <~~ json
        
        if
            let dateString: String = "date_on_receipt" <~~ json,
            let date = dateString.toDate("yyyy-MM-dd HH:mm:ss")?.date {
                self.date = date
        } else {
            self.date = nil
        }
    }
}


