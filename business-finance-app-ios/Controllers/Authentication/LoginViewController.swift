//
//  LoginViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import SwiftyAttributes
import MessageUI
import LocalAuthentication
import ANActivityIndicator

enum LoginValidationError: Error {
    case missingEmail
    case missingPassword
    case invalidEmail
}

struct LoginStore {

    var email: String?
    var password: String?
    
    func validate() throws -> (email: String, password: String) {
        guard let email = self.email, email.trim().isNotEmpty else {
            throw LoginValidationError.missingEmail
        }
        
        guard email.isValidEmail else {
            throw LoginValidationError.invalidEmail
        }
        
        guard let password = self.password, password.trim().isNotEmpty else {
            throw LoginValidationError.missingPassword
        }
        
        return (email: email, password: password)
    }
}

class LoginViewController: BaseViewController {
    struct Constants {
        static let demoRequestReceiverEmailAddress = "hallo@riso-app.de"
    }
    static func instantiate() -> LoginViewController {
        let storyboard = UIStoryboard(storyboard: .authentication)
        let vc: LoginViewController = storyboard.instantiateViewController()
        return vc
    }
    
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailPlaceholderLabel: UILabel!
    @IBOutlet weak var emailTextFieldContainer: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordPlaceholderLabel: UILabel!
    @IBOutlet weak var passwordTextFieldContainer: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var demoRequestLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeightConstraint: NSLayoutConstraint!
    private var rememberPwdBtn: UIButton!
    private var loginWithBiometricdBtn: UIButton!
    var userCancelBiometrics : Bool = false
    var checkBiometricDisabled : Bool = false

