//
//  ReminderRepeatModel.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/7/18.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class ReminderRepeatModel: NSObject {
    var frequency: String
    var month : String
    var weekArr: [String]
    
    override init() {
        self.frequency = ""
        self.month = ""
        self.weekArr = [String]()
    }
}

class ReminderItemsModel: NSObject {
    var startTime: Int
    var endTime: Int
    var weekArr: [Int]
    
    override init() {
        self.startTime = 0
        self.endTime = 0
        self.weekArr = [Int]()
    }
}
