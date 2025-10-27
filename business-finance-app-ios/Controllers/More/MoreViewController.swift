//
//  MoreViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import SafariServices
import LocalAuthentication

class MoreViewController: BaseViewController {
    struct Constants {
        static let imprintURL = App.environment.apiURL + "/urls/imprint"
        static let privacyURL = App.environment.apiURL + "/urls/privacy"
        static let legalURL   = App.environment.apiURL + "/urls/legals"
    }
    
    enum Section: Equatable {
        case profile(UserProfile)
        case imprint
        case privacy
        case legal
        case tutorial
        case clearKeychain
        case appSecurity
        case reminders
        case signOut
        case footer
        
        var description: String {
            switch self {
            case .profile       : return "profile"
            case .imprint       : return "imprint"
            case .privacy       : return "privacy"
            case .legal         : return "legal"
            case .tutorial      : return "tutorial"
            case .clearKeychain : return "clearKeychain"
            case .appSecurity   : return "appSecurity"
            case .reminders     : return "reminders"
            case .signOut       : return "signOut"
            case .footer        : return "footer"
            }
        }
        
        var localizedText: String {
            return "more.\(self.description)".localized
        }
    }
    
    static func instantiate() -> MoreViewController {
        let storyboard = UIStoryboard(storyboard: .more)
        let vc: MoreViewController = storyboard.instantiateViewController()
        return vc
    }
    
    private var sections: [[Section]] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            guard let tableView = tableView else { return }
            tableView.separatorStyle       = .none
            tableView.tableHeaderView      = UIView()
            tableView.tableFooterView      = UIView()
            tableView.backgroundColor      = UIColor.Palette.white
            tableView.alwaysBounceVertical = true
        }
    }
    var context = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if STA
        sections = [[.imprint, .privacy, .legal, .tutorial, .clearKeychain, .appSecurity, .reminders, .signOut, .footer]]
        #else
        sections = [[.imprint, .privacy, .legal, .tutorial, .appSecurity, .reminders, .signOut, .footer]]
        #endif
        if let profile = ApplicationDelegate.client.loggedUser {
            sections.insert([.profile(profile)], at: 0)
        }
        
        title = "navigation.title.more".localized
        tableView?.delegate           = self
        tableView?.dataSource         = self
    }
    
    func section(for indexPath: IndexPath) -> Section {
        return sections[indexPath.section][indexPath.row]
    }
}

