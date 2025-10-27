//
//  DailyCommuterMonthlyConfirmationVC.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/9/17.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class DailyCommuterMonthlyConfirmationVC:BaseViewController {
    private var homeAddrStrLab: UILabel = UILabel()
    private var workAddrStrLab: UILabel = UILabel()
    private var distanceStrLab: UILabel = UILabel()
    private var CommuterWorkDaysStrLab: UILabel = UILabel()
    private var commuterWorkTypeStrLab: UILabel = UILabel()
    private var getUserTravel: UserTravel?
    var isListOfNotificationPage: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.navigationItem.title = "Monatliche Bestätigung"
        self.navigationItem.setHidesBackButton(true, animated: false)

        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Sind folgende Daten für Deinen Fahrtkostenzuschuss noch aktuell?"
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor(hexString: "#2B395C")
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.appFont(ofSize: 15 * AutoSizeScaleX, weight: .bold)
        titleLabel.sizeToFit()
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
        }
               
        let noBtn: UIButton = UIButton(type: .custom)
        noBtn.setTitleColor(UIColor(hexString: "#FF0000"), for: .normal)
        noBtn.setTitle( "Nein", for: .normal)
        noBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        noBtn.layer.borderWidth = 1 * AutoSizeScaleX
        noBtn.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
        noBtn.layer.shadowColor = UIColor.black.cgColor
        noBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        noBtn.layer.shadowOpacity = 0.12
        noBtn.layer.shadowRadius = 3
        noBtn.addTarget(self, action: #selector(noBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(noBtn)
        noBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(self.view.snp_bottom).offset(-40 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let yesBtn: UIButton = UIButton(type: .custom)
        yesBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        yesBtn.setTitle( "Ja", for: .normal)
        yesBtn.backgroundColor = UIColor(hexString: "#3868F6")
        yesBtn.setTitleColor(.white, for: .normal)
        yesBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        yesBtn.addTarget(self, action: #selector(yesBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(yesBtn)
        yesBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(noBtn.snp_top).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let homeAddrLab: UILabel = UILabel()
        homeAddrLab.text = "Wohnadresse"
        homeAddrLab.textAlignment = .left
        homeAddrLab.font = UIFont.appFont(ofSize: 16 * AutoSizeScaleX, weight: .bold)
        self.view.addSubview(homeAddrLab)
        homeAddrLab.textColor = UIColor(hexString: "#222B45")
        homeAddrLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(titleLabel.snp_bottom).offset(30 * AutoSizeScaleX)
            make.height.width.equalTo(20 * AutoSizeScaleX)
        }
        
        let homeAddrStrLab: UILabel = UILabel()
        homeAddrStrLab.text = "Wohnadresse"
        homeAddrStrLab.textAlignment = .left
        homeAddrStrLab.numberOfLines = 0
        homeAddrStrLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        self.view.addSubview(homeAddrStrLab)
        self.homeAddrStrLab = homeAddrStrLab
        homeAddrStrLab.textColor = UIColor(hexString: "#2B395C")
        homeAddrStrLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(homeAddrLab)
            make.top.equalTo(homeAddrLab.snp_bottom).offset(2 * AutoSizeScaleX)
            make.height.width.equalTo(40 * AutoSizeScaleX)
        }
        
        let homeAddrSeparateLine: UILabel = UILabel()
        homeAddrSeparateLine.backgroundColor = .lightGray
        self.view.addSubview(homeAddrSeparateLine)
        homeAddrSeparateLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(homeAddrLab)
            make.top.equalTo(homeAddrStrLab.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
        }
        
        let workAddrLab: UILabel = UILabel()
        workAddrLab.text = "Arbeitsadresse"
        workAddrLab.textAlignment = .left
        workAddrLab.font = UIFont.appFont(ofSize: 16 * AutoSizeScaleX, weight: .bold)
        self.view.addSubview(workAddrLab)
        workAddrLab.textColor = UIColor(hexString: "#222B45")
        workAddrLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(homeAddrSeparateLine.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.width.equalTo(24 * AutoSizeScaleX)
        }
        
        let workAddrStrLab: UILabel = UILabel()
        workAddrStrLab.text = "Arbeitsadresse"
        workAddrStrLab.textAlignment = .left
        workAddrStrLab.numberOfLines = 0
        workAddrStrLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        self.view.addSubview(workAddrStrLab)
        self.workAddrStrLab = workAddrStrLab
        workAddrStrLab.textColor = UIColor(hexString: "#2B395C")
        workAddrStrLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(workAddrLab)
            make.top.equalTo(workAddrLab.snp_bottom).offset(2 * AutoSizeScaleX)
            make.height.width.equalTo(40 * AutoSizeScaleX)
        }
        
        let workAddrSeparateLine: UILabel = UILabel()
        workAddrSeparateLine.backgroundColor = .lightGray
        self.view.addSubview(workAddrSeparateLine)
        workAddrSeparateLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(workAddrLab)
            make.top.equalTo(workAddrStrLab.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
        }
        
        let distanceLab: UILabel = UILabel()
        distanceLab.text = "Entfernung"
        distanceLab.textAlignment = .left
        distanceLab.font = UIFont.appFont(ofSize: 16 * AutoSizeScaleX, weight: .bold)
        self.view.addSubview(distanceLab)
        distanceLab.textColor = UIColor(hexString: "#222B45")
        distanceLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(workAddrSeparateLine.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.width.equalTo(20 * AutoSizeScaleX)
        }
        
        let distanceStrLab: UILabel = UILabel()
        distanceStrLab.text = "20 KM"
        distanceStrLab.textAlignment = .right
        distanceStrLab.numberOfLines = 0
        distanceStrLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        self.view.addSubview(distanceStrLab)
        self.distanceStrLab = distanceStrLab
        distanceStrLab.textColor = UIColor(hexString: "#2B395C")
        distanceStrLab.snp.makeConstraints { (make) in
            make.right.equalTo(distanceLab)
            make.top.width.height.equalTo(distanceLab)
        }
        
        let distanceSeparateLine: UILabel = UILabel()
        distanceSeparateLine.backgroundColor = .lightGray
        self.view.addSubview(distanceSeparateLine)
        distanceSeparateLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(distanceLab)
            make.top.equalTo(distanceStrLab.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
        }
        
        let CommuterWorkDaysLab: UILabel = UILabel()
        CommuterWorkDaysLab.text = "Anzahl der Tage, die Du zur Arbeit  "
        CommuterWorkDaysLab.textAlignment = .left
        CommuterWorkDaysLab.font = UIFont.appFont(ofSize: 16 * AutoSizeScaleX, weight: .bold)
        self.view.addSubview(CommuterWorkDaysLab)
        CommuterWorkDaysLab.textColor = UIColor(hexString: "#222B45")
        CommuterWorkDaysLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(distanceSeparateLine.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.width.equalTo(20 * AutoSizeScaleX)
        }
        
        let CommuterWorkDaysStrLab: UILabel = UILabel()
        CommuterWorkDaysStrLab.text = "14"
        CommuterWorkDaysStrLab.textAlignment = .right
        CommuterWorkDaysStrLab.numberOfLines = 0
        CommuterWorkDaysStrLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        self.view.addSubview(CommuterWorkDaysStrLab)
        self.CommuterWorkDaysStrLab = CommuterWorkDaysStrLab
        CommuterWorkDaysStrLab.textColor = UIColor(hexString: "#2B395C")
        CommuterWorkDaysStrLab.snp.makeConstraints { (make) in
            make.right.equalTo(CommuterWorkDaysLab)
            make.top.width.height.equalTo(CommuterWorkDaysLab)
        }
        
        let commuterWorkDaysSeparateLine: UILabel = UILabel()
        commuterWorkDaysSeparateLine.backgroundColor = .lightGray
        self.view.addSubview(commuterWorkDaysSeparateLine)
        commuterWorkDaysSeparateLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(CommuterWorkDaysLab)
            make.top.equalTo(CommuterWorkDaysStrLab.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
        }
        
        let commuterWorkTypeLab: UILabel = UILabel()
        commuterWorkTypeLab.text = "Wie pendelst Du zur Arbeit? "
        commuterWorkTypeLab.textAlignment = .left
        commuterWorkTypeLab.font = UIFont.appFont(ofSize: 16 * AutoSizeScaleX, weight: .bold)
        self.view.addSubview(commuterWorkTypeLab)
        commuterWorkTypeLab.textColor = UIColor(hexString: "#222B45")
        commuterWorkTypeLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(commuterWorkDaysSeparateLine.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.width.equalTo(20 * AutoSizeScaleX)
        }
        
        let commuterWorkTypeStrLab: UILabel = UILabel()
        commuterWorkTypeStrLab.text = "14"
        commuterWorkTypeStrLab.textAlignment = .right
        commuterWorkTypeStrLab.numberOfLines = 0
        commuterWorkTypeStrLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        self.view.addSubview(commuterWorkTypeStrLab)
        self.commuterWorkTypeStrLab = commuterWorkTypeStrLab
        commuterWorkTypeStrLab.textColor = UIColor(hexString: "#2B395C")
        commuterWorkTypeStrLab.snp.makeConstraints { (make) in
            make.right.equalTo(commuterWorkTypeLab)
            make.top.width.height.equalTo(commuterWorkTypeLab)
        }
        
        let commuterWorkTypeSeparateLine: UILabel = UILabel()
        commuterWorkTypeSeparateLine.backgroundColor = .lightGray
        self.view.addSubview(commuterWorkTypeSeparateLine)
        commuterWorkTypeSeparateLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(commuterWorkTypeLab)
            make.top.equalTo(commuterWorkTypeLab.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
        }

    }
    func getUserTravelData(){
        client.getUserTravelData { (userTravel) in
            self.getUserTravel = userTravel
            self.homeAddrStrLab.text = "\(self.getUserTravel?.home_address_line1 ?? "" ) \(self.getUserTravel?.home_address_line2 ?? "") \(self.getUserTravel?.home_city ?? "") \(self.getUserTravel?.home_state ?? "") \(self.getUserTravel?.home_zipcode ?? "")"
            self.workAddrStrLab.text = "\(self.getUserTravel?.work_address_line1 ?? "" ) \(self.getUserTravel?.work_address_line2 ?? "") \(self.getUserTravel?.work_city ?? "") \(self.getUserTravel?.work_state ?? "") \(self.getUserTravel?.work_zipcode ?? "")"
            self.distanceStrLab.text = String(format: "%.1f km", self.getUserTravel?.commuting_distance ?? 0.0)
            self.CommuterWorkDaysStrLab.text = String(self.getUserTravel?.days_to_commute_work ?? 0)
            self.commuterWorkTypeStrLab.text = self.getUserTravel?.commuting_channel ?? ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let getNotificationID = ITNSUserDefaults.value(forKey: "notification_id") as? String {
            let getNotificationIDValue = Int(getNotificationID ?? "")!

            ApplicationDelegate.client.updateNotificationMsg(Id:getNotificationIDValue) { [self] message in
            }
        }
        getUserTravelData()
    }
    
    @objc func yesBtnAction(sender: UIButton) {
        self.client.postMonthlyTravelStatusAddress{ (getPostMonthlyTravelStatus) in
        }
        if(self.isListOfNotificationPage == false){
            ITNSUserDefaults.set(true, forKey: "PieChartTourGuideHide")
        }
        let alert = UIAlertController(title: "Vielen Dank für Deine Bestätigung!", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style:
            UIAlertAction.Style.default) {
               UIAlertAction in
            self.navigationController?.popViewController(animated: false)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)

    }
    @objc func noBtnAction(sender: UIButton) {
        if(self.isListOfNotificationPage == false){
            ITNSUserDefaults.set(true, forKey: "PieChartTourGuideHide")
        }
        let controller = ViewDailyCommuterViewController()
        self.navigationController?.pushAndHideTabBar(controller)
    }

}
