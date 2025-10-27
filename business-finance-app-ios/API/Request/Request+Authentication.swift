//
//  Request+Authentication.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Alamofire

private enum PlatformType: Int {
    case android = 1
    case iOS     = 2
}

extension Request {
    static func login(email: String, password: String) -> Request {

        let parameters: [String : Any] = [
            "username" : email,
            "password" : password,
            "client_secret" : "dQ1UcPpCrpKIU9gASpaHaGvoVv8Yx2SxUilE1mUL",
            "client_id" : "2",
            "grant_type" : "password"
        ]
        let route = Route(
            endpoint: "/oauth/token",
            method: .post,
            shouldAuthorize: false,
            parameters: parameters
        )
        return Request(route: route, url: Request.environment.baseURL)
    }
    
    static func signOut(deviceID: String) -> Request {
        let parameters = [
            "device_id" : deviceID
        ]
        let route = Route(
            endpoint: "/logout",
            method: .post,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: Request.environment.apiURL)
    }
    
    static func register(deviceID: String, pushToken: String) -> Request {
        let parameters: Parameters = [
            "device_id" : deviceID,
            "token"     : pushToken,
            "device_type" : PlatformType.iOS.rawValue
        ]
        
        let route = Route(
            endpoint: "/devices",
            method: .post,
            shouldAuthorize: true,
            parameters: parameters
        )
    
        return Request(route: route, url: Request.environment.apiURL)
    }
    
    static func registerPushNotification(deviceName: String,deviceModel: String,deviceID: String, pushToken: String) -> Request {
        let parameters: Parameters = [
            "device_name" : deviceName,
            "device_model"     : deviceModel,
            "installation_id" : deviceID,
            "token" : pushToken,
            "device_type" : "ios"
        ]
        
        let route = Route(
            endpoint: "/device-tokens-store",
            method: .post,
            shouldAuthorize: true,
            parameters: parameters
        )
    
        return Request(route: route, url: Request.environment.apiURL)
    }
    
    static func resetPassword(email: String) -> Request {
        let parameters = ["email" : email]
        let route = Route(
            endpoint: "/forgot-password",
            method: .post,
            shouldAuthorize: false,
            parameters: parameters
        )
        return Request(route: route, url: Request.environment.apiURL)
    }
}
