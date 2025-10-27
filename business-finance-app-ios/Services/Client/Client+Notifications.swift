//
//  Client+Notifications.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 10/05/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Gloss

extension Client {
    func getUnreadNotifications(completion: @escaping ([PushNotification]) -> Void) {
        let request = Request.getUnreadNotifications().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { (response) in
            
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            let dataContainer = json["data"] as? [JSON]
            completion(dataContainer?.compactMap({ PushNotification(userInfo: $0)}) ?? [])
        }
    }
    
    func readNotifications(for actions: PushNotification.Action..., completion: @escaping () -> Void) {
        let notifications = self.unreadNotifications(for: actions)
        self.read(notifications: notifications) {
            completion()
        }
    }
    
    func read(notifications: [PushNotification], completion: @escaping () -> Void) {
        let request = Request.read(notificationIds: notifications.map { $0.id })
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { (response) in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let _ = parsedResponse.0 else {
                completion()
                return
            }
            
            completion()
        }
    }
}
