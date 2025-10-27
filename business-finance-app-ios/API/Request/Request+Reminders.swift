//
//  Request+Reminders.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/7/13.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import Alamofire
import CoreFoundation

extension Request {
    static func getReminderList() -> Request {
        let route = Route(endpoint: "/reminder", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }

    static func deleteReminder(reminderID: String) -> Request {
        let parameters: [String : Any] = [:]
        let route = Route(
            endpoint: "/reminder/\(reminderID)",
            method: .delete,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: Request.environment.apiURL)
    }
    
    static func reminderOnOFF(reminderID: String) -> Request {
        let parameters: [String : Any] = [:]
        let route = Route(
            endpoint: "/on-off-reminder/\(reminderID)",
            method: .post,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: Request.environment.apiURL)
    }
}
