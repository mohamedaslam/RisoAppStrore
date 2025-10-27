//
//  Client.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation
import UIKit.UIDevice
import Gloss
import Kingfisher
import Rollbar
import SwiftDate
import Alamofire
import ANActivityIndicator

typealias VoidBlock = () -> Void
typealias BoolBlock = (Bool) -> Void

class Client {
    enum State {
        case needsAuthentication
        case showingOnboarding
        case ready
        case unknown
    }
    
    enum KeychainKey {
        case accessToken
        case isFirstLogin(UserProfile?)
        
        var key: String {
            switch self {
            case .accessToken: return  "accessToken"
            case .isFirstLogin(let profile):
                return "isFirstLogin_\(profile?.id ?? -1)"
            }
        }
    }
    
    struct Constants {
        #if STA
        static let environment = "STA"
        #else
        static let environment = "PRD"
        #endif
        
        struct Rollbar {
            static let token = "2eb3e428232944a793feeb98b093811b"
        }
    }
    
    private let keychainManager: KeychainManager
    let restClient: RESTClient
    let deepLinkClient: DeepLinkClient
    
    private(set) var loggedUser: UserProfile?
    private(set) var products: [Product] = []
    private(set) var currentMonthOverview: MonthlyOverview?
    private(set) var firstDocumentUploadDate: Date?
    private var store: ScanStore = ScanStore()

    var unreadNotificationsCount: Int {
        return unreadNotifications.count
    }
    
    private var unreadNotifications: [PushNotification] = [] {
        didSet {
            UIApplication.shared.applicationIconBadgeNumber = unreadNotificationsCount
        }
    }
    
    var state: State = .unknown {
        didSet {
            NotificationCenter.default.post(name: .didUpdateApplicationState, object: state)
        }
    }
    
    var isFirstLogin: Bool {
        set {
           keychainManager.set(newValue, for: KeychainKey.isFirstLogin(loggedUser).key)
        }
        get {
            return keychainManager.bool(for: KeychainKey.isFirstLogin(loggedUser).key) ?? true
        }
    }
    
    var accessToken: String? {
        set {
            keychainManager.set(newValue, for: KeychainKey.accessToken.key)
        }
        get {
            return keychainManager.string(for: KeychainKey.accessToken.key)

        }
    }
    var accessTokenWithOutKeyChain: String?
    init(keychainManager: KeychainManager = .init(),
         restClient: RESTClient = .init(),
         deepLinkClient: DeepLinkClient = .init()) {
        
        self.keychainManager = keychainManager
        self.restClient      = restClient
        self.deepLinkClient  = deepLinkClient
        
        setupAnalytics()
        
        NotificationCenter.default.addObserver(forName: .willRequireContentUpdate, object: nil, queue: .main) { (notification) in
            let operation = BlockOperation {
                let group = DispatchGroup()
                
                group.enter()
                self.getMonthlyOverviews(month: Date.currentMonth, year: Date.currentYear) {
                    self.currentMonthOverview = $0.first
                    group.leave()
                }
                
                NotificationCenter.default.post(name: .shouldUpdateUnreadNotifications, object: nil, userInfo: nil)

                group.notify(queue: DispatchQueue.main) {
                    NotificationCenter.default.post(name: .didUpdateUnreadNotifications, object: self.unreadNotifications)
                    // Do some app refresh here
                }
            }
            operation.start()
        }
        
        NotificationCenter
            .default
            .addObserver(
                forName: .shouldUpdateUnreadNotifications,
                object: nil, queue: nil
            ) { [weak self] (notification) in
                guard let `self` = self else { return }
                
                let operation = BlockOperation {
                    let group = DispatchGroup()

//                    group.enter()
//                    self.getUnreadNotifications { (notifications) in
//                        self.unreadNotifications = notifications
//                        group.leave()
//                    }
                    
                    group.notify(queue: DispatchQueue.main) {
                        NotificationCenter.default.post(name: .didUpdateUnreadNotifications, object: self.unreadNotifications)
                        // Do some app refresh here
                    }
                }
                operation.start()
        }
        
        if ITNSUserDefaults.value(forKey: "FirstTimeAppInstall") == nil {
            ITNSUserDefaults.set(false, forKey: "FirstTimeAppInstall")
            self.clearKeychain()
        }
        if accessToken == nil {
            self.set(state: .needsAuthentication)
        } else {
            bootstrapApp()
        }
    }
    
