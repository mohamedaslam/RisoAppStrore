//
//  VoucherProduct.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/19.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import Gloss
import AVFoundation

struct VoucherProduct: Equatable, Hashable {
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
    let getDefaultVoucher     : [DefaultVoucher]

    var hashValue: Int {
        return id
    }
}


extension VoucherProduct: JSONDecodable {
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
        self.getDefaultVoucher = "default_vouchers"  <~~ json ?? []
        self.getVoucherProductDetails = getProductData

    }
}

struct VoucherProductDetails: Equatable, Hashable {
    let id: Int
    let name: String
    let description: String
    let is_active: Bool
    let no_limit : Int
    let is_general: Int
    let colour: String
    let multi_pages: Int
    let max_amount_year: Int
    let max_amount_day: Int
    let max_amount_month: Int
    let tax_rate: String
    let is_yearly_limits: Int
    let category_type: Int
    let legal_rules: String
    let yearly_limit: Int
    let image_path: String
    let hide_from_rainbow : Bool
    let image : String
    let product_code : String
    let created_at: String?
    let updated_at: String?
    let deleted_at: String?

    var hashValue: Int {
        return id
    }
}


extension VoucherProductDetails: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json else {
                return nil
        }

        self.id        = id
        self.name = "name" <~~ json ?? ""
        self.description = "description" <~~ json ?? ""
        self.is_active = "is_active" <~~ json ?? false
        self.no_limit = "no_limit" <~~ json ?? 0
        self.is_general = "is_general" <~~ json ?? 0
        self.colour = "colour" <~~ json ?? ""
        self.multi_pages = "multi_pages" <~~ json ?? 0
        self.max_amount_year = "max_amount_year" <~~ json ?? 0
        self.max_amount_day = "max_amount_day" <~~ json ?? 0
        self.max_amount_month = "max_amount_month" <~~ json ?? 0
        self.tax_rate = "tax_rate" <~~ json ?? ""
        self.is_yearly_limits = "is_yearly_limits" <~~ json ?? 0
        self.category_type = "category_type" <~~ json ?? 0
        self.created_at = "created_at" <~~ json ?? "#dsfdsf"
        self.updated_at = "updated_at" <~~ json ?? ""
        self.deleted_at = "updated_at" <~~ json ?? ""
        self.legal_rules = "legal_rules" <~~ json ?? ""
        self.yearly_limit = "yearly_limit" <~~ json ?? 0
        self.image_path = "image_path" <~~ json ?? ""
        self.hide_from_rainbow = "hide_from_rainbow" <~~ json ?? false
        self.image = "image" <~~ json ?? ""
        self.product_code = "product_code" <~~ json ?? ""
    }
}

struct DefaultVoucher: Equatable, Hashable {
    let id: Int
    let type: String
    let value: Int
    let name : String
    let voucher_id: Int
    let product_id: Int


    var hashValue: Int {
        return id
    }
}


extension DefaultVoucher: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json else {
                return nil
        }

        self.id        = id
        self.name = "name" <~~ json ?? ""
        self.type = "type" <~~ json ?? ""
        self.value = "no_limit" <~~ json ?? 0
        self.voucher_id = "voucher_id" <~~ json ?? 0
        self.product_id = "product_id" <~~ json ?? 0
    }
}
