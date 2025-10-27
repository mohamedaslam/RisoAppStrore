//
//  Environment.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation

enum Environment {
    case production
    case staging
    
    var baseURL: String {
        switch self {
        case .production:
       // return "https://qa-api.riso-app.de"
         return "https://dev-api.riso-app.de"
       //  return "https://riso-prod.viableapi.com"
        case .staging:
            return "https://bfa.viableapi.com"
        }
    }

    var apiURL: String {
        return baseURL + "/api/v1"
    }
}



/*
 
 Use new URLs:
 Production:
 Admin: https://admin.riso-app.de/
 API: https://api.riso-app.de/
 Dev:
 Admin: https://dev-admin.riso-app.de/
 API: https://dev-api.riso-app.de/
 
 OLD API
 //https://riso-prod.viableapi.com
 
 */


/*
 konstantin@skiy31.de
 caCva3-sacnud-vydgup
 */
