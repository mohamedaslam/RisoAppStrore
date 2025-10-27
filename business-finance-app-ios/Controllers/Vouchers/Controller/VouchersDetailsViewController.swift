//
//  VouchersDetailsViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/16.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import UIKit

class VouchersDetailsViewController: BaseViewController {
    var yourCreditAmountLab: UILabel = UILabel()
    var yourCreditAmountValueLab: UILabel = UILabel()
    var discountAmountLab: UILabel = UILabel()
    var bgView: UIView = UIView()
    var iconContainerView: UIView = UIView()
    var iconImageView: UIImageView = UIImageView()
    var voucherValueLab: UILabel = UILabel()
    var onlineOfflineStatusLab : UILabel = UILabel()
    var getVouchers : Vouchers?
    var value_spent: String = "0"
    var budget: Int = 0
    var still_possible: Int = 0
    var isSachbezugPage : Bool = false
    var isDankeBonusPage : Bool = false
    var userProductId: Int = 0
    var voucherId: Int = 0
    var isAllVouchers : Bool = false
    var isStilPossibleValue : Bool = false
    var shopVoucherBtn : UIButton = UIButton()
    var saveDefaultVoucherBtn : UIButton = UIButton()
    private var vouchers: [Vouchers] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Gutscheine"

        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(tapBackBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        
        configUISetup()
    }
    @objc func tapBackBtnAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func configUISetup(){
        let yourCreditAmountLab: UILabel = UILabel()
        yourCreditAmountLab.text = "Dein Guthaben"
        yourCreditAmountLab.sizeToFit()
        yourCreditAmountLab.font = UIFont.appFont(ofSize: 17, weight: .semibold)
        yourCreditAmountLab.textColor = UIColor.init(hexString: "#2B395C")
        self.view.addSubview(yourCreditAmountLab)
        self.yourCreditAmountLab = yourCreditAmountLab
        yourCreditAmountLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.width.equalTo(200 * AutoSizeScaleX)
            make.height.equalTo(24 * AutoSizeScaleX)
            make.top.equalTo(self.view).offset(14 * AutoSizeScaleX)
        }

