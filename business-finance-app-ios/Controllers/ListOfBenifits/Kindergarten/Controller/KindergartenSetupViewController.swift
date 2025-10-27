//
//  KindergartenSetupViewController.swift
//  BFA
//
//  Created by Mohammed Aslam on 2022/9/12.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import ANActivityIndicator
enum CreatKindergartenValidationError: Error {
    case missingName
    case missingGender
    case missingDOB
    case missingKindergartenName
    case missingKindergartenAddress
    case missingChildNotCompulsory
    case missingSpouseNotGettingAllowance
}

struct KindergartenStore {

     var name: String?
     var gender: String?
     var dob: String?
     var kindergartenName: String?
     var kindergartenAddress: String?
     var childNotCompulsory: Bool?
     var spouseNotGettingAllowance : Bool?


    func validate() throws -> (name: String,gender: String,dob: String,kindergartenName: String,kindergartenAddress: String,spouseNotGettingAllowance: Bool) {
        guard let name = self.name, name.trim().isNotEmpty else {
            throw CreatKindergartenValidationError.missingName
        }
        guard let gender = self.gender, gender.trim().isNotEmpty else {
            throw CreatKindergartenValidationError.missingGender
        }
        guard let dob = self.dob, dob.trim().isNotEmpty else {
            throw CreatKindergartenValidationError.missingDOB
        }
        guard let kindergartenName = self.kindergartenName, kindergartenName.trim().isNotEmpty else {
            throw CreatKindergartenValidationError.missingKindergartenName
        }
        guard let kindergartenAddress = self.kindergartenAddress, kindergartenAddress.trim().isNotEmpty else {
            throw CreatKindergartenValidationError.missingKindergartenAddress
        }
        guard let spouseNotGettingAllowance = self.spouseNotGettingAllowance, spouseNotGettingAllowance else {
            throw CreatKindergartenValidationError.missingSpouseNotGettingAllowance
        }

        return (name: name,gender :gender,dob:dob,kindergartenName:kindergartenName,kindergartenAddress:kindergartenAddress,spouseNotGettingAllowance:spouseNotGettingAllowance)
    }
}

class KindergartenSetupViewController: BaseViewController ,UIPickerViewDelegate, UIPickerViewDataSource{
    private var kindergartenStore = KindergartenStore()

    private var childNotCompulsaryAgeBtn : UIButton = UIButton()
    private var spouseNotGettingAllowanceBtn : UIButton = UIButton()
    private var nameTF : UITextField = UITextField()
    private var genderTF : UITextField = UITextField()
    private var kindergartenNameTypeTF : UITextField = UITextField()
    private var selectedDobLab : UILabel = UILabel()
    private var selectedGenderLab : UILabel = UILabel()
    private var date: Date = Date()
    private var datePicker: UIDatePicker = UIDatePicker()
    private var dOBPickerView : UIView = UIView()
    private var dobBGView : UIView = UIView()
    private var kindergartenNameTypeBGView : UIView = UIView()
    private var kindergartenAddressBGView : UIView = UIView()
    private var uploadReceiptBGView : UIView = UIView()
    private var genderPickerBGView : UIView = UIView()
    private var genderPicker: UIPickerView = UIPickerView()
    private var mainScrollView: UIScrollView = UIScrollView()
    private var cancelBtn : UIButton = UIButton()
    private var clickedTextField = UITextField()
    var clickedTextView: UITextView?

    private var genderPickerImg: UIImageView = UIImageView()
    private var datePickerImg: UIImageView = UIImageView()
    private var selectedRow = -1
    private var isChildNotCompulsaryAgeSelected = 0
    private var isSpouseNotGettingAllowanceSelected = 0
    private var tableView: UITableView!
    private var tapGenderBtn:UIButton = UIButton()
    private var tapDobBGBtn:UIButton = UIButton()
    private let kindergartenNameMaxLength = 50
    private let kindergartenAddressMaxLength = 150
    private var kindergartenAddressTextView: UITextView = UITextView()
    private var countLab: UILabel = UILabel()
    private var placeholderLabel: UILabel = UILabel()
    private var scrollView: UIScrollView = {
    let scroll = UIScrollView()
        return scroll

    }()
    let genderArray = ["Männlich", "Weiblich"]
    let genderListArray = [
        "Männlich",
        "Weiblich",
        "Das möchte ich nicht mitteilen."
    ]
    var configView: UIView  = {
        let content = UIView()
        return content
    }()
    var getTitle: String = ""
    private var store: ScanStore = ScanStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,selector:#selector(self.keyboardWillShow),name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide),name:UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(notification:)), name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(notification:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing(notification:)), name: UITextView.textDidEndEditingNotification, object: nil)
        
