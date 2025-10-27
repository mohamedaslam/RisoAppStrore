//
//  ViewDailyCommuterViewController.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/8/26.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import ANActivityIndicator
import Alamofire

class ViewDailyCommuterViewController: BaseViewController {
    private var homeAddressBGView : UIView = UIView()
    private var workAddressBGView : UIView = UIView()
    private var commuteToWorkDaysBGView : UIView = UIView()
    private var commuteToWorkTypeBGView : UIView = UIView()
    private var descriptionTF : UITextField = UITextField()
   // var timeRightArrow: UIImageView = UIImageView()
  //  var typeRightArrow: UIImageView = UIImageView()
    private var daysPickerView: UIView = UIView()
    private var typePickBGView: UIView = UIView()

    private var selectedDaysLab: UILabel = UILabel()
    private var tapcommuteToWorkDayBGBtn: UIButton = UIButton()
    private var tapcommuteToWorkTypeBGBtn:UIButton = UIButton()
    private var selectedTypeLab: UILabel = UILabel()
    private var getKMbtn:UIButton = UIButton()
    private var workAdressTextView: UITextView = UITextView()
    private var homeAddressTextView : UITextView = UITextView()
    private var homeAddrsplaceholderLabel: UILabel = UILabel()
    private var workAddrsplaceholderLabel: UILabel = UILabel()
    private var dontHaveWorkStatusLabel: UILabel = UILabel()
    private var getUserTravel: UserTravel?
    private var getCompanyAddress: CompanyAddress?
    var getUserProductID : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "Fahrtkosten"
        

        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        
        let editBtn =  UIButton(type: .custom)
        editBtn.setTitle("Bearbeiten", for: .normal)
        editBtn.addTarget(self, action: #selector(tapEditBtnAction(sender:)), for: .touchUpInside)
        editBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        editBtn.sizeToFit()
        let barEditButton = UIBarButtonItem(customView: editBtn)
        navigationItem.rightBarButtonItem = barEditButton
        
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
       // self.userTravel = self.getUserTravel
        print("self.getUserTravel?.home_address_line1")

        print(self.getUserTravel?.home_address_line1 ?? "")
        configUISetup()
        getUserTravelData()
        
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        client.getUserTravelData { (userTravel) in

            self.getUserTravel = userTravel
            self.updateUI()
        }
        
        client.getCompanyAddress{ (companyAddress) in

        }
        
        client.getMonthlyTravelStatusAddress { (getMonthlyTravelStatus) in

        }

        
    }
    func getUserTravelData(){

    }

    func configUISetup(){
        let homeAddressBGView: UIView = UIView()
        homeAddressBGView.backgroundColor = .white
        homeAddressBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        homeAddressBGView.layer.shadowColor = UIColor.black.cgColor
        homeAddressBGView.layer.shadowOffset = CGSize.zero
        homeAddressBGView.layer.shadowOpacity = 0.12
        homeAddressBGView.layer.shadowRadius = 3
        self.view.addSubview(homeAddressBGView)
        self.homeAddressBGView = homeAddressBGView
        homeAddressBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.height.equalTo(74 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let homeAddressTextView: UITextView = UITextView()
        homeAddressTextView.font = UIFont.appFont(ofSize: 14, weight: .regular)
        homeAddressTextView.textColor = UIColor(hexString: "#2B395C")
        homeAddressTextView.isUserInteractionEnabled = false
        self.homeAddressBGView.addSubview(homeAddressTextView)
        homeAddressTextView.snp.makeConstraints { (make) in
            make.left.equalTo(homeAddressBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(homeAddressBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(homeAddressBGView)
        }
        self.homeAddressTextView = homeAddressTextView
        
        homeAddrsplaceholderLabel = UILabel()
        homeAddrsplaceholderLabel.text = "Wohnadresse"
        homeAddrsplaceholderLabel.sizeToFit()
        self.homeAddressTextView.addSubview(homeAddrsplaceholderLabel)
        homeAddrsplaceholderLabel.textColor = .lightGray
        homeAddrsplaceholderLabel.isHidden = !homeAddressTextView.text.isEmpty
        homeAddrsplaceholderLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.homeAddressTextView)
            make.left.equalTo(4 * AutoSizeScaleX)
             make.height.equalTo(self.homeAddressTextView)
            make.centerY.equalTo(self.homeAddressTextView).offset(-4 * AutoSizeScaleX)
        }
        
        
        let workAddressBGView: UIView = UIView()
        workAddressBGView.backgroundColor = .white
        workAddressBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        workAddressBGView.layer.shadowColor = UIColor.black.cgColor
        workAddressBGView.layer.shadowOffset = CGSize.zero
        workAddressBGView.layer.shadowOpacity = 0.12
        workAddressBGView.layer.shadowRadius = 3
        self.view.addSubview(workAddressBGView)
        self.workAddressBGView = workAddressBGView
        workAddressBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.homeAddressBGView.snp_bottom).offset(16 * AutoSizeScaleX)
            make.left.right.height.equalTo(homeAddressBGView)
        }

