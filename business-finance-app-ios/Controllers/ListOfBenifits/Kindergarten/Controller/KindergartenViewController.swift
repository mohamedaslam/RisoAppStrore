//
//  KindergartenViewController.swift
//  BFA
//
//  Created by Mohammed Aslam on 2022/9/12.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class KindergartenViewController:BaseViewController {
    private var nameBGView : UIView = UIView()
    private var genderBGView : UIView = UIView()
    private var dobBGView : UIView = UIView()
    private var kindergartenNameBGView : UIView = UIView()
    private var kindergartenAddrBGView : UIView = UIView()
    private var uploadReceiptBGView : UIView = UIView()
    private var workAddressBGView : UIView = UIView()
    private var commuteToWorkDaysBGView : UIView = UIView()
    private var commuteToWorkTypeBGView : UIView = UIView()
    private var descriptionTF : UITextField = UITextField()
    private var daysPickerView: UIView = UIView()
    private var typePickBGView: UIView = UIView()
    private var selectedDaysLab: UILabel = UILabel()
    private var tapcommuteToWorkDayBGBtn: UIButton = UIButton()
    private var tapcommuteToWorkTypeBGBtn:UIButton = UIButton()
    private var selectedTypeLab: UILabel = UILabel()
    private var getKMbtn:UIButton = UIButton()
    private var workAdressTextView: UITextView = UITextView()
    private var nameTF : UITextField = UITextField()
    private var genderTF : UITextField = UITextField()
    private var dobTF : UITextField = UITextField()
    private var kindergartenNameTF : UITextField = UITextField()
    private var kindergartenAddrTextView : UITextView = UITextView()

    private var getUserTravel: UserTravel?
    private var getCompanyAddress: CompanyAddress?
    var getkindergartenKidsDetails: KindergartenKid?

    private var getUserProductID : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "Anschauen"
        

        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        //configUISetup()
        configUI()
        getUserTravelData()
        
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func getUserTravelData(){

    }

    func configUI(){
        
        let removeChildBtn: UIButton = UIButton(type: .custom)
        removeChildBtn.setTitleColor(UIColor(hexString: "#FF0000"), for: .normal)
        removeChildBtn.setTitle( "Dieses Kind löschen", for: .normal)
        removeChildBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        removeChildBtn.layer.borderWidth = 1 * AutoSizeScaleX
        removeChildBtn.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
        removeChildBtn.layer.shadowColor = UIColor.red.cgColor
        removeChildBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        removeChildBtn.layer.shadowOpacity = 0.12
        removeChildBtn.layer.shadowRadius = 3
        removeChildBtn.addTarget(self, action: #selector(removeChildBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(removeChildBtn)
        removeChildBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let editBtn: UIButton = UIButton(type: .custom)
        editBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        editBtn.setTitle( "Bearbeiten", for: .normal)
        editBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        editBtn.layer.borderWidth = 1 * AutoSizeScaleX
        editBtn.layer.borderColor = UIColor(hexString: "#3868F6").cgColor
        editBtn.layer.shadowColor = UIColor.black.cgColor
        editBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        editBtn.layer.shadowOpacity = 0.12
        editBtn.layer.shadowRadius = 3
        editBtn.addTarget(self, action: #selector(editBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(editBtn)
        editBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(removeChildBtn.snp_top).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let nameBGView: UIView = UIView()
        nameBGView.backgroundColor = .white
        nameBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        nameBGView.layer.shadowColor = UIColor.black.cgColor
        nameBGView.layer.shadowOffset = CGSize.zero
        nameBGView.layer.shadowOpacity = 0.12
        nameBGView.layer.shadowRadius = 3
        self.view.addSubview(nameBGView)
        self.nameBGView = nameBGView
        nameBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(18 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let nameLab: UILabel = UILabel()
        nameLab.font = UIFont.appFont(ofSize: 15, weight: .regular)
        nameLab.textColor = UIColor(hexString: "#2B395C")
        nameLab.text = self.getkindergartenKidsDetails?.name
        nameLab.textAlignment = .left
        nameLab.numberOfLines = 0
        self.nameBGView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(nameBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(nameBGView)
        }
        
        let genderBGView: UIView = UIView()
        genderBGView.backgroundColor = .white
        genderBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        genderBGView.layer.shadowColor = UIColor.black.cgColor
        genderBGView.layer.shadowOffset = CGSize.zero
        genderBGView.layer.shadowOpacity = 0.12
        genderBGView.layer.shadowRadius = 3
        self.view.addSubview(genderBGView)
        self.genderBGView = genderBGView
        genderBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameBGView.snp_bottom).offset(18 * AutoSizeScaleX)
            make.height.left.right.equalTo(self.nameBGView)
        }

        let genderTF: UITextField = UITextField()
        genderTF.font = UIFont.appFont(ofSize: 15, weight: .regular)
        genderTF.textColor = UIColor(hexString: "#2B395C")
        genderTF.isUserInteractionEnabled = false
        genderTF.text = self.getkindergartenKidsDetails?.gender
        self.genderBGView.addSubview(genderTF)
        genderTF.snp.makeConstraints { (make) in
            make.left.equalTo(genderBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(genderBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(genderBGView)
        }
        self.genderTF = genderTF
        
        let dobBGView: UIView = UIView()
        dobBGView.backgroundColor = .white
        dobBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        dobBGView.layer.shadowColor = UIColor.black.cgColor
        dobBGView.layer.shadowOffset = CGSize.zero
        dobBGView.layer.shadowOpacity = 0.12
        dobBGView.layer.shadowRadius = 3
        self.view.addSubview(dobBGView)
        self.dobBGView = dobBGView
        dobBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.genderBGView.snp_bottom).offset(18 * AutoSizeScaleX)
            make.height.left.right.equalTo(self.genderBGView)

        }

        let dobTF: UITextField = UITextField()
        dobTF.font = UIFont.appFont(ofSize: 15, weight: .regular)
        dobTF.textColor = UIColor(hexString: "#2B395C")
        dobTF.isUserInteractionEnabled = false
        dobTF.text = self.getkindergartenKidsDetails?.dob

        self.dobBGView.addSubview(dobTF)
        dobTF.snp.makeConstraints { (make) in
            make.left.equalTo(dobBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(dobBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(dobBGView)
        }
        self.dobTF = dobTF
        
        
        let kindergartenNameBGView: UIView = UIView()
        kindergartenNameBGView.backgroundColor = .white
        kindergartenNameBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        kindergartenNameBGView.layer.shadowColor = UIColor.black.cgColor
        kindergartenNameBGView.layer.shadowOffset = CGSize.zero
        kindergartenNameBGView.layer.shadowOpacity = 0.12
        kindergartenNameBGView.layer.shadowRadius = 3
        self.view.addSubview(kindergartenNameBGView)
        self.kindergartenNameBGView = kindergartenNameBGView
        kindergartenNameBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.dobBGView.snp_bottom).offset(18 * AutoSizeScaleX)
            make.height.left.right.equalTo(self.dobBGView)
        }

        let kindergartenNameLab: UILabel = UILabel()
        kindergartenNameLab.font = UIFont.appFont(ofSize: 15, weight: .regular)
        kindergartenNameLab.textColor = UIColor(hexString: "#2B395C")
        kindergartenNameLab.text = self.getkindergartenKidsDetails?.kinder_garden_name
        kindergartenNameLab.textAlignment = .left
        kindergartenNameLab.numberOfLines = 0
        self.kindergartenNameBGView.addSubview(kindergartenNameLab)
        kindergartenNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kindergartenNameBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(kindergartenNameBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(kindergartenNameBGView)
        }
        
        let kindergartenAddrBGView: UIView = UIView()
        kindergartenAddrBGView.backgroundColor = .white
        kindergartenAddrBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        kindergartenAddrBGView.layer.shadowColor = UIColor.black.cgColor
        kindergartenAddrBGView.layer.shadowOffset = CGSize.zero
        kindergartenAddrBGView.layer.shadowOpacity = 0.12
        kindergartenAddrBGView.layer.shadowRadius = 3
        self.view.addSubview(kindergartenAddrBGView)
        self.kindergartenAddrBGView = kindergartenAddrBGView
        kindergartenAddrBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.kindergartenNameBGView.snp_bottom).offset(18 * AutoSizeScaleX)
            make.left.right.equalTo(self.kindergartenNameBGView)
            make.height.equalTo(90 * AutoSizeScaleX)

        }

        
        let kindergartenAddrLab: UILabel = UILabel()
        kindergartenAddrLab.font = UIFont.appFont(ofSize: 15, weight: .regular)
        kindergartenAddrLab.textColor = UIColor(hexString: "#2B395C")
        kindergartenAddrLab.text = self.getkindergartenKidsDetails?.kinder_garden_address
        kindergartenAddrLab.textAlignment = .left
        kindergartenAddrLab.numberOfLines = 0
        kindergartenAddrBGView.addSubview(kindergartenAddrLab)
        kindergartenAddrLab.snp.makeConstraints { (make) in
            make.left.equalTo(kindergartenAddrBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(kindergartenAddrBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(kindergartenAddrBGView)
        }
    }
    
 
    @objc func backBtnAction(sender: UIButton) {
        self.view.endEditing(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func removeChildBtnAction(sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Bist Du Dir sicher, dass Du mit dem Löschen fortfahren möchtest?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style:
            UIAlertAction.Style.default) {

               UIAlertAction in//self.getReminder!.hashValue
            ApplicationDelegate.client.deleteKid(userID: self.getkindergartenKidsDetails!.hashValue) { [self] message in
                guard let message = message else { return }
                self.alterView(getMessage: message)
            }
        }
        let cancelAction = UIAlertAction(title: "Abbrechen", style:
            UIAlertAction.Style.cancel) {
               UIAlertAction in
            }
        okAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alterView(getMessage : String){
        let alert = UIAlertController(title: getMessage, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: KindergartenListViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
            }))

            self.present(alert, animated: true, completion: {
            })
    }

    
    @objc func editBtnAction(sender: UIButton) {
        let controller = KindergartenEditViewController()
        controller.getkindergartenKidsDetails = self.getkindergartenKidsDetails
        navigationController?.pushAndHideTabBar(controller)
    }
    
}
