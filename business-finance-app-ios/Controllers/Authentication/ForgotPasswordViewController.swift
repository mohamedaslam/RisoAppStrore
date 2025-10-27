//
//  ForgotPasswordViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    static func instantiate(email: String?) -> ForgotPasswordViewController {
        let storyboard = UIStoryboard(storyboard: .authentication)
        let vc: ForgotPasswordViewController = storyboard.instantiateViewController()
        vc.email = email
        return vc
    }
    
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailPlaceholderLabel: UILabel!
    @IBOutlet weak var emailTextFieldContainer: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var disclaimerLabel: UILabel!
    private var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        emailTextFieldContainer?.layer.borderWidth = 1
        emailTextFieldContainer?.layer.borderColor = UIColor.App.TextField.border.cgColor
        
        emailPlaceholderLabel?.font          = UIFont.appFont(ofSize: 13, weight: .regular)
        emailPlaceholderLabel?.textColor     = UIColor.App.Text.light
        emailPlaceholderLabel?.textAlignment = .left
    
        emailTextField?.textColor              = UIColor.App.Text.dark
        emailTextField?.font                   = UIFont.appFont(ofSize: 15, weight: .regular)
        emailTextField?.autocorrectionType     = .no
        emailTextField?.autocapitalizationType = .none
        emailTextField?.keyboardType         = .emailAddress
        emailTextField?.returnKeyType        = .next
        emailTextField?.delegate             = self
        emailTextField?.addTarget(self,
                                 action: #selector(textFieldTextChanged(_:)),
                                 for: .editingChanged)
        
        forgotPasswordButton?.set(style: .filled)
        forgotPasswordButton?.addTarget(self,
                                       action: #selector(sendButtonDidTouch(_:)),
                                       for: .touchUpInside)
        
        disclaimerLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        disclaimerLabel?.textColor = UIColor.App.Text.light
    
        emailErrorLabel?.alpha        = 0.0
        emailErrorLabel?.textColor    = UIColor.App.Text.error
        
        refreshTexts()
    }
    
    private func refreshTexts() {
        title                       = "navigation.title.forgotPassword".localized
        emailPlaceholderLabel?.text = "auth.fieldPlaceholder.email".localized
        emailTextField?.text        = email
        disclaimerLabel?.text       = "forgotPassword.text.info".localized
        
        forgotPasswordButton?.setTitle("forgotPassword.button.send".localized, for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentContainerView.set(shadowType: .subtle)
        forgotPasswordButton.set(shadowType: .subtle)
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
        default:
            break
        }
    }
    
    func clearErrors(for textField: UITextField) {
        switch textField {
        case emailTextField:
            UIView.animate(withDuration: 0.3) {
                self.emailErrorLabel?.text = nil
                self.emailErrorLabel?.alpha = 0.0
                self.emailTextFieldContainer?.layer.borderColor = UIColor.App.TextField.border.cgColor
            }
            break
        default:
            break
        }
    }
    
    deinit {
        
    }
}

// MARK: - Actions
extension ForgotPasswordViewController {
    @objc
    func sendButtonDidTouch(_ sender: UIButton) {
        guard let email = self.email?.trim(), email.isNotEmpty else {
            showError("error.missingEmail".localized, for: emailTextField)
            return
        }
        
        guard email.isValidEmail else {
            showError("error.invalidEmail".localized, for: emailTextField)
            return
        }
        
        // Check if valid
        sender.begin()
        ApplicationDelegate.client.resetPassword(email: email) { message in
            sender.end()
            guard let message = message else { return }
            let _ = self.navigationController?.popViewController(animated: true)
            UIApplication.shared.showAlertWith(title: "forgotPassword.text.successAlert.title".localized,
                                               message: "forgotPassword.text.successAlert.text".localized)
            
        }
    }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            return true
        default:
            textField.resignFirstResponder()
            return true
        }
    }
    
    @objc
    func textFieldTextChanged(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            email = textField.text
        default:
            return
        }
    }
}
