//
//  Request+Products.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Alamofire

extension Request {
    static func getProducts() -> Request {
        var parameters: [String : Any] = [:]
        parameters["is_active"] = 1
        let route = Route(endpoint: "/products", method: .get, shouldAuthorize: true,parameters: parameters)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    static func getAllProducts() -> Request {
        let route = Route(endpoint: "/products_all", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    static func getDisclaimerTexts(for product: Product) -> Request {
        let route = Route(endpoint: "/products/\(product.id)/legal_rules", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    static func getDisclaimerTextsForKindergarten(prductID: Int) -> Request {
        let route = Route(endpoint: "/products/\(prductID)/legal_rules", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
}
