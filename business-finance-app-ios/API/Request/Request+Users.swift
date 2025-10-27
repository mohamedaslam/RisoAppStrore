//
//  Request+Users.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 25/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation

extension Request {
    static func getUserProfile() -> Request {
        let route = Route(endpoint: "/users/me", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
}
