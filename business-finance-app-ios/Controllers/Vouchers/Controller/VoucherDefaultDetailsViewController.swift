//
//  VoucherDefaultDetailsViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/2/1.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import UIKit

class VoucherDefaultDetailsViewController:  BaseViewController {
    var yourCreditAmountLab: UILabel = UILabel()
    var yourCreditAmountValueLab: UILabel = UILabel()
    var discountAmountLab: UILabel = UILabel()
    var bgView: UIView = UIView()
    var iconContainerView: UIView = UIView()
    var iconImageView: UIImageView = UIImageView()
    var voucherValueLab: UILabel = UILabel()
    var onlineOfflineStatusLab : UILabel = UILabel()
   // var getVouchers : UserVoucher?
    var getVouchers : UserData?
    var value_spent: String = "0"
    var budget: Int = 0
    var still_possible: Int = 0
    var isSachbezugPage : Bool = false
    var userProductId: Int = 0
    var voucherId: Int = 0
    var isAllVouchers : Bool = false
    var isStilPossibleValue : Bool = false
    var shopVoucherBtn : UIButton = UIButton()
    var markVoucherBtn : UIButton = UIButton()
    var saveDefaultVoucherBtn : UIButton = UIButton()
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
        ifYouNeedHelpLab.text = "Falls Du Hilfe benötigst, schreib' uns bitte an “support@risoapp.zohodesk.eu”"
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
            make.bottom.equalTo(self.view).offset(-30 * AutoSizeScaleX)
        }
        
        let bgView: UIView = UIView()
        self.view.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(separeateLineLab.snp_bottom).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(ifYouNeedHelpLab.snp_top).offset(-40 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(30 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-30 * AutoSizeScaleX)
        }
        
        //voucherDetailsborder
        let bgImageView: UIImageView = UIImageView()
        bgImageView.contentMode = .scaleToFill
        bgImageView.image = UIImage(named: "UservoucherDetails")
        self.bgView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(bgView)
        }
        
        let markVoucherBtn: UIButton = UIButton()
        markVoucherBtn.setTitle(" Als eingelöst markieren", for: .normal)
        markVoucherBtn.titleLabel?.font = .systemFont(ofSize: AutoSizeScale(14))
        markVoucherBtn.setTitleColor(.lightGray, for: .normal)
        markVoucherBtn.setImage(UIImage(named: "tickchecked"), for: .normal)
        markVoucherBtn.imageView?.contentMode = .scaleAspectFit
        markVoucherBtn.setImage(UIImage(named: "tickUnchecked"), for: .selected)
        markVoucherBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        markVoucherBtn.addTarget(self, action: #selector(markVoucherBtnAction(sender:)), for: .touchUpInside)
        markVoucherBtn.isSelected = true
        self.bgView.addSubview(markVoucherBtn)
        markVoucherBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AutoSizeScale(220), height: AutoSizeScale(24)))
            make.left.equalTo(self.bgView).offset(16 * AutoSizeScaleX)
            make.top.equalTo(bgView).offset(AutoSizeScale(14))
        }
        self.markVoucherBtn = markVoucherBtn

        if(self.getVouchers?.voucher_status == 1){
            markVoucherBtn.isHidden = true
        }else{
            markVoucherBtn.isHidden = false
        }
        //
        let iconContainerView: UIView = UIView()
        self.bgView.addSubview(iconContainerView)
        self.iconContainerView = iconContainerView
        iconContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.markVoucherBtn.snp_bottom).offset(6 * AutoSizeScaleX)
            make.height.equalTo(100 * AutoSizeScaleX)
            make.width.equalTo(210 * AutoSizeScaleX)
            make.centerX.equalTo(self.bgView)
        }
        //voucherDetailsborder
        let iconImageView: UIImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        self.iconContainerView.addSubview(iconImageView)
      //  iconImageView.kf.setImage(with: self.getVouchers?.vendor.imageURL)

        self.iconImageView = iconImageView
        iconImageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(iconContainerView)
        }
        
        let voucherValueLab: UILabel = UILabel()
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
            make.right.equalTo(self.bgView.snp_centerX).offset(-24 * AutoSizeScaleX)
            make.height.equalTo(150 * AutoSizeScaleX)
            make.top.equalTo(iconContainerView.snp_bottom).offset(36 * AutoSizeScaleX)
        }
        

        let borderLineLab: UILabel = UILabel()
        borderLineLab.layer.cornerRadius = 7 * AutoSizeScaleX
        borderLineLab.layer.borderWidth = 1 * AutoSizeScaleX
        borderLineLab.layer.borderColor = UIColor.black.cgColor
        self.bgView.addSubview(borderLineLab)
        borderLineLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.bgView).offset(18 * AutoSizeScaleX)
            make.right.equalTo(self.bgView).offset(-18 * AutoSizeScaleX)
            make.height.equalTo(150 * AutoSizeScaleX)
            make.top.equalTo(iconContainerView.snp_bottom).offset(40 * AutoSizeScaleX)
        }
        
        let separateLineLab: UILabel = UILabel()
        separateLineLab.backgroundColor = UIColor.black
        borderLineLab.addSubview(separateLineLab)
        separateLineLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(borderLineLab).offset(-24 * AutoSizeScaleX)
            make.top.bottom.equalTo(borderLineLab)
            make.width.equalTo(1 * AutoSizeScaleX)
        }
        
        let onlineOfflineStatusLab: UILabel = UILabel()
        onlineOfflineStatusLab.sizeToFit()
        onlineOfflineStatusLab.textAlignment = .center
        onlineOfflineStatusLab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        self.bgView.addSubview(onlineOfflineStatusLab)
        onlineOfflineStatusLab.textColor = .lightGray
        onlineOfflineStatusLab.layer.cornerRadius = 7 * AutoSizeScaleX
        onlineOfflineStatusLab.layer.borderWidth = 1 * AutoSizeScaleX
        onlineOfflineStatusLab.layer.borderColor = UIColor.clear.cgColor
        self.onlineOfflineStatusLab = onlineOfflineStatusLab
        onlineOfflineStatusLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.bgView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(voucherValueLab.snp_right).offset(-1 * AutoSizeScaleX)
            make.height.equalTo(20 * AutoSizeScaleX)
            make.top.equalTo(borderLineLab.snp_top).offset(8 * AutoSizeScaleX)
        }
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(hexString: "#2B395C"),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let goToUrVocherBtn: UIButton = UIButton(type: .custom)
        goToUrVocherBtn.setTitleColor(UIColor(hexString: "#2B395C"), for: .normal)
        let attributeString = NSMutableAttributedString(
           string: "Zum Gutschein gehen",
           attributes: yourAttributes
        )
        goToUrVocherBtn.setAttributedTitle(attributeString, for: .normal)
        goToUrVocherBtn.addTarget(self, action: #selector(goToYourVoucherBtnAction(sender:)), for: .touchUpInside)
        self.bgView.addSubview(goToUrVocherBtn)
        //self.goToUrVocherBtn = goToUrVocherBtn
        goToUrVocherBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.bgView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(separateLineLab.snp_right).offset(2 * AutoSizeScaleX)
            make.top.equalTo(onlineOfflineStatusLab.snp_bottom).offset(4 * AutoSizeScaleX)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        
        let voucherCodeLab: UILabel = UILabel()
        voucherCodeLab.text = "Gutschein-Code:"
        voucherCodeLab.sizeToFit()
        voucherCodeLab.textAlignment = .left
        voucherCodeLab.textColor = UIColor.init(named: "#2B395C")
        voucherCodeLab.font = UIFont.appFont(ofSize: 12, weight: .regular)
        self.bgView.addSubview(voucherCodeLab)
        voucherCodeLab.textColor = .lightGray
        voucherCodeLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.bgView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(separateLineLab.snp_right).offset(6 * AutoSizeScaleX)
            make.top.equalTo(goToUrVocherBtn.snp_bottom).offset(6 * AutoSizeScaleX)
            make.height.equalTo(16 * AutoSizeScaleX)
        }
        
        let copyVoucherBtn: UIButton = UIButton(type: .custom)
        copyVoucherBtn.addTarget(self, action: #selector(copyVoucherBtnAction(sender:)), for: .touchUpInside)
        self.bgView.addSubview(copyVoucherBtn)
        copyVoucherBtn.setImage(UIImage.init(named: "copyVoucher"), for: .normal)
       // self.copyVoucherBtn = copyVoucherBtn
        copyVoucherBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.bgView).offset(-24 * AutoSizeScaleX)
            make.width.equalTo(24 * AutoSizeScaleX)
            make.top.equalTo(voucherCodeLab.snp_bottom).offset(6 * AutoSizeScaleX)
            make.height.equalTo(26 * AutoSizeScaleX)
        }
        
        
        let voucherCodeTextLab: UILabel = UILabel()
        voucherCodeTextLab.layer.borderWidth = 1 * AutoSizeScaleX
        voucherCodeTextLab.textAlignment = .center
        voucherCodeTextLab.numberOfLines = 0
        voucherCodeTextLab.textColor = UIColor(hexString: "#2B395C")
        voucherCodeTextLab.sizeToFit()
        voucherCodeTextLab.font = UIFont.appFont(ofSize: 11, weight: .regular)
        voucherCodeTextLab.backgroundColor = UIColor.App.TableView.grayBackground
        voucherCodeTextLab.layer.borderColor = UIColor.black.cgColor
        self.bgView.addSubview(voucherCodeTextLab)

        voucherCodeTextLab.snp.makeConstraints { (make) in
            make.right.equalTo(copyVoucherBtn.snp_left).offset(-6 * AutoSizeScaleX)
            make.left.equalTo(separateLineLab.snp_right).offset(6 * AutoSizeScaleX)
            make.top.equalTo(voucherCodeLab.snp_bottom).offset(4 * AutoSizeScaleX)
            make.height.equalTo(30 * AutoSizeScaleX)
        }
               
        let copyVoucherPinBtn: UIButton = UIButton(type: .custom)
        copyVoucherPinBtn.addTarget(self, action: #selector(copyVoucherPinBtnAction(sender:)), for: .touchUpInside)
        self.bgView.addSubview(copyVoucherPinBtn)
        copyVoucherPinBtn.setImage(UIImage.init(named: "copyVoucher"), for: .normal)
       // self.copyVoucherBtn = copyVoucherBtn
        copyVoucherPinBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.bgView).offset(-44 * AutoSizeScaleX)
            make.width.equalTo(24 * AutoSizeScaleX)
            make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(6 * AutoSizeScaleX)
            make.height.equalTo(26 * AutoSizeScaleX)
        }
        
        
        let voucherPinCodeTextLab: UILabel = UILabel()
        voucherPinCodeTextLab.textAlignment = .left
        voucherPinCodeTextLab.textColor = UIColor(hexString: "#2B395C")
        voucherPinCodeTextLab.font = UIFont.appFont(ofSize: 16, weight: .regular)
        voucherPinCodeTextLab.backgroundColor = .clear
        voucherPinCodeTextLab.layer.borderColor = UIColor.black.cgColor
        self.bgView.addSubview(voucherPinCodeTextLab)
        voucherPinCodeTextLab.snp.makeConstraints { (make) in
            make.right.equalTo(copyVoucherBtn.snp_left).offset(-6 * AutoSizeScaleX)
            make.left.equalTo(separateLineLab.snp_right).offset(6 * AutoSizeScaleX)
            make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(4 * AutoSizeScaleX)
            make.height.equalTo(26 * AutoSizeScaleX)
        }
        
        let shopVoucherBtn: UIButton = UIButton(type: .custom)
        shopVoucherBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        shopVoucherBtn.backgroundColor = UIColor(hexString: "#3868F6")
        shopVoucherBtn.setTitleColor(.white, for: .normal)
        shopVoucherBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        shopVoucherBtn.addTarget(self, action: #selector(shopVouchersBtnAction(sender:)), for: .touchUpInside)
        self.bgView.addSubview(shopVoucherBtn)
        self.shopVoucherBtn = shopVoucherBtn
        shopVoucherBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.bgView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.bgView).offset(20 * AutoSizeScaleX)
            make.top.equalTo(borderLineLab.snp_bottom).offset(20 * AutoSizeScaleX)
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
            make.top.equalTo(borderLineLab.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        if(isSachbezugPage == true){
            saveDefaultVoucherBtn.isHidden = false
            shopVoucherBtn.isHidden = true
        }else{
            saveDefaultVoucherBtn.isHidden = true
            shopVoucherBtn.isHidden = false
        }
        self.shopVoucherBtn.isUserInteractionEnabled = true
        
        let desciptionLab: UILabel = UILabel()
        desciptionLab.sizeToFit()
        desciptionLab.textAlignment = .center
        desciptionLab.numberOfLines = 0
        desciptionLab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        self.bgView.addSubview(desciptionLab)
        desciptionLab.textColor = UIColor.init(hexString: "#2B395C")
        desciptionLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-40 * AutoSizeScaleX)
            make.height.equalTo(70 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(40 * AutoSizeScaleX)
            make.top.equalTo(saveDefaultVoucherBtn.snp_bottom).offset(20 * AutoSizeScaleX)
        }
            
            iconImageView.kf.setImage(with: self.getVouchers?.vendor.imageURL)
            voucherValueLab.attributedText = "€\(self.getVouchers?.value ?? 0) \n Gutschein".attributedStringWithColorSize(color: .black, size: 50)
            if(self.getVouchers?.type == "1"){
                onlineOfflineStatusLab.text = "Online"
            }else{
                onlineOfflineStatusLab.text = "Online & Offline"
            }
        voucherPinCodeTextLab.text = "PIN: \(self.getVouchers?.pin ?? "")"
        shopVoucherBtn.setTitle( "Go to \(self.getVouchers?.vendor.name ?? "")", for: .normal)
        desciptionLab.text = self.getVouchers?.vendor.description
        self.shopVoucherBtn.setTitle( "Gehe zu \(self.getVouchers?.vendor.name ?? "")", for: .normal)
        if((self.getVouchers?.code_url.count)! > 0){
            goToUrVocherBtn.isHidden = false
        }else{
            goToUrVocherBtn.isHidden = true
        }
        if(self.getVouchers?.pin.count == 0){
            voucherPinCodeTextLab.isHidden = true
            copyVoucherPinBtn.isHidden = true
        }else{
            voucherPinCodeTextLab.isHidden = false
            copyVoucherPinBtn.isHidden = false
        }
        if(self.getVouchers?.voucher_type.count == 0){
            voucherCodeTextLab.isHidden = true
            voucherCodeLab.isHidden = true
            copyVoucherBtn.isHidden = true
            if(self.getVouchers?.pin.count == 0){
                copyVoucherPinBtn.snp.updateConstraints { (make) in
                    make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(6 * AutoSizeScaleX)
                }
                voucherPinCodeTextLab.snp.updateConstraints { (make) in
                    make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(4 * AutoSizeScaleX)
                }
            }else{
                copyVoucherPinBtn.snp.updateConstraints { (make) in
                    make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(-36 * AutoSizeScaleX)
                }
                voucherPinCodeTextLab.snp.updateConstraints { (make) in
                    make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(-34 * AutoSizeScaleX)
                }
            }
        }else{
            voucherCodeTextLab.isHidden = false
            voucherCodeLab.isHidden = false
            copyVoucherBtn.isHidden = false
        }
        if(self.getVouchers?.voucher_status == 2){
            markVoucherBtn.setImage(UIImage(named: "tickUnchecked"), for: .selected)
            markVoucherBtn.isEnabled = true
        }else{
            markVoucherBtn.setImage(UIImage(named: "tickchecked"), for: .normal)
            markVoucherBtn.isEnabled = false
        }
        if(self.getVouchers?.voucher_status == 4){
            markVoucherBtn.setImage(UIImage(named: "tickUnchecked"), for: .normal)
            markVoucherBtn.isEnabled = false
        }
        if(isValidUrl(urlString: self.getVouchers?.code_url) == true){
            voucherCodeTextLab.isHidden = true
            voucherCodeLab.isHidden = true
            copyVoucherBtn.isHidden = true
            goToUrVocherBtn.isHidden = false
            if(self.getVouchers?.pin.count == 0){
                copyVoucherPinBtn.snp.updateConstraints { (make) in
                    make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(6 * AutoSizeScaleX)
                }
                voucherPinCodeTextLab.snp.updateConstraints { (make) in
                    make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(4 * AutoSizeScaleX)
                }
            }else{
                copyVoucherPinBtn.snp.updateConstraints { (make) in
                    make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(-36 * AutoSizeScaleX)
                }
                voucherPinCodeTextLab.snp.updateConstraints { (make) in
                    make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(-34 * AutoSizeScaleX)
                }
            }
        }else{
            if((self.getVouchers?.code_url.count)! > 0){
                voucherCodeTextLab.text =  self.getVouchers?.code_url
                goToUrVocherBtn.isHidden = true
                voucherCodeTextLab.isHidden = false
                voucherCodeLab.isHidden = false
                copyVoucherBtn.isHidden = false
            }else{
                goToUrVocherBtn.isHidden = true
                voucherCodeTextLab.isHidden = true
                voucherCodeLab.isHidden = true
                copyVoucherBtn.isHidden = true
                if(self.getVouchers?.pin.count == 0){
                    copyVoucherPinBtn.snp.updateConstraints { (make) in
                        make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(6 * AutoSizeScaleX)
                    }
                    voucherPinCodeTextLab.snp.updateConstraints { (make) in
                        make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(4 * AutoSizeScaleX)
                    }
                }else{
                    copyVoucherPinBtn.snp.updateConstraints { (make) in
                        make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(-36 * AutoSizeScaleX)
                    }
                    voucherPinCodeTextLab.snp.updateConstraints { (make) in
                        make.top.equalTo(voucherCodeTextLab.snp_bottom).offset(-34 * AutoSizeScaleX)
                    }
                }

            }
        }
    }
    
    func isValidUrl (urlString: String?) -> Bool {
       if let urlString = urlString {
           if let url  = NSURL(string: urlString) {
               return UIApplication.shared.canOpenURL(url as URL)
           }
       }
       return false
    }
    
    @objc func markVoucherBtnAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        client.redeemVoucher(voucherID: self.getVouchers!.id) { (message) in
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                        self.markVoucherBtn.isEnabled = false

                    }))
                    self.present(alert, animated: true, completion: {
                        print("completion block")
                    })
        }

    }
    
    
    @objc func shopVouchersBtnAction(sender: UIButton) {

        guard let url = URL(string: self.getVouchers?.vendor.link ?? "") else { return }
            UIApplication.shared.open(url)
    }
    
    @objc func goToYourVoucherBtnAction(sender : UIButton){
        
        let controller = VoucherWebviewViewController()
        controller.getVoucherURLStr = self.getVouchers?.code_url ?? ""
        self.navigationController?.pushAndHideTabBar(controller, animated: true)
    }
    
    @objc func saveDefaultVoucherBtnAction(sender: UIButton) {
        client.saveDefaultVoucher(userProductID: self.userProductId, voucherID: self.getVouchers?.id ?? 0) { (message) in

            self.alterView(getMessage: message ?? "Erfolgreich gespeichert")
        }
    }
    
    @objc func copyVoucherBtnAction(sender:UIButton){
        UIPasteboard.general.string = self.getVouchers?.code_url
        self.showToast(message: "In Zwischenablage kopiert.", font: .systemFont(ofSize: 12.0))

    }
    @objc func copyVoucherPinBtnAction(sender:UIButton){
        UIPasteboard.general.string = self.getVouchers?.pin
        self.showToast(message: "In Zwischenablage kopiert.", font: .systemFont(ofSize: 12.0))

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
}
extension VoucherDefaultDetailsViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 80 * AutoSizeScaleX, y: self.view.frame.size.height-100 * AutoSizeScaleX, width: 170 * AutoSizeScaleX, height: 35 * AutoSizeScaleX))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
//1- 
extension String {
//    func isValidUrl() -> Bool {
//        let regex = "((http|https|ftp)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        return predicate.evaluate(with: self)
//    }

}
