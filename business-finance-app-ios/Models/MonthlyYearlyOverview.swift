//
//  MonthlyYearlyOverview.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/11/12.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import Gloss

struct MonthlyYearlyOverview: Equatable {
    let joined_date         : String
    let monthly               : [MonthlyOverviewData]
    let yearly               : YearlyOverviewData

}

extension MonthlyYearlyOverview: JSONDecodable {
    init?(json: JSON) {
        guard let yearly: YearlyOverviewData = "yearly" <~~ json else {
            return nil
        }
        self.joined_date     = "joined_date" <~~ json ?? ""
        self.monthly     = "monthly" <~~ json ?? []
        self.yearly      = yearly
    }
}

struct YearlyOverviewData: Equatable {
    let totalAmount           : Double
    let total_amount_spent    : Double
    let remainingAmount       : Double
    let approvedInvoicesCount : Int
    let products     : [ProductOverview]
    
    var productsOverviews: [ProductOverview] {
        return self.products.sorted { (product1, product2) -> Bool in
            return product1.product.id < product2.product.id
        }
    }
    
    /** Tells the app if one cannot track expenses for these products */
    var disabledProducts: [Product] {
        return Array(
            Set<Product>(
                productsOverviews.filter { $0.remainingAmount <= 0 }.map { $0.product }
            )
        )
    }
}

extension YearlyOverviewData: JSONDecodable {
    init?(json: JSON) {
        self.total_amount_spent    = "total_amount_spent" <~~ json ?? 0
        self.totalAmount           = "total_amount" <~~ json ?? 0
        self.remainingAmount       = "remaining_amount"  <~~ json ?? 0
        self.approvedInvoicesCount = "approved_invoices_count" <~~ json ?? 0
        self.products     = "product_overview" <~~ json ?? []
    }
}
struct MonthlyOverviewData: Equatable {
    let totalAmount           : Double
    let total_amount_spent    : Double
    let remainingAmount       : Double
    let approvedInvoicesCount : Int
    let month                 : String
    let year                  : String
    private let products     : [ProductOverview]
    
    var productsOverviews: [ProductOverview] {
        return self.products.sorted { (product1, product2) -> Bool in
            return product1.product.id < product2.product.id
        }
    }
    
    /** Tells the app if one cannot track expenses for these products */
    var disabledProducts: [Product] {
        return Array(
            Set<Product>(
                productsOverviews.filter { $0.remainingAmount <= 0 }.map { $0.product }
            )
        )
    }
}

extension MonthlyOverviewData: JSONDecodable {
    init?(json: JSON) {
        self.totalAmount           = "total_amount" <~~ json ?? 0
        self.total_amount_spent    = "total_amount_spent" <~~ json ?? 0
        self.remainingAmount       = "remaining_amount"  <~~ json ?? 0
        self.approvedInvoicesCount = "approved_invoices_count" <~~ json ?? 0
        self.month                 = "month" <~~ json ?? ""
        self.year                  = "year" <~~ json ?? ""
        self.products     = "product_overview" <~~ json ?? []
    }
}
