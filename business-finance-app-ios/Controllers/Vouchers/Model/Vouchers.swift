//
//  Vouchers.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/15.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import Gloss

struct Vouchers: Equatable, Hashable {
    let id: Int
    let vendor_id: Int
    let name: String?
    let type: String
    let value: Int
    let voucher_code: String?
    let created_at: String?
    let updated_at: String?
    let deleted_at: String?
    let is_active: Int?
    let vendor     : Vendor

    var hashValue: Int {
        return id
    }
}


extension Vouchers: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json,
            let name     : String = "name" <~~ json else {
                return nil
        }
        guard
            let getVendorData: Vendor = "vendor" <~~ json else {
            return nil
        }
        self.id        = id
        self.name      = name
        self.vendor_id = "vendor_id" <~~ json ?? 0
        self.type = "type" <~~ json ?? ""
        self.value = "value" <~~ json ?? 0
        self.is_active = "is_active" <~~ json ?? 0
        self.voucher_code = "voucher_code" <~~ json ?? ""
        self.created_at = "created_at" <~~ json ?? "#dsfdsf"
        self.updated_at = "updated_at" <~~ json ?? ""
        self.deleted_at = "updated_at" <~~ json ?? ""
        self.vendor = getVendorData
    }
}

