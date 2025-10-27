//
//  KidDetail.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/9/17.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import SwiftyJSON

class KidDetail: NSObject {
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
   // let current_month_document:String?
    let user_product_id : Int
    let product_id : Int
    let message : String?
    
    let getCurrentMonthDocument : CurrentMonthDocuments
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.user_id = jsonData["user_id"].intValue
        self.name = jsonData["name"].stringValue
        self.gender = jsonData["gender"].stringValue
        self.dob = jsonData["dob"].stringValue
        self.age = jsonData["age"].intValue
        self.kinder_garden_name = jsonData["kinder_garden_name"].stringValue
        self.kinder_garden_address = jsonData["kinder_garden_address"].stringValue
        self.is_applicable = jsonData["is_applicable"].boolValue
        self.is_data_confirmed = jsonData["is_data_confirmed"].boolValue
        self.not_compulsory_school_age = jsonData["not_compulsory_school_age"].boolValue
        self.spouse_not_getting_benefit = jsonData["spouse_not_getting_benefit"].boolValue
        self.created_at = jsonData["created_at"].stringValue
        self.updated_at = jsonData["updated_at"].stringValue
        self.deleted_at = jsonData["deleted_at"].stringValue
        self.user_product_id = jsonData["user_product_id"].intValue
        self.product_id = jsonData["product_id"].intValue
        self.message = jsonData["message"].stringValue
        self.getCurrentMonthDocument = CurrentMonthDocuments(jsonData: jsonData["current_month_document"])

    }

}
class CurrentMonthDocuments: NSObject {
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
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.user_id = jsonData["user_id"].intValue
        self.product_id = jsonData["product_id"].intValue
        self.company_id = jsonData["company_id"].intValue
        self.location_id = jsonData["location_id"].intValue
        self.status = jsonData["status"].intValue
        self.amount_on_invoice = jsonData["amount_on_invoice"].intValue
        self.amount = jsonData["amount"].intValue
        self.supplier_city = jsonData["supplier_city"].stringValue
        self.supplier_country = jsonData["supplier_country"].stringValue
        self.supplier_name = jsonData["supplier_name"].stringValue
        self.supplier_street = jsonData["supplier_street"].stringValue
        self.supplier_tax_number = jsonData["supplier_tax_number"].stringValue
        self.supplier_zip = jsonData["supplier_zip"].stringValue
        self.comments = jsonData["comments"].stringValue
        self.review_date = jsonData["review_date"].stringValue
        self.created_at = jsonData["created_at"].stringValue
        self.updated_at = jsonData["updated_at"].stringValue
        self.date_on_receipt = jsonData["date_on_receipt"].stringValue
        self.date_uploaded = jsonData["date_uploaded"].stringValue
        self.vat_number = jsonData["vat_number"].stringValue
        self.rejection_reason = jsonData["rejection_reason"].stringValue
        self.tax_number = jsonData["tax_number"].stringValue
        self.is_file_sync = jsonData["is_file_sync"].intValue
        self.user_kid_id = jsonData["user_kid_id"].intValue
        self.user_travel_id = jsonData["user_travel_id"].intValue

    }

}
