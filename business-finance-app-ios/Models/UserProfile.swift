//
//  UserProfile.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 25/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Gloss

struct UserProfile: Equatable {
    let id: Int
    let name: String
    let email: String
}

extension UserProfile: JSONDecodable {
    init?(json: JSON) {
        guard
            let id   : Int    = "id" <~~ json,
            let name : String = "name" <~~ json,
            let email: String = "email" <~~ json else {
                return nil
        }
        
        self.id    = id
        self.name  = name
        self.email = email
    }
}
