//
//  UserVoucher.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/15.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import Gloss

struct UserVoucher: Equatable, Hashable {
    let month : Int
    let year : Int
    var data : [UserData]
}

struct UserData: Equatable, Hashable {
   
    let id: Int
    let user_id: Int
    let product_id: Int
    let vendor_id: Int
    let voucher_id: Int
    let value: Int
    let voucher_type: String
    let pin: String
    let code_url: String
    let description: String
    let expiry_date: String
    let order_date: String
    let type: String
    let is_assigned : Int
    let voucher_status: Int
    let created_at: String?
    let updated_at: String?
    let deleted_at: String?
    let is_active: Int?
    let vendor     : Vendor

    var hashValue: Int {
        return id
    }
}
extension UserVoucher: JSONDecodable {
    init?(json: JSON) {
        self.month = "month" <~~ json ?? 0
        self.year = "year" <~~ json ?? 0
        self.data = "data" <~~ json ?? []
    }
}

extension UserData: JSONDecodable {
    init?(json: JSON) {

        guard
            let id       : Int    = "id" <~~ json,
            let user_id     : Int = "user_id" <~~ json else {
                return nil
        }
        guard
            let getVendorData: Vendor = "vendor" <~~ json else {
            return nil
        }
        self.id        = id
        self.user_id      = user_id
        self.product_id = "product_id" <~~ json ?? 0
        self.vendor_id = "vendor_id" <~~ json ?? 0
        self.voucher_id = "voucher_id" <~~ json ?? 0
        self.voucher_type = "voucher_type" <~~ json ?? ""
        self.value = "value" <~~ json ?? 0
        self.is_active = "is_active" <~~ json ?? 0
        self.pin = "pin" <~~ json ?? ""
        self.code_url = "code_url" <~~ json ?? ""
        self.description = "description" <~~ json ?? ""
        self.expiry_date = "expiry_date" <~~ json ?? ""
        self.order_date = "order_date" <~~ json ?? ""
        self.type = "type" <~~ json ?? ""
        self.is_assigned = "is_assigned" <~~ json ?? 0
        self.voucher_status = "voucher_status" <~~ json ?? 0
        self.created_at = "created_at" <~~ json ?? "#dsfdsf"
        self.updated_at = "updated_at" <~~ json ?? ""
        self.deleted_at = "updated_at" <~~ json ?? ""
        self.vendor = getVendorData

    }
}
