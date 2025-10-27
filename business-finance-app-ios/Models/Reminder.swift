//
//  Reminder.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/7/13.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import Gloss

struct Reminder: Equatable, Hashable {
    let id: String
    let userProductId: String
    let userId: Int
    let remainderRuleId: Int
    let title: String?
    let description: String?
    let hexColor: String?
    let day_of_month: Int?
    let reminderTime: String?
    let type: String?
    let frequency: String?
    let created_at: String?
    let updated_at: String?
    let deleted_at: String?
    private let getReminderItems     : [Items]

    
    var items: [Items] {
        return self.getReminderItems
    }
    var hashValue: String {
        return id
    }
}


extension Reminder: JSONDecodable {
    init?(json: JSON) {       
        guard
            let id       : String    = "id" <~~ json,
            let title     : String = "title" <~~ json else {
                return nil
        }
        
        self.id        = id
        self.title      = title
        self.userProductId = "product_id" <~~ json ?? ""
        self.userId = "user_id" <~~ json ?? 0
        self.remainderRuleId = "remainder_rule_id" <~~ json ?? 0
        self.description = "description" <~~ json
        self.hexColor = "colour" <~~ json ?? "#dsfdsf"
        self.type = "type" <~~ json ?? ""
        self.frequency = "frequency" <~~ json ?? ""
        self.day_of_month = "day_of_month" <~~ json
        self.reminderTime = "reminder_time" <~~ json 
        self.created_at = "created_at" <~~ json ?? ""
        self.updated_at = "updated_at" <~~ json ?? ""
        self.deleted_at = "deleted_at" <~~ json ?? ""
        self.getReminderItems     = "items" <~~ json ?? []
    }
}

extension Reminder {
    static func getDummyProducts() -> [Product] {
        return dummyProducts.compactMap { Product.init(json: $0) }
    }
}

struct Items: Equatable, Hashable {
    let id: String?
    let reminder_id: String?
    let frequency: String?
    let reminder_month: Int?
    let day_of_month: Int?
    let week_day : Int?
    let reminder_time: String?
    let created_at: String?
    let updated_at: String?
    let deleted_at: String?

    var hashValue: Int {
        return id.hashValue
    }
}
extension Items: JSONDecodable {
    init?(json: JSON) {
        self.id        = "id" <~~ json
        self.reminder_id      = "reminder_id" <~~ json
        self.frequency      = "frequency" <~~ json
        self.reminder_month      = "reminder_month" <~~ json ?? 0
        self.day_of_month      = "day_of_month" <~~ json ?? 0
        self.week_day      = "week_day" <~~ json  ?? 0
        self.reminder_time      = "reminder_time" <~~ json 
        self.created_at      = "created_at" <~~ json
        self.updated_at      = "updated_at" <~~ json
        self.deleted_at      = "deleted_at" <~~ json
    }
}


private let dummyProducts: [[String : Any]] = [
    [
        "id" : 1,
        "name" : "Lunch",
        "colour" : "#FFBA00",
        "multi_pages" : false
    ],
    [
        "id" : 2,
        "name" : "Goods",
        "colour" : "#F94094",
        "multi_pages" : false
    ],
    [
        "id" : 3,
        "name" : "Internet",
        "colour" : "#2FCC71",
        "multi_pages" : true
    ]
]