        let getValue_spent:Float = Float(self.value_spent) ?? 0
        let yourCreditAmountValueLab: UILabel = UILabel()
        yourCreditAmountValueLab.text = "\((getValue_spent).priceAsString()) / \(Float(self.budget).priceAsString()) "
        yourCreditAmountValueLab.sizeToFit()
        yourCreditAmountValueLab.textAlignment = .right
        yourCreditAmountValueLab.font = UIFont.appFont(ofSize: 17, weight: .semibold)
        yourCreditAmountValueLab.textColor = UIColor.init(hexString: "#2B395C")
        self.view.addSubview(yourCreditAmountValueLab)
        self.yourCreditAmountValueLab = yourCreditAmountValueLab
        yourCreditAmountValueLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.width.equalTo(200 * AutoSizeScaleX)
            make.height.equalTo(yourCreditAmountLab)
            make.top.equalTo(self.view).offset(14 * AutoSizeScaleX)
        }
        
        let discountAmountLab: UILabel = UILabel()
        discountAmountLab.text = "\(Float(self.still_possible).priceAsString()) noch möglich"
        discountAmountLab.sizeToFit()
        discountAmountLab.textAlignment = .right
        discountAmountLab.font = UIFont.appFont(ofSize: 17, weight: .semibold)
        self.view.addSubview(discountAmountLab)
        discountAmountLab.textColor = UIColor.init(hexString: "#2B395C")
        self.discountAmountLab = discountAmountLab
        discountAmountLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.width.equalTo(220 * AutoSizeScaleX)
            make.height.equalTo(16 * AutoSizeScaleX)
            make.top.equalTo(yourCreditAmountValueLab.snp_bottom).offset(6 * AutoSizeScaleX)
        }
        
        let separeateLineLab: UILabel = UILabel()
        self.view.addSubview(separeateLineLab)
        separeateLineLab.backgroundColor = .lightGray
        separeateLineLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
            make.top.equalTo(discountAmountLab.snp_bottom).offset(20 * AutoSizeScaleX)
        }
        
        let ifYouNeedHelpLab: UILabel = UILabel()
        ifYouNeedHelpLab.text = "Wenn Sie Hilfe benötigen, schreiben Sie uns bitte an “support@risoapp.zohodesk.eu“"
        ifYouNeedHelpLab.sizeToFit()
        ifYouNeedHelpLab.numberOfLines = 0
        ifYouNeedHelpLab.textAlignment = .center
        ifYouNeedHelpLab.font = UIFont.appFont(ofSize: 12, weight: .semibold)
        self.view.addSubview(ifYouNeedHelpLab)
        ifYouNeedHelpLab.textColor = .lightGray
        ifYouNeedHelpLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(44 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(self.view).offset(-40 * AutoSizeScaleX)
        }
        
        let bgView: UIView = UIView()
        bgView.backgroundColor = .white
        self.view.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(separeateLineLab.snp_bottom).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(ifYouNeedHelpLab.snp_top).offset(-40 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(30 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-30 * AutoSizeScaleX)
        }
        
        let bgImageView: UIImageView = UIImageView()
        bgImageView.contentMode = .scaleToFill
        bgImageView.image = UIImage(named: "voucherDetailsborder")
        self.bgView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(bgView)
        }
        
        let shopVoucherBtn: UIButton = UIButton(type: .custom)
        shopVoucherBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        shopVoucherBtn.setTitle( self.getVouchers?.vendor.link, for: .normal)
        shopVoucherBtn.backgroundColor = UIColor(hexString: "#3868F6")
        shopVoucherBtn.setTitleColor(.white, for: .normal)
        shopVoucherBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        shopVoucherBtn.addTarget(self, action: #selector(shopVouchersBtnAction(sender:)), for: .touchUpInside)
        self.bgView.addSubview(shopVoucherBtn)
        self.shopVoucherBtn = shopVoucherBtn
        shopVoucherBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.bgView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.bgView).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(self.bgView).offset(-22 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let saveDefaultVoucherBtn: UIButton = UIButton(type: .custom)
        saveDefaultVoucherBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        saveDefaultVoucherBtn.setTitle( "Als Standard-Gutschein speichern", for: .normal)
        saveDefaultVoucherBtn.backgroundColor = UIColor(hexString: "#3868F6")
        saveDefaultVoucherBtn.setTitleColor(.white, for: .normal)
        saveDefaultVoucherBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        saveDefaultVoucherBtn.addTarget(self, action: #selector(saveDefaultVoucherBtnAction(sender:)), for: .touchUpInside)
        self.bgView.addSubview(saveDefaultVoucherBtn)
        self.saveDefaultVoucherBtn = saveDefaultVoucherBtn
        saveDefaultVoucherBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.bgView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.bgView).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(self.bgView).offset(-22 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        if(isSachbezugPage == true){
            saveDefaultVoucherBtn.isHidden = false
            shopVoucherBtn.isHidden = true
        }else{
            saveDefaultVoucherBtn.isHidden = true
            shopVoucherBtn.isHidden = false
        }


        if(self.isAllVouchers == true){
            if(self.isStilPossibleValue == false){
                self.shopVoucherBtn.backgroundColor = UIColor.lightGray
                self.shopVoucherBtn.isUserInteractionEnabled = false
                    if let profile = ApplicationDelegate.client.loggedUser {
                            UIApplication.shared.showAlertWith(title: "",message: "Hey \(profile.name), Sie haben Ihr maximales Limit erreicht. Sie können nicht weiter einkaufen.")
                        }
            }else{
                self.shopVoucherBtn.backgroundColor = UIColor(hexString: "#3868F6")
                self.shopVoucherBtn.isUserInteractionEnabled = true
            }
            self.shopVoucherBtn.setTitle( "Diesen Gutschein kaufen", for: .normal)
        }else{
            self.shopVoucherBtn.setTitle( self.getVouchers?.vendor.link, for: .normal)
            self.shopVoucherBtn.isUserInteractionEnabled = true
        }
        
        let iconContainerView: UIView = UIView()
        self.bgView.addSubview(iconContainerView)
        self.iconContainerView = iconContainerView
        iconContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.bgView).offset(30 * AutoSizeScaleX)
            make.height.equalTo(100 * AutoSizeScaleX)
            make.width.equalTo(210 * AutoSizeScaleX)
            make.centerX.equalTo(self.bgView)
        }
        //voucherDetailsborder
        let iconImageView: UIImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        self.iconContainerView.addSubview(iconImageView)
        iconImageView.kf.setImage(with: self.getVouchers?.vendor.imageURL)
        self.iconImageView = iconImageView
        iconImageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(iconContainerView)
        }
        
        let voucherValueLab: UILabel = UILabel()
        voucherValueLab.attributedText = "€\(self.getVouchers?.value ?? 0) \n Gutschein".attributedStringWithColorSize(color: .black, size: 50)
        voucherValueLab.sizeToFit()
        voucherValueLab.textAlignment = .center
        self.bgView.addSubview(voucherValueLab)
        voucherValueLab.backgroundColor = .white
        voucherValueLab.numberOfLines = 0
        voucherValueLab.layer.cornerRadius = 7 * AutoSizeScaleX
        voucherValueLab.layer.borderWidth = 1 * AutoSizeScaleX
        voucherValueLab.layer.borderColor = UIColor.clear.cgColor
        self.voucherValueLab = voucherValueLab
        voucherValueLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.bgView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.bgView.snp_centerX).offset(1 * AutoSizeScaleX)
            make.height.equalTo(100 * AutoSizeScaleX)
            make.top.equalTo(iconContainerView.snp_bottom).offset(40 * AutoSizeScaleX)
        }
        
        let onlineOfflineStatusLab: UILabel = UILabel()
        if(self.getVouchers?.type == "1"){
            onlineOfflineStatusLab.text = "Online"
        }else{
            onlineOfflineStatusLab.text = "Online & Offline"
        }
        onlineOfflineStatusLab.sizeToFit()
        onlineOfflineStatusLab.textAlignment = .center
        onlineOfflineStatusLab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        self.bgView.addSubview(onlineOfflineStatusLab)
        onlineOfflineStatusLab.backgroundColor = .white
        onlineOfflineStatusLab.textColor = .lightGray
        onlineOfflineStatusLab.layer.cornerRadius = 7 * AutoSizeScaleX
        onlineOfflineStatusLab.layer.borderWidth = 1 * AutoSizeScaleX
        onlineOfflineStatusLab.layer.borderColor = UIColor.clear.cgColor
        self.onlineOfflineStatusLab = onlineOfflineStatusLab
        onlineOfflineStatusLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.bgView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(voucherValueLab.snp_right).offset(-1 * AutoSizeScaleX)
            make.height.equalTo(100 * AutoSizeScaleX)
            make.top.equalTo(iconContainerView.snp_bottom).offset(30 * AutoSizeScaleX)
        }
        
        let desciptionLab: UILabel = UILabel()
        desciptionLab.text = self.getVouchers?.vendor.description
        desciptionLab.sizeToFit()
        desciptionLab.textAlignment = .center
        desciptionLab.numberOfLines = 0
        desciptionLab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        self.bgView.addSubview(desciptionLab)
        desciptionLab.textColor = UIColor.init(hexString: "#2B395C")
        desciptionLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-40 * AutoSizeScaleX)
            make.height.equalTo(50 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(40 * AutoSizeScaleX)
            make.top.equalTo(onlineOfflineStatusLab.snp_bottom).offset(16 * AutoSizeScaleX)
        }
        let borderLineLab: UILabel = UILabel()
        borderLineLab.layer.cornerRadius = 7 * AutoSizeScaleX
        borderLineLab.layer.borderWidth = 1 * AutoSizeScaleX
        borderLineLab.layer.borderColor = UIColor.black.cgColor
        self.bgView.addSubview(borderLineLab)
        borderLineLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.bgView).offset(18 * AutoSizeScaleX)
            make.right.equalTo(self.bgView).offset(-18 * AutoSizeScaleX)
            make.height.equalTo(102 * AutoSizeScaleX)
            make.top.equalTo(iconContainerView.snp_bottom).offset(40 * AutoSizeScaleX)
        }
        
        let separateLineLab: UILabel = UILabel()
        separateLineLab.backgroundColor = UIColor.black
        borderLineLab.addSubview(separateLineLab)
        separateLineLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(borderLineLab)
            make.top.bottom.equalTo(borderLineLab)
            make.width.equalTo(1 * AutoSizeScaleX)
        }
        
    }
    @objc func shopVouchersBtnAction(sender: UIButton) {

        if(self.isAllVouchers == true){
            client.shopVoucher(userProductID: self.userProductId, voucherID: self.getVouchers?.id ?? 0) { (message,getData) in
                if(getData == nil){
                    self.showBalanceAmountAlterView(getMessage: message ?? "")
                }else{
                    self.client.getVoucherProduct(vouchersProductID:self.userProductId) { (getVoucherProductData) in
                        self.value_spent = getVoucherProductData?.value_spent ?? ""
                        let getValue_spent:Float = Float(self.value_spent) ?? 0
                        self.still_possible = getVoucherProductData?.still_possible ?? 0
                        self.yourCreditAmountValueLab.text = "\((getValue_spent).priceAsString()) / \(Float(self.budget).priceAsString()) "
                        self.discountAmountLab.text  = "\(Float(self.still_possible).priceAsString()) noch möglich"
                        //=======
                        if(self.isDankeBonusPage == false){
                            if let profile = ApplicationDelegate.client.loggedUser {
    //                            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                                let alert = UIAlertController(title: "", message: "Hallo \(profile.name), Du hast gerade Deinene \"\(self.getVouchers?.vendor.name ?? "")\" Gutschein gekauft. Bitte warten Sie bis Ende des Monats, um es zu aktivieren.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                                    if(self.still_possible == 0){
                                        self.shopVoucherBtn.backgroundColor = UIColor.lightGray
                                        self.shopVoucherBtn.isUserInteractionEnabled = false
                                        for controller in self.navigationController!.viewControllers as Array {
                                            if controller.isKind(of: SachbezugViewController.self) {
                                                self.navigationController!.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    }else{
                                        self.showBalanceAmountAlterView(getMessage: "Hallo, \(profile.name),Du hast Dein maximales Guthaben noch nicht erreicht. Bitte wähle noch weitere Gutscheine. Du hast noch \(self.still_possible) Euro Guthaben übrig. Bitte schließe den Vorgang vor dem 15. des Monats ab.")
                                        
                                    }
                                }))
                                self.present(alert, animated: true, completion: {
                                    print("completion block")
                                })
                            }
                        }else{
                            if let profile = ApplicationDelegate.client.loggedUser {
                                self.showBalanceAmountAlterView(getMessage:"Hallo \(profile.name), Du hast gerade Deinene \"\(self.getVouchers?.vendor.name ?? "")\" Gutschein gekauft. Bitte warten Sie bis Ende des Monats, um es zu aktivieren.")
                            }
                        }
                    }
                }
            }
        }else{
            guard let url = URL(string: "http://\(self.getVouchers?.vendor.link ?? "")") else { return }
            UIApplication.shared.open(url)
        }
    }
    
    @objc func saveDefaultVoucherBtnAction(sender: UIButton) {
        client.saveDefaultVoucher(userProductID: self.userProductId, voucherID: self.getVouchers?.id ?? 0) { (message) in
            self.alterView(getMessage: message ?? "Erfolgreich gespeichert")
        }
    }
    
    func alterView(getMessage : String){
        let alert = UIAlertController(title: getMessage, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                let controller = SachbezugDefaultVoucherVC()
                controller.userProductID = self.userProductId
                self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }))
            self.present(alert, animated: true, completion: {
            })
    }
    
    func showBalanceAmountAlterView(getMessage : String){
        let alert = UIAlertController(title: "", message: getMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: DankeBonusViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                    if controller.isKind(of: SachbezugViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }

}
/*

 */
