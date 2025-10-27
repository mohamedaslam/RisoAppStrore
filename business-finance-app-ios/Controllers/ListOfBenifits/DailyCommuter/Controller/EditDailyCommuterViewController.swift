//
//  EditDailyCommuterViewController.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/8/26.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GooglePlaces
import ANActivityIndicator
import SwiftyJSON
import Alamofire
class EditDailyCommuterViewController: BaseViewController,UIPickerViewDelegate, UIPickerViewDataSource,GetDataDelegte {
    private var commuterStore = DailyCommuterStore()

    var homeAddressBGView : UIView = UIView()
    var workAddressBGView : UIView = UIView()
    var commuteToWorkDaysBGView : UIView = UIView()
    var commuteToWorkTypeBGView : UIView = UIView()
    var expandWorkAddressView : UIView = UIView()
  //  var titleTF : UITextField = UITextField()
    var descriptionTF : UITextField = UITextField()
    var timeRightArrow: UIImageView = UIImageView()
    var typeRightArrow: UIImageView = UIImageView()
    var workAddressDownArrow: UIImageView = UIImageView()
    var daysPickerView: UIView = UIView()
    var typePickBGView: UIView = UIView()
    var commuteToDaysPicker: UIPickerView = UIPickerView()
   // var pickerView: UIPickerView!
    private var isTimePickerOpened: Bool = false
    var date: Date = Date()
    var datePicker: UIDatePicker = UIDatePicker()

    var selectedDaysLab: UILabel = UILabel()
    var tapcommuteToWorkDayBGBtn: UIButton = UIButton()
    var tapcommuteToWorkTypeBGBtn:UIButton = UIButton()
    var dontHaveWorkAddrBtn : UIButton = UIButton()
    var getKMbtn:UIButton = UIButton()
    var addNewAddressBtn:UIButton = UIButton()
    var workAddressBGBtn:UIButton = UIButton()
    var selectedTypeLab: UILabel = UILabel()
    private var workAdressTextView: UITextView = UITextView()
    private var homeAddressTextView : UITextView = UITextView()
    private let destribeMaxLength = 80
    private var countLab: UILabel = UILabel()
    private var homeAddrsplaceholderLabel: UILabel = UILabel()
    private var workAddrplaceholderLabel: UILabel = UILabel()
    private var workDefaultAddressLab: UILabel = UILabel()
    private var workNewAddressLab: UILabel = UILabel()
    private var placesClient: GMSPlacesClient!
    var getUserTravel: UserTravel?
    var getCompanyAddress: CompanyAddress?
    var home_address_line1: String = ""
    var home_address_line2: String = ""
    var home_city: String = ""
    var home_state: String = ""
    var home_zipcode: String = ""
    var home_latitude: Double = -1
    var home_longitude: Double = -1
    var work_address_line1: String = ""
    var work_address_line2: String = ""
    var work_city: String = ""
    var work_state: String = ""
    var work_zipcode: String = ""
    var work_latitude: Double = -1
    var work_longitude: Double = -1
    var work_custom_address_line1: String = ""
    var work_custom_address_line2: String = ""
    var work_custom_city: String = ""
    var work_custom_state: String = ""
    var work_custom_zipcode: String = ""
    var work_custom_latitude: Double = -1
    var work_custom_longitude: Double = -1
    var commuting_distance : Double = 0
    var is_approved : Int = 0
    var commuting_channel : String = ""
    var selectedRow = -1
    var getUserProductID : Int = 0
    var is_custom_work_address : Int = 0
    var getDistanceKM : Float = 0
    var days_to_commute_work : Int = 1
    let daysArray = ["1", "2", "3", "4", "5","6", "7", "8", "9", "10","11", "12", "13", "14", "15"]
    var selectionList: SelectionList!
    var getDistanceKmStr: String = ""
    var getDistanceStatusStr: String = ""
    var no_work_address : Int = 0

    let benifitsListArray = [
        "Firmenwagen",
        "Öffentliche Verkehrsmittel",
        "Sonstige",
        "Gemischt"
    ]
    var tableView: UITableView!
    var workAddressTableView: UITableView!

    var homeLatitude : Double = 0
    var homeLongtitude : Double = 0
    var workLatitude : Double = 0
    var workLongtitude : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()

        
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "Bearbeiten"
        
        // Delegate設定

        
        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        
        configUISetup()
                
        //My location
        let myLocation = CLLocation(latitude: 12.970541439725256, longitude: 77.60971848711716)

        //My Next Destination
        let myNextDestination = CLLocation(latitude: 12.9620535, longitude: 77.6048052)

        //Finding my distance to my next destination (in km)
        let distance = myLocation.distance(from: myNextDestination) / 1000
        updateUI()
   
