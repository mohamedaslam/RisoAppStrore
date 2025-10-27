//
//  Request+Notification.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/10/24.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import Alamofire

extension Request {
    
    static func getNotificationList() -> Request {
        let route = Route(endpoint: "/user/notification/getMessages", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func notificaitonRead(notification_Id: Int) -> Request {
        let parameters: [String : Any] =
        ["id" : notification_Id]
        let route = Route(endpoint: "user/notification/updateMessagesStatus", method: .post, shouldAuthorize: true, parameters: parameters)
        return Request(route: route, url: Request.environment.apiURL)
    }
}
