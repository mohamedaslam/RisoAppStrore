//
//  Request+Kindergarten.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/9/13.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import Alamofire
extension Request {
    
    static func createKidKindergarten(name: String, gender: String,dob: String, kinder_garden_name: String, kinder_garden_address: String, not_compulsory_school_age: Bool, spouse_not_getting_benefit: Bool) -> Request {
 
        let parameters: [String : Any] = [
            "name" : name,
            "gender" : gender,
            "dob" : dob,
            "kinder_garden_name" : kinder_garden_name ,
            "kinder_garden_address" : kinder_garden_address,
            "not_compulsory_school_age" : not_compulsory_school_age,
            "spouse_not_getting_benefit" : spouse_not_getting_benefit
        ]
        let route = Route(endpoint: "/user-kids/store",method: .post,shouldAuthorize: true,parameters: parameters)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func editKidKindergarten(id: Int,user_id: Int, name: String, gender: String,dob: String, age: Int, kinder_garden_name: String, kinder_garden_address: String, is_applicable: Bool,not_compulsory_school_age: Bool, spouse_not_getting_benefit: Bool, created_at: String,updated_at: String,deleted_at: String) -> Request {
        
        let parameters: [String : Any] = [
            "id" : id,
            "user_id" : user_id,
            "name" : name,
            "gender" : gender,
            "dob" : dob,
            "age" : age,
            "kinder_garden_name" : kinder_garden_name ,
            "kinder_garden_address" : kinder_garden_address,
            "is_applicable" : is_applicable,
            "not_compulsory_school_age" : not_compulsory_school_age,
            "spouse_not_getting_benefit" : spouse_not_getting_benefit,
            "created_at" : created_at,
            "updated_at" : updated_at,
            "deleted_at" : deleted_at
        ]

        let route = Route(endpoint: "/user-kids/store", method: .post, shouldAuthorize: true, parameters: parameters)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func getListOfKindergartenKids() -> Request {
        let route = Route(endpoint: "/user-kids", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func deleteKid(kid_UserID: Int) -> Request {
        let parameters: [String : Any] = [:]
        let route = Route(endpoint: "user-kids/destory/\(kid_UserID)", method: .delete, shouldAuthorize: true, parameters: parameters)
        return Request(route: route, url: Request.environment.apiURL)
    }
    
    static func getMonthlyKidStatusAddress() -> Request {
        let route = Route(endpoint: "/current-month-travel-status", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
}
