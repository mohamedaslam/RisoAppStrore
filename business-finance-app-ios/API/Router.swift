//
//  Router.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Alamofire

struct Router: URLRequestConvertible {
    let request: Request
    
    init(request: Request) {
        self.request = request
    }
    
    func asURLRequest() throws -> URLRequest {
        let url                    = try request.url.asURL()
        let route                  = request.route
        var urlRequest             = URLRequest(url: url.appendingPathComponent(route.endpoint))
        urlRequest.httpMethod      = route.method.rawValue
        urlRequest.timeoutInterval = TimeInterval(60)
        
        if route.shouldAuthorize && request.accessToken != nil {
            urlRequest.addValue("Bearer \(request.accessToken!)", forHTTPHeaderField: "Authorization")
        }
        
        return try URLEncoding.default.encode(urlRequest, with: route.parameters)        
    }
}