        view.backgroundColor = UIColor.white

        self.navigationItem.title = self.getTitle
        
        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
 

        configSetUpUI()
        
    }
    
    func configSetUpUI(){
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        scrollView.addSubview(configView)
        configView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }

        let childNotCompulsaryAgeBtn: UIButton = UIButton()
        childNotCompulsaryAgeBtn.setImage(UIImage(named: "tickUnchecked"), for: .normal)
        childNotCompulsaryAgeBtn.imageView?.contentMode = .scaleAspectFit
        childNotCompulsaryAgeBtn.setImage(UIImage(named: "tickchecked"), for: .selected)
        childNotCompulsaryAgeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        childNotCompulsaryAgeBtn.addTarget(self, action: #selector(childNotCompulsaryAgeBtnAction(sender:)), for: .touchUpInside)
        self.configView.addSubview(childNotCompulsaryAgeBtn)
        self.childNotCompulsaryAgeBtn = childNotCompulsaryAgeBtn
        childNotCompulsaryAgeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.configView).offset(20 * AutoSizeScaleX)
            make.top.equalTo(self.configView).offset(20 * AutoSizeScaleX)
            make.height.width.equalTo(30 * AutoSizeScaleX)
        }
        
        let childNotCompulsaryAgeLab: UILabel = UILabel()
        childNotCompulsaryAgeLab.text = "Ich bestätige, dass mein Kind nicht schulpflichtig ist."
        childNotCompulsaryAgeLab.numberOfLines = 0
        childNotCompulsaryAgeLab.textAlignment = .left
        childNotCompulsaryAgeLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        childNotCompulsaryAgeLab.sizeToFit()
        self.configView.addSubview(childNotCompulsaryAgeLab)
        childNotCompulsaryAgeLab.textColor = .lightGray
        childNotCompulsaryAgeLab.snp.makeConstraints { (make) in
            make.left.equalTo(childNotCompulsaryAgeBtn.snp_right).offset(2 * AutoSizeScaleX)
            make.right.equalTo(self.configView).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(self.configView).offset(20 * AutoSizeScaleX)
            make.height.width.equalTo(40 * AutoSizeScaleX)
        }
        
        let spouseNotGettingAllowanceBtn: UIButton = UIButton()
        spouseNotGettingAllowanceBtn.setImage(UIImage(named: "tickUnchecked"), for: .normal)
        spouseNotGettingAllowanceBtn.imageView?.contentMode = .scaleAspectFit
        spouseNotGettingAllowanceBtn.setImage(UIImage(named: "tickchecked"), for: .selected)
        spouseNotGettingAllowanceBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        spouseNotGettingAllowanceBtn.addTarget(self, action: #selector(spouseNotGettingAllowanceBtnAction(sender:)), for: .touchUpInside)
        self.configView.addSubview(spouseNotGettingAllowanceBtn)
        self.spouseNotGettingAllowanceBtn = spouseNotGettingAllowanceBtn
        spouseNotGettingAllowanceBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.configView).offset(20 * AutoSizeScaleX)
            make.top.equalTo(childNotCompulsaryAgeLab.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.width.equalTo(30 * AutoSizeScaleX)
        }
        
        let spouseNotGettingAllowanceLab: UILabel = UILabel()
        spouseNotGettingAllowanceLab.text = "Ich bestätige, dass mein (Ehe)Partner keinen Kindergartenzuschuss von seinem Arbeitgeber erhält."
        spouseNotGettingAllowanceLab.numberOfLines = 0
        spouseNotGettingAllowanceLab.textAlignment = .left
        spouseNotGettingAllowanceLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        spouseNotGettingAllowanceLab.sizeToFit()
        self.configView.addSubview(spouseNotGettingAllowanceLab)
        spouseNotGettingAllowanceLab.textColor = .lightGray
        spouseNotGettingAllowanceLab.snp.makeConstraints { (make) in
            make.left.equalTo(spouseNotGettingAllowanceBtn.snp_right).offset(2 * AutoSizeScaleX)
            make.right.equalTo(self.configView).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(spouseNotGettingAllowanceBtn)
            make.height.equalTo(56 * AutoSizeScaleX)
        }
        
        let nameBGView: UIView = UIView()
        nameBGView.backgroundColor = .white
        nameBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        nameBGView.layer.shadowColor = UIColor.black.cgColor
        nameBGView.layer.shadowOffset = CGSize.zero
        nameBGView.layer.shadowOpacity = 0.12
        nameBGView.layer.shadowRadius = 3
        self.configView.addSubview(nameBGView)
        nameBGView.snp.makeConstraints { (make) in
            make.top.equalTo(spouseNotGettingAllowanceLab.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.configView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.configView).offset(-20 * AutoSizeScaleX)
        }

        let nameTF: UITextField = UITextField()
        nameTF.clearButtonMode = UITextField.ViewMode.always
        nameTF.placeholder = "Name"
        nameTF.delegate = self
        nameTF.textColor = UIColor(hexString: "#2B395C")
        nameBGView.addSubview(nameTF)
        self.nameTF = nameTF
        nameTF.snp.makeConstraints { (make) in
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
        self.configView.addSubview(genderBGView)
        
        genderBGView.snp.makeConstraints { (make) in
            make.top.equalTo(nameBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.configView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.configView).offset(-20 * AutoSizeScaleX)
        }

        let tapGenderBtn: UIButton = UIButton(type: .custom)
        tapGenderBtn.addTarget(self, action: #selector(tapGenderBtnAction(sender:)), for: .touchUpInside)
        genderBGView.addSubview(tapGenderBtn)
        self.tapGenderBtn = tapGenderBtn
        tapGenderBtn.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalTo(genderBGView)
        }

        let genderLab: UILabel = UILabel()
        genderLab.textColor = .lightGray
        genderLab.font = UIFont.appFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
        genderLab.text = "Geschlecht"
        genderLab.textColor = UIColor(hexString: "#2B395C")
        genderLab.textAlignment = .left
        genderBGView.addSubview(genderLab)
        genderLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTF)
            make.width.equalTo(100 * AutoSizeScaleX)
            make.top.bottom.equalTo(genderBGView)
        }
        
        let genderPickerImg: UIImageView = UIImageView()
        genderPickerImg.image = UIImage.init(named: "RightArrow")
        genderBGView.addSubview(genderPickerImg)
        self.genderPickerImg = genderPickerImg
        genderPickerImg.snp.makeConstraints { (make) in
            make.right.equalTo(genderBGView).offset(-20 * AutoSizeScaleX)
            make.centerY.equalTo(genderBGView)
            make.height.equalTo(14 * AutoSizeScaleX)
            make.width.equalTo(8 * AutoSizeScaleX)
        }
        
        let selectedGenderLab: UILabel = UILabel()
        selectedGenderLab.textColor = .lightGray
        selectedGenderLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        selectedGenderLab.text = " "
        selectedGenderLab.textAlignment = .right
        genderBGView.addSubview(selectedGenderLab)
        self.selectedGenderLab = selectedGenderLab
        selectedGenderLab.snp.makeConstraints { (make) in
            make.right.equalTo(genderPickerImg.snp_left).offset(-10 * AutoSizeScaleX)
            make.width.equalTo(140 * AutoSizeScaleX)
            make.top.bottom.equalTo(genderBGView)
        }
        
        let genderPickerBGView: UIView = UIView()
        genderPickerBGView.backgroundColor = UIColor.App.TableView.grayBackground
        self.view.addSubview(genderPickerBGView)
        self.genderPickerBGView = genderPickerBGView
        genderPickerBGView.snp.makeConstraints { (make) in
            make.top.equalTo(genderBGView.snp_bottom).offset(2 * AutoSizeScaleX)
            make.left.right.equalTo(nameBGView)
            make.height.equalTo(0 * AutoSizeScaleX)
        }
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        self.genderPickerBGView.addSubview(tableView)
        self.tableView = tableView
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.genderPickerBGView)
        }
               
        let dobBGView: UIView = UIView()
        dobBGView.backgroundColor = .white
        dobBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        dobBGView.layer.shadowColor = UIColor.black.cgColor
        dobBGView.layer.shadowOffset = CGSize.zero
        dobBGView.layer.shadowOpacity = 0.12
        dobBGView.layer.shadowRadius = 3
        self.configView.addSubview(dobBGView)
        self.dobBGView = dobBGView
        dobBGView.snp.makeConstraints { (make) in
            make.top.equalTo(genderPickerBGView.snp_bottom).offset(16 * AutoSizeScaleX)
            make.left.right.height.equalTo(nameBGView)
        }
        
        let tapDobBGBtn: UIButton = UIButton(type: .custom)
        tapDobBGBtn.addTarget(self, action: #selector(tapDobBGBtnAction(sender:)), for: .touchUpInside)
        dobBGView.addSubview(tapDobBGBtn)
        self.tapDobBGBtn = tapDobBGBtn
        tapDobBGBtn.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalTo(dobBGView)
        }

        let dobLab: UILabel = UILabel()
        dobLab.textColor = .lightGray
        dobLab.font = UIFont.appFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
        dobLab.text = "Geburtsdatum"
        dobLab.textColor = UIColor(hexString: "#2B395C")
        dobLab.textAlignment = .left
        dobBGView.addSubview(dobLab)
        dobLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTF)
            make.width.equalTo(130 * AutoSizeScaleX)
            make.top.bottom.equalTo(dobBGView)
        }
        
        let datePickerImg: UIImageView = UIImageView()
        datePickerImg.image = UIImage.init(named: "calendar")
        dobBGView.addSubview(datePickerImg)
        self.datePickerImg = datePickerImg
        datePickerImg.snp.makeConstraints { (make) in
            make.right.equalTo(dobBGView).offset(-20 * AutoSizeScaleX)
            make.centerY.equalTo(dobBGView)
            make.width.height.equalTo(18 * AutoSizeScaleX)
        }
        
        let selectedDobLab: UILabel = UILabel()
        selectedDobLab.textColor = .lightGray
        selectedDobLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        selectedDobLab.text = " "
        selectedDobLab.textAlignment = .right
        dobBGView.addSubview(selectedDobLab)
        self.selectedDobLab = selectedDobLab
        selectedDobLab.snp.makeConstraints { (make) in
            make.right.equalTo(datePickerImg.snp_left).offset(-10 * AutoSizeScaleX)
            make.width.equalTo(100 * AutoSizeScaleX)
            make.top.bottom.equalTo(dobBGView)
        }
        
        let dOBPickerView: UIView = UIView()
        dOBPickerView.backgroundColor = UIColor.App.TableView.grayBackground
        self.configView.addSubview(dOBPickerView)
        self.dOBPickerView = dOBPickerView
        dOBPickerView.snp.makeConstraints { (make) in
            make.top.equalTo(dobBGView.snp_bottom).offset(2 * AutoSizeScaleX)
            make.left.right.equalTo(dobBGView)
            make.height.equalTo(0 * AutoSizeScaleX)
        }
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.date = self.date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dOBPickerView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.top.bottom.right.left.equalTo(dOBPickerView)
        }
        self.datePicker = datePicker        
        let kindergartenNameTypeBGView: UIView = UIView()
        kindergartenNameTypeBGView.backgroundColor = .white
        kindergartenNameTypeBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        kindergartenNameTypeBGView.layer.shadowColor = UIColor.black.cgColor
        kindergartenNameTypeBGView.layer.shadowOffset = CGSize.zero
        kindergartenNameTypeBGView.layer.shadowOpacity = 0.12
        kindergartenNameTypeBGView.layer.shadowRadius = 3
        self.configView.addSubview(kindergartenNameTypeBGView)
        self.kindergartenNameTypeBGView = kindergartenNameTypeBGView
        kindergartenNameTypeBGView.snp.makeConstraints { (make) in
            make.top.equalTo(dOBPickerView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.configView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.configView).offset(-20 * AutoSizeScaleX)
        }

        let kindergartenNameTypeTF: UITextField = UITextField()
        kindergartenNameTypeTF.clearButtonMode = UITextField.ViewMode.always
        kindergartenNameTypeTF.placeholder = "Name/Art des Kindergartens"
        kindergartenNameTypeTF.delegate = self
        kindergartenNameTypeTF.textColor = UIColor(hexString: "#2B395C")
        self.kindergartenNameTypeBGView.addSubview(kindergartenNameTypeTF)
        self.kindergartenNameTypeTF = kindergartenNameTypeTF
        kindergartenNameTypeTF.snp.makeConstraints { (make) in
            make.left.equalTo(kindergartenNameTypeBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(kindergartenNameTypeBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(kindergartenNameTypeBGView)
        }
        
        let kindergartenAddressBGView: UIView = UIView()
        kindergartenAddressBGView.backgroundColor = .white
        kindergartenAddressBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        kindergartenAddressBGView.layer.shadowColor = UIColor.black.cgColor
        kindergartenAddressBGView.layer.shadowOffset = CGSize.zero
        kindergartenAddressBGView.layer.shadowOpacity = 0.12
        kindergartenAddressBGView.layer.shadowRadius = 3
        self.configView.addSubview(kindergartenAddressBGView)
        self.kindergartenAddressBGView = kindergartenAddressBGView
        kindergartenAddressBGView.snp.makeConstraints { (make) in
            make.top.equalTo(kindergartenNameTypeBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(70 * AutoSizeScaleX)
            make.left.equalTo(self.configView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.configView).offset(-20 * AutoSizeScaleX)
        }

        let kindergartenAddressTextView: UITextView = UITextView()
        kindergartenAddressTextView.font = UIFont.appFont(ofSize: 16, weight: .regular)
        kindergartenAddressTextView.textColor = UIColor(hexString: "#2B395C")
        kindergartenAddressTextView.delegate = self
        kindergartenAddressTextView.returnKeyType = .done
        kindergartenAddressTextView.font = .systemFont(ofSize: 16)
        self.kindergartenAddressBGView.addSubview(kindergartenAddressTextView)
        kindergartenAddressTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.kindergartenNameTypeTF)
            make.right.equalTo(self.kindergartenNameTypeTF.snp_right).offset(-4 * AutoSizeScaleX)
            make.top.equalTo(self.kindergartenAddressBGView).offset(4 * AutoSizeScaleX)
            make.bottom.equalTo(self.kindergartenAddressBGView)
        }
        self.kindergartenAddressTextView = kindergartenAddressTextView
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Adresse des Kindergartens"
        placeholderLabel.sizeToFit()
        self.kindergartenAddressBGView.addSubview(placeholderLabel)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.isHidden = !kindergartenAddressTextView.text.isEmpty
        placeholderLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.kindergartenAddressTextView)
            make.left.equalTo(self.kindergartenNameTypeTF)
             make.height.equalTo(self.kindergartenAddressTextView)
            make.centerY.equalTo(self.kindergartenAddressTextView).offset(-8 * AutoSizeScaleX)
        }
        
        let countLab: UILabel = UILabel()
        countLab.text = "0/\(self.kindergartenAddressMaxLength)"
        countLab.isHidden = true
        countLab.textColor = .lightGray
        countLab.font = UIFont.appFont(ofSize: 10 * AutoSizeScaleX, weight: .regular)
        kindergartenAddressBGView.addSubview(countLab)
        countLab.snp.makeConstraints { (make) in
            make.top.equalTo(kindergartenAddressTextView.snp_bottom).offset(-20 * AutoSizeScaleX)
            make.right.equalTo(kindergartenAddressBGView)
            make.height.equalTo(20 * AutoSizeScaleX)
            make.width.equalTo(40 * AutoSizeScaleX)
        }
        self.countLab = countLab
        
        let submitBtn: UIButton = UIButton(type: .custom)
        submitBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        submitBtn.setTitle( "Einreichen", for: .normal)
        submitBtn.backgroundColor = UIColor(hexString: "#3868F6")
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        submitBtn.addTarget(self, action: #selector(submitBtnAction(sender:)), for: .touchUpInside)
        self.configView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.configView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.configView).offset(20 * AutoSizeScaleX)
            make.top.equalTo(kindergartenAddressBGView.snp_bottom).offset(40 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let cancelBtn: UIButton = UIButton(type: .custom)
        cancelBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        cancelBtn.setTitle( "Abbrechen", for: .normal)
        cancelBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        cancelBtn.layer.borderWidth = 1 * AutoSizeScaleX
        cancelBtn.layer.borderColor = UIColor(hexString: "#3868F6").cgColor
        cancelBtn.layer.shadowColor = UIColor.black.cgColor
        cancelBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        cancelBtn.layer.shadowOpacity = 0.12
        cancelBtn.layer.shadowRadius = 3
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(sender:)), for: .touchUpInside)
        self.configView.addSubview(cancelBtn)
        self.cancelBtn = cancelBtn
        cancelBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.configView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.configView).offset(20 * AutoSizeScaleX)
            make.top.equalTo(submitBtn.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        if(self.getTitle == "Ersteinrichtung" || self.getTitle == "Ersteinrichtung  "){
            cancelBtn.isHidden = true
        }else{
            cancelBtn.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
    }
    
    @objc func childNotCompulsaryAgeBtnAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(!sender.isSelected){
            self.isChildNotCompulsaryAgeSelected = 0
            self.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
            self.selectedDobLab.text = String.getDOBFromDate(date: self.datePicker.date)

        }else{
            self.isChildNotCompulsaryAgeSelected = 1
            self.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -7, to: Date())
            self.selectedDobLab.text = String.getDOBFromDate(date: self.datePicker.date)

        }
        self.view.endEditing(false)
    }
    
    @objc func spouseNotGettingAllowanceBtnAction(sender : UIButton) {
        sender.isSelected = !sender.isSelected
        if(!sender.isSelected){
            self.isSpouseNotGettingAllowanceSelected = 1
        }else{
            self.isSpouseNotGettingAllowanceSelected = 0
        }
        self.view.endEditing(false)
    }
    
    @objc func tapGenderBtnAction(sender:UIButton) {
        collapse()
        guard let button = sender as? UIButton else { return }
        if !button.isSelected {
            button.isSelected = true
            genderExpand()
        }
        else {
            button.isSelected = false
            genderCollapse()
        }
    }
    
    @objc func tapDobBGBtnAction(sender: UIButton) {
        genderCollapse()
    guard let button = sender as? UIButton else { return }
    if !button.isSelected {
        button.isSelected = true
        expand()
    }
    else {
        button.isSelected = false
        self.tapGenderBtn.isSelected = false
        collapse()
    }
}
    @objc func datePickerValueChanged() {
        self.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.selectedDobLab.text = String.getDOBFromDate(date: self.datePicker.date)
    }
    // MARK: - Custom Button Action
    @objc
    private func showMoreSection() {
        let controller = MoreViewController.instantiate()
        navigationController?.pushAndHideTabBar(controller)
    }
    
    @objc func expand(){
        UIView.animate(withDuration: 0.3) {
//            self.datePickerImg.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            self.dOBPickerView.snp.updateConstraints { make in
                make.height.equalTo(160 * AutoSizeScaleX)
            }
        }
    }
    
    @objc func collapse(){
        self.tapDobBGBtn.isSelected = false
        UIView.animate(withDuration: 0.3) {
//            self.datePickerImg.transform = CGAffineTransform(rotationAngle: 0)
            self.dOBPickerView.snp.updateConstraints { make in
                make.height.equalTo(0 * AutoSizeScaleX)
            }
        }
    }
    
    @objc func genderExpand(){
        UIView.animate(withDuration: 0.3) {
            self.genderPickerImg.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            self.genderPickerBGView.snp.updateConstraints { make in
                make.height.equalTo(106 * AutoSizeScaleX)
            }
        }
    }
    
    @objc func genderCollapse(){
        self.tapGenderBtn.isSelected = false
        UIView.animate(withDuration: 0.3) {
            self.genderPickerImg.transform = CGAffineTransform(rotationAngle: 0)
            self.genderPickerBGView.snp.updateConstraints { make in
                make.height.equalTo(0 * AutoSizeScaleX)
            }
        }
    }
    
    @objc func backBtnAction(sender: UIButton) {
        self.view.endEditing(false)
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeDashboardViewController.self) {
//            if controller.isKind(of: DashboardContainerViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            
            if controller.isKind(of: KindergartenViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            
            if controller.isKind(of: KindergartenListViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: BenifitsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @objc func submitBtnAction(sender: UIButton) {

        kindergartenStore.childNotCompulsory    = self.childNotCompulsaryAgeBtn.isSelected == true
        kindergartenStore.spouseNotGettingAllowance    = self.spouseNotGettingAllowanceBtn.isSelected == true
        kindergartenStore.name    = self.nameTF.text
        kindergartenStore.gender    = self.selectedGenderLab.text
        kindergartenStore.dob    = self.selectedDobLab.text
        kindergartenStore.kindergartenName    = self.kindergartenNameTypeTF.text
        kindergartenStore.kindergartenAddress    = self.kindergartenAddressTextView.text

        do {
            let credentials = try kindergartenStore.validate()
    
            if(self.isChildNotCompulsaryAgeSelected == 0){
            let alert = UIAlertController(title: "Bitte bestätigen", message: "dass Ihr Kind noch in den Kindergarten geht", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ja", style: .default , handler:{ (UIAlertAction)in
                    self.createKidKinderkartenApi()
                }))
                alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler:{ (UIAlertAction)in
                }))
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
            }else{
                self.createKidKinderkartenApi()
            }
            
        } catch let error as CreatKindergartenValidationError {
            switch error {
            case .missingChildNotCompulsory:
                UIApplication.shared.showAlertWith(title: "Bitte bestätigen Sie, dass das Kind nicht im schulpflichtigen Alter ist.".localized, message: "")
                break
            case .missingName:
                UIApplication.shared.showAlertWith(title: "Bitte Name des Kindes eintragen.".localized, message: "")
                break
            case .missingGender:
                UIApplication.shared.showAlertWith(title: "Bitte Geschlecht auswählen.".localized, message: "")
                break
            case .missingDOB:
                UIApplication.shared.showAlertWith(title: "Bitte Geburtsdatum eintragen.".localized, message: "")
                break
            case .missingKindergartenName:
                UIApplication.shared.showAlertWith(title: "Bitte Name des Kindergartens eintragen.".localized, message: "")
                break
            case .missingKindergartenAddress:
                UIApplication.shared.showAlertWith(title: "Bitte Adresse des Kindergartens eintragen.".localized, message: "")
                break
            case .missingSpouseNotGettingAllowance:
                UIApplication.shared.showAlertWith(title: "Bitte bestätigen, dass Dein (Ehe)Partner keinen Kindergartenzuschuss von seinem Arbeitgeber erhält.".localized, message: "")
                break

            }
        } catch let error {
            print(error)
        }
    }
    
    @objc func uploadReceiptBtnAction(sender: UIButton){
        let controller = MultiPictureScanViewController.instantiate(with: store)
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func cancelBtnAction(sender: UIButton) {
        let controller = KindergartenListViewController()
        navigationController?.pushAndHideTabBar(controller)
    }
    
    @objc func createKidKinderkartenApi(){
        ANActivityIndicatorPresenter.shared.showIndicator()
        ANActivityIndicatorPresenter.shared.showIndicator()
        ApplicationDelegate.client.createKidKinderkarten(name: self.nameTF.text!, gender: self.selectedGenderLab.text! , dob: self.selectedDobLab.text!,kinder_garden_name: self.kindergartenNameTypeTF.text!, kinder_garden_address: self.kindergartenAddressTextView.text!, not_compulsory_school_age: self.childNotCompulsaryAgeBtn.isSelected, spouse_not_getting_benefit: self.spouseNotGettingAllowanceBtn.isSelected){ message in
            ANActivityIndicatorPresenter.shared.hideIndicator()

            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                    if(self.getTitle == "Ersteinrichtung"){
                        let controller = KindergartenListViewController()
                        self.navigationController?.pushAndHideTabBar(controller)
                    }else{
                        for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: KindergartenListViewController.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                            if controller.isKind(of: HomeDashboardViewController.self) {
//                                        if controller.isKind(of: DashboardContainerViewController.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                    }

                }))
                self.present(alert, animated: true, completion: {
                })
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async {
            var contentRect = CGRect.zero
            for view in self.scrollView.subviews {
               contentRect = contentRect.union(view.frame)
            }
            self.scrollView.contentSize.width = contentRect.size.width
            self.scrollView.contentSize.height = self.cancelBtn.frame.origin.y + self.cancelBtn.frame.size.height + 20 * AutoSizeScaleX
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    @objc func keyboardWillAppear(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if clickedTextField.frame.origin.y + 70*AutoSizeScaleX > keyboardSize.origin.y {
                self.scrollView.isScrollEnabled = true
                self.view.frame.origin.y = keyboardSize.origin.y - clickedTextField.center.y - 180*AutoSizeScaleX
            }
        }
    }
    @objc func keyboardWillDisappear(notification:NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return genderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        self.selectedGenderLab.text = genderArray[row]
        genderCollapse()
    }
    
    @objc func keyboardWillShow(notification: Notification) {

           guard let userInfo = notification.userInfo,
               let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
               else{
                   return
           }
           let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
          // scrollView.contentOffset = CGPoint(x: 0, y:200 * AutoSizeScaleX)
        scrollView.contentInset = contentInset
          scrollView.scrollIndicatorInsets = contentInset
          var aRect: CGRect = self.view.frame
          aRect.size.height -= frame.height

          if let clickTextView = clickedTextView{
              scrollView.contentOffset = CGPoint(x: 0, y:120 * AutoSizeScaleX)

          }
       }

       @objc func keyboardWillHide(notification: Notification)
       {
           scrollView.contentInset = .zero
       }
    
    // MARK: - TextView Notifications

    @objc func textViewDidChange(notification: Notification) {
        placeholderLabel.isHidden = !self.kindergartenAddressTextView.text.isEmpty

        if self.kindergartenAddressTextView.markedTextRange == nil {
            if self.kindergartenAddressTextView.text.count > self.kindergartenAddressMaxLength {
                self.kindergartenAddressTextView.text = self.kindergartenAddressTextView.text.subStringTo(index: self.kindergartenAddressMaxLength - 1)
            }
            self.countLab.text = "\(self.kindergartenAddressTextView.text.count)/\(self.kindergartenAddressMaxLength)"
        }
    }
    
    @objc func textViewDidBeginEditing(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (isFinish) in
                if isFinish && !self.kindergartenAddressTextView.isFirstResponder {
                    NotificationCenter.default.post(name: UITextView.textDidEndEditingNotification, object: self.kindergartenAddressTextView)
                }
            })
        }
    }
    
    @objc func textViewDidEndEditing(notification: Notification) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}


