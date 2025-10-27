//
//  VoucherYearDetail.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2023/2/27.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import Foundation
import AVFoundation
import Gloss

struct VoucherYearDetail: Equatable, Hashable {
    let id: Int
    let user_id: Int
    let product_id: Int
    let max_amount_day: Int
    let max_amount_month: Int
    let is_assigned: Bool
    let location_product_id: Int
    let max_amount_year: Int
    let min_value: Int
    let budget: Int?
    let default_still_possible : Int?
    let default_amount : Int?
    let value_spent: String?
    let still_possible: Int
    let max_value : Int
    let created_at: String?
    let updated_at: String?
    let deleted_at: String?
    let getVoucherProductDetails     : VoucherProductDetails

    var hashValue: Int {
        return id
    }
}


extension VoucherYearDetail: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json,
            let user_id     : Int = "user_id" <~~ json else {
                return nil
        }
        guard
            let getProductData: VoucherProductDetails = "product" <~~ json else {
            return nil
        }
   
        self.id        = id
        self.user_id      = user_id
        self.product_id = "product_id" <~~ json ?? 0
        self.max_amount_day = "vendor_id" <~~ json ?? 0
        self.max_amount_month = "voucher_id" <~~ json ?? 0
        self.is_assigned = "voucher_type" <~~ json ?? false
        self.location_product_id = "location_product_id" <~~ json ?? 0
        self.max_amount_year = "max_amount_year" <~~ json ?? 0
        self.min_value = "min_value" <~~ json ?? 0
        self.budget = "budget" <~~ json ?? 0
        self.default_amount = "default_amount" <~~ json ?? 0
        self.default_still_possible = "default_still_possible" <~~ json ?? 0
        self.value_spent = "value_spent" <~~ json ?? ""
        self.still_possible = "still_possible" <~~ json ?? 0
        self.max_value = "max_value" <~~ json ?? 0
        self.created_at = "created_at" <~~ json ?? "#dsfdsf"
        self.updated_at = "updated_at" <~~ json ?? ""
        self.deleted_at = "updated_at" <~~ json ?? ""
        self.getVoucherProductDetails = getProductData

    }
}