    private var store = LoginStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccssNotification(notification:)), name: .loginSucessNotificaion, object: nil)
        setupViews()
        loginWithBiometric()
        ITNSUserDefaults.set(false, forKey: "isLogoutFromApp")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: .checkLoginWithBiometricSuccessNotification, object: nil, queue: .main) { notification in
            ANActivityIndicatorPresenter.shared.showIndicator()
        }
    }
    
    func loginWithBiometric(){
        let isBiometricsEnrolled = ITNSUserDefaults.object(forKey: "isBiometricsEnrolled") as? Bool
        let isLogoutFromApp = ITNSUserDefaults.object(forKey: "isLogoutFromApp") as? Bool

        if (isBiometricsEnrolled == true && isLogoutFromApp == false) {
            ANActivityIndicatorPresenter.shared.showIndicator()
            // retrieve the user name
            guard let lastAccessedUserName = UserDefaults.standard.object(forKey: "lastAccessedUserName") as? String else { return }
            
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                // device can be used for biometric authentication
                // evalutate the policy
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Access requires authentication") { (success, err) in
                    DispatchQueue.main.async { [weak self] in
                        if success {
                            switch context.biometryType {
                            case .faceID, .touchID:
                                print("device support faceId or touchId authentication")
                                self?.loadPasswordFromKeychainAndAuthenticateUser(lastAccessedUserName)
                            default: break
                            }
                        }else{
                            ANActivityIndicatorPresenter.shared.hideIndicator()

                        }
                    }
                }
            } else {
// device cannot be used for biometric authentication
// UIApplication.shared.showAlertWith(title: "Biometry is not enrolled",message: "")
                FHAppUtility.shared.showAlertWithActions(view: self, title: "FaceID/TouchID nicht konfiguriert", message: "Bitte gehen Sie zu Einstellungen und konfigurieren Sie Ihre FaceID/TouchID.", firstButtonTitle: "OK", secondButtonTitle: "", alertActionNum: 1) { (result) in

                }
                ANActivityIndicatorPresenter.shared.hideIndicator()

                if let error = error {
                    switch error.code {
                    case LAError.Code.biometryNotEnrolled.rawValue: print("biometry is not enrolled")
                    case LAError.Code.biometryLockout.rawValue: print("biometry is not enrolled")
                    case LAError.Code.biometryNotAvailable.rawValue: print("biometry is not enrolled")
                    default: break
                    }
                }
            }

        }
    }
    private func setupViews() {
        errorView.clipsToBounds = true
        errorView.backgroundColor = UIColor.App.Text.error.alpha(0.2)
        errorLabel.textColor = UIColor.App.Text.error
        
        [emailTextFieldContainer, passwordTextFieldContainer].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.App.TextField.border.cgColor
        }
        [emailPlaceholderLabel, passwordPlaceholderLabel].forEach {
            $0?.font          = UIFont.appFont(ofSize: 13, weight: .regular)
            $0?.textColor     = UIColor.App.Text.light
            $0?.textAlignment = .left
        }
        [emailTextField, passwordTextField].forEach {
            $0?.textColor              = UIColor.App.Text.dark
            $0?.font                   = UIFont.appFont(ofSize: 15, weight: .regular)
            $0?.autocorrectionType     = .no
            $0?.autocapitalizationType = .none
        }
        
        emailTextField.keyboardType         = .emailAddress
        emailTextField.returnKeyType        = .next
        emailTextField.delegate             = self
        emailTextField.addTarget(self,
                                 action: #selector(textFieldTextChanged(_:)),
                                 for: .editingChanged)
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType     = .send
        passwordTextField.delegate          = self
        passwordTextField.addTarget(self,
                                    action: #selector(textFieldTextChanged(_:)),
                                    for: .editingChanged)
        
        loginButton.set(style: .filled)
        loginButton.addTarget(self,
                              action: #selector(loginButtonDidTouch(_:)),
                              for: .touchUpInside)
        
        forgotPasswordButton.set(style: .transparent)
        forgotPasswordButton.addTarget(self,
                                       action: #selector(forgotPasswordButtonDidTouch(_:)),
                                       for: .touchUpInside)
        
        demoRequestLabel.isUserInteractionEnabled = true
        demoRequestLabel.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(requestDemoTextDidTouch(_:)))
        )
        
        emailErrorLabel.alpha        = 0.0
        emailErrorLabel.textColor    = UIColor.App.Text.error
        passwordErrorLabel.alpha     = 0.0
        passwordErrorLabel.textColor = UIColor.App.Text.error
        clearErrors()
        refreshTexts()
        let rememberPwdBtn: UIButton = UIButton()
        rememberPwdBtn.setTitle(" Angemeldet bleiben", for: .normal)
        rememberPwdBtn.titleLabel?.font = .systemFont(ofSize: AutoSizeScale(12))
        rememberPwdBtn.setTitleColor(.lightGray, for: .normal)
        rememberPwdBtn.setImage(UIImage(named: "tickchecked"), for: .normal)
        rememberPwdBtn.imageView?.contentMode = .scaleAspectFit
        rememberPwdBtn.setImage(UIImage(named: "tickUnchecked"), for: .selected)
        rememberPwdBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        rememberPwdBtn.addTarget(self, action: #selector(rememberPwdBtnAction(sender:)), for: .touchUpInside)
        rememberPwdBtn.isSelected = true
        ITNSUserDefaults.set(false, forKey: LoginRememberMeClick)
        self.view.addSubview(rememberPwdBtn)
        rememberPwdBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AutoSizeScale(150), height: AutoSizeScale(20)))
            make.left.equalTo(loginButton.snp_left)
            make.top.equalTo(loginButton.snp_bottom).offset(AutoSizeScale(8))
        }
        self.rememberPwdBtn = rememberPwdBtn
        
        let loginWithBiometricdBtn: UIButton = UIButton()
        loginWithBiometricdBtn.setTitle(" LOGIN MIT BIOMETRISCHEN DATEN", for: .normal)
        loginWithBiometricdBtn.titleLabel?.font = .systemFont(ofSize: AutoSizeScale(9))
        loginWithBiometricdBtn.setTitleColor(.white, for: .normal)
        loginWithBiometricdBtn.backgroundColor = UIColor(hexString: "#3868F6")
        loginWithBiometricdBtn.addTarget(self, action: #selector(loginWithBiometricdBtnAction(sender:)), for: .touchUpInside)
        //proceedWithBiometricdBtn.isSelected = true
        self.view.addSubview(loginWithBiometricdBtn)
        loginWithBiometricdBtn.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(loginButton)
            make.height.equalTo(loginButton).offset(-6 * AutoSizeScaleX)
            make.top.equalTo(rememberPwdBtn.snp_bottom).offset(AutoSizeScale(8))
        }
        self.loginWithBiometricdBtn = loginWithBiometricdBtn
        
        let faceTouchIDMainLogoImageView: UIImageView = UIImageView()
        faceTouchIDMainLogoImageView.image = UIImage.init(named: "touchIDWhite")
        faceTouchIDMainLogoImageView.contentMode = .scaleAspectFit
        loginWithBiometricdBtn.addSubview(faceTouchIDMainLogoImageView)
        faceTouchIDMainLogoImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(faceTouchIDMainLogoImageView);
            make.width.height.equalTo(28 * AutoSizeScaleX)
            make.centerY.equalTo(loginWithBiometricdBtn)
            make.left.equalTo(loginWithBiometricdBtn.snp_left).offset(12 * AutoSizeScaleX)
        }
        
        let isBiometricsEnrolled = ITNSUserDefaults.object(forKey: "isBiometricsEnrolled") as? Bool
        let isLogoutFromApp = ITNSUserDefaults.object(forKey: "isLogoutFromApp") as? Bool
        
        if(isBiometricsEnrolled == true ){
            self.loginWithBiometricdBtn.isHidden = false
        }else{
            self.loginWithBiometricdBtn.isHidden = true
        }
    }
    
    private func refreshTexts() {
        title                           = "navigation.title.auth".localized
        emailPlaceholderLabel.text      = "auth.fieldPlaceholder.email".localized
        passwordPlaceholderLabel.text   = "auth.fieldPlaceholder.password".localized
        emailTextField.text             = store.email
        passwordTextField.text          = store.password
        demoRequestLabel.attributedText = [
            "auth.text.disclaimer"
                .localized
                .withFont(UIFont.appFont(ofSize: 13, weight: .regular))
                .withTextColor(UIColor.App.Text.light),
            " ".withFont(UIFont.appFont(ofSize: 13, weight: .regular)),
            "auth.text.requestDemo"
                .localized
                .withFont(UIFont.appFont(ofSize: 13, weight: .regular))
                .withTextColor(UIColor.App.Text.focused)
        ].merged()
        
        loginButton.setTitle("auth.button.login".localized, for: .normal)
        forgotPasswordButton.setTitle("auth.button.forgotPassword".localized, for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentContainerView.set(shadowType: .subtle)
        loginButton.set(shadowType: .subtle)
    }
    
    @objc func rememberPwdBtnAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let isBiometricsEnrolled = ITNSUserDefaults.object(forKey: "isBiometricsEnrolled") as? Bool
        if(!sender.isSelected){
            ITNSUserDefaults.set(true, forKey: LoginRememberMeClick)
            if (isBiometricsEnrolled == true) {
                UIApplication.shared.showAlertWith(title: "Hallo, wir werden jetzt den Login mit biometrischen Daten deaktivieren, sodass Du immer angemeldet bist.".localized,message: "")
                ITNSUserDefaults.set(false, forKey: "isBiometricsEnrolled")
                self.loginWithBiometricdBtn.isHidden = true
                self.checkBiometricDisabled = true
            }
        }else{
            ITNSUserDefaults.set(false, forKey: LoginRememberMeClick)
            if (self.checkBiometricDisabled == true) {
                ITNSUserDefaults.set(true, forKey: "isBiometricsEnrolled")
                self.loginWithBiometricdBtn.isHidden = false
            }
        }
        self.view.endEditing(false)
    }
    
    @objc func loginWithBiometricdBtnAction(sender: UIButton) {
        loginWithBiometric()
    }
    
    func showError(_ error: String, for textField: UITextField) {
        switch textField {
        case emailTextField:
            UIView.animate(withDuration: 0.3) {
                self.emailErrorLabel?.text = error
                self.emailErrorLabel?.alpha = 1.0
                self.emailTextFieldContainer?.layer.borderColor = UIColor.App.TextField.error.cgColor
            }
            break
        case passwordTextField:
            UIView.animate(withDuration: 0.3) {
                self.passwordErrorLabel?.text = error
                self.passwordErrorLabel?.alpha = 1.0
                self.passwordTextFieldContainer?.layer.borderColor = UIColor.App.TextField.error.cgColor
            }
            break
        default:
            break
        }
    }
    
    func clearErrors(for textField: UITextField) {
        errorLabelHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        UIView.animate(withDuration: 0.3) {
            self.errorView.alpha = 0.0
            self.view.layoutIfNeeded()
        }
        
        switch textField {
        case emailTextField:
            UIView.animate(withDuration: 0.3) {
                self.emailErrorLabel?.text = nil
                self.emailErrorLabel?.alpha = 0.0
                self.emailTextFieldContainer?.layer.borderColor = UIColor.App.TextField.border.cgColor
            }
            break
        case passwordTextField:
            UIView.animate(withDuration: 0.3) {
                self.passwordErrorLabel?.text = nil
                self.passwordErrorLabel?.alpha = 0.0
                self.passwordTextFieldContainer?.layer.borderColor = UIColor.App.TextField.border.cgColor
            }
            break
        default:
            break
        }
    }
    
    func clearErrors() {
        clearErrors(for: emailTextField)
        clearErrors(for: passwordTextField)
        
        errorLabelHeightConstraint.priority = UILayoutPriority(rawValue: 999)
        UIView.animate(withDuration: 0.3) {
            self.errorView.alpha = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        demoRequestLabel?.removeGestureRecognizers()
    }
}