        if(self.getUserTravel?.no_work_address == 1){
//            self.is_custom_work_address = 1

            self.workAddressBGView.backgroundColor = UIColor.App.TableView.grayBackground
            self.commuteToWorkDaysBGView.backgroundColor = UIColor.App.TableView.grayBackground
            self.commuteToWorkTypeBGView.backgroundColor = UIColor.App.TableView.grayBackground
            self.workAdressTextView.backgroundColor = UIColor.App.TableView.grayBackground
            self.homeAddressBGView.backgroundColor = UIColor.App.TableView.grayBackground
            self.homeAddressTextView.backgroundColor = UIColor.App.TableView.grayBackground
        }else{
//            self.is_custom_work_address = 0

            self.workAddressBGView.backgroundColor = .white
            self.commuteToWorkDaysBGView.backgroundColor = .white
            self.commuteToWorkTypeBGView.backgroundColor = .white
            self.workAdressTextView.backgroundColor = .white
            self.homeAddressTextView.backgroundColor = .white
            self.homeAddressBGView.backgroundColor = .white
        }

    }
    
    func configUISetup(){
        
        let cancleBtn: UIButton = UIButton(type: .custom)
        cancleBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        cancleBtn.setTitle( "Abbrechen", for: .normal)
        cancleBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        cancleBtn.layer.borderWidth = 1 * AutoSizeScaleX
        cancleBtn.layer.borderColor = UIColor(hexString: "#3868F6").cgColor
        cancleBtn.layer.shadowColor = UIColor.black.cgColor
        cancleBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        cancleBtn.layer.shadowOpacity = 0.12
        cancleBtn.layer.shadowRadius = 3
        cancleBtn.addTarget(self, action: #selector(cancelBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let submitBtn: UIButton = UIButton(type: .custom)
        submitBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        submitBtn.setTitle( "Einreichen", for: .normal)
        submitBtn.backgroundColor = UIColor(hexString: "#3868F6")
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        submitBtn.addTarget(self, action: #selector(submitBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(cancleBtn.snp_top).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
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
            make.top.equalTo(self.view).offset(14 * AutoSizeScaleX)
            make.height.equalTo(74 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let homeAddressBGBtn: UIButton = UIButton(type: .custom)
        homeAddressBGBtn.addTarget(self, action: #selector(homeAddressBGBtnAction(sender:)), for: .touchUpInside)
        homeAddressBGBtn.layer.cornerRadius = 15 * AutoSizeScaleX
        homeAddressBGBtn.backgroundColor = UIColor(hexString: "#3868F6")
        homeAddressBGBtn.setImage(UIImage(named:"editUser"), for: .normal)
        self.homeAddressBGView.addSubview(homeAddressBGBtn)
        homeAddressBGBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.homeAddressBGView)
            make.height.width.equalTo(30 * AutoSizeScaleX)
            make.right.equalTo(self.homeAddressBGView).offset(-10 * AutoSizeScaleX)
        }
        
        let homeAddressTextView: UITextView = UITextView()
        homeAddressTextView.font = UIFont.appFont(ofSize: 14, weight: .regular)
        homeAddressTextView.textColor = UIColor(hexString: "#2B395C")
        homeAddressTextView.delegate = self
        homeAddressTextView.text = self.getUserTravel?.home_address_line1

        homeAddressTextView.centerVerticalText()
        homeAddressTextView.alignTextVerticallyInContainer()
        homeAddressTextView.isUserInteractionEnabled = false
        homeAddressTextView.returnKeyType = .done
        self.homeAddressBGView.addSubview(homeAddressTextView)
        homeAddressTextView.snp.makeConstraints { (make) in
            make.left.equalTo(homeAddressBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(homeAddressBGBtn.snp_left).offset(-10 * AutoSizeScaleX)
            make.top.equalTo(homeAddressBGView).offset(6 * AutoSizeScaleX)
            make.bottom.equalTo(homeAddressBGView)
        }
        self.homeAddressTextView = homeAddressTextView
        
        let homeAddrsplaceholderLabel: UILabel = UILabel()
        homeAddrsplaceholderLabel.text = "Wohnadresse"
        homeAddrsplaceholderLabel.sizeToFit()
        self.homeAddressTextView.addSubview(homeAddrsplaceholderLabel)
        homeAddrsplaceholderLabel.textColor = .lightGray
       // homeAddrsplaceholderLabel.isHidden = !homeAddressTextView.text.isEmpty
        self.homeAddrsplaceholderLabel = homeAddrsplaceholderLabel
        homeAddrsplaceholderLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.homeAddressTextView)
            make.left.equalTo(4 * AutoSizeScaleX)
             make.height.equalTo(self.homeAddressTextView)
            make.centerY.equalTo(self.homeAddressTextView).offset(-4 * AutoSizeScaleX)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapHomeAddress(_:)))
        self.homeAddressBGView.addGestureRecognizer(tap)
        
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
        
        let workAddressBGBtn: UIButton = UIButton(type: .custom)
        workAddressBGBtn.addTarget(self, action: #selector(workAddressBGBtnAction(sender:)), for: .touchUpInside)
        self.workAddressBGView.addSubview(workAddressBGBtn)
        self.workAddressBGBtn = workAddressBGBtn
        workAddressBGBtn.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.workAddressBGView)
        }
        
        let workAddressDownArrow: UIImageView = UIImageView()
        workAddressDownArrow.image = UIImage.init(named: "customAddDownArrow")
        workAddressDownArrow.contentMode = .scaleAspectFit
        self.workAddressBGView.addSubview(workAddressDownArrow)
        workAddressDownArrow.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.workAddressBGView)
            make.height.width.equalTo(18 * AutoSizeScaleX)
            make.right.equalTo(self.workAddressBGView).offset(-14 * AutoSizeScaleX)
        }
        self.workAddressDownArrow = workAddressDownArrow
        
        let workAdressTextView: UITextView = UITextView()
        workAdressTextView.font = UIFont.appFont(ofSize: 14, weight: .regular)
        workAdressTextView.textColor = UIColor(hexString: "#2B395C")
        workAdressTextView.delegate = self
        workAdressTextView.isUserInteractionEnabled = false
        workAdressTextView.centerVerticalText()
        workAdressTextView.returnKeyType = .done
        workAddressBGView.addSubview(workAdressTextView)
        workAdressTextView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.homeAddressTextView)
            make.top.equalTo(self.workAddressBGView).offset(6 * AutoSizeScaleX)
            make.bottom.equalTo(self.workAddressBGView)
        }
        self.workAdressTextView = workAdressTextView
        
        let workAddrplaceholderLabel: UILabel =  UILabel()
        workAddrplaceholderLabel.text = "Arbeitsadresse"
        workAddrplaceholderLabel.sizeToFit()
        self.workAdressTextView.addSubview(workAddrplaceholderLabel)
        workAddrplaceholderLabel.textColor = .lightGray
        //workAddrplaceholderLabel.isHidden = !workAdressTextView.text.isEmpty
        self.workAddrplaceholderLabel = workAddrplaceholderLabel
        workAddrplaceholderLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.workAdressTextView)
            make.left.equalTo(4 * AutoSizeScaleX)
             make.height.equalTo(self.workAdressTextView)
            make.centerY.equalTo(self.workAdressTextView).offset(-4 * AutoSizeScaleX)
        }
        
        let dontHaveWorkAddrBtn: UIButton = UIButton()
        dontHaveWorkAddrBtn.setTitle(" Ich habe keine Arbeitsadresse.", for: .normal)
        dontHaveWorkAddrBtn.titleLabel?.font = .systemFont(ofSize: AutoSizeScale(12))
        dontHaveWorkAddrBtn.setTitleColor(.lightGray, for: .normal)
        dontHaveWorkAddrBtn.setImage(UIImage(named: "tickchecked"), for: .normal)
        dontHaveWorkAddrBtn.imageView?.contentMode = .scaleAspectFit
        dontHaveWorkAddrBtn.setImage(UIImage(named: "tickUnchecked"), for: .selected)
        dontHaveWorkAddrBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        dontHaveWorkAddrBtn.addTarget(self, action: #selector(dontHaveWorkAddrBtnAction(sender:)), for: .touchUpInside)
        dontHaveWorkAddrBtn.isSelected = true
        self.view.addSubview(dontHaveWorkAddrBtn)
        self.dontHaveWorkAddrBtn = dontHaveWorkAddrBtn
        dontHaveWorkAddrBtn.snp.makeConstraints { (make) in
            make.left.equalTo(homeAddressBGView)
            make.top.equalTo(self.workAddressBGView.snp_bottom).offset(16 * AutoSizeScaleX)
            make.height.equalTo(24 * AutoSizeScaleX)
            make.width.equalTo(250 * AutoSizeScaleX)
        }
        
        let distanceLab: UILabel = UILabel()
        distanceLab.text = "Entfernung"
        distanceLab.textColor = UIColor(hexString: "#2B395C")
        distanceLab.font = UIFont.appFont(ofSize: 18, weight: .bold)
        distanceLab.sizeToFit()
        self.view.addSubview(distanceLab)
        distanceLab.snp.makeConstraints { (make) in
            make.width.equalTo(200 * AutoSizeScaleX)
            make.left.equalTo(homeAddressBGView)
            make.height.equalTo(30 * AutoSizeScaleX)
            make.top.equalTo(dontHaveWorkAddrBtn.snp_bottom).offset(18 * AutoSizeScaleX)
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
        getKMbtn.addTarget(self, action: #selector(getKMbtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(getKMbtn)
        self.getKMbtn = getKMbtn
        getKMbtn.snp.makeConstraints { (make) in
            make.right.equalTo(homeAddressBGView)
            make.width.equalTo(80 * AutoSizeScaleX)
            make.height.equalTo(34 * AutoSizeScaleX)
            make.top.equalTo(dontHaveWorkAddrBtn.snp_bottom).offset(18 * AutoSizeScaleX)
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
            make.left.right.equalTo(homeAddressBGView)
            make.height.equalTo(60 * AutoSizeScaleX)
        }
        
        let tapcommuteToWorkBGBtn: UIButton = UIButton(type: .custom)
        tapcommuteToWorkBGBtn.addTarget(self, action: #selector(tapcommuteToWorkAction(sender:)), for: .touchUpInside)
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
        commuteToWorkLab.numberOfLines = 0
        commuteToWorkLab.textAlignment = .left
        self.commuteToWorkDaysBGView.addSubview(commuteToWorkLab)
        commuteToWorkLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.homeAddressTextView)
            make.width.equalTo(200 * AutoSizeScaleX)
            make.top.bottom.equalTo(self.commuteToWorkDaysBGView)
        }

        let timeRightArrow: UIImageView = UIImageView()
        timeRightArrow.image = UIImage.init(named: "RightArrow")
        timeRightArrow.contentMode = .scaleAspectFit
        self.commuteToWorkDaysBGView.addSubview(timeRightArrow)
        timeRightArrow.snp.makeConstraints { (make) in
            make.right.equalTo(self.commuteToWorkDaysBGView).offset(-6 * AutoSizeScaleX)
            make.centerY.equalTo(self.commuteToWorkDaysBGView)
            make.width.height.equalTo(18 * AutoSizeScaleX)
        }
        self.timeRightArrow = timeRightArrow

        let selectedDaysLab: UILabel = UILabel()
        selectedDaysLab.textColor = .lightGray
        selectedDaysLab.font = UIFont.appFont(ofSize: 15, weight: .regular)
        selectedDaysLab.text = " "
        selectedDaysLab.textAlignment = .right
        self.commuteToWorkDaysBGView.addSubview(selectedDaysLab)
        self.selectedDaysLab = selectedDaysLab
        selectedDaysLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.timeRightArrow.snp_left).offset(-10 * AutoSizeScaleX)
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
        
        let UIPicker: UIPickerView = UIPickerView()
        UIPicker.delegate = self
        UIPicker.dataSource = self
        UIPicker.backgroundColor = .white
        self.view.addSubview(UIPicker)
        UIPicker.center = self.view.center
        daysPickerView.addSubview(UIPicker)
        UIPicker.snp.makeConstraints { (make) in
            make.top.bottom.right.left.equalTo(daysPickerView)
        }
        self.commuteToDaysPicker = UIPicker

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
            make.top.equalTo(self.commuteToDaysPicker.snp_bottom).offset(16 * AutoSizeScaleX)
            make.left.right.height.equalTo(commuteToWorkDaysBGView)
        }
        
        let commuteToWorkTypeLab: UILabel = UILabel()
        commuteToWorkTypeLab.textColor = .lightGray
        commuteToWorkTypeLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        commuteToWorkTypeLab.text = "Wie pendelst Du zur Arbeit?"
        commuteToWorkTypeLab.numberOfLines = 0
        commuteToWorkTypeLab.textColor = UIColor(hexString: "#2B395C")
        commuteToWorkTypeLab.textAlignment = .left
        self.commuteToWorkTypeBGView.addSubview(commuteToWorkTypeLab)
        commuteToWorkTypeLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.homeAddressTextView)
            make.width.equalTo(200 * AutoSizeScaleX)
            make.top.bottom.equalTo(self.commuteToWorkTypeBGView)
        }

        let typeRightArrow: UIImageView = UIImageView()
        typeRightArrow.image = UIImage.init(named: "RightArrow")
        typeRightArrow.contentMode = .scaleAspectFit
        self.commuteToWorkTypeBGView.addSubview(typeRightArrow)
        typeRightArrow.snp.makeConstraints { (make) in
            make.right.equalTo(self.commuteToWorkTypeBGView).offset(-6 * AutoSizeScaleX)
            make.centerY.equalTo(self.commuteToWorkTypeBGView)
            make.width.height.equalTo(18 * AutoSizeScaleX)
        }
        self.typeRightArrow = typeRightArrow

        let selectedTypeLab: UILabel = UILabel()
        selectedTypeLab.textColor = .lightGray
        selectedTypeLab.font = UIFont.appFont(ofSize: 15, weight: .regular)
        selectedTypeLab.text = " "
        selectedTypeLab.textAlignment = .right
        self.commuteToWorkTypeBGView.addSubview(selectedTypeLab)
        self.selectedTypeLab = selectedTypeLab
        selectedTypeLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.typeRightArrow.snp_left).offset(-4 * AutoSizeScaleX)
            make.width.equalTo(130 * AutoSizeScaleX)
            make.top.bottom.equalTo(commuteToWorkTypeLab)
        }
        
        let tapcommuteToWorkTypeBGBtn: UIButton = UIButton(type: .custom)
        tapcommuteToWorkTypeBGBtn.addTarget(self, action: #selector(tapcommuteToWorkTypeAction(sender:)), for: .touchUpInside)
        commuteToWorkTypeBGView.addSubview(tapcommuteToWorkTypeBGBtn)
        self.tapcommuteToWorkTypeBGBtn = tapcommuteToWorkTypeBGBtn
        tapcommuteToWorkTypeBGBtn.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalTo(commuteToWorkTypeBGView)
        }
        
        let typePickBGView: SelectionList = SelectionList()
        typePickBGView.backgroundColor = UIColor.App.TableView.grayBackground
        self.view.addSubview(typePickBGView)
        self.typePickBGView = typePickBGView
        typePickBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.commuteToWorkTypeBGView.snp_bottom).offset(8 * AutoSizeScaleX)
            make.left.equalTo(homeAddressBGView)
            make.right.equalTo(homeAddressBGView)
            make.height.equalTo(0 * AutoSizeScaleX)
        }
        self.selectionList = typePickBGView

        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        self.typePickBGView.addSubview(tableView)
        self.tableView = tableView
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.typePickBGView)
        }
        
        let expandWorkAddressView: UIView = UIView()
        expandWorkAddressView.backgroundColor = .white
        expandWorkAddressView.layer.borderWidth = 0.5 * AutoSizeScaleX
        expandWorkAddressView.layer.borderColor = UIColor.lightGray.cgColor
        expandWorkAddressView.layer.cornerRadius = 2 * AutoSizeScaleX
        expandWorkAddressView.layer.shadowColor = UIColor.black.cgColor
        expandWorkAddressView.layer.shadowOffset = CGSize.zero
        expandWorkAddressView.layer.shadowOpacity = 0.12
        expandWorkAddressView.layer.shadowRadius = 3
        self.view.addSubview(expandWorkAddressView)
        self.expandWorkAddressView = expandWorkAddressView
        expandWorkAddressView.snp.makeConstraints { (make) in
            make.top.equalTo(self.workAddressBGView.snp_bottom).offset(2 * AutoSizeScaleX)
            make.left.right.equalTo(workAddressBGView)
            make.height.equalTo(0 * AutoSizeScaleX)
        }
        
        let workAddressTableView = UITableView(frame: CGRect.zero, style: .plain)
        workAddressTableView.separatorStyle = .none
        workAddressTableView.dataSource = self
        workAddressTableView.delegate = self
        //workAddressTableView.register(WorkAddressTableViewCell.self, forCellWithReuseIdentifier: "CellID")
        workAddressTableView.register(WorkAddressTableViewCell.self, forCellReuseIdentifier: "CellID")
        workAddressTableView.showsVerticalScrollIndicator = false
        workAddressTableView.estimatedRowHeight = 0.0
        workAddressTableView.estimatedSectionFooterHeight = 0.0
        workAddressTableView.estimatedSectionHeaderHeight = 0.0
        self.expandWorkAddressView.addSubview(workAddressTableView)
        self.workAddressTableView = workAddressTableView
        workAddressTableView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.expandWorkAddressView)
        }
        
        self.work_address_line1 = self.getUserTravel?.work_address_line1 ?? ""
        self.work_address_line2 = self.getUserTravel?.work_address_line2 ?? ""
        self.work_city = self.getUserTravel?.work_city ?? ""
        self.work_state = self.getUserTravel?.work_state ?? ""
        self.work_zipcode = self.getUserTravel?.work_zipcode ?? ""

        

        if(self.getUserTravel?.no_work_address == 0){
            self.dontHaveWorkAddrBtn.isSelected = true
            self.homeAddressTextView.text = "\(self.getUserTravel?.home_address_line1 ?? "" ) \(self.getUserTravel?.home_address_line2 ?? "") \(self.getUserTravel?.home_city ?? "") \(self.getUserTravel?.home_state ?? "") \(self.getUserTravel?.home_zipcode ?? "")"
    //        self.workAdressTextView.text = "\(self.getUserTravel?.work_address_line1 ?? "" ) \(self.getUserTravel?.work_address_line2 ?? "") \(self.getUserTravel?.work_city ?? "") \(self.getUserTravel?.work_state ?? "") \(self.getUserTravel?.work_zipcode ?? "")"
            self.workAdressTextView.text = "\(self.work_address_line1) \(self.work_address_line2) \(self.work_zipcode) \(self.work_city) \(self.work_state) "
            self.homeAddrsplaceholderLabel.isHidden = true
            self.workAddrplaceholderLabel.isHidden = true
            if(self.getUserTravel?.commuting_distance == -1){
                self.getKMbtn.setTitle("0.0 km", for: .normal)
            }else{
                self.getKMbtn.setTitle(String(format: "%.1f km", self.getUserTravel?.commuting_distance ?? 0.0), for: .normal)
            }
            self.selectedDaysLab.text = String(self.getUserTravel?.days_to_commute_work ?? 0)
            UIPicker.selectRow(((self.getUserTravel?.days_to_commute_work ?? 2) - 1 ) , inComponent: 0, animated: true)
            self.selectedTypeLab.text = self.getUserTravel?.commuting_channel ?? ""
        }else{
            self.dontHaveWorkAddrBtn.isSelected = false

        }

        client.getCompanyAddress { (getCompanyAddress) in
            self.getCompanyAddress = getCompanyAddress
            if(self.getUserTravel?.no_work_address == 1){
                self.workAdressTextView.text = "\(self.getCompanyAddress?.getWorkAddress.work_address_line1 ?? "" ) \(self.getCompanyAddress?.getWorkAddress.work_address_line2 ?? "") \(self.getCompanyAddress?.getWorkAddress.work_zipcode ?? "") \(self.getCompanyAddress?.getWorkAddress.work_city ?? "") \(self.getCompanyAddress?.getWorkAddress.work_state ?? "") "
                self.workLatitude = Double(self.getCompanyAddress?.getWorkAddress.work_latitude ?? "") ?? 0.0
                self.workLongtitude = Double(self.getCompanyAddress?.getWorkAddress.work_longitude ?? "") ?? 0.0
            }

            if(self.workAdressTextView.text.isEmptyOrWhitespace()){
                self.workAddrplaceholderLabel.isHidden = false
            }else{
                self.workAddrplaceholderLabel.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(notification:)), name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(notification:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing(notification:)), name: UITextView.textDidEndEditingNotification, object: nil)
        client.getCompanyAddress { (getCompanyAddress) in
            self.getCompanyAddress = getCompanyAddress
            if(self.getUserTravel?.no_work_address == 1){

            }

            if(self.workAdressTextView.text.isEmptyOrWhitespace()){
                self.workAddrplaceholderLabel.isHidden = false
            }else{
                self.workAddrplaceholderLabel.isHidden = true
            }
        }
    }
     
    func updateUI(){
        self.home_address_line1 = self.getUserTravel?.home_address_line1 ?? ""
        self.home_address_line2 = self.getUserTravel?.home_address_line2 ?? ""
        self.home_city = self.getUserTravel?.home_city ?? ""
        self.home_latitude = Double(self.getUserTravel?.home_latitude ?? "") ?? -1
        self.home_longitude = Double(self.getUserTravel?.home_longitude ?? "") ?? -1
        self.home_state = self.getUserTravel?.home_state ?? ""
        self.home_zipcode = self.getUserTravel?.home_zipcode ?? ""
        self.work_custom_address_line1 = self.getUserTravel?.work_address_line1 ?? ""
        self.work_custom_address_line2 = self.getUserTravel?.work_address_line2 ?? ""
        self.work_custom_city = self.getUserTravel?.work_city ?? ""
        self.work_custom_latitude = Double(self.getUserTravel?.work_latitude ?? "") ?? -1
        self.work_custom_longitude = Double(self.getUserTravel?.work_longitude ?? "") ?? -1
        self.work_custom_state = self.getUserTravel?.work_state ?? ""
        self.work_custom_zipcode = self.getUserTravel?.work_zipcode ?? ""
        self.commuting_channel = self.getUserTravel?.commuting_channel ?? ""
        self.commuting_distance = self.getUserTravel?.commuting_distance ?? -1
        self.days_to_commute_work = self.getUserTravel?.days_to_commute_work ?? 1
        self.is_approved = self.getUserTravel?.is_approved ?? 1
        self.is_custom_work_address = self.getUserTravel?.is_custom_work_address ?? 1
        self.no_work_address = self.getUserTravel?.no_work_address ?? 1
        self.getUserProductID = self.getUserTravel?.product_id ?? 0
        self.workLatitude = self.work_custom_latitude
        self.workLongtitude = self.work_custom_longitude
        self.homeLatitude = self.home_latitude
        self.homeLongtitude = self.home_longitude
        //calculateDistance()
    }
    class VerticallyCenteredTextView: UITextView {
        override var contentSize: CGSize {
            didSet {
                var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
                topCorrection = max(0, topCorrection)
                contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    @objc func submitBtnAction(sender: UIButton) {
        if(self.no_work_address == 0){
            commuterStore.homeAddress    = self.homeAddressTextView.text
            commuterStore.workAddress    = self.workAdressTextView.text
            commuterStore.commuterWorkDays   = self.selectedDaysLab.text
            commuterStore.commuterWorkType  = self.selectedTypeLab.text
            
            if(self.getDistanceKmStr == "1 m" || self.getDistanceKmStr == "2 m" || self.getDistanceKmStr == "3 m" || self.getDistanceKmStr == "4 m" || self.getDistanceKmStr == "5 m" || self.getDistanceKmStr == "6 m" || self.getDistanceKmStr == "7 m" || self.getDistanceKmStr == "8 m"){
                UIApplication.shared.showAlertWith(title: "Privatadresse und Geschäftsadresse sollten nicht identisch sein",message: "")
            }else{
            if(self.commuting_distance == 0.0){
                if(self.homeAddressTextView.text.isEmptyOrWhitespace()){
                    UIApplication.shared.showAlertWith(title: "Bitte geben Sie die Privatadresse ein",message: "")
                }else if(self.workAdressTextView.text.isEmptyOrWhitespace()){
                    UIApplication.shared.showAlertWith(title: "Bitte Arbeitsadresse eingeben",message: "")
                }else if(self.getDistanceStatusStr == "ZERO_RESULTS"){
                        UIApplication.shared.showAlertWith(title: "Bitte wählen Sie die richtige Adresse",message: "")
                    }
            }else{
            do {
                
                let credentials = try commuterStore.validate()
        
                ANActivityIndicatorPresenter.shared.showIndicator()
                ApplicationDelegate.client.createUserTravel(home_address_line1: self.home_address_line1, home_address_line2: self.home_address_line2, home_city: self.home_city, home_state: self.home_state, home_zipcode:home_zipcode, home_latitude: Float(self.homeLatitude), home_longitude:Float(self.homeLongtitude), work_address_line1: self.work_address_line1, work_address_line2: self.work_address_line2, work_city: self.work_city, work_state: self.work_state, work_zipcode: self.work_zipcode, work_latitude: Float(self.workLatitude), work_longitude: Float(self.workLongtitude), is_custom_work_address: self.is_custom_work_address, commuting_distance: Float(self.commuting_distance), commuting_channel: self.commuting_channel, days_to_commute_work: self.days_to_commute_work, product_id: self.getUserProductID,is_approved:self.is_approved,no_work_address: self.no_work_address){ message in
                    ANActivityIndicatorPresenter.shared.hideIndicator()
                    self.client.getMonthlyTravelStatusAddress{ (getMonthConfirmationStatus) in
                        if(getMonthConfirmationStatus?.is_need_monthly_confirmation == 1){
                            self.client.postMonthlyTravelStatusAddress { (getPostMonthlyTravelStatus) in

                            }
                        }
                    }
                    let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                            for controller in self.navigationController!.viewControllers as Array {
                                        if controller.isKind(of: BenifitsViewController.self) {
                                            self.navigationController!.popToViewController(controller, animated: true)
                                            break
                                        }
                                if controller.isKind(of: HomeDashboardViewController.self) {
//                                if controller.isKind(of: DashboardContainerViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                                if controller.isKind(of: ViewDailyCommuterViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }))
                        self.present(alert, animated: true, completion: {
                        })
                }

                }
                catch let error as CreatDailyCommuterValidationError {
                switch error {
                case .missingHomeAddress:
                    UIApplication.shared.showAlertWith(title: "Bitte geben Sie die Privatadresse ein".localized, message: "")
                    break
                case .missingWorkAddress:
                    UIApplication.shared.showAlertWith(title: "Bitte Arbeitsadresse eingeben".localized, message: "")

                    break
                case .missingWorkDays:
                        UIApplication.shared.showAlertWith(title: "Bitte geben Sie Pendlerarbeit, Tage ein".localized, message: "")
                    break
                case .missingWorkType:
                    UIApplication.shared.showAlertWith(title: "Bitte geben Sie Pendlerarbeit ein, geben Sie Folgendes ein:".localized, message: "")
                    break
                }
            } catch let error {
                print(error)
            }
            }
            }
            }else{
                ANActivityIndicatorPresenter.shared.showIndicator()
                ApplicationDelegate.client.createUserTravel(home_address_line1: "", home_address_line2: "", home_city: "", home_state: "", home_zipcode:"", home_latitude:-1, home_longitude:-1, work_address_line1: "", work_address_line2: "", work_city: "", work_state:"", work_zipcode: "", work_latitude: -1, work_longitude:-1, is_custom_work_address: self.is_custom_work_address, commuting_distance: -1, commuting_channel: "", days_to_commute_work: 0, product_id: self.getUserProductID,is_approved:0,no_work_address: self.no_work_address){ message in
                    ANActivityIndicatorPresenter.shared.hideIndicator()

                    let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                            for controller in self.navigationController!.viewControllers as Array {
                                        if controller.isKind(of: BenifitsViewController.self) {
                                            self.navigationController!.popToViewController(controller, animated: true)
                                            break
                                        }
                                    }

                        }))
                        self.present(alert, animated: true, completion: {
                        })

                }
        }
            
    }
        

    @objc func homeAddressBGBtnAction(sender: UIButton){
        if(self.no_work_address == 0){

        let controller = AddAddressViewController()
        controller.getHomeWorkType = 1
        controller.delegate = self
        controller.streetAddr = self.home_address_line1
        controller.houseNo = self.home_address_line2
        controller.city = self.home_city
        controller.zipCode = self.home_zipcode
        controller.aptSuite = self.home_state
            if(self.homeAddressTextView.text.isEmpty){
                controller.getLatitude = -2
                controller.getLongtitude = -2
            }else{
                controller.getLatitude = self.home_latitude
                controller.getLongtitude = self.home_longitude
            }

        navigationController?.pushAndHideTabBar(controller)
        }
    }
    @objc func workAddressBGBtnAction(sender: UIButton){
        if(self.no_work_address == 0){
        guard let button = sender as? UIButton else { return }
        if !button.isSelected {
            button.isSelected = true
            expandWorkAddress()
        }
        else {
            button.isSelected = false
            collapseWorkAddress()
        }
        }
    }
    @objc func cancelBtnAction(sender: UIButton) {
        self.view.endEditing(false)
        for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: BenifitsViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
            }
        }
    }
    @objc func getKMbtnAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        calculateDistance()
    }
    
    @objc func selectionChanged() {
        print(self.selectionList.selectedIndexes)
    }
    
    @objc func backBtnAction(sender: UIButton) {
        self.view.endEditing(false)
        for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ViewDailyCommuterViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
            }
        }
    }
    @objc func addNewAddressBtnAction(sender: UIButton) {
        collapseWorkAddress()
    }
    @objc func dontHaveWorkAddrBtnAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(!sender.isSelected){
            self.is_custom_work_address = 1
            self.no_work_address = 1
            self.workAddressBGView.backgroundColor = UIColor.App.TableView.grayBackground
            self.commuteToWorkDaysBGView.backgroundColor = UIColor.App.TableView.grayBackground
            self.commuteToWorkTypeBGView.backgroundColor = UIColor.App.TableView.grayBackground
            self.workAdressTextView.backgroundColor = UIColor.App.TableView.grayBackground
            self.homeAddressBGView.backgroundColor = UIColor.App.TableView.grayBackground
            self.homeAddressTextView.backgroundColor = UIColor.App.TableView.grayBackground

        }else{
            self.is_custom_work_address = 0
            self.no_work_address = 0
            self.workAddressBGView.backgroundColor = .white
            self.commuteToWorkDaysBGView.backgroundColor = .white
            self.commuteToWorkTypeBGView.backgroundColor = .white
            self.workAdressTextView.backgroundColor = .white
            self.homeAddressTextView.backgroundColor = .white
            self.homeAddressBGView.backgroundColor = .white
            
        }
        self.view.endEditing(false)
        collapse()
        collapseType()
    }
    
    @objc func tapcommuteToWorkAction(sender: UIButton) {
        collapseWorkAddress()
        collapseType()
        if(self.no_work_address == 0){
    guard let button = sender as? UIButton else { return }
    if !button.isSelected {
        button.isSelected = true
        expand()
    }
    else {
        button.isSelected = false
        collapse()
    }
        }
        
}
    @objc func handleTapHomeAddress(_ sender: UITapGestureRecognizer? = nil) {
        if(self.no_work_address == 0){

        let controller = AddAddressViewController()
        controller.getHomeWorkType = 1
        controller.delegate = self
        controller.streetAddr = self.home_address_line1
            controller.houseNo = self.home_address_line2
        controller.city = self.home_city
        controller.zipCode = self.home_zipcode
        controller.aptSuite = self.home_state
            if(self.homeAddressTextView.text.isEmpty){
                controller.getLatitude = -2
                controller.getLongtitude = -2
            }else{
                controller.getLatitude = self.home_latitude
                controller.getLongtitude = self.home_longitude
            }

        navigationController?.pushAndHideTabBar(controller)
        }
    }
    @objc func handleTapWorkAddress(_ sender: UITapGestureRecognizer? = nil) {

    }
    @objc func addButtonClickAction(sender: UIButton){
        if(self.no_work_address == 0){
            if(self.getUserTravel?.no_work_address == 1){
                let controller = AddAddressViewController()
                    controller.getHomeWorkType = 2
                    controller.delegate = self
                    navigationController?.pushAndHideTabBar(controller)
            }else{
                let controller = AddAddressViewController()
                    controller.getHomeWorkType = 2
                    controller.delegate = self
                    controller.streetAddr = self.work_address_line1
                    controller.houseNo = self.work_address_line2
                    controller.city = self.work_city
                    controller.zipCode = self.work_zipcode
                    controller.aptSuite = self.work_state
                    controller.getLatitude = self.workLatitude
                    controller.getLongtitude = self.workLongtitude
                    navigationController?.pushAndHideTabBar(controller)
            }
    }
}
    @objc func editButtonCickAction(sender: UIButton){
        if(self.no_work_address == 0){
    
        let controller = AddAddressViewController()
            controller.getHomeWorkType = 2
            controller.delegate = self
            controller.streetAddr = self.work_address_line1
            controller.houseNo = self.work_address_line2
            controller.city = self.work_city
            controller.zipCode = self.work_zipcode
            controller.aptSuite = self.work_state
            controller.getLatitude = self.workLatitude
            controller.getLongtitude = self.workLongtitude
            navigationController?.pushAndHideTabBar(controller)
        }
    }
    @objc func tapcommuteToWorkTypeAction(sender: UIButton) {
        collapseWorkAddress()
        collapseType()
        if(self.no_work_address == 0){
        guard let button = sender as? UIButton else { return }
        if !button.isSelected {
            button.isSelected = true
            expandType()
        }
        else {
            button.isSelected = false
            collapseType()
        }
        }
    }
    
    func getDirections(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) {
       let source = MKMapItem(placemark: MKPlacemark(coordinate: loc1))
       source.name = "The Pride Hotel Bangalore, 93, Richmond Rd, Langford Gardens, Bengaluru, Karnataka 560025, India"
       let destination = MKMapItem(placemark: MKPlacemark(coordinate: loc2))
       destination.name = "Magrath Rd, Ashok Nagar, Bengaluru, Karnataka 560025, India"
       MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
            
    @objc func expandWorkAddress(){
        self.workAddressDownArrow.transform = CGAffineTransform(rotationAngle: CGFloat(0))

        UIView.animate(withDuration: 0.5) {
            //self.timeRightArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))

            self.expandWorkAddressView.snp.updateConstraints { make in
                make.height.equalTo(120 * AutoSizeScaleX)
            }
        }
    }
    @objc func collapseWorkAddress(){
        self.workAddressDownArrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))

        UIView.animate(withDuration: 0.5) {
            self.expandWorkAddressView.snp.updateConstraints { make in
                make.height.equalTo(0 * AutoSizeScaleX)
            }

        }
    }