        let workAdressTextView: UITextView = UITextView()
        workAdressTextView.font = UIFont.appFont(ofSize: 14, weight: .regular)
        workAdressTextView.textColor = UIColor(hexString: "#2B395C")
        workAdressTextView.isUserInteractionEnabled = false
        workAddressBGView.addSubview(workAdressTextView)
        workAdressTextView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.homeAddressTextView)
            make.top.equalTo(self.workAddressBGView).offset(4 * AutoSizeScaleX)
            make.bottom.equalTo(self.workAddressBGView)
        }
        self.workAdressTextView = workAdressTextView
        
        workAddrsplaceholderLabel = UILabel()
        workAddrsplaceholderLabel.text = "Arbeitsadresse"
        workAddrsplaceholderLabel.sizeToFit()
        self.workAdressTextView.addSubview(workAddrsplaceholderLabel)
        workAddrsplaceholderLabel.textColor = .lightGray
        workAddrsplaceholderLabel.isHidden = !workAdressTextView.text.isEmpty
        workAddrsplaceholderLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.workAdressTextView)
            make.left.equalTo(4 * AutoSizeScaleX)
             make.height.equalTo(self.workAdressTextView)
            make.centerY.equalTo(self.workAdressTextView).offset(-4 * AutoSizeScaleX)
        }
                
        let distanceLab: UILabel = UILabel()
        distanceLab.text = "Entfernung"
        distanceLab.textColor = UIColor(hexString: "#2B395C")
        distanceLab.font = UIFont.appFont(ofSize: 18, weight: .bold)
        distanceLab.sizeToFit()
        self.view.addSubview(distanceLab)
        distanceLab.isHidden = !homeAddressTextView.text.isEmpty
        distanceLab.snp.makeConstraints { (make) in
            make.width.equalTo(200 * AutoSizeScaleX)
            make.left.equalTo(homeAddressBGView)
            make.height.equalTo(30 * AutoSizeScaleX)
            make.top.equalTo(self.workAddressBGView.snp_bottom).offset(16 * AutoSizeScaleX)
        }
        
        let getKMbtn: UIButton = UIButton(type: .custom)
        getKMbtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        getKMbtn.setTitle( "0 km", for: .normal)
        getKMbtn.titleLabel?.font = UIFont.appFont(ofSize: 16, weight: .regular)
        getKMbtn.layer.cornerRadius = 7 * AutoSizeScaleX
        getKMbtn.layer.borderWidth = 1 * AutoSizeScaleX
        getKMbtn.layer.borderColor = UIColor(hexString: "#3868F6").cgColor
        getKMbtn.layer.shadowColor = UIColor.black.cgColor
        getKMbtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        getKMbtn.layer.shadowOpacity = 0.12
        getKMbtn.layer.shadowRadius = 3
        self.view.addSubview(getKMbtn)
        self.getKMbtn = getKMbtn
        getKMbtn.snp.makeConstraints { (make) in
            make.right.equalTo(homeAddressBGView)
            make.width.equalTo(80 * AutoSizeScaleX)
            make.height.equalTo(34 * AutoSizeScaleX)
            make.top.equalTo(self.workAddressBGView.snp_bottom).offset(16 * AutoSizeScaleX)
        }
               
        let commuteToWorkDaysBGView: UIView = UIView()
        commuteToWorkDaysBGView.backgroundColor = .white
        commuteToWorkDaysBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        commuteToWorkDaysBGView.layer.shadowColor = UIColor.black.cgColor
        commuteToWorkDaysBGView.layer.shadowOffset = CGSize.zero
        commuteToWorkDaysBGView.layer.shadowOpacity = 0.12
        commuteToWorkDaysBGView.layer.shadowRadius = 3
        self.view.addSubview(commuteToWorkDaysBGView)
        self.commuteToWorkDaysBGView = commuteToWorkDaysBGView
        commuteToWorkDaysBGView.snp.makeConstraints { (make) in
            make.top.equalTo(getKMbtn.snp_bottom).offset(20 * AutoSizeScaleX)
            make.left.right.height.equalTo(homeAddressBGView)
        }
        
        let tapcommuteToWorkBGBtn: UIButton = UIButton(type: .custom)
        commuteToWorkDaysBGView.addSubview(tapcommuteToWorkBGBtn)
        self.tapcommuteToWorkDayBGBtn = tapcommuteToWorkBGBtn
        tapcommuteToWorkBGBtn.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalTo(commuteToWorkDaysBGView)
        }
        

        let commuteToWorkLab: UILabel = UILabel()
        commuteToWorkLab.textColor = .lightGray
        commuteToWorkLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        commuteToWorkLab.text = "Anzahl der Tage, die Du zur Arbeit "
        commuteToWorkLab.textColor = UIColor(hexString: "#2B395C")
        commuteToWorkLab.textAlignment = .left
        commuteToWorkLab.numberOfLines = 0
        self.commuteToWorkDaysBGView.addSubview(commuteToWorkLab)
        commuteToWorkLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.homeAddressTextView)
            make.width.equalTo(200 * AutoSizeScaleX)
            make.top.bottom.equalTo(self.commuteToWorkDaysBGView)
        }

        let selectedDaysLab: UILabel = UILabel()
        selectedDaysLab.textColor = .lightGray
        selectedDaysLab.font = UIFont.appFont(ofSize: 15, weight: .regular)
        selectedDaysLab.text = " "
        selectedDaysLab.textAlignment = .right
        self.commuteToWorkDaysBGView.addSubview(selectedDaysLab)
        self.selectedDaysLab = selectedDaysLab
        selectedDaysLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.commuteToWorkDaysBGView).offset(-16 * AutoSizeScaleX)
            make.width.equalTo(100 * AutoSizeScaleX)
            make.top.bottom.equalTo(commuteToWorkLab)
        }

        let daysPickerView: UIView = UIView()
        daysPickerView.backgroundColor = UIColor.App.TableView.grayBackground
        self.view.addSubview(daysPickerView)
        self.daysPickerView = daysPickerView
        daysPickerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.commuteToWorkDaysBGView.snp_bottom).offset(2 * AutoSizeScaleX)
            make.left.right.equalTo(homeAddressBGView)
            make.height.equalTo(0 * AutoSizeScaleX)
        }
        

        let commuteToWorkTypeBGView: UIView = UIView()
        commuteToWorkTypeBGView.backgroundColor = .white
        commuteToWorkTypeBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        commuteToWorkTypeBGView.layer.shadowColor = UIColor.black.cgColor
        commuteToWorkTypeBGView.layer.shadowOffset = CGSize.zero
        commuteToWorkTypeBGView.layer.shadowOpacity = 0.12
        commuteToWorkTypeBGView.layer.shadowRadius = 3
        self.view.addSubview(commuteToWorkTypeBGView)
        self.commuteToWorkTypeBGView = commuteToWorkTypeBGView
        commuteToWorkTypeBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.commuteToWorkDaysBGView.snp_bottom).offset(16 * AutoSizeScaleX)
            make.left.right.height.equalTo(homeAddressBGView)
        }
        
        let commuteToWorkTypeLab: UILabel = UILabel()
        commuteToWorkTypeLab.textColor = .lightGray
        commuteToWorkTypeLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        commuteToWorkTypeLab.text = "Wie pendelst Du zur Arbeit?"
        commuteToWorkTypeLab.textColor = UIColor(hexString: "#2B395C")
        commuteToWorkTypeLab.textAlignment = .left
        commuteToWorkTypeLab.numberOfLines = 0
        self.commuteToWorkTypeBGView.addSubview(commuteToWorkTypeLab)
        commuteToWorkTypeLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.homeAddressTextView)
            make.width.equalTo(200 * AutoSizeScaleX)
            make.top.bottom.equalTo(self.commuteToWorkTypeBGView)
        }

        let selectedTypeLab: UILabel = UILabel()
        selectedTypeLab.textColor = .lightGray
        selectedTypeLab.font = UIFont.appFont(ofSize: 15, weight: .regular)
        selectedTypeLab.text = " "
        selectedTypeLab.textAlignment = .right
        self.commuteToWorkTypeBGView.addSubview(selectedTypeLab)
        self.selectedTypeLab = selectedTypeLab
        selectedTypeLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.commuteToWorkTypeBGView).offset(-16 * AutoSizeScaleX)
            make.width.equalTo(130 * AutoSizeScaleX)
            make.top.bottom.equalTo(commuteToWorkTypeLab)
        }
        
        let tapcommuteToWorkTypeBGBtn: UIButton = UIButton(type: .custom)
        commuteToWorkTypeBGView.addSubview(tapcommuteToWorkTypeBGBtn)
        self.tapcommuteToWorkTypeBGBtn = tapcommuteToWorkTypeBGBtn
        tapcommuteToWorkTypeBGBtn.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalTo(commuteToWorkTypeBGView)
        }

        dontHaveWorkStatusLabel = UILabel()
        dontHaveWorkStatusLabel.text = "Sie haben als `keine Arbeitsadresse haben` festgelegt. Bitte klicken Sie auf die Schaltfläche Bearbeiten, wenn Sie eine Arbeitsadresse hinzufügen möchten."
        dontHaveWorkStatusLabel.backgroundColor = UIColor(hexString: "#FFFDE3")
        dontHaveWorkStatusLabel.sizeToFit()
        dontHaveWorkStatusLabel.font = UIFont.appFont(ofSize: 14, weight: .regular)
        dontHaveWorkStatusLabel.numberOfLines = 0
        self.view.addSubview(dontHaveWorkStatusLabel)
        dontHaveWorkStatusLabel.textColor = .lightGray
        dontHaveWorkStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.commuteToWorkTypeBGView.snp_bottom).offset(16 * AutoSizeScaleX)
            make.left.right.height.equalTo(homeAddressBGView)
        }
        
        updateUI()

    }
    
    func updateUI(){
        if(self.getUserTravel?.no_work_address == 0){
            self.dontHaveWorkStatusLabel.isHidden = true
//            self.homeAddrsplaceholderLabel.isHidden = false
//            self.workAddrsplaceholderLabel.isHidden = false
            self.homeAddressTextView.text = "\(self.getUserTravel?.home_address_line1 ?? "" ) \(self.getUserTravel?.home_address_line2 ?? "") \(self.getUserTravel?.home_zipcode ?? "") \(self.getUserTravel?.home_city ?? "") \(self.getUserTravel?.home_state ?? "") "
            self.workAdressTextView.text = "\(self.getUserTravel?.work_address_line1 ?? "" ) \(self.getUserTravel?.work_address_line2 ?? "") \(self.getUserTravel?.work_zipcode ?? "") \(self.getUserTravel?.work_city ?? "") \(self.getUserTravel?.work_state ?? "") "
            self.homeAddrsplaceholderLabel.isHidden = true
            self.workAddrsplaceholderLabel.isHidden = true
            if(self.getUserTravel?.commuting_distance == -1){
                self.getKMbtn.setTitle("0.0 km", for: .normal)
            }else{
                self.getKMbtn.setTitle(String(format: "%.1f km", self.getUserTravel?.commuting_distance ?? 0.0), for: .normal)
            }
            self.selectedDaysLab.text = String(self.getUserTravel?.days_to_commute_work ?? 0)
            self.selectedTypeLab.text = self.getUserTravel?.commuting_channel ?? ""
        }else{
            self.dontHaveWorkStatusLabel.isHidden = false

        }

    }
    @objc func backBtnAction(sender: UIButton) {
        self.view.endEditing(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapEditBtnAction(sender: UIButton){
               
        let controller = EditDailyCommuterViewController()
        controller.getUserTravel = self.getUserTravel
        controller.getUserProductID = self.getUserTravel?.product_id ?? 15
        navigationController?.pushAndHideTabBar(controller)
    }

}
