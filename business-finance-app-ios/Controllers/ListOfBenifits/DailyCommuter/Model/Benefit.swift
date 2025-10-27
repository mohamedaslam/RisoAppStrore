//
//  Benefit.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/9/2.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import Gloss

struct Benefit: Equatable, Hashable {
    let id: Int
    let name: String
    let description: String
    let is_active: Int
    let colour: String?
    let multi_pages: Int?
    let created_at: String?
    let updated_at: Int?
    let max_amount_day: String?
    let max_amount_month: String?
    let tax_rate: String?
    let product_code: String?
    let legal_rules: String?
    let yearly_limit: Bool?
    let max_amount_year: String?
    let is_user_travel_set : Int?
    let is_user_kinder_set : Int?
    let image_path: String?
    let hide_from_rainbow: Bool?
    let image: String?
    let getUserProduct     : User_product
    var imageURL: URL? {
        guard let stringURL = image_path else { return nil }
        return URL(string: stringURL)
    }
    var hashValue: Int {
        return id
    }
}


extension Benefit: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json,
            let name     : String = "name" <~~ json else {
                return nil
        }
        guard
            let getProductData: User_product = "user_product" <~~ json else {
            return nil
        }
        self.id        = id
        self.name      = name
        self.description = "description" <~~ json ?? ""
        self.is_active = "is_active" <~~ json ?? 0
        self.colour = "colour" <~~ json ?? ""
        self.multi_pages = "multi_pages" <~~ json
        self.created_at = "created_at" <~~ json ?? "#dsfdsf"
        self.updated_at = "updated_at" <~~ json ?? 0
        self.max_amount_day = "max_amount_day" <~~ json ?? ""
        self.max_amount_month = "max_amount_month" <~~ json
        self.tax_rate = "tax_rate" <~~ json
        self.product_code = "product_code" <~~ json ?? ""
        self.legal_rules = "legal_rules" <~~ json ?? ""
        self.yearly_limit = "yearly_limit" <~~ json ?? false
        self.max_amount_year = "max_amount_year" <~~ json ?? ""
        self.image_path = "image_path" <~~ json ?? ""
        self.hide_from_rainbow = "hide_from_rainbow" <~~ json ?? false
        self.image = "image" <~~ json ?? ""
        self.is_user_travel_set = "is_user_travel_set" <~~ json ?? 1
        self.is_user_kinder_set = "is_user_kinder_set" <~~ json ?? 1
        self.getUserProduct     = getProductData

    }
}


struct User_product: Equatable, Hashable {
    let product_id: Int
    let user_id: String?
    let max_amount_day: String?
    let max_amount_month: Int?
    let is_assigned: Int?
    let id : Int
}

extension User_product: JSONDecodable {
    init?(json: JSON) {
        self.product_id        = "product_id" <~~ json ?? 8
        self.user_id      = "user_id" <~~ json
        self.max_amount_day      = "max_amount_day" <~~ json
        self.max_amount_month      = "max_amount_month" <~~ json ?? 0
        self.is_assigned      = "is_assigned" <~~ json ?? 0
        self.id         = "id" <~~ json ?? 0
    }
}