extension MoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = section(for: indexPath)
        switch sectionType {
        case .profile(let profile):
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            
            cell.textLabel?.textColor       = UIColor.App.Text.dark
            cell.textLabel?.font            = UIFont.appFont(ofSize: 20, weight: .semibold, compact: true)
            cell.textLabel?.text            = profile.name
            
            cell.detailTextLabel?.textColor = UIColor.App.Text.light
            cell.detailTextLabel?.font      = UIFont.appFont(ofSize: 15, weight: .regular)
            cell.detailTextLabel?.text      = profile.email
            
            return cell
        case .imprint, .privacy, .legal, .tutorial, .reminders, .signOut, .clearKeychain:
            let cell                  = UITableViewCell(style: .default, reuseIdentifier: nil)
            
            cell.textLabel?.textColor = UIColor.App.Text.dark
            cell.textLabel?.font      = UIFont.appFont(ofSize: 15, weight: .regular)
            cell.textLabel?.text      = sectionType.localizedText
            
            return cell
        case .appSecurity :
            let cell                  = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.textColor = UIColor.App.Text.dark
            cell.textLabel?.font      = UIFont.appFont(ofSize: 15, weight: .regular)
            cell.textLabel?.text      = sectionType.localizedText
            let switchView = UISwitch(frame: .zero)
            
            let isBiometricsEnrolled = ITNSUserDefaults.object(forKey: "isBiometricsEnrolled") as? Bool
            if (isBiometricsEnrolled == true) {
                switchView.setOn(isBiometricsEnrolled!, animated: true)
            }
            else if (isBiometricsEnrolled == false) {
                switchView.setOn(isBiometricsEnrolled!, animated: true)
            }
            else if (isBiometricsEnrolled == nil) {
                switchView.setOn(false, animated: true)
            }

             switchView.tag = indexPath.row // for detect which row switch Changed
             switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
             cell.accessoryView = switchView
            return cell
        case .footer:
            let cell = MoreAppIdentityCell.dequeue(in: tableView)
            cell.appVersionLabel.text = String(format: "app.version".localized, "\(App.version)(\(App.build))")
            return cell
        }
    }
    @objc func switchChanged(_ sender : UISwitch!){

        let userDefaults = UserDefaults.standard

        if (sender.isOn == true) {
            
            FHAppUtility.shared.showAlertWithActions(view: self, title: "Biometrische Authentifizierung aktivieren?", message: "Möchten Sie Ihr biometrisches Authentifizierungs-Login in der „Riso“-App aktivieren?", firstButtonTitle: "Ja", secondButtonTitle: "Nein", alertActionNum: 2) { (result) in
                
                if result { //User has clicked on yes
                    if self.context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                        self.context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Access requires authentication") { (success, err) in
                            DispatchQueue.main.async { [weak self] in
                                if success {
                                    switch self?.context.biometryType {
                                    case .faceID, .touchID:
                                        ITNSUserDefaults.set(true, forKey: "isBiometricsEnrolled")

                                    default: break
                                    }
                                }
                            }
                        }
                    }
                    else {
                        FHAppUtility.shared.showAlertWithActions(view: self, title: "FaceID/TouchID nicht konfiguriert", message: "Bitte gehen Sie zu den Einstellungen und konfigurieren Sie Ihre FaceID/TouchID.", firstButtonTitle: "OK", secondButtonTitle: "", alertActionNum: 1) { (result) in
                            
                            if result {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                else { //User has clicked on No
                    self.tableView.reloadData()
                }
            }
        }
        else if (sender.isOn == false) {
            ITNSUserDefaults.set(false, forKey: "isBiometricsEnrolled")

            if(ITNSUserDefaults.bool(forKey: LoginRememberMeClick)){
                FHAppUtility.shared.showAlertWithActions(view: self, title: "Die biometrische Authentifizierung für die RISO-App wurde erfolgreich deaktiviert. Sie können sich nicht mit der alten Biometrie anmelden!", message: "", firstButtonTitle: "Ok", secondButtonTitle: "", alertActionNum: 1) { (result) in
                }
            }else{
                FHAppUtility.shared.showAlertWithActions(view: self, title: "Die biometrische Authentifizierung für die RISO-App wurde erfolgreich deaktiviert. Sie können sich nicht mit der alten Biometrie anmelden!", message: "", firstButtonTitle: "Ok", secondButtonTitle: "", alertActionNum: 1) { (result) in
                }
            }
//            let removeUsernameSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "userName")
//            let removePasswordSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "userPassword")
//            print("Removed Username was successful: \(removeUsernameSuccessful)")
//            print("Removed Password was successful: \(removePasswordSuccessful)")
            userDefaults.synchronize()
        }
        
        userDefaults.synchronize()
    }
}

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let sectionType = section(for: indexPath)
        switch sectionType {
        case .profile:
            cell.addBorderWithColor(UIColor.App.TableView.separator,
                                    andWidth: 1,
                                    atPosition: .bottom,
                                    leftMargin: 20,
                                    rightMargin: 35)
            break
        case .imprint, .privacy, .legal, .tutorial, .appSecurity, .reminders, .signOut, .clearKeychain, .footer:
            cell.removeBorderAtPosition(.bottom)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = section(for: indexPath)
        switch sectionType {
        case .profile:
            return 110
        case .imprint, .privacy, .legal, .tutorial, .appSecurity, .reminders, .signOut, .clearKeychain:
            return 60
        case .footer:
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        // Profile
        case 0:
            return 10
        default:
            return  0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sectionType = section(for: indexPath)
        switch sectionType {
        case .profile:
            break
        case .imprint:
            guard let url = URL(string: Constants.imprintURL) else { return }
            let controller = WebViewController(with: url)
            controller.title = sectionType.localizedText
            navigationController?.pushViewController(controller, animated: true)
        case .privacy:
            guard let url = URL(string: Constants.privacyURL) else { return }
            let controller = WebViewController(with: url)
            controller.title = sectionType.localizedText
            navigationController?.pushViewController(controller, animated: true)
        case .legal:
            guard let url = URL(string: Constants.legalURL) else { return }
            let controller = WebViewController(with: url)
            controller.title = sectionType.localizedText
            controller.view.backgroundColor = .white
            navigationController?.pushViewController(controller, animated: true)
            break
        case .tutorial:
            let pages = OnboardingPage.getOnboardingPages()
            let controller = OnboardingPageViewController(pages: pages, canDismiss: false)
            navigationController?.pushViewController(controller, animated: true)
            break
        case .appSecurity:

            break
        case .reminders:
            let controller = ListOfRemindersViewController()
            controller.title = sectionType.localizedText
            navigationController?.pushViewController(controller, animated: true)
            break
        case .signOut:
            ApplicationDelegate.client.signOut()
            break
        case .clearKeychain:
            #if STA
            ApplicationDelegate.client.clearKeychain()
            #endif
            return
        case .footer:
            return
        }
    }
}

class MoreAppIdentityCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            guard let imageView = logoImageView else { return }
            imageView.contentMode = .center
            imageView.image = #imageLiteral(resourceName: "Riso_blue")
        }
    }
    @IBOutlet weak var appVersionLabel: UILabel! {
        didSet {
            guard let label     = appVersionLabel else { return }
            label.font          = UIFont.appFont(ofSize: 13, weight: .regular)
            label.textAlignment = .right
            label.textColor     = UIColor.App.Text.dark
        }
    }
}
