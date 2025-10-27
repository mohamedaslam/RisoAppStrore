//
//  AppDelegate+DeepLinking.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 07/05/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
 
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
        NotificationCenter.default.post(name: .updateBadgeCountNotificaion, object: nil)


      completionHandler(UIBackgroundFetchResult.newData)
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        client.register(deviceToken: token) {
            print($0 ? "Registered" : "Failed to register")
        }
        client.registerPushNotification(deviceName:"iPhone", deviceModel: "iPhone12", deviceToken: token){
            print($0 ? "Registered" : "Failed to register")

        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo
        let defaults = UserDefaults(suiteName: "group.com.riso.ios-app")
        NotificationCenter.default.post(name: .updateBadgeCountNotificaion, object: nil)
        completionHandler([.alert, .badge, .sound])
 
    }
    
    private func show(root: UIViewController,
                      duration: TimeInterval = 0.5,
                      completion: (() -> Void)? = nil) {
        guard let window = self.window else { return }
        UIView.transition(
            with: window,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = root
            },
            completion: { _ in completion? () }
        )
    }
    func getPushNotificationDeeplink(notificationDictionary: [AnyHashable:Any]) {
        NotificationCenter.default.post(name: .updateBadgeCountNotificaion, object: nil)

        guard let aps = notificationDictionary["aps"] as? [String: Any] ,
                let module = aps["module"] as? String  else  {
            return
        }
        let notificaitonID = aps["notification_id"] as? String
        var badgeCountValue = aps["product_id"] as? String
        ITNSUserDefaults.set(notificaitonID, forKey: "notification_id")
        ITNSUserDefaults.set(notificaitonID, forKey: "badge_count")
        let getNotificationIDValue = Int(notificaitonID ?? "")!


        let isBiometricsEnrolled = ITNSUserDefaults.object(forKey: "isBiometricsEnrolled") as? Bool
        if(module == "Kindergarten"){
            self.handle(flow: .mainApp)
        }
        if(module == "UserTravel"){
           self.handle(flow: .mainApp)
        }
        if(module == "default" || module == "self" || module == "default / self" || module == "default/self"){
           self.handle(flow: .mainApp)
            ITNSUserDefaults.set(true, forKey: "receviedReminderPushNotification")
        }
        if(module == "travel"){
            guard let aps = notificationDictionary["aps"] as? [String: Any] ,
                  let product_id = aps["product_id"] as? String  else  {
                return
            }
            let is_user_travel_set = aps["is_user_travel_set"] as? String
            ITNSUserDefaults.set(is_user_travel_set, forKey: "is_user_travel_set")
            ITNSUserDefaults.set(true, forKey: "isTravelNotification")
            ITNSUserDefaults.set(product_id, forKey: "UserTravel_product_id")
            if(ITNSUserDefaults.bool(forKey: isLogout)){
                if(isBiometricsEnrolled == false || isBiometricsEnrolled == nil || isBiometricsEnrolled == true ){
                    self.handle(flow: .mainApp)
                    ITNSUserDefaults.set(true, forKey: "receviedPushNotification")
                    }
            }else{
                ITNSUserDefaults.set(true, forKey: "receviedPushNotification")

            }
        }

        if(module == "kinder"){
            ITNSUserDefaults.set(true, forKey: "isKinderNotification")
            let is_user_kinder_set = aps["is_user_kinder_set"] as? String
            ITNSUserDefaults.set(is_user_kinder_set, forKey: "is_user_kinder_set")

            if(ITNSUserDefaults.bool(forKey: isLogout)){
                if(isBiometricsEnrolled == false || isBiometricsEnrolled == nil || isBiometricsEnrolled == true){
                    self.handle(flow: .mainApp)
                    ITNSUserDefaults.set(true, forKey: "receviedPushNotification")
            }
            }else{
                ITNSUserDefaults.set(true, forKey: "receviedPushNotification")
            }
        }
        if(self.client.accessToken == nil && self.client.accessTokenWithOutKeyChain == nil){
            self.handle(flow: .authentication)
        }
        ApplicationDelegate.client.updateNotificationMsg(Id:getNotificationIDValue) { [self] message in
        }
    }
}



