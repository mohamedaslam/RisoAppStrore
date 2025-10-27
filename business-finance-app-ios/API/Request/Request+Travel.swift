//
//  Request+Travel.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/8/30.
//  Copyright © 2022 Viable Labs. All rights reserved.
//
import Foundation
import Alamofire
extension Request {
    
    static func createUserTravel(home_address_line1: String, home_address_line2: String, home_city: String, home_state: String,home_zipcode: String, home_latitude: Float, home_longitude: Float, work_address_line1: String, work_address_line2: String, work_city: String, work_state: String, work_zipcode: String, work_latitude: Float, work_longitude: Float, is_custom_work_address: Int, commuting_distance: Float,commuting_channel: String,days_to_commute_work: Int, product: Int,is_approved: Int,no_work_address:Int ) -> Request {
 
        let parameters: [String : Any] = [
            "home_address_line1" : home_address_line1,
            "home_address_line2" : home_address_line2,
            "home_city" : home_city,
            "home_state" : home_state,
            "home_zipcode" : home_zipcode,
            "home_latitude" : home_latitude,
            "home_longitude" : home_longitude,
            "work_address_line1" : work_address_line1,
            "work_address_line2" : work_address_line2,
            "work_city" : work_city,
            "work_state" : work_state,
            "work_zipcode" : work_zipcode,
            "work_latitude" : work_latitude,
            "work_longitude" : work_longitude,
            "is_custom_work_address" : is_custom_work_address,
            "commuting_distance" : commuting_distance,
            "commuting_channel" : commuting_channel,
            "days_to_commute_work" : days_to_commute_work,
            "is_approved" : is_approved,
            "product_id" : product,
            "no_work_address" : no_work_address
        ]

        let route = Route(endpoint: "/user-travel",method: .post,shouldAuthorize: true,parameters: parameters)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func editUserTravel(home_address_line1: String, home_address_line2: String, home_city: String, home_state: String,home_zipcode: Int, home_latitude: Float, home_longitude: Float, work_address_line1: String, work_address_line2: String, work_city: String, work_state: String, work_zipcode: Int, work_latitude: Float, work_longitude: Float, is_custom_work_address: Int, commuting_distance: Float,commuting_channel: String,days_to_commute_work: Int,product_id: Int,is_approved: Int,no_work_address:Int) -> Request {
 
        let parameters: [String : Any] = [
            "home_address_line1" : home_address_line1,
            "home_address_line2" : home_address_line2,
            "home_city" : home_city,
            "home_state" : home_state,
            "home_zipcode" : home_zipcode,
            "home_latitude" : home_latitude,
            "home_longitude" : home_longitude,
            "work_address_line1" : work_address_line1,
            "work_address_line2" : work_address_line2,
            "work_city" : work_city,
            "work_state" : work_state,
            "work_zipcode" : work_zipcode,
            "work_latitude" : work_latitude,
            "work_longitude" : work_longitude,
            "is_custom_work_address" : is_custom_work_address,
            "commuting_distance" : commuting_distance,
            "commuting_channel" : commuting_channel,
            "days_to_commute_work" : days_to_commute_work,
            "product_id" : product_id,
            "is_approved" : is_approved,
            "no_work_address" : no_work_address
        ]
        let route = Route(endpoint: "/user-travel",method: .post,shouldAuthorize: true,parameters: parameters)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func viewUserTravel() -> Request {
        let route = Route(endpoint: "/user-travel", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func getBenefitList() -> Request {
        let route = Route(endpoint: "/benefit-products", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func getUserTravelData() -> Request {
        let route = Route(endpoint: "/user-travel", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func getUserCompanyAddress() -> Request {
        let route = Route(endpoint: "/user-company-address", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func getMonthlyTravelStatusAddress() -> Request {
        let route = Route(endpoint: "/current-month-travel-status", method: .get, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func postMonthlyTravelStatusAddress() -> Request {
        let route = Route(endpoint: "/travel-monthly-confirmation", method: .post, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func postMonthlyKidConfirmation() -> Request {
        let route = Route(endpoint: "user-kids/kid-monthly-confirmation", method: .post, shouldAuthorize: true)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    

}
