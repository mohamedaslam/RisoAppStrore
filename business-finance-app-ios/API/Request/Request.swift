//
//  Request.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation

struct Request {
    static let environment = App.environment
    let route: Route
    let url: String
    var accessToken: String?
    
    init(route: Route, url: String, accessToken: String? = nil) {
        self.route       = route
        self.url         = url
        self.accessToken = accessToken
    }
    func inject(accessToken: String?) -> Request {
        return Request(route: self.route, url: self.url, accessToken: accessToken)
    }
    
    func inject(route: Route) -> Request {
        return Request(route: route, url: self.url, accessToken: self.accessToken)
    }
}

extension Request {
    func makeRoutable() -> Router {
        return Router(request: self)
    }
}
