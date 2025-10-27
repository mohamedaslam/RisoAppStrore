//
//  MonthlyOverview.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Gloss

struct MonthlyOverview: Equatable {
    let month: Int
    let year: Int
    let totalAmount           : Double
    let remainingAmount       : Double
    let approvedInvoicesCount : Int
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

extension MonthlyOverview: JSONDecodable {
    init?(json: JSON) {
        guard
            let month = Int(value: json["month"]),
            let year = Int(value: json["year"]) else {
                return nil
        }
        
        self.month                 = month
        self.year                  = year
        self.totalAmount           = "total_amount" <~~ json ?? 0
        self.remainingAmount       = "remaining_amount"  <~~ json ?? 0
        self.approvedInvoicesCount = "approved_invoices_count" <~~ json ?? 0
        self.products     = "product_overview" <~~ json ?? []
    }
}

extension MonthlyOverview {
    var hasData: Bool {
        return approvedInvoicesCount > 0
    }
    
    var isCurrentMonthOverview: Bool {
        return month == Date.currentMonth && year == Date.currentYear
    }
}

//extension MonthlyOverview {
//    static func getDummyOverview() -> MonthlyOverview {
//        return MonthlyOverview(json: monthlyOverviewDummyJSON)!
//    }
//}
//
//private let monthlyOverviewDummyJSON: [String : Any] = [
//    "month": 4,
//    "year": 2018,
//    "total_amount": 1450,
//    "remaining_amount": 1322,
//    "approved_invoices_count": 4,
//    "product_overview": [
//        [
//            "total_amount": 250,
//            "remaining_amount": 217,
//            "approved_invoices_count": 2,
//            "product": [
//                "id": 1,
//                "name": "Lunch",
//                "is_active": 1,
//                "colour": "#FFB106",
//                "multi_pages": 0,
//                "created_at": "2018-04-24 04:38:40",
//                "updated_at": "2018-04-24 04:38:40",
//                "pivot": [
//                    "user_id": 1,
//                    "product_id": 1,
//                    "max_amount_day": 5,
//                    "max_amount_month": 250,
//                    "is_assigned": 1,
//                    "id": 1
//                ]
//            ]
//        ],
//        [
//            "total_amount": 350,
//            "remaining_amount": 255,
//            "approved_invoices_count": 2,
//            "product": [
//                "id": 5,
//                "name": "Travel",
//                "is_active": 1,
//                "colour": "#EB5A3A",
//                "multi_pages": 0,
//                "created_at": "2018-04-24 04:38:40",
//                "updated_at": "2018-04-24 04:38:40",
//                "pivot": [
//                    "user_id": 1,
//                    "product_id": 5,
//                    "max_amount_day": 5,
//                    "max_amount_month": 350,
//                    "is_assigned": 1,
//                    "id": 2
//                ]
//            ]
//        ],
//        [
//            "total_amount": 850,
//            "remaining_amount": 850,
//            "approved_invoices_count": 0,
//            "product": [
//                "id": 2,
//                "name": "Internet",
//                "is_active": 1,
//                "colour": "#2AC566",
//                "multi_pages": 0,
//                "created_at": "2018-04-24 04:38:40",
//                "updated_at": "2018-04-24 04:38:40",
//                "pivot": [
//                    "user_id": 1,
//                    "product_id": 2,
//                    "max_amount_day": 8,
//                    "max_amount_month": 850,
//                    "is_assigned": 1,
//                    "id": 3
//                ]
//            ]
//        ]
//    ]
//]
