//
//  RisoAlertView.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/9/30.
//  Copyright © 2022 Viable Labs. All rights reserved.

import UIKit
import Foundation

class FHAppUtility {
    
    private init(){}
    static var shared = FHAppUtility()
    
    
    func showAlertWithActions (view: UIViewController, title: String, message: String, firstButtonTitle: String, secondButtonTitle: String, alertActionNum: Int, completion:@escaping (_ result:Bool) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if (alertActionNum == 2) {
            
            alert.addAction(UIAlertAction(title: secondButtonTitle, style: .default, handler: { action in
                completion(false)
            }))
            
            alert.addAction(UIAlertAction(title: firstButtonTitle, style: .default, handler: { action in
                completion(true)
            }))
        }
        else {
            alert.addAction(UIAlertAction(title: firstButtonTitle, style: .default, handler: { action in
                completion(true)
            }))
        }
        
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true)
        })
    }
    
}