// MARK: - Actions
extension LoginViewController {
    @objc
    func requestDemoTextDidTouch(_ sender: UITapGestureRecognizer) {
        refreshTexts()
        
        guard MFMailComposeViewController.canSendMail() else { return }
        let composer = MFMailComposeViewController()
        composer.navigationBar.tintColor = UIColor.white
        composer.navigationBar.barTintColor = UIColor.App.primary
        composer.mailComposeDelegate = self
        composer.setToRecipients([Constants.demoRequestReceiverEmailAddress])
        
        composer.setSubject("demoRequestEmail.subject".localized())
        composer.setMessageBody("demoRequestEmail.body".localized(), isHTML: false)
        present(composer, animated: true, completion: nil)
    }
    
    @objc
    func loginButtonDidTouch(_ sender: UIButton) {
            do {
                let credentials = try store.validate()
                sender.begin()
                ApplicationDelegate.client.login(
                    email: credentials.email,
                    password: credentials.password,
                    failure: { error in
                        sender.end()
                        if
                            error.localizedDescription.contains("credentials")
                                && error.localizedDescription.contains("incorrect") {
                            self.errorLabel.text = "error.incorrectCredentials".localized
                            self.errorLabelHeightConstraint.priority = UILayoutPriority(rawValue: 1)
                            UIView.animate(withDuration: 0.3, animations: {
                                self.errorView.alpha = 1.0
                                self.view.layoutIfNeeded()
                            })
                        } else {
                            if(error.localizedDescription.contains("Dein Riso-Konto wurde inaktiv gesetzt")){
                                self.errorLabel.text = "error.account_inactive".localized
                                self.errorLabelHeightConstraint.priority = UILayoutPriority(rawValue: 1)
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.errorView.alpha = 1.0
                                    self.view.layoutIfNeeded()
                                })
                            }else{
                                self.showError(error.localizedDescription, for: self.emailTextField)
                            }
                        }
                        
                    }
                )
            } catch let error as LoginValidationError {
                switch error {
                case .invalidEmail:
                    showError("error.invalidEmail".localized, for: emailTextField)
                    break
                case .missingEmail:
                    showError("error.missingEmail".localized, for: emailTextField)
                    break
                case .missingPassword:
                    showError("error.missingPassword".localized, for: passwordTextField)
                    break
                }
            } catch let error {
                print(error)
            }
    }
    
    private func login() {
        
    }
    @objc
    func forgotPasswordButtonDidTouch(_ sender: UIButton) {

//        print(#function)
        let controller = ForgotPasswordViewController.instantiate(email: store.email)
        navigationController?.pushViewController(controller, animated: true)
    }
    @objc func loginSuccssNotification(notification: Notification){
//  if(!ITNSUserDefaults.bool(forKey: LoginRememberMeClick)){
        let isBiometricsEnrolled = ITNSUserDefaults.object(forKey: "isBiometricsEnrolled") as? Bool

        if (isBiometricsEnrolled == false || isBiometricsEnrolled == nil) {
            if(!ITNSUserDefaults.bool(forKey: LoginRememberMeClick)){
                FHAppUtility.shared.showAlertWithActions(view: self, title: "App sperren", message: "Möchtest Du die App mit einem Passwortschutz versehen?", firstButtonTitle: "Ja", secondButtonTitle: "Nein", alertActionNum: 2) { (result) in
                    if result { //User has clicked on Yes
                        let controller = BiometricViewController()
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: false)
                    }
                    else { //User has clicked on No
                        let isreceviedPushNotification = ITNSUserDefaults.object(forKey: "receviedPushNotification") as? Bool

                        if (isreceviedPushNotification == true) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                NotificationCenter.default.post(name: .clickOnTravelNotificaion, object: nil)
                            }
                            ITNSUserDefaults.set(false, forKey: "receviedPushNotification")
                        }
                        ApplicationDelegate.client.bootstrapApp()
                    }
                }
            }else{
                ApplicationDelegate.client.bootstrapApp()
            }
        }else{
            ApplicationDelegate.client.bootstrapApp()
        }
    }

    func loadPasswordFromKeychainAndAuthenticateUser(_ user_name: String) {
        guard !user_name.isEmpty else { return }
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: user_name, accessGroup: KeychainConfiguration.accessGroup)
        do {
            let storedPassword = try passwordItem.readPassword()
           // LoginService.callLogInService(userName: user_name, password: storedPassword, successBlock: successBlock, failureBlock: failureBlock)
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
 //   }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
            return false
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            loginButtonDidTouch(loginButton)
            return true
        default:
            textField.resignFirstResponder()
            return true
        }
    }
    
    @objc
    func textFieldTextChanged(_ textField: UITextField) {
        clearErrors(for: textField)
        switch textField {
        case emailTextField:
            store.email    = textField.text
        case passwordTextField:
            store.password = textField.text
        default:
            return
        }
    }
}

extension LoginViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension MFMailComposeViewController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return nil
    }
}

extension UIApplication {
    func show(error: String) {
        showAlertWith(title: "Oops!", message: error)
    }
    
    func showAlertWith(title: String? = nil, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok".localized, style: .cancel, handler: nil))
        if let presentedController = keyWindow?.rootViewController?.presentedViewController {
            presentedController.present(alertController, animated: true, completion: nil)
        } else {
            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
