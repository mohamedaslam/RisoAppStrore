//
//  Request+Dashboard.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 26/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Alamofire

extension Request {
    static func getMonthlyOverviews(month: Int?, year: Int?) -> Request {
        var parameters: [String : Any] = [:]
        if let year = year {
            if let month = month {
                parameters["month"] = "\(month >= 10 ? "" : "0")\(month)"
            }
            parameters["year"] = "\(year)"
        }
        let route = Route(
            endpoint: "/dashboard-new",
            method: .get,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    static func getMonthlyYearlyOverviews(month: Int?, year: Int?) -> Request {
        var parameters: [String : Any] = [:]
        if let year = year {
            if let month = month {
                parameters["month"] = "\(month >= 10 ? "" : "0")\(month)"
            }
            parameters["year"] = "\(year)"
        }
        let route = Route(
            endpoint: "/dashboard-new",
            method: .get,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
}
