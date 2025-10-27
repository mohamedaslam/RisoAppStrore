//
//  Request+Scan.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 30/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Alamofire

extension Request {
    static func uploadScan(images: [UIImage], productId: Int) -> Request {
        let parameters: [String : Any] = [
            "files" : images,
            "user_product_id" : productId
        ]
        
        let route = Route(
            endpoint: "/documents",
            method: .post,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func uploadKidReceipt(images: [UIImage], productId: Int,userKidId: Int) -> Request {
        let parameters: [String : Any] = [
            "files" : images,
            "user_product_id" : productId,
            "user_kid_id" : userKidId
        ]
        
        let route = Route(
            endpoint: "/documents",
            method: .post,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func getDocuments(month: Int, year: Int, product: Product?) -> Request {
        var parameters: [String : Any] = [
            "sort" : "updated_at",
            "year" : "\(year)"
        ]
        
        if(month == -1){}else{
            parameters["month"] = "\(month >= 10 ? "" : "0")\(month)"
        }
        
        if let userProductId = product?.userProductId {
            parameters["user_product_id"] = userProductId
        }
        
        let route = Route(
            endpoint: "/documents",
            method: .get,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func getDocumentsPendingCount(month: Int, year: Int, product: Product?) -> Request {
        var parameters: [String : Any] = [:]
//            "year" : "\(year)"
//        ]
        
        // parameters["month"] = "\(month >= 10 ? "" : "0")\(month)"
        
        if let userProductId = product?.userProductId {
            parameters["user_product_id"] = userProductId
        }
        
        let route = Route(
            endpoint: "/documents/pending_count",
            method: .get,
            shouldAuthorize: true,
            parameters: parameters
        )
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func getFirstDocumentUploadDate() -> Request {
        let route = Route(
            endpoint: "/documents/first_upload_date",
            method: .get,
            shouldAuthorize: true,
            parameters: [:]
        )
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
}
