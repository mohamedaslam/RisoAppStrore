//
//  KindergartenKid.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/9/13.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import Gloss

struct KindergartenKid: Equatable, Hashable {
    let id: Int
    let user_id: Int
    let name: String
    let gender: String
    let dob: String?
    let age: Int
    let kinder_garden_name: String?
    let kinder_garden_address: String?
    let is_applicable: Bool
    let is_data_confirmed : Bool
    let not_compulsory_school_age: Bool
    let spouse_not_getting_benefit: Bool
    let created_at: String?
    let updated_at: String?
    let deleted_at: String?
    let current_month_document:CurrentMonthDocument?
    let user_product_id : Int
    let product_id : Int
    let message : String?
    
  //  let getCurrentMonthDocument : CurrentMonthDocument

    var hashValue: Int {
        return id
    }
}


extension KindergartenKid: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json,
            let user_id       : Int    = "user_id" <~~ json,
            let name     : String = "name" <~~ json else {
                return nil
        }

        self.id        = id
        self.user_id      = user_id
        self.name      = name
        self.gender = "gender" <~~ json ?? ""
        self.dob = "dob" <~~ json ?? ""
        self.age = "age" <~~ json ?? 0
        self.kinder_garden_name = "kinder_garden_name" <~~ json ?? ""
        self.kinder_garden_address = "kinder_garden_address" <~~ json
        self.is_applicable = Bool(value: "is_applicable" <~~ json ?? false)
        self.is_data_confirmed = Bool(value: "is_data_confirmed" <~~ json ?? false)
        self.not_compulsory_school_age = Bool(value: "not_compulsory_school_age" <~~ json ?? false)
        self.spouse_not_getting_benefit = Bool(value: "spouse_not_getting_benefit" <~~ json ?? false)
        self.created_at = "created_at" <~~ json
        self.updated_at = "updated_at" <~~ json ?? ""
        self.deleted_at = "deleted_at" <~~ json ?? ""
        self.current_month_document = "current_month_document" <~~ json
        self.user_product_id = "user_product_id" <~~ json ?? 0
        self.product_id = "product_id" <~~ json ?? 0
        self.message = "message" <~~ json ?? ""
    }
}

struct CurrentMonthDocument: Equatable, Hashable {
    let id: Int
    let user_id: Int
    let product_id: Int
    let company_id: Int
    let location_id: Int
    let status: Int
    let amount_on_invoice: Int
    let amount: Int
    let supplier_city: String
    let supplier_country: String
    let supplier_name: String
    let supplier_street: String
    let supplier_tax_number: String
    let supplier_zip: String
    let comments: String
    let review_date: String
    let created_at: String
    let updated_at: String
    let date_on_receipt: String
    let date_uploaded: String
    let vat_number : String
    let rejection_reason: String
    let tax_number: String
    let is_file_sync: Int
    let user_kid_id: Int
    let user_travel_id : Int
    var hashValue: Int {
        return id
    }
}


extension CurrentMonthDocument: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json,
            let user_id       : Int    = "user_id" <~~ json else{
                return nil
        }
        self.id        = id
        self.user_id   = user_id
        self.comments  = "comments" <~~ json ?? ""
        self.amount    = "amount" <~~ json ?? 0
        self.amount_on_invoice = "amount_on_invoice" <~~ json ?? 0
        self.company_id = "company_id" <~~ json ?? 0
        self.created_at = "created_at" <~~ json ?? ""
        self.date_on_receipt = "date_on_receipt" <~~ json ?? ""
        self.date_uploaded = "date_uploaded" <~~ json ?? ""
        self.is_file_sync = "is_file_sync" <~~ json ?? 0
        self.location_id = "location_id" <~~ json ?? 0
        self.product_id = "product_id" <~~ json ?? 0
        self.rejection_reason = "rejection_reason" <~~ json ?? ""
        self.review_date = "review_date" <~~ json ?? ""
        self.status = "status" <~~ json ?? 0
        self.supplier_city = "supplier_city" <~~ json ?? ""
        self.supplier_country = "supplier_country" <~~ json ?? ""
        self.supplier_name = "supplier_name" <~~ json ?? ""
        self.supplier_street = "supplier_street" <~~ json ?? ""
        self.supplier_tax_number = "supplier_tax_number" <~~ json ?? ""
        self.supplier_zip = "supplier_zip" <~~ json ?? ""
        self.tax_number = "tax_number" <~~ json ?? ""
        self.updated_at = "updated_at" <~~ json ?? ""
        self.user_kid_id = "user_kid_id" <~~ json ?? 0
        self.user_travel_id = "user_travel_id" <~~ json ?? 0
        self.vat_number = "vat_number" <~~ json ?? ""
    }
}



