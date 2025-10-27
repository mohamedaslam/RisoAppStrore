//
//  JSONLogger.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 02/05/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation

class JSONLogger {
    class func prettyPrint(_ json: [AnyHashable : Any]?) {
        guard let json = json else {
            print("Invalid JSON. Aborting")
            return
        }
        
        guard JSONSerialization.isValidJSONObject(json) else {
            print("Invalid JSON. Aborting")
            return
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let jsonText = String.init(data: jsonData, encoding: .ascii)
            if let dictionaryFromJson = jsonText {
                print(dictionaryFromJson)
            }
        } catch let error {
            print("Got JSON error: \(error.localizedDescription)")
        }
    }
}