extension KindergartenSetupViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nameTF:
            textField.resignFirstResponder()
        case self.kindergartenNameTypeTF:
            self.kindergartenAddressTextView.becomeFirstResponder()
        case self.nameTF:
            self.nameTF.becomeFirstResponder()
            clickedTextField = textField
        default:
            textField.resignFirstResponder()

        }
        return false
    }
  
    
    func textFieldDidEndEditing(_ textField: UITextField){
//        activeField = nil
//        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)

    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clickedTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(self.kindergartenNameTypeTF == textField || self.nameTF == textField){
            let maxLength = 50
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        }else{
            return true
        }
    }
}
extension KindergartenSetupViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genderListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellID = "CellID"
        var cell: DailyCommuterTypeTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? DailyCommuterTypeTableViewCell
        if cell == nil {
            cell = DailyCommuterTypeTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.titleLab.text = self.genderListArray[indexPath.row]
        if indexPath.row == selectedRow{
            cell?.selectImgView.image = UIImage(named: "typeCheck")
        }else{
            cell?.selectImgView.image = UIImage(named: "typeUnCheck")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        self.selectedGenderLab.text = self.genderListArray[indexPath.row]
        genderCollapse()
        self.tapGenderBtn.isSelected = false
        tableView.reloadData()
    }
}
// MARK: - TextView Delegate Methods

extension KindergartenSetupViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        clickedTextView = textView

  }
    func textViewDidEndEditing(_ textView: UITextView){
        clickedTextView=nil
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputModeStr = textView.textInputMode?.primaryLanguage
        if inputModeStr == TextInputModeStr  && (textView.selectedTextRange?.start == textView.endOfDocument) && self.kindergartenAddressMaxLength == textView.text?.count {
            return false
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

