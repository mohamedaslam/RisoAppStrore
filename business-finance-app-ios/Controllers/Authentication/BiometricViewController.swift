//
//  BiometricViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/7/19.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import LocalAuthentication
import ANActivityIndicator

class BiometricViewController: UIViewController {
    private var context = LAContext()
    private var logoImageView: UIImageView = UIImageView()
    private var biometricMainBGView: UIView = UIView()
    private var biometricEnableBGView: UIView = UIView()
    private var biometricOptionsBGView: UIView = UIView()
    private var biometricDoneBGView: UIView = UIView()
    private var userCancelBiometrics : Bool = false
    private var faceIDBGView: UIView = UIView()
    private var touchIDBGView: UIView = UIView()
    private var faceTouchIDEnableTextlab: UILabel = UILabel()
    private var faceTouchIDAccessAccountTextLab: UILabel = UILabel()
    private var useFaceTouchIDBtn: UIButton = UIButton()
    private var faceTouchIDUseNextLoginTextLab: UILabel = UILabel()
    private var faceTouchIDMainLogoImageView: UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let biometricMainBGView: UIView = UIView()
        biometricMainBGView.backgroundColor = .white
        self.view.addSubview(biometricMainBGView)
        self.biometricMainBGView = biometricMainBGView
        biometricMainBGView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view)
            make.height.equalTo(500 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }
        
        let logoImageView: UIImageView = UIImageView()
        logoImageView.image = UIImage.init(named: "Riso_blue")
        self.biometricMainBGView.addSubview(logoImageView)
        self.logoImageView = logoImageView
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.biometricMainBGView).offset(6 * AutoSizeScaleX)
            make.centerX.equalTo(self.biometricMainBGView)
            make.width.equalTo(150 * AutoSizeScaleX)
            make.height.equalTo(50 * AutoSizeScaleX)
        }

        biomentricSelectOptionsUISetup()
        biometricEnableUISetup()
        biometricDoneUISetup()
        self.determineBiometricType()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func biomentricSelectOptionsUISetup(){
        
        let biometricOptionsBGView: UIView = UIView()
        biometricOptionsBGView.backgroundColor = .white
        biometricOptionsBGView.isHidden = false
        self.biometricMainBGView.addSubview(biometricOptionsBGView)
        self.biometricOptionsBGView = biometricOptionsBGView
        biometricOptionsBGView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.left.right.equalTo(biometricMainBGView)
            make.bottom.equalTo(biometricMainBGView.snp_bottom)
        }
        
        let loginMethodlab: UILabel = UILabel()
        loginMethodlab.text = "Sie werden Biometric als Anmeldeprozess aktivieren"
        loginMethodlab.textColor = .black
        loginMethodlab.textAlignment = .center
        loginMethodlab.numberOfLines = 0
        loginMethodlab.font = UIFont.appFont(ofSize: 16, weight: .bold)
        self.biometricOptionsBGView.addSubview(loginMethodlab)
        loginMethodlab.snp.makeConstraints { (make) in
            make.top.equalTo(self.biometricOptionsBGView).offset(30 * AutoSizeScaleX)
            make.height.equalTo(50 * AutoSizeScaleX)
            make.left.equalTo(self.biometricOptionsBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.biometricOptionsBGView).offset(-20 * AutoSizeScaleX)
        }

        let biometricButtonsBGView: UIView = UIView()
        biometricButtonsBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        biometricButtonsBGView.layer.shadowColor = UIColor.black.cgColor
        biometricButtonsBGView.layer.shadowOffset = CGSize.zero
        biometricButtonsBGView.layer.shadowOpacity = 0.12
        biometricButtonsBGView.layer.shadowRadius = 3
        self.biometricOptionsBGView.addSubview(biometricButtonsBGView)
        biometricButtonsBGView.snp.makeConstraints { (make) in
            make.top.equalTo(loginMethodlab.snp_bottom).offset(40 * AutoSizeScaleX)
            make.bottom.equalTo(self.biometricOptionsBGView)
            make.left.equalTo(self.biometricOptionsBGView).offset(40 * AutoSizeScaleX)
            make.right.equalTo(self.biometricOptionsBGView).offset(-40 * AutoSizeScaleX)
        }


        let faceIDBGView: UIView = UIView()
        faceIDBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        faceIDBGView.layer.shadowColor = UIColor.black.cgColor
        faceIDBGView.layer.shadowOffset = CGSize.zero
        faceIDBGView.layer.shadowOpacity = 0.12
        faceIDBGView.layer.shadowRadius = 3
        faceIDBGView.isHidden = true
        biometricButtonsBGView.addSubview(faceIDBGView)
        self.faceIDBGView = faceIDBGView
        faceIDBGView.snp.makeConstraints { (make) in
            make.centerX.top.equalTo(biometricButtonsBGView)
            make.width.equalTo(110 * AutoSizeScaleX)
            make.height.equalTo(120 * AutoSizeScaleX)
        }
        let faceIDBtn: UIButton = UIButton(type: .custom)
        faceIDBtn.setTitleColor(.white, for: .normal)
        faceIDBtn.setImage(UIImage(named: "biometricImg"), for: .normal)
        faceIDBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        faceIDBtn.layer.shadowColor = UIColor.black.cgColor
        faceIDBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        faceIDBtn.layer.shadowOpacity = 0.12
        faceIDBtn.layer.shadowRadius = 3
        faceIDBtn.addTarget(self, action: #selector(faceIDBtnAction(sender:)), for: .touchUpInside)
        faceIDBGView.addSubview(faceIDBtn)
        faceIDBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(biometricButtonsBGView)
            make.top.equalTo(20 * AutoSizeScaleX)
            make.width.equalTo(50 * AutoSizeScaleX)
            make.height.equalTo(50 * AutoSizeScaleX)
        }

        let faceIDlab: UILabel = UILabel()
        faceIDlab.text = "Biometrisch"
        faceIDlab.textColor = UIColor(hexString: "#3868F6")
        faceIDlab.textAlignment = .center
        faceIDlab.numberOfLines = 0
        faceIDlab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        faceIDBGView.addSubview(faceIDlab)
        faceIDlab.snp.makeConstraints { (make) in
            make.top.equalTo(faceIDBtn.snp_bottom).offset(20 * AutoSizeScaleX)
            make.centerX.equalTo(faceIDBtn.snp_centerX)
            make.height.equalTo(20 * AutoSizeScaleX)
            make.width.equalTo(100 * AutoSizeScaleX)
        }

        let touchIDBGView: UIView = UIView()
        touchIDBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        touchIDBGView.layer.shadowColor = UIColor.black.cgColor
        touchIDBGView.layer.shadowOffset = CGSize.zero
        touchIDBGView.layer.shadowOpacity = 0.12
        touchIDBGView.layer.shadowRadius = 3
        touchIDBGView.isHidden = true
        biometricButtonsBGView.addSubview(touchIDBGView)
        self.touchIDBGView = touchIDBGView
        touchIDBGView.snp.makeConstraints { (make) in
            make.centerX.equalTo(biometricButtonsBGView)
            make.top.equalTo(biometricButtonsBGView)
            make.width.equalTo(110 * AutoSizeScaleX)
            make.height.equalTo(120 * AutoSizeScaleX)
        }
        
        let touchIDBtn: UIButton = UIButton(type: .custom)
        touchIDBtn.setTitleColor(.white, for: .normal)
        touchIDBtn.setImage(UIImage(named: "biometricImg"), for: .normal)
        touchIDBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        touchIDBtn.layer.shadowColor = UIColor.black.cgColor
        touchIDBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        touchIDBtn.layer.shadowOpacity = 0.12
        touchIDBtn.layer.shadowRadius = 3
        touchIDBtn.addTarget(self, action: #selector(touchIDBtnAction(sender:)), for: .touchUpInside)
        touchIDBGView.addSubview(touchIDBtn)
        touchIDBtn.snp.makeConstraints { (make) in
            make.left.equalTo(biometricButtonsBGView).offset(20 * AutoSizeScaleX)
            make.top.equalTo(20 * AutoSizeScaleX)
            make.width.equalTo(50 * AutoSizeScaleX)
            make.height.equalTo(50 * AutoSizeScaleX)
        }

        let touchIDlab: UILabel = UILabel()
        touchIDlab.text = "Biometrisch"
        touchIDlab.textColor = UIColor(hexString: "#3868F6")
        touchIDlab.textAlignment = .center
        touchIDlab.numberOfLines = 0
        touchIDlab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        touchIDBGView.addSubview(touchIDlab)
        touchIDlab.snp.makeConstraints { (make) in
            make.top.equalTo(touchIDBtn.snp_bottom).offset(20 * AutoSizeScaleX)
            make.centerX.equalTo(touchIDBtn.snp_centerX)
            make.height.equalTo(20 * AutoSizeScaleX)
            make.width.equalTo(100 * AutoSizeScaleX)
        }
        
        let maybeLaterBtn: UIButton = UIButton(type: .custom)
        maybeLaterBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        maybeLaterBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        maybeLaterBtn.setTitle( "VIelleicht später", for: .normal)
        maybeLaterBtn.layer.shadowColor = UIColor.black.cgColor
        maybeLaterBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        maybeLaterBtn.layer.shadowOpacity = 0.12
        maybeLaterBtn.layer.shadowRadius = 3
        maybeLaterBtn.addTarget(self, action: #selector(maybeLaterBtnAction(sender:)), for: .touchUpInside)
        biometricButtonsBGView.addSubview(maybeLaterBtn)
        maybeLaterBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(biometricButtonsBGView).offset(-10 * AutoSizeScaleX)
            make.width.equalTo(150 * AutoSizeScaleX)
            make.height.equalTo(30 * AutoSizeScaleX)
        }
    }
    @objc func biometricEnableUISetup(){
        
        let biometricEnableBGView: UIView = UIView()
        biometricEnableBGView.backgroundColor = .white
        biometricEnableBGView.isHidden = true
        self.biometricMainBGView.addSubview(biometricEnableBGView)
        self.biometricEnableBGView = biometricEnableBGView
        biometricEnableBGView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.left.right.equalTo(biometricMainBGView)
            make.bottom.equalTo(biometricMainBGView.snp_bottom)
        }
        
        
        let faceTouchIDMainLogoImageView: UIImageView = UIImageView()
        faceTouchIDMainLogoImageView.image = UIImage.init(named: "biometricImg")
        faceTouchIDMainLogoImageView.contentMode = .scaleAspectFit
        self.biometricEnableBGView.addSubview(faceTouchIDMainLogoImageView)
        self.faceTouchIDMainLogoImageView = faceTouchIDMainLogoImageView
        faceTouchIDMainLogoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.biometricEnableBGView).offset(30 * AutoSizeScaleX)
            make.centerX.equalTo(self.biometricEnableBGView)
            make.width.equalTo(60 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
        }
        
        let faceIDEnableTextlab: UILabel = UILabel()
        faceIDEnableTextlab.text = "Möchten Sie die Anmeldung mit Face ID aktivieren?"
        faceIDEnableTextlab.textColor = .black
        faceIDEnableTextlab.textAlignment = .center
        faceIDEnableTextlab.numberOfLines = 0
        faceIDEnableTextlab.font = UIFont.appFont(ofSize: 17, weight: .bold)
        self.biometricEnableBGView.addSubview(faceIDEnableTextlab)
        self.faceTouchIDEnableTextlab = faceIDEnableTextlab
        faceIDEnableTextlab.snp.makeConstraints { (make) in
            make.top.equalTo(faceTouchIDMainLogoImageView.snp_bottom).offset(40 * AutoSizeScaleX)
            make.height.equalTo(44 * AutoSizeScaleX)
            make.left.equalTo(self.biometricEnableBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.biometricEnableBGView).offset(-20 * AutoSizeScaleX)
        }
        
        let faceIDAccessAccountTextLab: UILabel = UILabel()
        faceIDAccessAccountTextLab.text = "Verwenden Sie Ihre Face ID für einen schnelleren und einfacheren Zugriff auf Ihr Konto. "
        faceIDAccessAccountTextLab.textColor = .black
        faceIDAccessAccountTextLab.textAlignment = .center
        faceIDAccessAccountTextLab.numberOfLines = 0
        faceIDAccessAccountTextLab.font = UIFont.appFont(ofSize: 13, weight: .regular)
        self.biometricEnableBGView.addSubview(faceIDAccessAccountTextLab)
        self.faceTouchIDAccessAccountTextLab = faceIDAccessAccountTextLab
        faceIDAccessAccountTextLab.snp.makeConstraints { (make) in
            make.top.equalTo(faceIDEnableTextlab.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(40 * AutoSizeScaleX)
            make.left.equalTo(self.biometricEnableBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.biometricEnableBGView).offset(-20 * AutoSizeScaleX)
        }
        
        let maybeLaterBtn: UIButton = UIButton(type: .custom)
        maybeLaterBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        maybeLaterBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        maybeLaterBtn.setTitle( "Vielleicht später", for: .normal)
        maybeLaterBtn.layer.shadowColor = UIColor.black.cgColor
        maybeLaterBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        maybeLaterBtn.layer.shadowOpacity = 0.12
        maybeLaterBtn.layer.shadowRadius = 3
        maybeLaterBtn.addTarget(self, action: #selector(maybeLaterBtnAction(sender:)), for: .touchUpInside)
        self.biometricEnableBGView.addSubview(maybeLaterBtn)
        maybeLaterBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(biometricEnableBGView).offset(-10 * AutoSizeScaleX)
            make.width.equalTo(150 * AutoSizeScaleX)
            make.height.equalTo(30 * AutoSizeScaleX)
        }
        
        let useFaceIDBtn: UIButton = UIButton(type: .custom)
        useFaceIDBtn.backgroundColor = UIColor(hexString: "#3868F6")
        useFaceIDBtn.setTitleColor(.white, for: .normal)
        useFaceIDBtn.setTitle( "Face ID verwenden", for: .normal)
        useFaceIDBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        useFaceIDBtn.addTarget(self, action: #selector(useFaceTouchIDBtnAction(sender:)), for: .touchUpInside)
        self.biometricEnableBGView.addSubview(useFaceIDBtn)
        self.useFaceTouchIDBtn = useFaceIDBtn
        useFaceIDBtn.snp.makeConstraints { (make) in
            make.right.equalTo(biometricEnableBGView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(biometricEnableBGView).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(maybeLaterBtn.snp_top).offset(-30 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
    }
    
    @objc func biometricDoneUISetup(){
        
        let biometricDoneBGView: UIView = UIView()
        biometricDoneBGView.backgroundColor = .white
        biometricDoneBGView.isHidden = true
        self.biometricMainBGView.addSubview(biometricDoneBGView)
        self.biometricDoneBGView = biometricDoneBGView
        biometricDoneBGView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.left.right.equalTo(biometricMainBGView)
            make.bottom.equalTo(biometricMainBGView.snp_bottom)
        }
        
        let biometricImageView: UIImageView = UIImageView()
        biometricImageView.image = UIImage.init(named: "face-id_done")
        biometricImageView.contentMode = .scaleAspectFit
        self.biometricDoneBGView.addSubview(biometricImageView)
        biometricImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.biometricDoneBGView).offset(30 * AutoSizeScaleX)
            make.centerX.equalTo(self.biometricDoneBGView)
            make.width.equalTo(60 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
        }
        
        let faceIDDoneTextlab: UILabel = UILabel()
        faceIDDoneTextlab.text = "Getan!"
        faceIDDoneTextlab.textColor = .black
        faceIDDoneTextlab.textAlignment = .center
        faceIDDoneTextlab.numberOfLines = 0
        faceIDDoneTextlab.font = UIFont.appFont(ofSize: 17, weight: .bold)
        self.biometricDoneBGView.addSubview(faceIDDoneTextlab)
        faceIDDoneTextlab.snp.makeConstraints { (make) in
            make.top.equalTo(biometricImageView.snp_bottom).offset(40 * AutoSizeScaleX)
            make.height.equalTo(50 * AutoSizeScaleX)
            make.left.equalTo(self.biometricDoneBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.biometricDoneBGView).offset(-20 * AutoSizeScaleX)
        }
        
        let faceIDUseNextLoginTextLab: UILabel = UILabel()
        faceIDUseNextLoginTextLab.text = "Verwenden Sie Ihre Face ID beim nächsten Login"
        faceIDUseNextLoginTextLab.textColor = .black
        faceIDUseNextLoginTextLab.textAlignment = .center
        faceIDUseNextLoginTextLab.numberOfLines = 0
        faceIDUseNextLoginTextLab.font = UIFont.appFont(ofSize: 13, weight: .regular)
        self.biometricDoneBGView.addSubview(faceIDUseNextLoginTextLab)
        self.faceTouchIDUseNextLoginTextLab = faceIDUseNextLoginTextLab
        faceIDUseNextLoginTextLab.snp.makeConstraints { (make) in
            make.top.equalTo(faceIDDoneTextlab.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(50 * AutoSizeScaleX)
            make.left.equalTo(self.biometricDoneBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.biometricDoneBGView).offset(-20 * AutoSizeScaleX)
        }
        
        let oKBtn: UIButton = UIButton(type: .custom)
        oKBtn.backgroundColor = UIColor(hexString: "#3868F6")
        oKBtn.setTitleColor(.white, for: .normal)
        oKBtn.setTitle( "Ok", for: .normal)
        oKBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        oKBtn.addTarget(self, action: #selector(oKBtnAction(sender:)), for: .touchUpInside)
        self.biometricDoneBGView.addSubview(oKBtn)
        oKBtn.snp.makeConstraints { (make) in
            make.right.equalTo(biometricDoneBGView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(biometricDoneBGView).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(biometricDoneBGView).offset(-40 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
    }
    
    func determineBiometricType() {
        context.localizedFallbackTitle = "Enter Passcode"
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = "Abbrechen"
        } else {
            // Fallback on earlier versions
        }
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            var biometricType : String?
            if #available(iOS 11.0, *) {
                biometricType = context.biometryType == LABiometryType.faceID ? "Face ID" : "Touch ID"
            } else {
                // Fallback on earlier versions
                biometricType = "Touch ID"
            }
            if (biometricType == "Face ID") {
                if ( context.biometryType == .faceID ) {
                    self.faceIDBGView.isHidden = false
                    self.touchIDBGView.isHidden = true
                    self.faceTouchIDMainLogoImageView.image = UIImage.init(named: "biometricImg")
                    self.faceTouchIDUseNextLoginTextLab.text = "Verwenden Sie beim nächsten Login Ihre Face ID"
                    self.faceTouchIDEnableTextlab.text = "Möchten Sie die Anmeldung mit Face ID/Passcode aktivieren"
                    self.faceTouchIDAccessAccountTextLab.text = "Verwenden Sie Ihre Face ID/Ihren Passcode für einen schnelleren und einfacheren Zugriff auf Ihr Konto."
                    self.useFaceTouchIDBtn.setTitle( "Verwenden Sie Face ID/Passcode", for: .normal)
                } else {
                    self.faceIDBGView.isHidden = false
                    self.touchIDBGView.isHidden = true
                    self.faceTouchIDUseNextLoginTextLab.text = "Verwenden Sie Ihren Passcode bei der nächsten Anmeldung"
                    self.faceTouchIDEnableTextlab.text = "Möchten Sie die Anmeldung mit Passcode aktivieren?"
                    self.faceTouchIDAccessAccountTextLab.text = "Verwenden Sie Ihren Passcode für einen schnelleren und einfacheren Zugriff auf Ihr Konto. "
                    self.useFaceTouchIDBtn.setTitle( "Passcode verwenden", for: .normal)
                }
            }
            else if (biometricType == "Touch ID") {
                if ( context.biometryType == .touchID) {
                    self.faceIDBGView.isHidden = true
                    self.touchIDBGView.isHidden = false
                    self.faceTouchIDMainLogoImageView.image = UIImage.init(named: "touchID")
                    self.faceTouchIDUseNextLoginTextLab.text = "Verwenden Sie beim nächsten Login Ihre Touch ID"
                    self.faceTouchIDEnableTextlab.text = "Möchten Sie die Anmeldung mit Touch ID/Passcode aktivieren?"
                    self.faceTouchIDAccessAccountTextLab.text = "Verwenden Sie Ihre Touch ID/Ihren Passcode für einen schnelleren und einfacheren Zugriff auf Ihr Konto."
                    self.useFaceTouchIDBtn.setTitle( "Verwenden Sie Touch ID/Passcode", for: .normal)
                }else{
                    self.faceIDBGView.isHidden = false
                    self.touchIDBGView.isHidden = true
                    self.faceTouchIDUseNextLoginTextLab.text = "Verwenden Sie Ihren Passcode bei der nächsten Anmeldung"
                    self.faceTouchIDEnableTextlab.text = "Möchten Sie die Anmeldung mit Passcode aktivieren?"
                    self.faceTouchIDAccessAccountTextLab.text = "Verwenden Sie Ihren Passcode für einen schnelleren und einfacheren Zugriff auf Ihr Konto "
                    self.useFaceTouchIDBtn.setTitle( "Passcode verwenden", for: .normal)
                }

            }else{

            }
        }else{
                self.biometricOptionsBGView.isHidden = true
                self.biometricEnableBGView.isHidden = true
                self.biometricDoneBGView.isHidden = true

                FHAppUtility.shared.showAlertWithActions(view: self, title: "FaceID/TouchID nicht konfiguriert", message: "Bitte gehen Sie zu den Einstellungen und konfigurieren Sie Ihre FaceID/TouchID.", firstButtonTitle: "OK", secondButtonTitle: "", alertActionNum: 1) { (result) in
                    DispatchQueue.main.async {
                        ApplicationDelegate.client.bootstrapApp()
                        self.dismiss(animated: true, completion: nil)
                    }
            }
        }
    }
    
    func checkBiometricsAuthentication() {
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "To get login into the app.") { (wasSuccessful, error) in
                if wasSuccessful {
                    ITNSUserDefaults.set(true, forKey: "isBiometricsEnrolled")
                    ITNSUserDefaults.synchronize()
                    let userDefaults = UserDefaults.standard
                    let isBiometricsEnrolled = userDefaults.object(forKey: "isBiometricsEnrolled") as? Bool
                    userDefaults.synchronize()
                    DispatchQueue.main.async {
                        self.biometricDoneBGView.isHidden = false
                        self.biometricOptionsBGView.isHidden = true
                        self.biometricEnableBGView.isHidden = true
                    }
                    if (isBiometricsEnrolled == true) {
                            print("LOGIN WITH BIOMETRIC AND ENTER USERNAME AND PASSWORD FROM USERDEFAULT")

                    }
                    else if (isBiometricsEnrolled == true ) {
                        print("isBiometricsEnrolled == true && self.fromSignUp == true")
                    }
                    else if (isBiometricsEnrolled == false || isBiometricsEnrolled == nil) {
                        print("isBiometricsEnrolled == false || isBiometricsEnrolled == nil) && self.fromSignUp == true")
                    }
                    else if (isBiometricsEnrolled == false || isBiometricsEnrolled == nil) {
                        print("isBiometricsEnrolled == false || isBiometricsEnrolled == nil) && self.fromSignUp == false")
                    }
                    else {
                        print("saveBiometricsCredentials")
                    }
                }
                else {
                    if (self.userCancelBiometrics == true) {
                        let message = """
Es scheint, als hätten Sie Schwierigkeiten mit Ihrer biometrischen Authentifizierung. Wenn Sie auf „OK“ klicken, wird die App zum Anmeldebildschirm weitergeleitet, wo Sie Ihren Benutzernamen und Ihr Passwort verwenden können, um die „Riso“-App aufzurufen
"""
                        FHAppUtility.shared.showAlertWithActions(view: self, title: "Schwierigkeiten bei der biometrischen Authentifizierung?", message: message, firstButtonTitle: "OK", secondButtonTitle: "", alertActionNum: 1) { (result) in
                            
                            if result {
                                DispatchQueue.main.async {
                                    ApplicationDelegate.client.bootstrapApp()
                                    self.dismiss(animated: true, completion: nil)
                                    print("Logout")
                                }
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            ApplicationDelegate.client.bootstrapApp()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        else {
            
            FHAppUtility.shared.showAlertWithActions(view: self, title: "FaceID/TouchID nicht konfiguriert", message: "Bitte gehen Sie zu den Einstellungen und konfigurieren Sie Ihre FaceID/TouchID.", firstButtonTitle: "OK", secondButtonTitle: "", alertActionNum: 1) { (result) in
                ApplicationDelegate.handle(flow: .authentication)
            }
        }
    }
    
    @objc func useFaceTouchIDBtnAction(sender: UIButton) {
        self.checkBiometricsAuthentication()
        self.determineBiometricType()
    }
    
    @objc func faceIDBtnAction(sender: UIButton) {
        self.checkBiometricsAuthentication()
        determineBiometricType()
        self.biometricDoneBGView.isHidden = true
        self.biometricOptionsBGView.isHidden = true
        self.biometricEnableBGView.isHidden = true
    }
    
    @objc func touchIDBtnAction(sender: UIButton) {
        self.checkBiometricsAuthentication()
        determineBiometricType()
        self.biometricDoneBGView.isHidden = true
        self.biometricOptionsBGView.isHidden = true
        self.biometricEnableBGView.isHidden = true
    }
    
    @objc func credentialsBtnAction(sender: UIButton) {
        ApplicationDelegate.handle(flow: .authentication)
    }
    
    @objc func oKBtnAction(sender:UIButton){
        ANActivityIndicatorPresenter.shared.showIndicator()
        ApplicationDelegate.client.bootstrapApp()
    }
    
    @objc func maybeLaterBtnAction(sender:UIButton){
        ANActivityIndicatorPresenter.shared.showIndicator()
        self.biometricDoneBGView.isHidden = true
        self.biometricOptionsBGView.isHidden = false
        self.biometricEnableBGView.isHidden = true
        ApplicationDelegate.client.bootstrapApp()
    }

    
    @objc func loginSuccssNotification(notification: Notification){
        let isBiometricsEnrolled = ITNSUserDefaults.object(forKey: "isBiometricsEnrolled") as? Bool

        if (isBiometricsEnrolled == false || isBiometricsEnrolled == nil) {
            let alert = UIAlertController(title: "App sperren", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ja", style: .default , handler:{ (UIAlertAction)in
                    let controller = BiometricViewController()
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false)
                }))
                alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler:{ (UIAlertAction)in
                    ApplicationDelegate.client.bootstrapApp()
                }))
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
        }else{
            
            ApplicationDelegate.client.bootstrapApp()

        }
    }
    
}
