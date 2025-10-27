//
//  Request+Voucher.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/19.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import Foundation

extension Request {
//userProductID: Int,voucherID: Int,
static func getVendorsList(userProductID : Int,voucherID: Int) -> Request {
    let parameters: [String : Any] = [
        "id": userProductID,
        ]
    let route = Route(endpoint: "/vendors", method: .get, shouldAuthorize: true,parameters:parameters)
    return Request(route: route, url: environment.apiURL, accessToken: nil)
}

static func getVouchersList() -> Request {
    let route = Route(endpoint: "/vouchers", method: .get, shouldAuthorize: true)
    return Request(route: route, url: environment.apiURL, accessToken: nil)
}

static func getVoucherProduct() -> Request {
    let route = Route(endpoint: "/voucher-products", method: .get, shouldAuthorize: true)
    return Request(route: route, url: environment.apiURL, accessToken: nil)
}


static func getUserVouchersList(productID : Int,getMonth : Int,getYear : Int) -> Request {
    let parameters: [String : Any] = [
        "year" : "\(getYear)",
        "month" : "\(getMonth)",
        "product_id" : "\(productID)"
    ]
    let route = Route(endpoint: "/user-vouchers", method: .get, shouldAuthorize: true,parameters:parameters)
    return Request(route: route, url: environment.apiURL, accessToken: nil)
}
//vendor_id : vendor_id
static func getVouchersProduct(vouchersProductID : Int) -> Request {
    let parameters: [String : Any] = [
        "id" : vouchersProductID
    ]
    let route = Route(endpoint: "/voucher-products", method: .get, shouldAuthorize: true,parameters:parameters)
    return Request(route: route, url: environment.apiURL, accessToken: nil)
}
    
    static func getDefaultVouchers(vouchersProductID : Int) -> Request {
        let parameters: [String : Any] = [
            "id" : vouchersProductID
        ]
        let route = Route(endpoint: "/default-voucher", method: .get, shouldAuthorize: true,parameters:parameters)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    static func getFilterVouchersProduct(vendor_id : String,price_sort : String,min_price: Int, max_price: Int) -> Request {
        let parameters: [String : Any] = [
            "vendor_id" : vendor_id,
            "price_sort" : price_sort,
            "min_price" : min_price,
            "max_price" :max_price
        ]
        let route = Route(endpoint: "/vouchers", method: .get, shouldAuthorize: true,parameters:parameters)
        return Request(route: route, url: environment.apiURL, accessToken: nil)
    }
    
    static func deleteVoucher(voucherID: Int) -> Request {
        let parameters: [String : Any] = [
            "id" : voucherID
        ]
        let route = Route(endpoint: "default-voucher", method: .delete, shouldAuthorize: true, parameters: parameters)
        return Request(route: route, url: Request.environment.apiURL)
    }
    
    static func saveDefaultVoucher(userProductID : Int,voucherID: Int) -> Request {
        let parameters: [String : Any] = [
            "user_product_id": userProductID,
            "voucher_id": voucherID
        ]
        let route = Route(endpoint: "default-voucher", method: .post, shouldAuthorize: true, parameters: parameters)
        return Request(route: route, url: Request.environment.apiURL)
    }
    
    static func shopVoucher(userProductID : Int,voucherID: Int) -> Request {
        let parameters: [String : Any] = [
            "user_product_id": userProductID,
            "voucher_id": voucherID
        ]
        let route = Route(endpoint: "shop-voucher", method: .post, shouldAuthorize: true, parameters: parameters)
        return Request(route: route, url: Request.environment.apiURL)
    }
    
    static func redeemVoucher(voucherID: Int) -> Request {
        let parameters: [String : Any] = [
            "id": voucherID,
            "voucher_status" : 3
        ]
        let route = Route(endpoint: "update-voucher", method:.post, shouldAuthorize: true, parameters: parameters)
        return Request(route: route, url: Request.environment.apiURL)
    }
    
    static func yearVoucherDetail(id : Int,Year: Int) -> Request {
        let parameters: [String : Any] = [
            "id": id,
            "year": Year
        ]
        let route = Route(endpoint: "year-voucher-detail", method: .get, shouldAuthorize: true, parameters: parameters)
        return Request(route: route, url: Request.environment.apiURL)
    }

}