@objc func expand(){
    UIView.animate(withDuration: 0.3) {
        self.timeRightArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        self.daysPickerView.snp.updateConstraints { make in
            make.height.equalTo(160 * AutoSizeScaleX)
        }
    }
}
    @objc func expandType(){
        UIView.animate(withDuration: 0.3) {
            self.typeRightArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            self.typePickBGView.snp.updateConstraints { make in
                make.height.equalTo(200 * AutoSizeScaleX)
            }
        }
    }
    
@objc func collapse(){
    UIView.animate(withDuration: 0.3) {
        self.timeRightArrow.transform = CGAffineTransform(rotationAngle: CGFloat(0))
        self.daysPickerView.snp.updateConstraints { make in
            make.height.equalTo(0 * AutoSizeScaleX)
        }
    }
}

    @objc func collapseType(){
        UIView.animate(withDuration: 0.3) {
            self.typeRightArrow.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            self.typePickBGView.snp.updateConstraints { make in
                make.height.equalTo(0 * AutoSizeScaleX)
            }
        }
    }

    
@objc func datePickerValueChanged() {
    self.selectedDaysLab.text = String.getTimeFromDate(date: self.datePicker.date)
}

// MARK: - TextView Notifications

@objc func textViewDidChange(notification: Notification) {
    self.homeAddrsplaceholderLabel.isHidden = !self.homeAddressTextView.text.isEmpty
    self.workAddrplaceholderLabel.isHidden = !self.workAdressTextView.text.isEmpty

    if self.homeAddressTextView.markedTextRange == nil {
        if self.homeAddressTextView.text.count > self.destribeMaxLength {
            self.homeAddressTextView.text = self.homeAddressTextView.text.subStringTo(index: self.destribeMaxLength - 1)
        }
        self.countLab.text = "\(self.homeAddressTextView.text.count)/\(self.destribeMaxLength)"
    }
}