    private func setupAnalytics() {
        let config: RollbarConfiguration = RollbarConfiguration()
        config.environment = Constants.environment
        Rollbar.initWithAccessToken(Constants.Rollbar.token, configuration: config)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func signOut(completion: VoidBlock? = nil) {
        ITNSUserDefaults.set(false, forKey: isLogout)

        if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
            let request = Request.signOut(deviceID: deviceID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
            restClient.request(request) { response in
                self.clearData(resetKeychain: false)
                ITNSUserDefaults.set(true, forKey: "isLogoutFromApp")
                self.set(state: .showingOnboarding)
            }
        } else {
            self.clearData(resetKeychain: false)
            self.set(state: .showingOnboarding)
            ITNSUserDefaults.set(true, forKey: "isLogoutFromApp")
        }

    }
    
    func register(deviceToken: String, completion: BoolBlock? = nil) {
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else {
            completion?(false)
            return
        }
        
        let request = Request.register(deviceID: deviceID, pushToken: deviceToken)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { (response) in
            let _: JSONParsedResponse = ResponseParser.parse(response)
            completion?(true)
        }
    }
    
    func registerPushNotification(deviceName: String,deviceModel: String, deviceToken: String, completion: BoolBlock? = nil) {
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else {
            completion?(false)
            return
        }

        let request = Request.registerPushNotification(deviceName: deviceName, deviceModel: deviceModel, deviceID: deviceID, pushToken: deviceToken)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { (response) in
            let _: JSONParsedResponse = ResponseParser.parse(response)

            completion?(true)
        }
    }
    
    func login(email: String, password: String, failure: @escaping (Error) -> Void) {
        let request = Request.login(email: email, password: password)
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                failure(parsedResponse.1 ?? APIError(error: "json_parsing_failure", message: "error.default".localized))
                return
            }
            
            guard let authResponse = AuthResponse(json: json) else {
                failure(parsedResponse.1 ?? APIError(error: "invalid_auth_response", message: "error.default".localized))
                return
            }
            self.saveAccountDetailsToKeychain(userName: email, password: password)

                    if(!ITNSUserDefaults.bool(forKey: LoginRememberMeClick)){
                        self.accessTokenWithOutKeyChain = authResponse.accessToken
                        self.accessToken = nil
                    }else{
                        self.accessToken = authResponse.accessToken
                        self.accessTokenWithOutKeyChain = nil
                    }
            ITNSUserDefaults.set(true, forKey: isLogout)

           // self.bootstrapApp()

            NotificationCenter.default.post(name: .loginSucessNotificaion, object: nil, userInfo: nil)
        }
    }
    
    private func saveAccountDetailsToKeychain(userName: String, password: String) {
        guard !userName.isEmpty, !password.isEmpty else { return }
        UserDefaults.standard.set(userName, forKey: "lastAccessedUserName")
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: userName, accessGroup: KeychainConfiguration.accessGroup)
        do {
            try passwordItem.savePassword(password)
        } catch {
            print("Error saving password")
        }
    }
    


    func createReminderNew(title: String, description: String, time: String, frequency: String, weekDays : [[String: Any]],completion: @escaping (String?) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let parameters: [String : Any] = [
            "title" : title,
            "description" : description,
            "reminder_time" : time,
            "frequency" : frequency,
            "items": weekDays
          ]
     //   let url = "https://riso-prod.viableapi.com/api/v1/reminder"
        let url = "https://dev-api.riso-app.de/api/v1/reminder"
     //   let url = "https://qa-api.riso-app.de/api/v1/reminder"

         var headers: HTTPHeaders {
                get {
                    return [
                        "Authorization" : "Bearer \(self.accessToken ?? self.accessTokenWithOutKeyChain ?? "")"
                    ]
                }
            }
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
                    response in
                    switch (response.result) {
                    case .success:
                        let _: JSONParsedResponse = ResponseParser.parse(response)
                        ANActivityIndicatorPresenter.shared.hideIndicator()
                        let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
                        guard let json = parsedResponse.0 else {
                            if let error = parsedResponse.1 {
                                UIApplication.shared.show(error: error.localizedDescription)
                            }
                            return
                        }
                        let message = json["message"] as? String
                        completion(message)

 
                        break
                    case .failure:
                        print(Error.self)
                        ANActivityIndicatorPresenter.shared.hideIndicator()

                    }
                }
    }
    func editReminderNew(title: String, description: String, time: String, frequency: String, weekDays : [[String: Any]],reminderID : String, completion: @escaping (String?) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()
        let parameters: [String : Any] = [
            "title" : title,
            "description" : description,
            "reminder_time" : time,
            "frequency" : frequency,
            "items": weekDays
          ]
        let url = "https://dev-api.riso-app.de/api/v1/reminder/\(reminderID)"
      // let url = "https://qa-api.riso-app.de/api/v1/reminder/\(reminderID)"
      //  let url = "https://riso-prod.viableapi.com/api/v1/reminder/\(reminderID)"
    
         var headers: HTTPHeaders {
                get {
                    return [
                        "Authorization" : "Bearer \(self.accessToken ?? self.accessTokenWithOutKeyChain ?? "")"
                    ]
                }
            }
        Alamofire.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
                    response in
                    switch (response.result) {
                    case .success:
                        let _: JSONParsedResponse = ResponseParser.parse(response)
                        ANActivityIndicatorPresenter.shared.hideIndicator()
                        let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
                        guard let json = parsedResponse.0 else {
                            if let error = parsedResponse.1 {
                                UIApplication.shared.show(error: error.localizedDescription)
                            }
                            return
                        }
                        let message = json["message"] as? String
                        completion(message)
                        break
                    case .failure:
                        print(Error.self)
                        ANActivityIndicatorPresenter.shared.hideIndicator()
                    }
                }
    }
       
    func getProfile(completion: @escaping (UserProfile?) -> Void) {
        let request = Request.getUserProfile().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    if(error.localizedDescription.contains("Dein Riso-Konto wurde inaktiv gesetzt")){
                        UIApplication.shared.show(error: "error.account_inactive".localized)
                    }
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion(nil)
                return
            }
            
            guard let profile: UserProfile = "data" <~~	json else {
                completion(nil)
                return
            }

            completion(profile)
        }
    }
    
    func resetPassword(email: String, completion: @escaping (String?) -> Void) {
        let request = Request.resetPassword(email: email)
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(nil)
                return
            }
            let message = json["message"] as? String
            completion(message)
        }
    }
    
    func getMonthlyOverviews(month: Int?, year: Int?, completion: @escaping ([MonthlyOverview]) -> Void) {
        let request = Request.getMonthlyOverviews(month: month, year: year)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            

            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            
            completion("data" <~~ json ?? [])
        }
    }
    
    func getMonthlyYearlyOverviews(month: Int?, year: Int?,completion: @escaping (MonthlyYearlyOverview?) -> Void) {
        let request = Request.getMonthlyYearlyOverviews(month: month, year: year)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    if(error.localizedDescription.contains("Dein Riso-Konto wurde inaktiv gesetzt")){
                        UIApplication.shared.show(error: "error.account_inactive".localized)
                    }
                    //UIApplication.shared.show(error: error.localizedDescription)
                    ANActivityIndicatorPresenter.shared.hideIndicator()
                }
                return
            }
            guard let monthlyYearlyOverviewData: MonthlyYearlyOverview = "data" <~~    json else {
                completion(nil)
                return
            }
            completion(monthlyYearlyOverviewData)
        }
    }
    
    func getProducts(completion: @escaping ([Product]) -> Void) {
        let request = Request.getProducts().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            completion("data" <~~ json ?? [])
        }
    }
    
    func getAllProducts(completion: @escaping ([Product]) -> Void) {
        let request = Request.getAllProducts().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            completion("data" <~~ json ?? [])
        }
    }
    func getReminderList(completion: @escaping ([Reminder]) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getReminderList().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            completion("data" <~~ json ?? [])
        }
    }
    
    func getNotificationMessagesList(completion: @escaping ([NotificationModel]) -> Void) {
//        ANActivityIndicatorPresenter.shared.showIndicator()
        let request = Request.getNotificationList().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            completion("data" <~~ json ?? [])
        }
    }
    
    func updateNotificationMsg(Id: Int, completion: @escaping (String?) -> Void) {
        let request = Request.notificaitonRead(notification_Id: Id).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(nil)
                return
            }
            let message = json["message"] as? String
            completion(message)
        }
    }
    
    func getBenefitList(completion: @escaping ([Benefit]) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getBenefitList().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in
            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            completion("data" <~~ json ?? [])
        }
    }
    
    func getUserTravelData(completion: @escaping (UserTravel?) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getUserTravelData().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion(nil)
                return
            }
            guard let userTravelData: UserTravel = "data" <~~    json else {
                completion(nil)
                return
            }
            completion(userTravelData)
        }
    }
    
    
    func getCompanyAddress(completion: @escaping (CompanyAddress?) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getUserCompanyAddress().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion(nil)
                return
            }
            
            guard let getCompanyAddress: CompanyAddress = "data" <~~    json else {
                completion(nil)
                return
            }
            completion(getCompanyAddress)

        }
    }
    
    func getMonthlyTravelStatusAddress(completion: @escaping (MonthlyConfirmationStatus?) -> Void) {
//        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getMonthlyTravelStatusAddress().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

//            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion(nil)
                return
            }
            guard let monthlyConfirmationData: MonthlyConfirmationStatus = "data" <~~    json else {
                completion(nil)
                return
            }
            
            completion(monthlyConfirmationData)
        }
    }
    
    func postMonthlyTravelStatusAddress(completion: @escaping (String?) -> Void) {
//        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.postMonthlyTravelStatusAddress().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

//  ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion(nil)
                return
            }
            
            let message = json["message"] as? String

            completion(message)
        }
    }
    
    
    func postMonthlyKidConfirmation(completion: @escaping (String?) -> Void) {
//        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.postMonthlyKidConfirmation().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

//            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion(nil)
                return
            }
            
            let message = json["message"] as? String

            completion(message)
        }
    }
    
    func deleteReminder(reminderID: String, completion: @escaping (String?) -> Void) {

        let request = Request.deleteReminder(reminderID: reminderID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(nil)
                return
            }
            let message = json["message"] as? String

            completion(message)
        }
    }
    
    func reminderOnOFF(reminderID: String, completion: @escaping (String?) -> Void) {

        let request = Request.reminderOnOFF(reminderID: reminderID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }

            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(nil)
                return
            }
            let message = json["message"] as? String
            completion(message)

        }
    }
    
    func createUserTravel(home_address_line1: String, home_address_line2: String, home_city: String, home_state: String,home_zipcode: String, home_latitude: Float, home_longitude: Float, work_address_line1: String, work_address_line2: String, work_city: String, work_state: String, work_zipcode: String, work_latitude: Float, work_longitude: Float, is_custom_work_address: Int, commuting_distance: Float,commuting_channel: String,days_to_commute_work: Int,product_id: Int,is_approved : Int,no_work_address: Int, completion:  @escaping (String?) -> Void){

//        guard let product = store.product else { return }

        let request = Request.createUserTravel(home_address_line1: home_address_line1, home_address_line2: home_address_line2, home_city: home_city, home_state:home_state, home_zipcode: home_zipcode, home_latitude: home_latitude, home_longitude: home_longitude, work_address_line1: work_address_line1, work_address_line2: work_address_line2, work_city: work_city, work_state: work_state, work_zipcode:work_zipcode, work_latitude: work_latitude, work_longitude: work_longitude, is_custom_work_address: is_custom_work_address, commuting_distance: commuting_distance, commuting_channel: commuting_channel, days_to_commute_work: days_to_commute_work, product: product_id ,is_approved:is_approved,no_work_address: no_work_address)

            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { (response) in
            let _: JSONParsedResponse = ResponseParser.parse(response)

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            let message = json["message"] as? String

            completion(message)
        }
    }
    
    func createKidKinderkarten(name: String, gender: String,dob: String, kinder_garden_name: String, kinder_garden_address: String, not_compulsory_school_age: Bool, spouse_not_getting_benefit: Bool,completion:  @escaping (String?) -> Void){

//        guard let product = store.product else { return }

        let request = Request.createKidKindergarten(name: name, gender: gender, dob: dob, kinder_garden_name: kinder_garden_name, kinder_garden_address: kinder_garden_address, not_compulsory_school_age: not_compulsory_school_age, spouse_not_getting_benefit: spouse_not_getting_benefit)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { (response) in
            let _: JSONParsedResponse = ResponseParser.parse(response)
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            let message = json["message"] as? String

            completion(message)
        }
    }
    //editKidKindergarten
    func editKidKindergarten(id : Int,user_id : Int,name: String, gender: String,dob: String, age : Int,kinder_garden_name: String, kinder_garden_address: String,is_applicable : Bool, not_compulsory_school_age: Bool, spouse_not_getting_benefit: Bool,created_at: String, updated_at: String, deleted_at: String, completion:  @escaping (String?) -> Void){

//        guard let product = store.product else { return }

        let request = Request.editKidKindergarten(id: id, user_id: user_id, name: name, gender: gender, dob: dob, age: age, kinder_garden_name: kinder_garden_name, kinder_garden_address: kinder_garden_address, is_applicable: is_applicable, not_compulsory_school_age: not_compulsory_school_age, spouse_not_getting_benefit: spouse_not_getting_benefit, created_at: created_at, updated_at: updated_at, deleted_at: deleted_at)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { (response) in
            let _: JSONParsedResponse = ResponseParser.parse(response)

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            let message = json["message"] as? String
            completion(message)
        }
    }
    func getListOfKindergartenKids(completion: @escaping ([KindergartenKid]) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getListOfKindergartenKids().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            completion("data" <~~ json ?? [])
        }
    }
    
    func deleteKid(userID: Int, completion: @escaping (String?) -> Void) {

        let request = Request.deleteKid(kid_UserID: userID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(nil)
                return
            }
            let message = json["message"] as? String

            completion(message)
        }
    }
    
    func deleteVoucher(voucherID: Int, completion: @escaping (String?) -> Void) {

        let request = Request.deleteVoucher(voucherID: voucherID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(nil)
                return
            }
            let message = json["message"] as? String

            completion(message)
        }
        
    }
    
    func saveDefaultVoucher(userProductID: Int,voucherID: Int, completion: @escaping (String?) -> Void) {

        let request = Request.saveDefaultVoucher(userProductID: userProductID, voucherID: voucherID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)

            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(nil)
                return
            }
            let message = json["message"] as? String

            completion(message)
        }
    }
    
    func shopVoucher(userProductID: Int,voucherID: Int, completion: @escaping (String?,JSON?) -> Void) {

        let request = Request.shopVoucher(userProductID: userProductID, voucherID: voucherID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(nil, nil)
                return
            }
            let message = json["message"] as? String
            let getData = json["data"] as? JSON
            
            completion(message,getData)
        }
        
    }
    
    func redeemVoucher(voucherID: Int, completion: @escaping (String?) -> Void) {

        let request = Request.redeemVoucher(voucherID: voucherID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(nil)
                return
            }
            let message = json["message"] as? String

            completion(message)
        }
        
    }
    
    func getVendorsList(userProductID: Int,voucherID: Int,completion: @escaping ([Vendor]) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getVendorsList(userProductID: userProductID, voucherID: voucherID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            completion("data" <~~ json ?? [])
        }
    }
    
    func getVendorsData(userProductID: Int,voucherID: Int,completion: @escaping ([VendorsList]) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getVendorsList(userProductID: userProductID, voucherID: voucherID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            completion("data" <~~ json ?? [])
        }
    }
    
    func getVouchersList(completion: @escaping ([Vouchers]) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getVouchersList().inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            completion("data" <~~ json ?? [])
        }
    }
    
    func getUserVouchersList(productID: Int,getMonth: Int,getYear: Int,completion: @escaping ([UserVoucher]) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getUserVouchersList(productID: productID,getMonth: getMonth, getYear : getYear).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            completion("data" <~~ json ?? [])
        }
    }
    
    
    func skipTutorial() {
        guard accessToken != nil else {
            set(state: .needsAuthentication)
            return
        }
        
        set(state: .ready)
    }
    
    private func set(state: State) {
        guard state != self.state else { return }
        self.state = state
    }
    
    func bootstrapApp() {
        let operation = BlockOperation {
            let group = DispatchGroup()
            
            group.enter()
            self.getProducts { (products) in
                self.products = products
                let prefetcher = ImagePrefetcher(
                    resources: products.compactMap({ $0.imageURL }),
                    options: nil) { (_, _ ,_) in
                        group.leave()
                        print("Cached images")
                }
                
                prefetcher.start()
                print("Got products")
            }
            
            group.enter()
            self.getProfile { (user) in
                self.loggedUser = user
                group.leave()
                print("Got Profile")
            }
            
            group.enter()
            self.getMonthlyOverviews(month: Date.currentMonth, year: Date.currentYear) {
                self.currentMonthOverview = $0.first
                group.leave()
                print("Got Current Overview")
            }
            
            
//            group.enter()
//            self.getUnreadNotifications { (notifications) in
//                self.unreadNotifications = notifications
//                group.leave()
//            }
            
            group.enter()
            self.getFirstDocumentUploadDate { date in
                self.firstDocumentUploadDate = date
                group.leave()
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                print("Finished")
                NotificationCenter.default.post(name: .didUpdateUnreadNotifications, object: self.unreadNotifications)
                self.set(state: .ready)
            })
        }
        
        operation.start()
    }
    
    func unreadNotificationsCount(for types: PushNotification.Action...) -> Int {
        return types.reduce(0) { (sum, notification) in
            sum + unreadNotifications.filter({ $0.action == notification }).count
        }
    }
    
    func loadDisclaimerTexts(for product: Product, completion: @escaping (DataState<[DisclaimerText]>) -> Void) {
        let request = Request.getDisclaimerTexts(for: product)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            
            if let error = parsedResponse.1 {
                completion(.error(error))
                return
            }
            
            guard
                let json = parsedResponse.0,
                let texts: [DisclaimerText] = "data" <~~ json,
                texts.isNotEmpty else {
                completion(.noData)
                return
            }
            
            completion(.data(texts))
        }
    }
    
    func getVoucherProduct(vouchersProductID:Int ,completion: @escaping (VoucherProduct?) -> Void) {
//        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getVouchersProduct(vouchersProductID: vouchersProductID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

//            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion(nil)
                return
            }
            guard let voucherProductData: VoucherProduct = "data" <~~    json else {
                completion(nil)
                return
            }
            
            completion(voucherProductData)
        }
    }
    
    func getDefaultVoucher(vouchersProductID:Int ,completion: @escaping ([Vouchers]) -> Void) {
//        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getDefaultVouchers(vouchersProductID: vouchersProductID).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            completion("data" <~~ json ?? [])
        }
    }
    
    func yearVoucherDetail(id: Int,year: Int, completion: @escaping (VoucherYearDetail?) -> Void) {

        let request = Request.yearVoucherDetail(id:id,Year: year).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                   // UIApplication.shared.show(error: error.localizedDescription)
                }
                completion(nil)
                return
            }
            guard let voucherProductData: VoucherYearDetail = "data" <~~    json else {
                completion(nil)
                return
            }
            completion(voucherProductData)
        }
        
    }
    
    func getFilterVoucherProduct(vendor_id : String,price_sort : String,min_price: Int, max_price: Int, completion: @escaping ([Vouchers]) -> Void) {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let request = Request.getFilterVouchersProduct(vendor_id : vendor_id,price_sort : price_sort,min_price: min_price, max_price: max_price).inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        restClient.request(request) { response in

            ANActivityIndicatorPresenter.shared.hideIndicator()

            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            guard let json = parsedResponse.0 else {
                if let error = parsedResponse.1 {
                    //UIApplication.shared.show(error: error.localizedDescription)
                }
                return
            }
            guard let json = parsedResponse.0 else {
                completion([])
                return
            }
            
            completion("data" <~~ json ?? [])
        }
    }
    
    
    func loadDisclaimerTextsForKindergartenTexts(productID : Int, completion: @escaping (DataState<[DisclaimerText]>) -> Void) {
        let request = Request.getDisclaimerTextsForKindergarten(prductID: productID)
            .inject(accessToken: accessToken ?? accessTokenWithOutKeyChain)
        
        restClient.request(request) { response in
            let parsedResponse: JSONParsedResponse = ResponseParser.parse(response)
            
            if let error = parsedResponse.1 {
                completion(.error(error))
                return
            }
            
            guard
                let json = parsedResponse.0,
                let texts: [DisclaimerText] = "data" <~~ json,
                texts.isNotEmpty else {
                completion(.noData)
                return
            }
            
            completion(.data(texts))
        }
    }
    
    internal func unreadNotifications(for types: [PushNotification.Action]) -> [PushNotification] {
        return types.reduce([PushNotification]()) { (aux, type) in
            var temp = aux
            temp.append(contentsOf: unreadNotifications.filter({ $0.action == type }))
            return temp
        }
    }
    
    private func clearData(resetKeychain: Bool) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        loggedUser              = nil
        accessToken             = nil
        currentMonthOverview    = nil
        unreadNotifications     = []
        firstDocumentUploadDate = nil
        
        if resetKeychain {
            keychainManager.reset()
        }
    }
    
    func clearKeychain() {
        clearData(resetKeychain: true)
        set(state: .needsAuthentication)
    }
}

