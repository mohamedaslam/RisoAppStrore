//
//  AppDelegate.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import UserNotifications
import AlamofireNetworkActivityLogger
import GooglePlaces
import LocalAuthentication
import ANActivityIndicator
import FirebaseCrashlytics
import FirebaseCore

var ApplicationDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private(set) var client: Client!
    private var isFirstOpening: Bool = true
    var isNeedRotation: Bool = false
    var isEnterBackground: Bool = false

    var context = LAContext()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        GMSPlacesClient.provideAPIKey("AIzaSyATxf1AEc3FFa9TKQCwOpgSx-S3jShptP8")
        NetworkActivityLogger.shared.startLogging()
        application.applicationSupportsShakeToEdit = false
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
        let currentVersion : String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

       let versionOfLastRun: String? = UserDefaults.standard.object(forKey: "VersionOfLastRun") as? String

       if versionOfLastRun == nil {
            // First start after installing the app
       } else if  !(versionOfLastRun?.isEqual(currentVersion))! {
             // App is updated
           UserDefaults.standard.removeObject(forKey: "FirstTimeDashboard")


       }
        UserDefaults.standard.set(currentVersion, forKey: "VersionOfLastRun")
        UserDefaults.standard.synchronize()
        ///
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { [weak self] granted, error in
                if granted {
                    self?.getNotificationSettingsAndRegister()
                } else {
                    if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Notification Access", message: "In order to use this application, turn on notification permissions.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                            alert.addAction(alertAction)
                            window.rootViewController!.present(alert , animated: true)
                        }
                    }
                }
            })
        isFirstOpening = true
        let root = WelcomeViewController.instantiate()
        configureWindow(root: root)
        setupNavigationBarAppearance(with: .lightContent)
        setupTabBarAppearance()
        initClient()
        return true
    }
    func applicationWillEnterForeground(_ application: UIApplication) {

    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if topController.isKind(of: AppTabBarController.self) {
                self.isEnterBackground = true
            }
        }
        let app: UIApplication = UIApplication.shared
        var backgroundTask: UIBackgroundTaskIdentifier!
        backgroundTask = app.beginBackgroundTask(expirationHandler: {
            app.endBackgroundTask(backgroundTask)
        })

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        if !isFirstOpening && client.loggedUser != nil {
            NotificationCenter.default.post(name: .willRequireContentUpdate, object: nil)
        }
        isFirstOpening = false
    }
    
    private func getNotificationSettingsAndRegister() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }


    private func initClient() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationStateChanged(_:)),
            name: .didUpdateApplicationState, object: nil
        )
        
        let keychainManager = KeychainManager()
        let restClient = RESTClient()
        self.client = Client(keychainManager: keychainManager, restClient: restClient)

    }
    
    @objc
    private func applicationStateChanged(_ notification: Notification) {
        guard let state = notification.object as? Client.State else { return }
        
        switch state {
        case .needsAuthentication:
            self.handle(flow: .authentication)
        case .ready:
            let isreceviedPushNotification = ITNSUserDefaults.object(forKey: "receviedPushNotification") as? Bool
            if (isreceviedPushNotification == true) {
                ITNSUserDefaults.set(false, forKey: "receviedPushNotification")
            }else{
                self.handle(flow: .mainApp)
            }
        case .showingOnboarding:
            self.handle(flow: .onboarding)
        case .unknown:
            break
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        ITNSUserDefaults.set(true, forKey: "receviedPushNotification")
        let userInfo = response.notification.request.content.userInfo
        let isBiometricsEnrolled = ITNSUserDefaults.object(forKey: "isBiometricsEnrolled") as? Bool

        if ((isBiometricsEnrolled == true) && (!ITNSUserDefaults.bool(forKey: LoginRememberMeClick))) {

            if (self.isEnterBackground == false) {
                let controller = TransparentBGViewController()
                controller.modalPresentationStyle = .overFullScreen
                window?.rootViewController!.present(controller , animated: false)
            }
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access requires authentication") { success, error in
                        DispatchQueue.main.async {
                            if success {
                                switch self.context.biometryType {
                                 case .faceID, .touchID:
                                ITNSUserDefaults.set(true, forKey: "isBiometricsEnrolled")
                                guard let lastAccessedUserName = UserDefaults.standard.object(forKey: "lastAccessedUserName") as? String else { return }
                                    self.loadPasswordFromKeychainAndAuthenticateUser(lastAccessedUserName)
                                      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                          self.getPushNotificationDeeplink(notificationDictionary: userInfo)
                                     }
                                  if (self.isEnterBackground == false) {
                                      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                          self.window?.rootViewController!.dismiss(animated: false)
                                     }
                                }
                                    self.window?.rootViewController!.dismiss(animated: false)
                                 default: break
                                }

                            } else {
                                if let error = error { print(error) }
                            }
                        }
                    }
                }
            }
        }else{
                self.getPushNotificationDeeplink(notificationDictionary: userInfo)
        }

        NotificationCenter.default.post(name: .clickOnNotificaion, object: nil)
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                switch response.actionIdentifier {
                case "accept":
                    print("Handle accept action identifier")
                case "decline":
                    print("Handle decline action identifier")
                default:
                    break
                }
            }


        completionHandler()
    }
    func loadPasswordFromKeychainAndAuthenticateUser(_ user_name: String) {

        guard !user_name.isEmpty else { return }
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: user_name, accessGroup: KeychainConfiguration.accessGroup)
        do {
            let storedPassword = try passwordItem.readPassword()
            ApplicationDelegate.client.login(
                email: user_name,
                password: storedPassword,
                failure: { error in
                }
            )
            
        } catch KeychainPasswordItem.KeychainError.noPassword {
            print("No saved password")
        } catch {
            print("Unhandled error")
        }
    }
}

// MARK: - Notifications

extension AppDelegate {
    private func setupRemotePushNotifications() {

    }
}
class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
