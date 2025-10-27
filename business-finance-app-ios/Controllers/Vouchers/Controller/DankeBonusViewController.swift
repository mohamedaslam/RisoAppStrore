//
//  DankeBonusViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/14.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import UIKit

class DankeBonusViewController: BaseViewController {
    var yourCreditAmountLab: UILabel = UILabel()
    var yourCreditAmountValueLab: UILabel = UILabel()
    var discountAmountLab: UILabel = UILabel()
    var segmentedControl : UISegmentedControl = UISegmentedControl()
    var yourCreditAmountStr: String = ""
    var yourCreditAmountValueStr: String = ""
    var discountAmountStr: String = ""
    var tableView: UITableView!
    private var vouchers: [Vouchers] = []
    private var userMyVouchers: [UserVoucher] = []
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
    var isFilterApplied : Bool = false
    var isYearSelected : Bool = false
    var vendorsCount: Int = 0
    var filterBtn: UIButton = UIButton()
    var isAllVouchersSelected : Bool = false
    var isVoucherFilterApplied : Bool = false
    private var datePickerItems: [Int] = []
    var year : Int = 2023
    var month : Int = 02

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
        self.navigationItem.title = "Danke-Bonus"
       

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getVouchersList()
        getUserVouchersList()
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
                    self.isAllVouchersSelected = true
                }else{
                    self.segmentedControl.setTitle("Alle Gutscheine (\(self.vouchers.count))", forSegmentAt: 0)
                    self.filterBtn.setTitle( "Filter", for: .normal)
                    self.isAllVouchersSelected = true
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
        getUserVouchersList()
        self.isAllVouchersSelected = true
    }
    
    @objc func tapBackBtnAction(sender: UIButton) {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ProductsOverviewViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
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
            make.top.equalTo(discountAmountLab.snp_bottom).offset(20 * AutoSizeScaleX)
        }
        
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
            make.top.equalTo(filterBtn.snp_bottom).offset(4 * AutoSizeScaleX)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }

    }
    
    func getVouchersList(){
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
                    self.isAllVouchersSelected = true
                }else{
                    self.segmentedControl.setTitle("Alle Gutscheine (\(self.vouchers.count))", forSegmentAt: 0)
                    self.filterBtn.setTitle( "Filter", for: .normal)
                    self.isAllVouchersSelected = true
                }
                
                if(self.segmentedControl.selectedSegmentIndex == 1){
                    self.isAllVouchersSelected = false
                }else{
                    self.isAllVouchersSelected = true
                }
                self.tableView.reloadData()
            }

        }
    }

    func getUserVouchersList(){
        client.getUserVouchersList(productID: self.productID,getMonth: self.month,getYear: self.year) { (vouchers) in

            self.userMyVouchers = vouchers
            var n = 0

            for i in (0 ..< self.userMyVouchers.count){
                if(self.userMyVouchers[i].data.count>0){
                   n += self.userMyVouchers[i].data.count
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
             getVouchersList()
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
           self.myVouchersSelected = false
           datePickerButton.isHidden = true

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

           getUserVouchersList()
           self.myVouchersSelected = true
           self.isAllVouchersSelected = false
           if(isYearSelected == true){
               datePickerButton.isHidden = true
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
            controller.value_spent = self.value_spent
            controller.budget = self.budget
            controller.isYearSelected = self.isYearSelected
            controller.month = self.month
            controller.year = self.year
            controller.still_possible = self.still_possible
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
extension DankeBonusViewController: UITableViewDataSource, UITableViewDelegate {
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
            cell?.orderedLab.isHidden = true
            if(getVoucher.type == "1"){
                cell?.vouchersSubTitleLab.text = "Online"
            }else{
                cell?.vouchersSubTitleLab.text = "Offline & Online"
            }
            cell?.iconImageView.kf.setImage(with: getVoucher.vendor.imageURL)
            
        }else{
            if(isYearSelected == true){
                datePickerButton.isHidden = true
            }else{
                datePickerButton.isHidden = true
            }
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
            controller.isDankeBonusPage = true
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
                //            if(getUserVoucher.data >1){
                if(self.still_possible >= getUserVoucher.value){
                    controller.isStilPossibleValue = true
                }else{
                    controller.isStilPossibleValue = false
                }
                //            }
                
                controller.getVouchers = getUserVoucher
                controller.value_spent = self.value_spent
                controller.still_possible = self.still_possible
                controller.budget = self.budget
                controller.isAllVouchers = self.isAllVouchersSelected
                controller.userProductId = self.userProductID
                self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }else{
                self.getUserVouchersList()
            }
        }

    }
    
    private func didUpdate(year: Int) {
        guard self.year != year, year <= Date.currentYear else { return }
        self.year = year
        self.month = 0
        datePickerButton.setTitle("\(year)", for: .normal)
        datePickerButton.sizeToFit()
        getUserVouchersList()
       // getUserYearVouchersList()

    }
    
    @objc
    private func datePickerButtonDidTouch(_ sender: UIButton) {
        if invisibleYearTextField.isFirstResponder {
            view.endEditing(true)
        }
        invisibleYearTextField.becomeFirstResponder()
    }
    
}
extension String {
    func attributedStringWithColorSize( color: UIColor, size:CGFloat = 22) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)


        var getCountValue = 12
        if(self.count == 11){
            getCountValue = 4
        }else{
            getCountValue = 5
        }
        if self.count < getCountValue {
            return attributedString
        }
            let range = NSRange(location: 0, length: getCountValue)
        attributedString.addAttribute(NSAttributedString.Key.font,value: UIFont.appFont(ofSize: 22, weight: .semibold) , range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

        return attributedString
    }
}
// MARK: - UIPickerViewDataSource
extension DankeBonusViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datePickerItems.count
    }
}

// MARK: - UIPickerViewDelegate
extension DankeBonusViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let year = datePickerItems[row]
        return "\(year)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = datePickerItems[row]
        didUpdate(year: year)
    }
}
