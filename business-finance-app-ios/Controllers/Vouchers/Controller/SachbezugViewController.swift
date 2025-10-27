//
//  SachbezugViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/22.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import UIKit

class SachbezugViewController: BaseViewController {
    var yourCreditAmountLab: UILabel = UILabel()
    var yourCreditAmountValueLab: UILabel = UILabel()
    var discountAmountLab: UILabel = UILabel()
    var yourDefaultVouchersLab : UILabel = UILabel()
    var segmentedControl : UISegmentedControl = UISegmentedControl()
    var yourCreditAmountStr: String = ""
    var yourCreditAmountValueStr: String = ""
    var discountAmountStr: String = ""
    var tableView: UITableView!
    private var vouchers: [Vouchers] = []
    private var userMyVouchers: [UserVoucher] = []
    private var myDataVoucher: [UserData] = []

    var getVoucherYearDetail: VoucherYearDetail?
    var myVouchersSelected : Bool = false
    var vendorIDStr: String = "0"
    var productID: Int = 0
    var priceSortStr: String = "ASC"
    var minPriceValue: Int = 5
    var maxPriceValue: Int = 150
    var userProductID: Int = 101
    var value_spent: String = "ASC"
    var budget: Int = 0
    var still_possible: Int = 0
    var getVoucherNamesArray: [String] = []
    var getVoucherValueArray: [Int] = []
    var isSachbezugPage : Bool = false
    var isFilterApplied : Bool = false
    var vendorsCount: Int = 0
    var filterBtn: UIButton = UIButton()
    var isAllVouchersSelected : Bool = false
    private var datePickerItems: [Int] = []
    var year : Int = 2023
    var month : Int = 0
    var isYearSelected : Bool = false
    internal let datePickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "collapseButton").original, for: .normal)
        button.setTitle(" \(Date.currentYear) ", for: UIControl.State())
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        button.centerTextAndImage(spacing: 10.0)
        button.sizeToFit()
        return button
    }()
    internal let datePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    internal let invisibleYearTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.isHidden = true
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "Sachbezug"
        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(tapBackBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        
        let startingYear = client.firstDocumentUploadDate?.year ?? Date.currentYear
        datePickerItems       = Array(startingYear...Date.currentYear).reversed()
        datePicker.dataSource = self
        datePicker.delegate   = self
        view.addSubview(invisibleYearTextField)
        invisibleYearTextField.inputView = datePicker
        invisibleYearTextField.attachDismissTooblar(doneButtonTitle: "Done".localized)
        let barButtonItem = UIBarButtonItem(customView: datePickerButton)
        navigationItem.rightBarButtonItem = barButtonItem
        datePickerButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerButton.setTitle("\(self.year)", for: .normal)
        datePickerButton.addTarget(self, action: #selector(datePickerButtonDidTouch(_:)), for: .touchUpInside)
        datePickerButton.sizeToFit()
        datePickerButton.isHidden = true

        configSetupUI()

        
        client.getDefaultVoucher(vouchersProductID:self.userProductID) { (getVoucherProductData) in
            self.vouchers = getVoucherProductData
            var n = 0

            for index in 0..<self.vouchers.count {
                let getVoucher : Vouchers = self.vouchers[index]
                self.getVoucherNamesArray.append(getVoucher.vendor.name)
                self.getVoucherValueArray.append(getVoucher.value)
                n += getVoucher.value

            }
            let string = self.getVoucherNamesArray.uniqued().joined(separator: ",")
            let getListOfVouchers = self.getVoucherNamesArray.uniqued().joinedWithComma()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                
                if let profile = ApplicationDelegate.client.loggedUser {
                    if(self.isSachbezugPage == true){
                        if(self.still_possible == 0){
                            if(self.budget - n == 0){
                            }else{
                                UIApplication.shared.showAlertWith(title: "",message: "Hallo, \(profile.name), Du hast Dein maximales Guthaben noch nicht erreicht. Bitte wähle noch weitere Standard-Gutscheine. Du hast noch \(self.budget - n) Euro Guthaben übrig. Bitte schließe den Vorgang vor dem '15 des Monats' ab.")
                            }
                            
                        }else{
                            if(self.budget - n == 0){
                            }else{
                                UIApplication.shared.showAlertWith(title: "",message: "Hallo, \(profile.name), Du hast Dein maximales Guthaben noch nicht erreicht. Bitte wähle noch weitere Standard-Gutscheine. Du hast noch \(self.budget - n) Euro Guthaben übrig. Bitte schließe den Vorgang vor dem '15 des Monats' ab.")
                            }                    }
                        
                        self.isSachbezugPage = false
                    }
                    
                }
            }
            let attributedString = NSMutableAttributedString(string: "Ihre Standardgutscheine sind \(getListOfVouchers) Anschauen")
            attributedString.addAttribute(.link, value: "Anschauen", range: NSRange(location: 1, length: 9))

            let formattedString = NSMutableAttributedString(string: "Ihre Standardgutscheine sind \(getListOfVouchers) Anschauen")

            let ShamUseAttribute = [
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0),
                NSAttributedString.Key.link: URL(string: "Sham")!,
            ] as [NSAttributedString.Key : Any]


            let ShamRange = ("Ihre Standardgutscheine sind \(getListOfVouchers) Anschauen" as NSString).range(of: "Anschauen")
            formattedString.addAttributes(ShamUseAttribute, range: ShamRange)
            
            self.yourDefaultVouchersLab.attributedText = formattedString
            
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserVouchersList(productID: self.productID,getMonth: self.month,getYear: self.year)

        if(self.vendorIDStr == "-1,"){
            self.vendorIDStr = "0"
        }
        client.getFilterVoucherProduct(vendor_id: self.vendorIDStr, price_sort: self.priceSortStr, min_price: self.minPriceValue, max_price: self.maxPriceValue) { (getVoucherProductData) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            self.vouchers = getVoucherProductData
                
                if(self.isFilterApplied == true){
                    self.segmentedControl.setTitle("Filter angewendet (\(self.vouchers.count))", forSegmentAt: 0)
                    if(self.vendorsCount == 1){
                        self.filterBtn.setTitle( "Filter", for: .normal)
                    }else{
                        if(self.vendorsCount == 0){
                            self.filterBtn.setTitle( "Filter", for: .normal)
                        }else{
                            self.filterBtn.setTitle( "\(self.vendorsCount - 1) Anbieter ausgewählt", for: .normal)
                        }
                    }
                }else{
                    self.segmentedControl.setTitle("Alle Gutscheine (\(self.vouchers.count))", forSegmentAt: 0)
                    self.filterBtn.setTitle( "Filter", for: .normal)
                }
            self.tableView.reloadData()
            }

        }
        client.getVoucherProduct(vouchersProductID:self.userProductID) { (getVoucherProductData) in
   
            self.minPriceValue = getVoucherProductData?.min_value ?? 0
            self.maxPriceValue = getVoucherProductData?.max_value ?? 50
            self.value_spent = getVoucherProductData?.value_spent ?? ""
            self.budget = getVoucherProductData?.budget ?? 0
            self.still_possible = getVoucherProductData?.still_possible ?? 0
            
            let getValue_spent:Float = Float(self.value_spent) ?? 0
            self.yourCreditAmountValueLab.text = "\((getValue_spent).priceAsString()) / \(Float(self.budget).priceAsString()) "
            self.discountAmountLab.text  = "\(Float(self.still_possible).priceAsString()) noch möglich"
        }
        getUserVouchersList(productID: self.productID,getMonth: self.month,getYear: self.year)

    }
    @objc func tapBackBtnAction(sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeDashboardViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: BenifitsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func configSetupUI(){
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
        
        let yourCreditAmountValueLab: UILabel = UILabel()
        yourCreditAmountValueLab.text = ""
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
        discountAmountLab.text = ""
        discountAmountLab.sizeToFit()
        discountAmountLab.textAlignment = .right
        discountAmountLab.font =  UIFont.appFont(ofSize: 17, weight: .semibold)
        self.view.addSubview(discountAmountLab)
        discountAmountLab.textColor = UIColor.init(hexString: "#2B395C")
        self.discountAmountLab = discountAmountLab
        discountAmountLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.width.equalTo(220 * AutoSizeScaleX)
            make.height.equalTo(16 * AutoSizeScaleX)
            make.top.equalTo(yourCreditAmountValueLab.snp_bottom).offset(6 * AutoSizeScaleX)
        }
        
        let separateLineLab: UILabel = UILabel()
        separateLineLab.backgroundColor = .lightGray
        self.view.addSubview(separateLineLab)
        separateLineLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-10 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(10 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
            make.top.equalTo(discountAmountLab.snp_bottom).offset(6 * AutoSizeScaleX)
        }
        
        let yourDefaultVouchersLab: UILabel = UILabel()
        yourDefaultVouchersLab.text = "Your default vouchers are IKEA & Etsy   View"
        yourDefaultVouchersLab.sizeToFit()
        yourDefaultVouchersLab.textAlignment = .center
        yourDefaultVouchersLab.numberOfLines = 0
        yourDefaultVouchersLab.font = UIFont.appFont(ofSize: 17, weight: .semibold)
        self.view.addSubview(yourDefaultVouchersLab)
        yourDefaultVouchersLab.textColor = UIColor.init(hexString: "#2B395C")
        self.yourDefaultVouchersLab = yourDefaultVouchersLab
        yourDefaultVouchersLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        yourDefaultVouchersLab.isUserInteractionEnabled = true
        yourDefaultVouchersLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-30 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(30 * AutoSizeScaleX)
            make.height.equalTo(80 * AutoSizeScaleX)
            make.top.equalTo(separateLineLab.snp_bottom).offset(6 * AutoSizeScaleX)
        }
           
        let questionMarkBtn: UIButton = UIButton(type: .custom)
        questionMarkBtn.setBackgroundImage(UIImage(named: "questionMarkImg"),for: .normal)
        questionMarkBtn.addTarget(self, action: #selector(questionBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(questionMarkBtn)
        questionMarkBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-10 * AutoSizeScaleX)
            make.centerY.equalTo(yourDefaultVouchersLab)
            make.width.equalTo(16 * AutoSizeScaleX)
            make.height.equalTo(20 * AutoSizeScaleX)
        }
        
        let separateLine2Lab: UILabel = UILabel()
        separateLine2Lab.backgroundColor = .lightGray
        self.view.addSubview(separateLine2Lab)
        separateLine2Lab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-10 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(10 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
            make.top.equalTo(yourDefaultVouchersLab.snp_bottom).offset(6 * AutoSizeScaleX)
        }
        
        let segmentItems = ["Alle Gutscheine()", "Meine Gutscheine()"]
        let segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        self.segmentedControl = segmentedControl
        if #available(iOS 13.0, *)
        {
            segmentedControl.tintColor = UIColor.red
            segmentedControl.backgroundColor = UIColor.App.TableView.grayBackground
            segmentedControl.selectedSegmentTintColor = UIColor.init(hexString: "#3868F6")
            segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black as Any], for: .normal)
            segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white as Any], for: .selected)
        }
        else
        {
            segmentedControl.tintColor = UIColor.red
            segmentedControl.backgroundColor = UIColor.lightGray
            segmentedControl.layer.cornerRadius = 4
        }
        segmentedControl.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(36 * AutoSizeScaleX)
            make.top.equalTo(separateLine2Lab.snp_bottom).offset(20 * AutoSizeScaleX)
        }
        self.isAllVouchersSelected = true

        let filterBtn: UIButton = UIButton(type: .custom)
        filterBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        filterBtn.setTitle( "Filter", for: .normal)
        filterBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        filterBtn.layer.borderWidth = 1 * AutoSizeScaleX
        filterBtn.layer.borderColor = UIColor(hexString: "#3868F6").cgColor
        filterBtn.layer.shadowColor = UIColor.black.cgColor
        filterBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        filterBtn.layer.shadowOpacity = 0.12
        filterBtn.layer.shadowRadius = 3
        filterBtn.addTarget(self, action: #selector(filterBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(filterBtn)
        self.filterBtn = filterBtn
        filterBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.top.equalTo(segmentedControl.snp_bottom).offset(16 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let filterImageView: UIImageView = UIImageView()
        filterImageView.image = UIImage.init(named: "filter")
        filterImageView.contentMode = .scaleAspectFit
        filterBtn.addSubview(filterImageView)
        filterImageView.snp.makeConstraints { (make) in
            make.right.equalTo(filterBtn).offset(-20 * AutoSizeScaleX)
            make.centerY.equalTo(filterBtn)
            make.height.equalTo(18 * AutoSizeScaleX)
            make.width.equalTo(14 * AutoSizeScaleX)
        }
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        self.view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(filterBtn.snp_bottom).offset(6 * AutoSizeScaleX)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        self.view.layoutIfNeeded()

        
        //getVouchersList()
    }

    func getVouchersList(){
       // client.getVouchersList { (vouchers) in
        if(self.vendorIDStr == "-1,"){
            self.vendorIDStr = "0"
        }
        client.getFilterVoucherProduct(vendor_id: self.vendorIDStr, price_sort: self.priceSortStr, min_price: self.minPriceValue, max_price: self.maxPriceValue) { (getVoucherProductData) in
            self.vouchers = getVoucherProductData
            if(self.isFilterApplied == true){
                self.segmentedControl.setTitle("Filter angewendet (\(self.vouchers.count))", forSegmentAt: 0)
            }else{
                self.segmentedControl.setTitle("Alle Gutscheine (\(self.vouchers.count))", forSegmentAt: 0)
            }

            self.tableView.reloadData()
            
        }
    }

    func getUserVouchersList(productID: Int,getMonth:Int,getYear:Int){
        client.getUserVouchersList(productID:productID,getMonth: getMonth,getYear: getYear) { (vouchers) in
            self.userMyVouchers = vouchers
            var n = 0
//            var sum = 0
            
            for i in (0 ..< self.userMyVouchers.count){
                if(self.userMyVouchers[i].data.count>0){
                   n += self.userMyVouchers[i].data.count
//                    self.myDataVoucher = self.userMyVouchers[i].data
//                    for i in (0 ..< self.myDataVoucher.count){
//                        sum += self.myDataVoucher[i].value
//                    }
                }
            }
            self.segmentedControl.setTitle("Meine Gutscheine (\(n))", forSegmentAt: 1)
            self.tableView.reloadData()
        }
    }
    
    func getUserYearVouchersList(){
        client.yearVoucherDetail(id:productID,year: self.year){ (getVoucherYearDetails) in
            self.getVoucherYearDetail = getVoucherYearDetails
            self.value_spent = self.getVoucherYearDetail?.value_spent ?? ""
            self.budget = self.getVoucherYearDetail?.budget ?? 0
            self.still_possible = self.getVoucherYearDetail?.still_possible ?? 0
            let getValue_spent:Float = Float(self.value_spent) ?? 0
            self.yourCreditAmountValueLab.text = "\((getValue_spent).priceAsString()) / \(Float(self.budget).priceAsString()) "
            self.discountAmountLab.text  = "\(Float(self.still_possible).priceAsString()) noch möglich"
        }
    }

    
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
       switch (segmentedControl.selectedSegmentIndex) {
          case 0:
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               
               self.filterBtn.snp.updateConstraints { (make) in
                   make.height.equalTo(46 * AutoSizeScaleX)
               }
               self.tableView.snp.updateConstraints { (make) in
                   make.top.equalTo(self.filterBtn.snp_bottom).offset(16 * AutoSizeScaleX)
               }
               self.filterBtn.isHidden = false
           }
           self.myVouchersSelected = false
           datePickerButton.isHidden = true
             getVouchersList()

               datePickerButton.isHidden = true
               client.getVoucherProduct(vouchersProductID:self.userProductID) { (getVoucherProductData) in
          
                   self.minPriceValue = getVoucherProductData?.min_value ?? 0
                   self.maxPriceValue = getVoucherProductData?.max_value ?? 50
                   self.value_spent = getVoucherProductData?.value_spent ?? ""
                   self.budget = getVoucherProductData?.budget ?? 0
                   self.still_possible = getVoucherProductData?.still_possible ?? 0

                   let getValue_spent:Float = Float(self.value_spent) ?? 0
                   self.yourCreditAmountValueLab.text = "\((getValue_spent).priceAsString()) / \(Float(self.budget).priceAsString()) "
                   self.discountAmountLab.text  = "\(Float(self.still_possible).priceAsString()) noch möglich"
           }

           segmentedControl.setTitle("Alle Gutscheine (\(self.vouchers.count))", forSegmentAt: 0)
           self.isAllVouchersSelected = true
           break
          case 1:
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
               
               self.filterBtn.snp.updateConstraints { (make) in
                   make.height.equalTo(1 * AutoSizeScaleX)
               }
               self.tableView.snp.updateConstraints { (make) in
                   make.top.equalTo(self.filterBtn.snp_bottom).offset(4 * AutoSizeScaleX)
               }

           }
           self.filterBtn.isHidden = true

           self.myVouchersSelected = true
           getUserVouchersList(productID: self.productID,getMonth: self.month,getYear: self.year)

         //  segmentedControl.setTitle("Meine Gutscheine (\(self.userMyVouchers.count))", forSegmentAt: 1)
           self.isAllVouchersSelected = false
           if(isYearSelected == true){
               datePickerButton.isHidden = true
               //getUserYearVouchersList()
           }else{
               datePickerButton.isHidden = true
           }

          break
          default:
          break
       }
    }
    
    @objc func filterBtnAction(sender: UIButton) {
        if(self.isFilterApplied == true){
            self.navigationController?.popViewController(animated: true)
        }else{
            let controller = VouchersFilterViewController()
            controller.userProductID = self.userProductID
            controller.productID = self.productID
            controller.minPriceValue = self.minPriceValue
            controller.maxPriceValue = self.maxPriceValue
            controller.isSachbezugPage = true
            controller.value_spent = self.value_spent
            controller.budget = self.budget
            controller.isYearSelected = self.isYearSelected
            controller.month = self.month
            controller.year = self.year
            controller.still_possible = self.still_possible
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func questionBtnAction(sender: UIButton){
        let controller = QuestionMarkViewController()
        navigationController?.pushAndHideTabBar(controller, animated: true)
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        // handling code
        let controller = SachbezugDefaultVoucherVC()
        controller.userProductID = self.userProductID
        controller.minPriceValue = self.minPriceValue
        controller.maxPriceValue = self.maxPriceValue
        navigationController?.pushAndHideTabBar(controller, animated: true)
    }
    private func didUpdate(year: Int) {
        guard self.year != year, year <= Date.currentYear else { return }
        self.year = year
        self.month = 0
        datePickerButton.setTitle("\(year)", for: .normal)
        datePickerButton.sizeToFit()
        getUserVouchersList(productID: self.productID,getMonth: self.month,getYear: self.year)
        //getUserYearVouchersList()

    }
    
    @objc
    private func datePickerButtonDidTouch(_ sender: UIButton) {
        if invisibleYearTextField.isFirstResponder {
            view.endEditing(true)
        }
        invisibleYearTextField.becomeFirstResponder()
    }

}
extension SachbezugViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.myVouchersSelected == false){
            return 1
        }else{
            return self.userMyVouchers.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(self.myVouchersSelected == false){
            return ""
        }else{
            if(isYearSelected == true){
                if(self.userMyVouchers[section].data.count > 0){
                    let fmt = DateFormatter()
                    fmt.dateFormat = "MMM"
                    let month = fmt.monthSymbols[self.userMyVouchers[section].month - 1]
                    return month
                }else{
                    return ""
                }
            }else{
                if(self.userMyVouchers[section].data.count > 0){
                    let fmt = DateFormatter()
                    fmt.dateFormat = "MMM"
                    let month = fmt.monthSymbols[self.month - 1]
                    return month
                }else{
                    return ""
                }

            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.myVouchersSelected == false){
            return self.vouchers.count
        }else{
            if(isYearSelected == true){
                return self.userMyVouchers[section].data.count

            }else{
                return self.userMyVouchers[0].data.count
            }
            
        }
        //return self.benifitsListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CellID"
        var cell: VouchersListTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? VouchersListTableViewCell
        if cell == nil {
            cell = VouchersListTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        if(self.myVouchersSelected == false){
            datePickerButton.isHidden = true
            let getVoucher : Vouchers = self.vouchers[indexPath.row]
            cell?.vouchersTitleLab.attributedText = "€\(getVoucher.value)  Gutschein".attributedStringWithColorSize(color: .black, size: 20)
            if(getVoucher.type == "1"){
                cell?.vouchersSubTitleLab.text = "Online"
            }else{
                cell?.vouchersSubTitleLab.text = " Online & Offline"
            }
            cell?.iconImageView.kf.setImage(with: getVoucher.vendor.imageURL)
            cell?.orderedLab.isHidden = true
        }else{
            self.segmentedControl.setTitle("Meine Gutscheine (\(self.userMyVouchers[indexPath.section].data.count))", forSegmentAt: 1)
            if(self.userMyVouchers[indexPath.section].data.count>0){

                cell?.vouchersTitleLab.attributedText = "€\(self.userMyVouchers[indexPath.section].data[indexPath.row].value)  Gutschein".attributedStringWithColorSize(color: .black, size: 20)
                if(self.userMyVouchers[indexPath.section].data[indexPath.row].is_active == 1){
                    cell?.vouchersSubTitleLab.text = "Online"
                }else{
                    cell?.vouchersSubTitleLab.text = "Offline & Online"
                }
                if(self.userMyVouchers[indexPath.section].data[indexPath.row].voucher_status == 1){
                    cell?.orderedLab.text = "Angefordert"
                    cell?.orderedLab.textColor = UIColor.init(hexString: "#1E4199")
                }else if(self.userMyVouchers[indexPath.section].data[indexPath.row].voucher_status == 2){
                    cell?.orderedLab.text = "Aktiv"
                    cell?.orderedLab.textColor = UIColor.init(hexString: "#4CD964")
                }else if(self.userMyVouchers[indexPath.section].data[indexPath.row].voucher_status == 3){
                    cell?.orderedLab.text = "Eingelöst"
                    cell?.orderedLab.textColor = UIColor.init(hexString: "#2B395C")
                }else if(self.userMyVouchers[indexPath.section].data[indexPath.row].voucher_status == 4){
                    cell?.orderedLab.text = "Abgelaufen"
                    cell?.orderedLab.textColor = UIColor.red
                }
                cell?.iconImageView.kf.setImage(with: self.userMyVouchers[indexPath.section].data[indexPath.row].vendor.imageURL)
                cell?.orderedLab.isHidden = false
            }
        }


        //cell?.benifitsTitleLab.text = self.benifitsListArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(self.myVouchersSelected == false){
        let getVoucher : Vouchers = self.vouchers[indexPath.row]
        let controller = VouchersDetailsViewController()
        if(self.still_possible >= getVoucher.value){
            controller.isStilPossibleValue = true
        }else{
            controller.isStilPossibleValue = false
        }
        controller.getVouchers = getVoucher
        controller.value_spent = self.value_spent
        controller.still_possible = self.still_possible
        controller.budget = self.budget
        controller.isAllVouchers = self.isAllVouchersSelected
        controller.userProductId = self.userProductID
        self.navigationController?.pushAndHideTabBar(controller, animated: true)
        }else{
            if(self.userMyVouchers[indexPath.section].data.count > 0){
                
                let getUserVoucher : UserData = self.userMyVouchers[indexPath.section].data[indexPath.row]
                
                let controller = VoucherDefaultDetailsViewController()
                if(self.still_possible >= getUserVoucher.value){
                    controller.isStilPossibleValue = true
                }else{
                    controller.isStilPossibleValue = false
                }
                controller.getVouchers = getUserVoucher
                controller.value_spent = self.value_spent
                controller.still_possible = self.still_possible
                controller.budget = self.budget
                controller.isAllVouchers = self.isAllVouchersSelected
                controller.userProductId = self.userProductID
                self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }else{
                self.getUserVouchersList(productID: self.productID,getMonth: self.month,getYear: self.year)
            }
        }
    }
    
}

extension Array where Element: Hashable {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
// MARK: - UIPickerViewDataSource
extension SachbezugViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datePickerItems.count
    }
}

// MARK: - UIPickerViewDelegate
extension SachbezugViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let year = datePickerItems[row]
        return "\(year)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = datePickerItems[row]
        didUpdate(year: year)
    }
}
