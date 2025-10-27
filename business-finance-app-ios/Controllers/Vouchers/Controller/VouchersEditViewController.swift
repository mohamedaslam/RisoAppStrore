//
//  VouchersEditViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/22.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import UIKit

class VouchersEditViewController: BaseViewController {
    var yourCreditAmountLab: UILabel = UILabel()
    var yourCreditAmountValueLab: UILabel = UILabel()
    var discountAmountLab: UILabel = UILabel()
    private var vouchers: [Vouchers] = []
    private var userMyVouchers: [UserVoucher] = []
    var tableView: UITableView!
    var myVouchersSelected : Bool = false
    var vendorIDStr: String = "0"
    var priceSortStr: String = "ASC"
    var minPriceValue: Int = 5
    var maxPriceValue: Int = 150
    var userProductID: Int = 101
    var value_spent: String = "ASC"
    var budget: Int = 0
    var still_possible: Int = 0
    var voucherId: Int = 0

    var bottomBtnsBGView: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Bearbeiten"

        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(tapBackBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        
        configSetupUI()
        
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
        
        client.getDefaultVoucher(vouchersProductID:self.userProductID) { (getVoucherProductData) in
            self.vouchers = getVoucherProductData
            self.tableView.reloadData()
        }
    }
    
    @objc func tapBackBtnAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        
        let separateLineLab: UILabel = UILabel()
        separateLineLab.backgroundColor = .lightGray
        self.view.addSubview(separateLineLab)
        separateLineLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-10 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(10 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
            make.top.equalTo(discountAmountLab.snp_bottom).offset(6 * AutoSizeScaleX)
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
            make.top.equalTo(separateLineLab.snp_bottom).offset(20 * AutoSizeScaleX)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.vendorIDStr == "-1,"){
            self.vendorIDStr = "0"
        }
        client.getFilterVoucherProduct(vendor_id: self.vendorIDStr, price_sort: self.priceSortStr, min_price: self.minPriceValue, max_price: self.maxPriceValue) { (getVoucherProductData) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            self.vouchers = getVoucherProductData
            self.tableView.reloadData()
            }

        }

    }
}

extension VouchersEditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.myVouchersSelected == false){
            return self.vouchers.count
        }else{
            return self.userMyVouchers.count
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
            let getVoucher : Vouchers = self.vouchers[indexPath.row]
            cell?.vouchersTitleLab.attributedText = "€\(getVoucher.value)  Gutschein".attributedStringWithColorSize(color: .black, size: 20)
            if(getVoucher.type == "1"){
                cell?.vouchersSubTitleLab.text = "Online"
            }else{
                cell?.vouchersSubTitleLab.text = "Offline & Online"
            }
            cell?.iconImageView.kf.setImage(with: getVoucher.vendor.imageURL)
            cell?.deleteBtn.isHidden = true

        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let getVoucher : Vouchers = self.vouchers[indexPath.row]

        let controller = VouchersDetailsViewController()
        controller.getVouchers = getVoucher
        controller.value_spent = self.value_spent
        controller.still_possible = self.still_possible
        controller.budget = self.budget
        controller.isSachbezugPage = true
        controller.userProductId = self.userProductID
        controller.voucherId = voucherId
        self.navigationController?.pushAndHideTabBar(controller, animated: true)
    }
    
    @objc func deleteBtnCickAction(sender: UIButton){
        let index = sender.tag
        let getVoucher : Vouchers = self.vouchers[index]
        client.deleteVoucher(voucherID:getVoucher.id) { (message) in
            self.client.getDefaultVoucher(vouchersProductID:self.userProductID) { (getVoucherProductData) in
                self.vouchers = getVoucherProductData
                self.tableView.reloadData()
            }
        }

    }
}
