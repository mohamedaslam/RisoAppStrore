//
//  Product.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Gloss

struct Product: Equatable, Hashable {
    let id: Int
    let userProductId: Int
    
    let name: String
    let description: String?
    let hexColor: String
    let isMultiPage: Bool
    let yearlyLimit: Bool
    let imagePath: String?
    let hideFromRainbow: Bool
    let active: Bool
    var category_type: Int
    let product_code: String
    let userProductDetails : UserProduct
    var imageURL: URL? {
        guard let stringURL = imagePath else { return nil }
        return URL(string: stringURL)
    }
    var hashValue: Int {
        return id.hashValue
    }
}

//"id": 2,
//"name": "Internet",
//"description": "",
//"is_active": 1,
//"colour": "#2AC566",
//"multi_pages": 1,
//"created_at": "2018-04-24 04:54:13",
//"updated_at": "2018-04-24 04:56:50",
//"user_product": {
//    "product_id": 2,
//    "user_id": 1,
//    "max_amount_day": 15,
//    "max_amount_month": 650,
//    "is_assigned": 1,
//    "id": 2
//},
//"image_path": null,
//"image": null

extension Product: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json,
            let name     : String = "name" <~~ json else {
                return nil
        }
        guard let userProductDetails: UserProduct = "user_product" <~~ json else {
            return nil
        }
        self.id        = id
        self.name      = name
        self.hexColor  = "colour" <~~ json ?? "#FF0000"
        self.product_code = "product_code" <~~ json ?? ""
        self.isMultiPage = Bool(value: "multi_pages" <~~ json ?? false)
        self.description = "description" <~~ json
        self.imagePath = "image_path" <~~ json
        self.hideFromRainbow = "hide_from_rainbow" <~~ json ?? false
        self.userProductId = "user_product.id" <~~ json ?? id
        self.yearlyLimit = Bool(value: "yearly_limit" <~~ json ?? false)
        self.active = Bool(value: "is_active" <~~ json ?? false)
        self.category_type = "category_type" <~~ json ?? 0
        self.userProductDetails = userProductDetails
    }
}
struct UserProduct: Equatable, Hashable {
    let user_id: Int
    let product_id: Int
    let max_amount_day: Int
    let max_amount_month: Int
    let max_amount_year: Int
    let is_assigned: Bool
    let id: Int
}

//"id": 2,
//"name": "Internet",
//"description": "",
//"is_active": 1,
//"colour": "#2AC566",
//"multi_pages": 1,
//"created_at": "2018-04-24 04:54:13",
//"updated_at": "2018-04-24 04:56:50",
//"user_product": {
//    "product_id": 2,
//    "user_id": 1,
//    "max_amount_day": 15,
//    "max_amount_month": 650,
//    "is_assigned": 1,
//    "id": 2
//},
//"image_path": null,
//"image": null

extension UserProduct: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json else {
                return nil
        }
        
        self.id        = id
        self.user_id  = "user_id" <~~ json ?? 0
        self.max_amount_day  = "max_amount_day" <~~ json ?? 0
        self.max_amount_month  = "max_amount_month" <~~ json ?? 0
        self.max_amount_year  = "max_amount_year" <~~ json ?? 0
        self.is_assigned  = "is_assigned" <~~ json ?? false
        self.product_id  = "product_id" <~~ json ?? 0
    }
}

extension Product {
    static func getDummyProducts() -> [Product] {
        return dummyProducts.compactMap { Product.init(json: $0) }
    }
}

extension Product {
    var color: UIColor {
        return UIColor(hexString: hexColor)
    }
}
private let dummyProducts: [[String : Any]] = [
    [
        "id" : 1,
        "name" : "Lunch",
        "colour" : "#FFBA00",
        "multi_pages" : false
    ],
    [
        "id" : 2,
        "name" : "Goods",
        "colour" : "#F94094",
        "multi_pages" : false
    ],
    [
        "id" : 3,
        "name" : "Internet",
        "colour" : "#2FCC71",
        "multi_pages" : true
    ]
]

extension Bool {
    init(value: Any) {
        if let intValue = value as? Int {
            self = (intValue == 1)
        } else if let stringValue = value as? String {
            self = ["true", "yes", "1"].contains(stringValue.lowercased())
        } else if let boolValue = value as? Bool {
            self = boolValue
        } else {
            self = false
        }
    }
}
