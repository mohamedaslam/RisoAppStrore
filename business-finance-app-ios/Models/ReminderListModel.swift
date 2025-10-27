//
//  ReminderListModel.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/7/13.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReminderListModel: NSObject {
    
    var id : String
    var userProductId : String
    var userId: Int
    var remainderRuleId: Int
    var title: String
    var descriptions: String
    var hexColor: String
    var day_of_month: Int
    var reaminderTime: String
    var created_at: String
    var updated_at: String
    var deleted_at: String
    
    
    init(jsonData: JSON){
        self.id = jsonData["id"].stringValue
        self.userProductId = jsonData["user_product_id"].stringValue
        self.userId = jsonData["user_id"].intValue
        self.remainderRuleId = jsonData["remainder_rule_id"].intValue
        self.title     = jsonData["title"].stringValue
        self.descriptions = jsonData["description"].stringValue
        self.hexColor = jsonData["colour"].stringValue
        self.day_of_month = jsonData["day_of_month"].intValue
        self.reaminderTime     = jsonData["remainder_time"].stringValue
        self.created_at = jsonData["created_at"].stringValue
        self.updated_at = jsonData["updated_at"].stringValue
        self.deleted_at = jsonData["deleted_at"].stringValue
    }
}

