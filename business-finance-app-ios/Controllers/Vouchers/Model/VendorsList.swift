//
//  VendorsList.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/21.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import Gloss

struct VendorsList: Equatable, Hashable {
    let id: Int
    let name: String
    let logo: String
    let link: String
    let description: String?
    let created_at: String?
    let updated_at: String?
    let deleted_at: String?
    let min_value: String?
    let max_value: String?
    let is_active: Int?
    let vouchers_count: Int?
    let image_path: String?
    var vouchers     : [VouchersList]
    var imageURL: URL? {
        guard let stringURL = image_path else { return nil }
        return URL(string: stringURL)
    }
    var hashValue: Int {
        return id
    }
}


extension VendorsList: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json,
            let name     : String = "name" <~~ json else {
                return nil
        }
//    guard
//            let getVouchersData: VouchersList = "vouchers" <~~ json ?? []  else {
//            return nil
//        }
        self.id        = id
        self.name      = name
        self.description = "description" <~~ json ?? ""
        self.logo = "logo" <~~ json ?? ""
        self.is_active = "is_active" <~~ json ?? 0
        self.link = "link" <~~ json ?? ""
        self.vouchers_count = "vouchers_count" <~~ json
        self.created_at = "created_at" <~~ json ?? "#dsfdsf"
        self.updated_at = "updated_at" <~~ json ?? ""
        self.deleted_at = "updated_at" <~~ json ?? ""
        self.min_value = "min_value" <~~ json ?? ""
        self.max_value = "max_value" <~~ json
        self.image_path = "image_path" <~~ json ?? ""

        self.vouchers = "vouchers" <~~ json ?? []
    }
}


