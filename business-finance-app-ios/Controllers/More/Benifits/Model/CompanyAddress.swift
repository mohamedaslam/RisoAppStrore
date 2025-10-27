//
//  CompanyAddress.swift
//  BFA
//
//  Created by Mohammed Aslam on 2022/9/4.
//  Copyright © 2022 Viable Labs. All rights reserved.
//
/*
 {
     "data": {
         "id": 7,
         "name": "Plankstadt",
         "is_active": 1,
         "is_headquarter": 0,
         "street": "",
         "zip": "",
         "city": "",
         "country": "",
         "phone": "",
         "fax": "",
         "tax_identification_number": "",
         "sales_identification_number": null,
         "company_id": 5,
         "created_at": "2022-05-04 19:08:50",
         "updated_at": "2022-05-04 19:08:50"
     },
     "message": ""
 }
 */
import Gloss

struct CompanyAddress: Equatable, Hashable {
        let getAddress     : Address
        let getWorkAddress : Parse
}


extension CompanyAddress: JSONDecodable {
    init?(json: JSON) {

        guard
            let getAddress: Address = "address" <~~ json else {
            return nil
        }
        guard
            let getWorkAddress: Parse = "parse" <~~ json else {
            return nil
        }
        self.getAddress     = getAddress
        self.getWorkAddress     = getWorkAddress

    }
}

struct Address: Equatable, Hashable {
    let id: Int
    let name: String
    let is_active: Int
    let is_headquarter: Int
    let street: String
    let zip: String
    let city: String
    let state: String
    let country: String
    let phone: String
    let fax: String
    let tax_identification_number: String
    let sales_identification_number: String
    let company_id: Int
    let created_at: String
    let updated_at: String
    let latitude: String
    let longitude: String

    var hashValue: Int {
        return id
    }
}


extension Address: JSONDecodable {
    init?(json: JSON) {
        guard
            let id       : Int    = "id" <~~ json else {
                return nil
        }
        self.id        = id
        self.name     = "name" <~~ json ?? ""
        self.is_active = "is_active" <~~ json ?? 0
        self.is_headquarter = "is_headquarter" <~~ json ?? 0
        self.street = "street" <~~ json ?? ""
        self.zip = "zip" <~~ json ?? ""
        self.city = "city" <~~ json ?? ""
        self.state = "state" <~~ json ?? ""
        self.country = "country" <~~ json ?? ""
        self.phone = "phone" <~~ json ?? ""
        self.fax = "phone" <~~ json ?? ""
        self.tax_identification_number = "tax_identification_number" <~~ json ?? ""
        self.sales_identification_number = "sales_identification_number" <~~ json ?? ""
        self.company_id = "company_id" <~~ json ?? 0
        self.created_at = "created_at" <~~ json ?? ""
        self.updated_at = "updated_at" <~~ json ?? ""
        self.latitude = "latitude" <~~ json ?? ""
        self.longitude = "longitude" <~~ json ?? ""
    }
}

struct Parse: Equatable, Hashable {
    let work_address_line1: String
    let work_address_line2: String
    let work_city: String
    let work_state: String
    let work_zipcode: String
    let work_latitude: String
    let work_longitude: String
}

extension Parse: JSONDecodable {
    init?(json: JSON) {
        self.work_address_line1     = "work_address_line1" <~~ json ?? ""
        self.work_address_line2 = "work_address_line2" <~~ json ?? ""
        self.work_city = "work_city" <~~ json ?? ""
        self.work_state = "work_state" <~~ json ?? ""
        self.work_zipcode = "work_zipcode" <~~ json ?? ""
        self.work_latitude = "work_latitude" <~~ json ?? ""
        self.work_longitude = "work_longitude" <~~ json ?? ""
    }
}