extension Notification.Name {
    static let didUpdateApplicationState = Notification.Name(
        rawValue: "Notification.Name.didUpdateApplicationState"
    )
}

//let dummyDashboard: JSON = [
//    "data": [
//        [
//            "total_amount": 1590,
//            "remaining_amount": 1579,
//            "approved_invoices_count": 1,
//            "product_overview": [
//                [
//                    "total_amount": 650,
//                    "remaining_amount": 639,
//                    "approved_invoices_count": 1,
//                    "product": [
//                        "id": 2,
//                        "name": "Internet",
//                        "description": "",
//                        "is_active": 1,
//                        "colour": "#2AC566",
//                        "multi_pages": 1,
//                        "created_at": "2018-04-24 04:54:13",
//                        "updated_at": "2018-05-25 12:14:11",
//                        "max_amount_day": 50,
//                        "max_amount_month": 50,
//                        "user_product": [
//                            "user_id": 2,
//                            "product_id": 2,
//                            "max_amount_day": 15,
//                            "max_amount_month": 650,
//                            "is_assigned": 1,
//                            "id": 5
//                        ],
//                        "image_path": "https://business-finance-app-staging.ams3.digitaloceanspaces.com/uploads/public/5ae/6d1/829/5ae6d182947fe849485275.png"
//                    ]
//                ],
//                [
//                    "total_amount": 850,
//                    "remaining_amount": 850,
//                    "approved_invoices_count": 0,
//                    "product": [
//                        "id": 3,
//                        "name": "Goods",
//                        "description": "",
//                        "is_active": 1,
//                        "colour": "#F83889",
//                        "multi_pages": 0,
//                        "created_at": "2018-04-24 04:54:13",
//                        "updated_at": "2018-05-25 12:14:34",
//                        "max_amount_day": 44,
//                        "max_amount_month": 44,
//                        "user_product": [
//                            "user_id": 2,
//                            "product_id": 3,
//                            "max_amount_day": 18,
//                            "max_amount_month": 850,
//                            "is_assigned": 1,
//                            "id": 6
//                        ],
//                        "image_path": "https://business-finance-app-staging.ams3.digitaloceanspaces.com/uploads/public/5ae/6d1/b03/5ae6d1b03e528640966919.png"
//                    ]
//                ],
//                [
//                    "total_amount": 90,
//                    "remaining_amount": 90,
//                    "approved_invoices_count": 0,
//                    "product": [
//                        "id": 1,
//                        "name": "Lunch",
//                        "description": "",
//                        "is_active": 1,
//                        "colour": "#FFB106",
//                        "multi_pages": 0,
//                        "created_at": "2018-04-24 04:54:13",
//                        "updated_at": "2018-05-25 12:13:41",
//                        "max_amount_day": 6,
//                        "max_amount_month": 94,
//                        "user_product": [
//                            "user_id": 2,
//                            "product_id": 1,
//                            "max_amount_day": 6,
//                            "max_amount_month": 90,
//                            "is_assigned": 1,
//                            "id": 12
//                        ],
//                        "image_path": "https://business-finance-app-staging.ams3.digitaloceanspaces.com/uploads/public/5ae/6d1/d15/5ae6d1d158d04389899120.png"
//                    ]
//                ]
//            ],
//            "month": "04",
//            "year": "2018"
//        ],
//        [
//            "total_amount": 1590,
//            "remaining_amount": 1495.64,
//            "approved_invoices_count": 11,
//            "product_overview": [
//                [
//                    "total_amount": 650,
//                    "remaining_amount": 645,
//                    "approved_invoices_count": 1,
//                    "product": [
//                        "id": 2,
//                        "name": "Internet",
//                        "description": "",
//                        "is_active": 1,
//                        "colour": "#2AC566",
//                        "multi_pages": 1,
//                        "created_at": "2018-04-24 04:54:13",
//                        "updated_at": "2018-05-25 12:14:11",
//                        "max_amount_day": 50,
//                        "max_amount_month": 50,
//                        "user_product": [
//                            "user_id": 2,
//                            "product_id": 2,
//                            "max_amount_day": 15,
//                            "max_amount_month": 650,
//                            "is_assigned": 1,
//                            "id": 5
//                        ],
//                        "image_path": "https://business-finance-app-staging.ams3.digitaloceanspaces.com/uploads/public/5ae/6d1/829/5ae6d182947fe849485275.png"
//                    ]
//                ],
//                [
//                    "total_amount": 850,
//                    "remaining_amount": 787.47,
//                    "approved_invoices_count": 4,
//                    "product": [
//                        "id": 3,
//                        "name": "Goods",
//                        "description": "",
//                        "is_active": 1,
//                        "colour": "#F83889",
//                        "multi_pages": 0,
//                        "created_at": "2018-04-24 04:54:13",
//                        "updated_at": "2018-05-25 12:14:34",
//                        "max_amount_day": 44,
//                        "max_amount_month": 44,
//                        "user_product": [
//                            "user_id": 2,
//                            "product_id": 3,
//                            "max_amount_day": 18,
//                            "max_amount_month": 850,
//                            "is_assigned": 1,
//                            "id": 6
//                        ],
//                        "image_path": "https://business-finance-app-staging.ams3.digitaloceanspaces.com/uploads/public/5ae/6d1/b03/5ae6d1b03e528640966919.png"
//                    ]
//                ],
//                [
//                    "total_amount": 90,
//                    "remaining_amount": 63.17,
//                    "approved_invoices_count": 6,
//                    "product": [
//                        "id": 1,
//                        "name": "Lunch",
//                        "description": "",
//                        "is_active": 1,
//                        "colour": "#FFB106",
//                        "multi_pages": 0,
//                        "created_at": "2018-04-24 04:54:13",
//                        "updated_at": "2018-05-25 12:13:41",
//                        "max_amount_day": 6,
//                        "max_amount_month": 94,
//                        "user_product": [
//                            "user_id": 2,
//                            "product_id": 1,
//                            "max_amount_day": 6,
//                            "max_amount_month": 90,
//                            "is_assigned": 1,
//                            "id": 12
//                        ],
//                        "image_path": "https://business-finance-app-staging.ams3.digitaloceanspaces.com/uploads/public/5ae/6d1/d15/5ae6d1d158d04389899120.png"
//                    ]
//                ]
//            ],
//            "month": "05",
//            "year": "2018"
//        ],
//        [
//            "total_amount": 1590,
//            "remaining_amount": 552.14,
//            "approved_invoices_count": 12,
//            "product_overview": [
//                [
//                    "total_amount": 650,
//                    "remaining_amount": 212,
//                    "approved_invoices_count": 4,
//                    "product": [
//                        "id": 2,
//                        "name": "Internet",
//                        "description": "",
//                        "is_active": 1,
//                        "colour": "#2AC566",
//                        "multi_pages": 1,
//                        "created_at": "2018-04-24 04:54:13",
//                        "updated_at": "2018-05-25 12:14:11",
//                        "max_amount_day": 50,
//                        "max_amount_month": 50,
//                        "user_product": [
//                            "user_id": 2,
//                            "product_id": 2,
//                            "max_amount_day": 15,
//                            "max_amount_month": 650,
//                            "is_assigned": 1,
//                            "id": 5
//                        ],
//                        "image_path": "https://business-finance-app-staging.ams3.digitaloceanspaces.com/uploads/public/5ae/6d1/829/5ae6d182947fe849485275.png"
//                    ]
//                ],
//                [
//                    "total_amount": 850,
//                    "remaining_amount": 700,
//                    "approved_invoices_count": 1,
//                    "product": [
//                        "id": 3,
//                        "name": "Goods",
//                        "description": "",
//                        "is_active": 1,
//                        "colour": "#F83889",
//                        "multi_pages": 0,
//                        "created_at": "2018-04-24 04:54:13",
//                        "updated_at": "2018-05-25 12:14:34",
//                        "max_amount_day": 44,
//                        "max_amount_month": 44,
//                        "user_product": [
//                            "user_id": 2,
//                            "product_id": 3,
//                            "max_amount_day": 18,
//                            "max_amount_month": 850,
//                            "is_assigned": 1,
//                            "id": 6
//                        ],
//                        "image_path": "https://business-finance-app-staging.ams3.digitaloceanspaces.com/uploads/public/5ae/6d1/b03/5ae6d1b03e528640966919.png"
//                    ]
//                ],
//                [
//                    "total_amount": 90,
//                    "remaining_amount": 10,
//                    "approved_invoices_count": 7,
//                    "product": [
//                        "id": 1,
//                        "name": "Lunch",
//                        "description": "",
//                        "is_active": 1,
//                        "colour": "#FFB106",
//                        "multi_pages": 0,
//                        "created_at": "2018-04-24 04:54:13",
//                        "updated_at": "2018-05-25 12:13:41",
//                        "max_amount_day": 6,
//                        "max_amount_month": 94,
//                        "user_product": [
//                            "user_id": 2,
//                            "product_id": 1,
//                            "max_amount_day": 6,
//                            "max_amount_month": 90,
//                            "is_assigned": 1,
//                            "id": 12
//                        ],
//                        "image_path": "https://business-finance-app-staging.ams3.digitaloceanspaces.com/uploads/public/5ae/6d1/d15/5ae6d1d158d04389899120.png"
//                    ]
//                ]
//            ],
//            "month": "06",
//            "year": "2018"
//        ]
//    ],
//    "message": "Dashboard data retrieved successfully!"
//]