@objc func textViewDidBeginEditing(notification: Notification) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (isFinish) in
            if isFinish && !self.workAdressTextView.isFirstResponder {
                NotificationCenter.default.post(name: UITextView.textDidEndEditingNotification, object: self.workAdressTextView)
            }
        })
    }
}
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        collapse()
    }
    
@objc func textViewDidEndEditing(notification: Notification) {
    self.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
    }
}
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return daysArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return daysArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        self.selectedDaysLab.text = daysArray[row]
        self.days_to_commute_work = Int(self.selectedDaysLab.text ?? "") ?? 0
        collapse()
    }
    
    func getData(streetAddr: String,houseNoStr : String, aptSuite: String, city: String, zipCode: String, country: String, countryCode: String, latitude: Double, longitude: Double, homeAddressType: Int) {

        if(homeAddressType == 1 ){
            self.home_address_line1 = streetAddr
            self.home_address_line2 = houseNoStr
            self.home_city = city
            self.home_zipcode = zipCode
            self.home_state = aptSuite
            self.home_latitude = latitude
            self.home_longitude = longitude
            self.homeAddressTextView.text = "\(streetAddr) \(houseNoStr) \(aptSuite) \(zipCode) \(city)  \(country)"
            self.homeAddrsplaceholderLabel.isHidden = true
            self.homeLatitude = latitude
            self.homeLongtitude = longitude
            calculateDistance()

        }
        if(homeAddressType == 2 ){
            self.workAddrplaceholderLabel.isHidden = true
            self.work_custom_address_line1 = streetAddr
            self.work_address_line1 = streetAddr
            self.work_custom_address_line2 = houseNoStr
            self.work_address_line2 = houseNoStr
            self.work_custom_city = city
            self.work_city = city
            self.work_custom_zipcode = zipCode
            self.work_zipcode = zipCode
            self.work_custom_state = aptSuite
            self.work_state = aptSuite
            self.work_custom_latitude = latitude
            self.work_custom_longitude = longitude
            self.workLatitude = latitude
            self.workLongtitude = longitude
            self.workAdressTextView.text = "\(self.work_custom_address_line1) \(self.work_custom_address_line2) \(self.work_custom_zipcode) \(self.work_custom_city)  \(self.work_custom_state)  "
            self.is_custom_work_address = 1
            calculateDistance()
            self.workAddressTableView.reloadData()
            collapseWorkAddress()

        }
    }

    func calculateDistance(){
       
        if(homeLatitude == 0.0 || homeLongtitude == 0.0 || workLatitude == 0.0 || workLongtitude == 0.0 || workLongtitude == -1 || homeLongtitude == -1){
            self.getKMbtn.setTitle("0.0 km", for: .normal)

            self.commuting_distance = -1
            self.is_approved = 0
        }else{
          //  let url = "https://maps.googleapis.com/maps/api/distancematrix/json?&origins=\(homeLatitude),\(homeLongtitude)&destinations=\(workLatitude),\(workLongtitude)&key=AIzaSyD9FN0o0hi1gzHpGH0ztWqwrjZ00S0dCiA"
      //      let url = "https://qa-api.riso-app.de/api/v1/maps/distance-matrix?origins=\(homeLatitude),\(homeLongtitude)&destinations=\(workLatitude),\(workLongtitude)"
//https://riso-prod.viableapi.com/api/v1
           //   let url = "https://riso-prod.viableapi.com/api/v1/maps/distance-matrix?origins=\(homeLatitude),\(homeLongtitude)&destinations=\(workLatitude),\(workLongtitude)"

           let url = "https://dev-api.riso-app.de/api/v1/maps/distance-matrix?origins=\(homeLatitude),\(homeLongtitude)&destinations=\(workLatitude),\(workLongtitude)"

            let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let header: HTTPHeaders = [ "Accept": "application/json", "Content-Type": "application/json", "Authorization":"Bearer \(client.accessToken ?? client.accessTokenWithOutKeyChain ?? "")" ]
            //let header: HTTPHeaders = [ "Accept": "application/json", "Content-Type": "application/json"]
            Alamofire.request(encodedUrl! , method: .get,encoding: JSONEncoding.default, headers: header)
                .responseJSON { (response) in
                    if let result = response.result.value {

                            let json = JSON(result) //use SwiftyJSON pod and import
                            let distanceStr = json["rows"][0]["elements"][0]["distance"]["text"].string
                        let distanceVal = json["rows"][0]["elements"][0]["distance"]["value"].int
                        let getStatus = json["rows"][0]["elements"][0]["status"].string


                        self.getDistanceKmStr = distanceStr ?? ""
                        self.getDistanceStatusStr = getStatus ?? ""
                        if(getStatus == "ZERO_RESULTS"){
                           // UIApplication.shared.showAlertWith(title: "Please select proper address",message: "")
                        }
                        if(distanceStr == "1 m" || distanceStr == "2 m" || distanceStr == "3 m" || distanceStr == "4 m" || distanceStr == "5 m" || distanceStr == "6 m" || distanceStr == "7 m" || distanceStr == "8 m" || distanceStr == "9 m"){
                            UIApplication.shared.showAlertWith(title: "Privatadresse und Geschäftsadresse sollten nicht identisch sein",message: "")
                        }
                        //            print(distance)
                        var getDistanceValue: Float = Float(Float(distanceVal ?? 0) / Float(1000))

                        let getFinalDistance: String = String(format: "%.1f", getDistanceValue) // "1.1"
                        self.getKMbtn.setTitle(String(format: "%.1f km", getDistanceValue), for: .normal)
                        self.getDistanceKM = Float(getFinalDistance) ?? 0.0
                        self.commuting_distance = Double(getFinalDistance) ?? -1
                    }
            }
        }

    }
}

