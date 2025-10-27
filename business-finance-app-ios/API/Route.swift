//
//  Route.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Alamofire

struct Route {
    let endpoint: String
    let method: HTTPMethod
    let shouldAuthorize: Bool
    let parameters: [String : Any]

    init(endpoint: String,
         method: HTTPMethod,
         shouldAuthorize: Bool,
         parameters: [String : Any] = [:]) {
        self.endpoint        = endpoint
        self.method          = method
        self.shouldAuthorize = shouldAuthorize
        self.parameters      = parameters
    }
}
