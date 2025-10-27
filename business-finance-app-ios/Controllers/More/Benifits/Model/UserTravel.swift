//
//  UserTravel.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/9/2.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import Gloss

struct UserTravel: Equatable, Hashable {
    let id: Int
    let user_id: Int
    let home_address_line1: String
    let home_address_line2: String
    let home_city: String
    let home_state: String
    let home_zipcode: String
    let home_latitude: String
    let home_longitude: String
    let work_address_line1: String
    let work_address_line2: String
    let work_city: String
    let work_state: String
    let work_zipcode: String
    let work_latitude: String
    let work_longitude: String
    let is_custom_work_address: Int
    let is_approved: Int
    let commuting_distance: Double
    let commuting_channel: String
    let days_to_commute_work: Int
    let created_at: String
    let updated_at: String
    let deleted_at: String
    let product_id: Int
    let user_product_id : Int
    let no_work_address : Int

    var hashValue: Int {
        return id
    }
}


extension UserTravel: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json else {
                return nil
        }
        self.id        = id
        self.user_id     = "user_id" <~~ json ?? 0
        self.home_address_line1 = "home_address_line1" <~~ json ?? ""
        self.home_address_line2 = "home_address_line2" <~~ json ?? ""
        self.home_city = "home_city" <~~ json ?? ""
        self.home_state = "home_state" <~~ json ?? ""
        self.home_zipcode = "home_zipcode" <~~ json ?? ""
        self.home_latitude = "home_latitude" <~~ json ?? ""
        self.home_longitude = "home_longitude" <~~ json ?? ""
        self.work_address_line1 = "work_address_line1" <~~ json ?? ""
        self.work_address_line2 = "work_address_line2" <~~ json ?? ""
        self.work_city = "work_city" <~~ json ?? ""
        self.work_state = "work_state" <~~ json ?? ""
        self.work_zipcode = "work_zipcode" <~~ json ?? ""
        self.work_latitude = "work_latitude" <~~ json ?? ""
        self.work_longitude = "work_longitude" <~~ json ?? ""
        self.is_custom_work_address = "is_custom_work_address" <~~ json ?? 0
        self.is_approved = "is_approved" <~~ json ?? 0
        self.commuting_distance = "commuting_distance" <~~ json ?? 0.0
        self.commuting_channel = "commuting_channel" <~~ json ?? ""
        self.days_to_commute_work = "days_to_commute_work" <~~ json ?? 0
        self.created_at = "created_at" <~~ json ?? ""
        self.updated_at = "updated_at" <~~ json ?? ""
        self.deleted_at = "deleted_at" <~~ json ?? ""
        self.product_id = "product_id" <~~ json ?? 0
        self.user_product_id = "user_product_id" <~~ json ?? 0
        self.no_work_address = "no_work_address" <~~ json ?? 0
    }
}


