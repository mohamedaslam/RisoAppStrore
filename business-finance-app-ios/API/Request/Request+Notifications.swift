//
//  Request+Notifications.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 10/05/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Alamofire

extension Request {
    static func getUnreadNotifications() -> Request {
        let parameters: [String : Any] = [:]
        
        let route = Route(
            endpoint: "/notifications/pending",
            method: .get,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func read(notificationIds: [Int]) -> Request {
        let parameters: [String : Any] = [
            "notification_id" : notificationIds.map { "\($0)" }
        ]
        
        let route = Route(
            endpoint: "/notifications/read",
            method: .post,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
}
