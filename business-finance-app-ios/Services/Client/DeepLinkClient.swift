//
//  DeepLinkClient.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 07/05/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

struct PushNotification {
    typealias Payload = [AnyHashable : Any]
    
    enum Action: String {
        case expenseTrackingReminder  = "invoice_submit_reminder"
        case invoiceStatusChange      = "document_status_change"
        case invoiceGroupStatusChange = "document_group_status_change"
    }
    
    let id: Int
    let action: PushNotification.Action
    let message: String
    let rawData: Payload?
    
    init?(userInfo: Payload) {
        JSONLogger.prettyPrint(userInfo)
        
        if
            let id           = userInfo["notification_id"] as? Int,
            let actionString = userInfo["action"] as? String,
            let action       = PushNotification.Action(rawValue: actionString) {
            self.id      = id
            self.action  = action
            self.rawData = userInfo["data"] as? Payload
        } else if
            let id           = userInfo["id"] as? Int,
            let actionString = userInfo["type"] as? String,
            let action       = PushNotification.Action(rawValue: actionString) {
            self.id      = id
            self.action  = action
            self.rawData = userInfo
        } else {
            return nil
        }
        
        self.message = (userInfo["data"] as? Payload)?["alert"] as? String ?? ""
        
    }
}

class DeepLinkClient {
    struct Scheme {
        let production = "riso"
    }
    
    func handle(_ notification: PushNotification, for application: UIApplication, isAppStart: Bool) {
        guard let tabBarController = application.keyWindow?.rootViewController as? AppTabBarController else {
            return
        }
        
        switch notification.action {
        case .invoiceStatusChange:
            //tabBarController.select(tab: .invoices, goToRoot: true)
            if let invoicesContainer = (tabBarController.selectedViewController as? BaseNavigationController)?.viewControllers.first as? InvoicesContainerViewController {
                invoicesContainer.didSelect((month: Date.currentMonth, Date.currentYear))
            }
            break
        case .invoiceGroupStatusChange:
           // tabBarController.select(tab: .invoices, goToRoot: true)
            if let invoicesContainer = (tabBarController.selectedViewController as? BaseNavigationController)?.viewControllers.first as? InvoicesContainerViewController {
                invoicesContainer.didSelect((month: Date.currentMonth, Date.currentYear))
            }
            break
        case .expenseTrackingReminder:
            tabBarController.select(tab: .dashboard, goToRoot: true)
            break
        }
    }
}
/*
 {
      "aps":{
       "alert": {
      "title": "RISO REMINDER",
      "subtitle": "Lunch",
      "body": "Please upload your Lunch bill,Today`s is last day!"
                }
            }
}

 
 {
      "aps":{
       "alert": "invoice_submit_reminder"
            }
}
 */
