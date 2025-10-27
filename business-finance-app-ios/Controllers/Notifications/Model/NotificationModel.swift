//
//  NotificationModel.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/10/21.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import Gloss

struct NotificationModel: Equatable, Hashable {
    let id: Int
    let userId: Int
    let title: String?
    let description: String?
    let product_id: String?
    let product_code: String?
    let is_user_kinder_set : Int
    let is_user_travel_set : Int
    let device_id: String?
    var is_read: Int
    let created_at: String?
    let updated_at: String?
    let deleted_at: String?
    let user_product_id : Int
    var hashValue: Int {
        return id
    }
}


extension NotificationModel: JSONDecodable {
    init?(json: JSON) {
        self.id        = "id" <~~ json ?? 0
        self.userId = "user_id" <~~ json ?? 0
        self.title      = "title" <~~ json ?? ""
        self.description = "description" <~~ json
        self.product_id = "product_id" <~~ json ?? ""
        self.product_code = "product_code" <~~ json ?? ""
        self.device_id = "device_id" <~~ json ?? ""
        self.is_read = "is_read" <~~ json ?? 0
        self.is_user_kinder_set = "is_user_kinder_set" <~~ json ?? 0
        self.is_user_travel_set = "is_user_travel_set" <~~ json ?? 0
        self.created_at = "created_at" <~~ json ?? ""
        self.updated_at = "updated_at" <~~ json ?? ""
        self.deleted_at = "deleted_at" <~~ json ?? ""
        self.user_product_id  = "user_product_id" <~~ json ?? 0
    }
}