// MARK: - TextView Delegate Methods

extension EditDailyCommuterViewController: UITextViewDelegate {
func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let inputModeStr = textView.textInputMode?.primaryLanguage
    if inputModeStr == TextInputModeStr  && (textView.selectedTextRange?.start == textView.endOfDocument) && self.destribeMaxLength == textView.text?.count {
        return false
    }
    if text == "\n" {
        textView.resignFirstResponder()
        return false
    }
    return true
}
}


extension EditDailyCommuterViewController: UITextFieldDelegate {
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let maxLength = 20
    let currentString = (textField.text ?? "") as NSString
    let newString = currentString.replacingCharacters(in: range, with: string)
    return newString.count <= maxLength
}
}


extension EditDailyCommuterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        if(tableView  == self.tableView){
            return self.benifitsListArray.count
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView  == self.tableView){
            return 50
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView  == self.tableView){
            let cellID = "CellID"
            var cell: DailyCommuterTypeTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? DailyCommuterTypeTableViewCell
            if cell == nil {
                cell = DailyCommuterTypeTableViewCell(style: .default, reuseIdentifier: cellID)
            }
            cell?.titleLab.text = self.benifitsListArray[indexPath.row]
            if(self.getUserTravel?.commuting_channel == self.benifitsListArray[indexPath.row]){
                if(selectedRow == -1){
                    selectedRow = indexPath.row
                }
            }
            if indexPath.row == selectedRow{
                cell?.selectImgView.image = UIImage(named: "typeCheck")
            }else{
                cell?.selectImgView.image = UIImage(named: "typeUnCheck")
            }
            return cell!
        }else{
       // if(tableView  == self.workAdressTextView){
            let cellID = "CellID"
            var cell: WorkAddressTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? WorkAddressTableViewCell
            if cell == nil {
                cell = WorkAddressTableViewCell(style: .default, reuseIdentifier: cellID)
            }
            if(indexPath.row == 0){
                cell?.addNewBtn.isHidden = true
                cell?.editBGBtn.isHidden = true
                cell?.addressLab.text = "\(self.getCompanyAddress?.getWorkAddress.work_address_line1 ?? "" ) \(self.getCompanyAddress?.getWorkAddress.work_address_line2 ?? "") \(self.getCompanyAddress?.getWorkAddress.work_zipcode ?? "") \(self.getCompanyAddress?.getWorkAddress.work_city ?? "") \(self.getCompanyAddress?.getWorkAddress.work_state ?? "") "
//                cell?.addressLab.text = "\("Meha MOJAR (Jimei Branch") \("Jimei Avenue Yudui Shanxi Road Intersection Longhe Erli 12-114") \("Jimei Xiamen") \("China") "

            }else{
                cell?.editBGBtn.addTarget(self, action: #selector(editButtonCickAction(sender:)), for: .touchUpInside)
                cell?.addNewBtn.addTarget(self, action: #selector(addButtonClickAction(sender:)), for: .touchUpInside)
                if(self.is_custom_work_address == 0){
                        cell?.addNewBtn.isHidden = false
                        cell?.editBGBtn.isHidden = true
                        cell?.addressLab.text = ""
                }else{
                    cell?.addressLab.text = "\(self.work_custom_address_line1) \(self.work_custom_address_line2) \(self.work_custom_zipcode) \(self.work_custom_city) \(self.work_custom_state) "
               }
//                if(self.workAdressTextView.text == "\(self.work_custom_address_line1) \(self.work_custom_address_line2) \(self.work_custom_city) \(self.work_custom_state) \(self.work_custom_zipcode)"){
//                    cell?.addNewBtn.isHidden = false
//                    cell?.editBGBtn.isHidden = true
//                    cell?.addressLab.text = ""
//                }else{
                  //  cell?.addressLab.text = "\(self.work_custom_address_line1) \(self.work_custom_address_line2) \(self.work_custom_city) \(self.work_custom_state) \(self.work_custom_zipcode)"
//                }
                let getAddress = cell?.addressLab.text
                
                if(getAddress.isEmptyOrWhitespace()){
                    cell?.addNewBtn.isHidden = false
                    cell?.editBGBtn.isHidden = true
                }else{
                    cell?.addNewBtn.isHidden = true
                    cell?.editBGBtn.isHidden = false
                }
//                if((cell?.addressLab.text ) != nil){
//                }
                
            }

            return cell!

        }
       // return UITableViewCell()
    }
    /*

     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(tableView  == self.tableView){
            selectedRow = indexPath.row
            self.selectedTypeLab.text = self.benifitsListArray[indexPath.row]
            self.commuting_channel = self.benifitsListArray[indexPath.row]
            collapseType()
            self.tapcommuteToWorkTypeBGBtn.isSelected = false
            tableView.reloadData()
        }else{
            
            if(indexPath.row == 0){
                self.is_custom_work_address = 0
//                self.work_address_line1 = "Meha MOJAR (Jimei Branch)"
//                self.work_address_line2 = "Jimei Avenue Yudui Shanxi Road Intersection Longhe Erli 12-114"
//                self.work_city = "Jimei Xiamen"
//                self.work_state = "China"
//                workLatitude = 24.60300000
//                work_longitude = 118.0780000

                self.work_address_line1 = self.getCompanyAddress?.getWorkAddress.work_address_line1 ?? ""
                self.work_address_line2 = self.getCompanyAddress?.getWorkAddress.work_address_line2 ?? ""
                self.work_city = self.getCompanyAddress?.getWorkAddress.work_city ?? ""
                workLatitude = Double(self.getCompanyAddress?.getWorkAddress.work_latitude ?? "") ?? 0.0
                workLongtitude = Double(self.getCompanyAddress?.getWorkAddress.work_longitude ?? "") ?? 0.0
                self.work_state = self.getCompanyAddress?.getWorkAddress.work_state ?? ""
                self.work_zipcode = self.getCompanyAddress?.getWorkAddress.work_zipcode ?? ""
                self.workAdressTextView.text = "\(self.work_address_line1) \(self.work_address_line2) \(self.work_zipcode) \(self.work_city) \(self.work_state) "

            }else{
                self.is_custom_work_address = 1
                self.work_address_line1 = self.work_custom_address_line1
                self.work_address_line2 = self.work_custom_address_line2
                self.work_city = self.work_custom_city
                workLatitude = self.work_custom_latitude
                workLongtitude = self.work_custom_longitude
                self.work_state = self.work_custom_state
                self.work_zipcode = self.work_custom_zipcode
                self.workAdressTextView.text = "\(self.work_address_line1) \(self.work_address_line2) \(self.work_zipcode) \(self.work_city) \(self.work_state) "

            }
            if(self.workAdressTextView.text.isEmptyOrWhitespace()){
                self.workAddrplaceholderLabel.isHidden = false
            }else{
                self.workAddrplaceholderLabel.isHidden = true
            }
            calculateDistance()
            collapseWorkAddress()
        }
    }
}



extension Optional where Wrapped == String {
    func isEmptyOrWhitespace() -> Bool {
        // Check nil
        guard let this = self else { return true }
        
        // Check empty string
        if this.isEmpty {
            return true
        }
        // Trim and check empty string
        return (this.trimmingCharacters(in: .whitespaces) == "")
    }
}
