//
//  AuthResponse.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Gloss

struct AuthResponse: JSONDecodable {
    let tokenType    : String
    let expiresIn    : Int
    let accessToken  : String
    let refreshToken : String
    
    init?(json: JSON) {
        guard
            let tokenType    : String = "token_type" <~~ json,
            let expiresIn    : Int    = "expires_in" <~~ json,
            let accessToken  : String = "access_token" <~~ json,
            let refreshToken : String = "refresh_token" <~~ json else {
                return nil
        }
        
        self.tokenType    = tokenType
        self.expiresIn    = expiresIn
        self.accessToken  = accessToken
        self.refreshToken = refreshToken
    }
}
