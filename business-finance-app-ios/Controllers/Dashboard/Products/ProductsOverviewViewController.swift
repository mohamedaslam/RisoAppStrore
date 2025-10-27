//
//  ProductsOverviewViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import ANActivityIndicator

extension ProductsOverviewViewController {
    static func instantiate(with monthlyOverview: MonthlyOverviewData,yearlyOverview :YearlyOverviewData,month:Int,year : Int,selectMonth : Int,getCategory:Int,isYearlySelected:Bool) -> ProductsOverviewViewController {
        let storyboard = UIStoryboard(storyboard: .dashboard)
        let vc: ProductsOverviewViewController = storyboard.instantiateViewController()
        vc.monthlyYearlyOverview = monthlyOverview
        vc.yearlyOverview = yearlyOverview
        vc.selectMonth = selectMonth
        vc.isYearlySelected = isYearlySelected
        vc.getCategory = getCategory
        vc.month = month
        vc.year = year
        return vc
    }
}

class ProductsOverviewViewController: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    //private var monthlyOverview: MonthlyOverview?
    private var monthlyYearlyOverview: MonthlyOverviewData?
    private var yearlyOverview: YearlyOverviewData?
    private var datePickerItems: [Int] = []
    var getVoucherProductData : VoucherProduct?

    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var segamentTab: UISegmentedControl!
    var isYearlySelected: Bool = false
    var month : Int = 0
    var selectMonth : Int = 0
    var year : Int = 0
    var getCategory : Int = 0
    var total_amount_spent = 0.0
    var total_amount = 0.0
    var remainingAmount = 0.0
    var accreditedAmount = 0.0
    var sorryNoBenefitAvlLab: UITextView = UITextView()
    let risoWebsiteURL = "https://www.riso-app.de/";

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
}

extension ProductsOverviewViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title                 = "productsOverview.title".localized

        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor            = UIColor.App.TableView.grayBackground
        tableView?.backgroundColor      = view.backgroundColor
        tableView?.dataSource         = self
        tableView?.delegate           = self
        tableView?.estimatedRowHeight = 100
        tableView?.tableFooterView    = UIView()
        tableView?.tableHeaderView    = UIView()
        tableView?.rowHeight          = UITableView.automaticDimension
        tableView?.separatorStyle     = .none
        tableView?.contentInset       = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        if(isYearlySelected == true){
            self.updateYearly(with: yearlyOverview!)
        }else{
            self.update(with: monthlyYearlyOverview!)
        }
        
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
        updateAmountData(getCategory: self.getCategory)
        self.segamentTab.selectedSegmentIndex = self.getCategory
        
        let sorryNoBenefitAvlLab: UITextView = UITextView()
        let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
       let attributedText = self.sorryNoBenefitAvlLab.attributedText

       let range = (str as NSString).range(of: "unserer Webseite")

        let attributedString = NSMutableAttributedString(string: str)
       attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
       var foundRange = attributedString.mutableString.range(of: "unserer Webseite")
       attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
      //Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen.
        sorryNoBenefitAvlLab.backgroundColor = .clear
        sorryNoBenefitAvlLab.isUserInteractionEnabled = true
        sorryNoBenefitAvlLab.isSelectable = true
        sorryNoBenefitAvlLab.delegate = self
        sorryNoBenefitAvlLab.isHidden = true
        sorryNoBenefitAvlLab.dataDetectorTypes = .link
        self.view.addSubview(sorryNoBenefitAvlLab)
        self.sorryNoBenefitAvlLab = sorryNoBenefitAvlLab
        self.sorryNoBenefitAvlLab.attributedText = attributedString
        self.sorryNoBenefitAvlLab.textColor = UIColor.init(hexString: "#2B395C")
        self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
        self.sorryNoBenefitAvlLab.textAlignment = .center
        sorryNoBenefitAvlLab.snp.makeConstraints { (make) in
            make.top.equalTo(segamentTab.snp_bottom).offset(20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(100 * AutoSizeScaleX)
        }
    }
    private func reloadData() {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let operation = BlockOperation { [unowned self] in
            let group = DispatchGroup()

            //MonthlyYearlyOverview
            group.enter()
            client.getMonthlyYearlyOverviews(month: nil, year: year) { [weak self] (monthlyYearlyOverviewData) in
                guard let `self` = self else {
                    group.leave()
                    return
                }
                self.yearlyOverview = monthlyYearlyOverviewData?.yearly
                group.leave()
            }
            group.notify(queue: DispatchQueue.main, execute: { [weak self] in
                guard let `self` = self else { return }

                UIView.animate(withDuration: 0.3, animations: { [self] in
//                    self.productsStackView.alpha          = 1.0
                    self.updateYearly(with: self.yearlyOverview!)
                    ANActivityIndicatorPresenter.shared.hideIndicator()
                    self.updateAmountData(getCategory: self.getCategory)

                })

            })
        }
        
        operation.start()
    }
    func update(with overview: MonthlyOverviewData) {
        self.monthlyYearlyOverview = overview
        DispatchQueue.main.async { self.tableView?.reloadData() }
        
        if let pushedControllers = self.navigationController?.viewControllers {
            for controller in pushedControllers {
                if
                    let detailsController = controller as? ProductOverviewDetailsViewController,
                    let currentOverview = detailsController.productOverview,
                    let indexOf = overview.productsOverviews.firstIndex(where: { (overview) -> Bool in
                        overview.product == currentOverview.product
                    }),
                    let newOverview = overview.productsOverviews.value(at: indexOf) {
                    detailsController.update(with: newOverview)
                }
            }
            self.updateAmountData(getCategory: self.getCategory)

        }

    }
    func updateYearly(with overview: YearlyOverviewData) {
        self.yearlyOverview = overview
        DispatchQueue.main.async { self.tableView?.reloadData() }
        
        if let pushedControllers = self.navigationController?.viewControllers {
            for controller in pushedControllers {
                if
                    let detailsController = controller as? ProductOverviewDetailsViewController,
                    let currentOverview = detailsController.productOverview,
                    let indexOf = overview.productsOverviews.firstIndex(where: { (overview) -> Bool in
                        overview.product == currentOverview.product
                    }),
                    let newOverview = overview.productsOverviews.value(at: indexOf) {
                    detailsController.update(with: newOverview)
                }
            }
            self.updateAmountData(getCategory: self.getCategory)
        }
    }
    
    private func didUpdate(year: Int) {
        guard self.year != year, year <= Date.currentYear else { return }
        self.year = year
        datePickerButton.setTitle("\(year)", for: .normal)
        datePickerButton.sizeToFit()
        reloadData()
    }
    
    @objc
    private func datePickerButtonDidTouch(_ sender: UIButton) {
        if invisibleYearTextField.isFirstResponder {
            view.endEditing(true)
        }
        invisibleYearTextField.becomeFirstResponder()
    }
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl)
    {
        if(segamentTab.selectedSegmentIndex == 0){
            self.getCategory = 0
        }else if (segamentTab.selectedSegmentIndex == 1){
            self.getCategory = 1
        }else if (segamentTab.selectedSegmentIndex == 2){
            self.getCategory = 2
        }else if (segamentTab.selectedSegmentIndex == 3){
            self.getCategory = 3
        }
        updateAmountData(getCategory: self.getCategory)

        self.tableView.reloadData()
    }
    
    @objc func updateAmountData(getCategory : Int){
        total_amount =  0.0
        total_amount_spent =  0.0
        remainingAmount =  0.0
        accreditedAmount = 0.0
        if(isYearlySelected == true){
            let getYearlyCategoryData = yearlyOverview?.productsOverviews.filter({$0.product.category_type == getCategory})
            for index in 0..<(getYearlyCategoryData!.count) {
                total_amount += getYearlyCategoryData?[index].totalAmount ?? 0.0
                total_amount_spent += getYearlyCategoryData?[index].totalAmountSpent ?? 0.0
                remainingAmount += getYearlyCategoryData?[index].remainingAmount ?? 0.0
            }
            accreditedAmount = total_amount - remainingAmount

            if(getYearlyCategoryData!.count == 0){
                if(getCategory == 1 || getCategory == 2 || getCategory == 0){
                    let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
                   let attributedText = self.sorryNoBenefitAvlLab.attributedText

                   let range = (str as NSString).range(of: "unserer Webseite")

                    let attributedString = NSMutableAttributedString(string: str)
                   attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                   var foundRange = attributedString.mutableString.range(of: "unserer Webseite")
                   attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
                   self.sorryNoBenefitAvlLab.attributedText = attributedString
                    self.sorryNoBenefitAvlLab.textColor = UIColor.init(hexString: "#2B395C")
                   self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                   self.sorryNoBenefitAvlLab.textAlignment = .center
                }
                if(getCategory == 3){
                    sorryNoBenefitAvlLab.isSelectable = true
                    sorryNoBenefitAvlLab.dataDetectorTypes = .link
                    self.sorryNoBenefitAvlLab.delegate = self
                    let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
                  let attributedText = self.sorryNoBenefitAvlLab.attributedText
                  let range = (str as NSString).range(of: "")
                 let attributedString = NSMutableAttributedString(string: str)
                  attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                  self.sorryNoBenefitAvlLab.attributedText = attributedString
                    self.sorryNoBenefitAvlLab.textColor = UIColor.init(hexString: "#2B395C")

                    self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                  self.sorryNoBenefitAvlLab.textAlignment = .center
                }
                self.sorryNoBenefitAvlLab.isHidden = false
                total_amount =  0.0
                total_amount_spent =  0.0
                remainingAmount =  0.0
                accreditedAmount = 0.0
            }else{
                self.sorryNoBenefitAvlLab.isHidden = true
            }
        }else{
            let getMonthlyCategoryData = self.monthlyYearlyOverview?.productsOverviews.filter({$0.product.category_type == getCategory})
            for index in 0..<(getMonthlyCategoryData!.count) {
                total_amount += getMonthlyCategoryData?[index].totalAmount ?? 0.0
                total_amount_spent += getMonthlyCategoryData?[index].totalAmountSpent ?? 0.0
                remainingAmount += getMonthlyCategoryData?[index].remainingAmount ?? 0.0
            }
            accreditedAmount = total_amount - remainingAmount

            if(getMonthlyCategoryData!.count == 0){
                self.sorryNoBenefitAvlLab.isHidden = false
                total_amount =  0.0
                total_amount_spent =  0.0
                remainingAmount =  0.0
                accreditedAmount = 0.0
                if(getCategory == 1 || getCategory == 2 || getCategory == 0){
                    let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
                   let attributedText = self.sorryNoBenefitAvlLab.attributedText

                   let range = (str as NSString).range(of: "unserer Webseite")

                    let attributedString = NSMutableAttributedString(string: str)
                   attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                   var foundRange = attributedString.mutableString.range(of: "unserer Webseite")
                   attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
                   self.sorryNoBenefitAvlLab.attributedText = attributedString
                    self.sorryNoBenefitAvlLab.textColor = UIColor.init(hexString: "#2B395C")
                   self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                   self.sorryNoBenefitAvlLab.textAlignment = .center
                }
                if(getCategory == 3){
                    sorryNoBenefitAvlLab.isSelectable = true
                    sorryNoBenefitAvlLab.dataDetectorTypes = .link
                    self.sorryNoBenefitAvlLab.delegate = self
                    let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
                  let attributedText = self.sorryNoBenefitAvlLab.attributedText
                  let range = (str as NSString).range(of: "")
                 let attributedString = NSMutableAttributedString(string: str)
                  attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                  self.sorryNoBenefitAvlLab.attributedText = attributedString
                    self.sorryNoBenefitAvlLab.textColor = UIColor.init(hexString: "#2B395C")
                  self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                  self.sorryNoBenefitAvlLab.textAlignment = .center
                }
            }else{
                self.sorryNoBenefitAvlLab.isHidden = true
            }
        }
        if(getCategory == 0 ){
            self.sorryNoBenefitAvlLab.isHidden = true
            if(isYearlySelected == true){
                total_amount_spent = self.yearlyOverview?.total_amount_spent ?? 0.0
                total_amount = self.yearlyOverview?.totalAmount ?? 0.0
                remainingAmount = self.yearlyOverview?.remainingAmount ?? 0.0
                accreditedAmount = total_amount_spent

            }else{
                total_amount = self.monthlyYearlyOverview?.totalAmount ?? 0.0
                total_amount_spent = self.monthlyYearlyOverview?.total_amount_spent ?? 0.0
                remainingAmount = self.monthlyYearlyOverview?.remainingAmount ?? 0.0
                accreditedAmount = total_amount - remainingAmount
            }
        }
        self.totalAmount.text = " \(accreditedAmount.priceAsString())/ \(total_amount.priceAsString())"
        self.discountAmount.text = " \(remainingAmount.priceAsString()) noch möglich"

    }
}

extension ProductsOverviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isYearlySelected == true){
            let getYearlyCategoryData = yearlyOverview?.productsOverviews.filter({$0.product.category_type == self.getCategory})

            if(self.getCategory == 0){
                return yearlyOverview?.productsOverviews.count ?? 0
            }else{
                return getYearlyCategoryData?.count ?? 0
            }
        }else{
            let getMonthlyCategoryData = monthlyYearlyOverview?.productsOverviews.filter({$0.product.category_type == self.getCategory})
            if(self.getCategory == 0){
                return monthlyYearlyOverview?.productsOverviews.count ?? 0
            }else{
                return getMonthlyCategoryData?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(isYearlySelected == true){
            let getYearlyCategoryData = yearlyOverview?.productsOverviews.filter({$0.product.category_type == self.getCategory})
            if(self.getCategory == 0){
                guard
                    let overviews = yearlyOverview?.productsOverviews,
                    (0..<overviews.count).contains(indexPath.row) else {
                        return UITableViewCell.empty()
                }
                let productOverview = overviews[indexPath.row]
                let cell = ProductOverviewTableViewCell.dequeue(in: tableView)
                cell.configure(with: productOverview)
                return cell
            }else{
                guard
                    let overviews = getYearlyCategoryData,
                    (0..<overviews.count).contains(indexPath.row) else {
                        return UITableViewCell.empty()
                }
                let productOverview = overviews[indexPath.row]
                let cell = ProductOverviewTableViewCell.dequeue(in: tableView)
                cell.configure(with: productOverview)
                self.sorryNoBenefitAvlLab.isHidden = true
                return cell
            }

        }else{
            let getMonthlyCategoryData = monthlyYearlyOverview?.productsOverviews.filter({$0.product.category_type == self.getCategory})
            if(self.getCategory == 0){
                guard
                    let overviews =  monthlyYearlyOverview?.productsOverviews,
                    (0..<overviews.count).contains(indexPath.row) else {
                        return UITableViewCell.empty()
                }
                let productOverview = overviews[indexPath.row]
                let cell = ProductOverviewTableViewCell.dequeue(in: tableView)
                cell.configure(with: productOverview)
                return cell
            }else{
                guard
                    let overviews = getMonthlyCategoryData,
                    (0..<overviews.count).contains(indexPath.row) else {
                        return UITableViewCell.empty()
                }
                let productOverview = overviews[indexPath.row]
                let cell = ProductOverviewTableViewCell.dequeue(in: tableView)
                cell.configure(with: productOverview)
                self.sorryNoBenefitAvlLab.isHidden = true

                return cell
            }

        }

    }
}

extension ProductsOverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(isYearlySelected == true){
            guard let monthlyOverview = yearlyOverview else { return }
            if(self.getCategory == 0){
                let overviews = monthlyOverview.productsOverviews
                guard (0..<overviews.count).contains(indexPath.row) else { return }
                
                let productOverview = overviews[indexPath.row]
                
                client.getVoucherProduct(vouchersProductID:productOverview.product.id) { (getVoucherProductData) in
                    self.getVoucherProductData = getVoucherProductData
                }
                if(productOverview.product.product_code == "danke_bonus"){
                    let controller = DankeBonusViewController()
                    controller.userProductID = productOverview.product.userProductId
                    controller.productID = productOverview.product.id
                    controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                    controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                    controller.value_spent = getVoucherProductData?.value_spent ?? ""
                    controller.isYearSelected = true
                    controller.month = 0
                    controller.year = self.year
                    controller.budget = getVoucherProductData?.min_value ?? 0
                    controller.still_possible = getVoucherProductData?.still_possible ?? 0
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }else if (productOverview.product.product_code == "sachbezug"){
                    let controller = SachbezugViewController()
                    controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                    controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                    controller.value_spent = getVoucherProductData?.value_spent ?? ""
                    controller.budget = getVoucherProductData?.min_value ?? 0
                    controller.isYearSelected = true
                    controller.month = 0
                    controller.year = self.year
                    controller.still_possible = getVoucherProductData?.still_possible ?? 0
                    controller.userProductID = productOverview.product.userProductId
                    controller.productID = productOverview.product.id
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }else{
                    let controller = ProductOverviewDetailsViewController.instantiate(
                        with: productOverview,
                        month: -1,
                        year: self.year
                    )
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }else{
                let getYearlyCategoryData = monthlyOverview.productsOverviews.filter({$0.product.category_type == self.getCategory})
                let overviews = getYearlyCategoryData
                guard (0..<overviews.count).contains(indexPath.row) else { return }
                
                let productOverview = overviews[indexPath.row]
                client.getVoucherProduct(vouchersProductID:productOverview.product.id) { (getVoucherProductData) in
                    self.getVoucherProductData = getVoucherProductData
                }
                if(productOverview.product.product_code == "danke_bonus"){
                    let controller = DankeBonusViewController()
                    controller.userProductID = productOverview.product.userProductId
                    controller.productID = productOverview.product.id
                    controller.isYearSelected = true
                    controller.month = 0
                    controller.year = self.year
                    controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                    controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                    controller.value_spent = getVoucherProductData?.value_spent ?? ""
                    controller.budget = getVoucherProductData?.min_value ?? 0
                    controller.still_possible = getVoucherProductData?.still_possible ?? 0
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }else if (productOverview.product.product_code == "sachbezug"){
                    let controller = SachbezugViewController()
                    controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                    controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                    controller.value_spent = getVoucherProductData?.value_spent ?? ""
                    controller.budget = getVoucherProductData?.min_value ?? 0
                    controller.isYearSelected = true
                    controller.month = 0
                    controller.year = self.year
                    controller.still_possible = getVoucherProductData?.still_possible ?? 0
                    controller.userProductID = productOverview.product.userProductId
                    controller.productID = productOverview.product.id
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }else{
                    let controller = ProductOverviewDetailsViewController.instantiate(
                        with: productOverview,
                        month: -1,
                        year: self.year
                    )
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }

        }else{
            guard let monthlyOverview = monthlyYearlyOverview else { return }
            if(self.getCategory == 0){
                let overviews = monthlyOverview.productsOverviews
                guard (0..<overviews.count).contains(indexPath.row) else { return }
                
                let productOverview = overviews[indexPath.row]
                client.getVoucherProduct(vouchersProductID:productOverview.product.id) { (getVoucherProductData) in
                    self.getVoucherProductData = getVoucherProductData
                }
                if(productOverview.product.product_code == "danke_bonus"){
                    let controller = DankeBonusViewController()
                    controller.userProductID = productOverview.product.userProductId
                    controller.productID = productOverview.product.id
                    controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                    controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                    controller.value_spent = getVoucherProductData?.value_spent ?? ""
                    controller.budget = getVoucherProductData?.min_value ?? 0
                    controller.isYearSelected = false
                    controller.month = self.selectMonth
                    controller.year = self.year
                    controller.still_possible = getVoucherProductData?.still_possible ?? 0
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }else if (productOverview.product.product_code == "sachbezug"){
                    let controller = SachbezugViewController()
                    controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                    controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                    controller.value_spent = getVoucherProductData?.value_spent ?? ""
                    controller.budget = getVoucherProductData?.min_value ?? 0
                    controller.isYearSelected = false
                    controller.month = self.selectMonth
                    controller.year = self.year
                    controller.still_possible = getVoucherProductData?.still_possible ?? 0
                    controller.userProductID = productOverview.product.userProductId
                    controller.productID = productOverview.product.id
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }else{
                    let controller = ProductOverviewDetailsViewController.instantiate(
                        with: productOverview,
                        month: Int(monthlyOverview.month) ?? 0,
                        year: self.year
                    )
                    self.navigationController?.pushViewController(controller, animated: true)
                }

            }else{
                let getMonthlyCategoryData = monthlyOverview.productsOverviews.filter({$0.product.category_type == self.getCategory})
                let overviews = getMonthlyCategoryData
                guard (0..<overviews.count).contains(indexPath.row) else { return }
                
                let productOverview = overviews[indexPath.row]
                client.getVoucherProduct(vouchersProductID:productOverview.product.id) { (getVoucherProductData) in
                    self.getVoucherProductData = getVoucherProductData
                }
                if(productOverview.product.product_code == "danke_bonus"){
//                if(productOverview.product.name  == "Danke-Bonus"){
                    let controller = DankeBonusViewController()
                    controller.userProductID = productOverview.product.userProductId
                    controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                    controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                    controller.value_spent = getVoucherProductData?.value_spent ?? ""
                    controller.budget = getVoucherProductData?.min_value ?? 0
                    controller.isYearSelected = false
                    controller.month = self.selectMonth
                    controller.year = self.year
                    controller.still_possible = getVoucherProductData?.still_possible ?? 0
                    controller.productID = productOverview.product.id
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }else if (productOverview.product.product_code == "sachbezug"){
                    let controller = SachbezugViewController()
                    controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                    controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                    controller.value_spent = getVoucherProductData?.value_spent ?? ""
                    controller.budget = getVoucherProductData?.min_value ?? 0
                    controller.isYearSelected = false
                    controller.month = self.selectMonth
                    controller.year = self.year
                    controller.still_possible = getVoucherProductData?.still_possible ?? 0
                    controller.userProductID = productOverview.product.userProductId
                    controller.productID = productOverview.product.id
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }else{
                    let controller = ProductOverviewDetailsViewController.instantiate(
                        with: productOverview,
                        month: Int(monthlyOverview.month) ?? 0,
                        year: self.year
                    )
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }

        }
    }
}

// MARK: - UIPickerViewDataSource
extension ProductsOverviewViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datePickerItems.count
    }
}

// MARK: - UIPickerViewDelegate
extension ProductsOverviewViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let year = datePickerItems[row]
        return "\(year)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = datePickerItems[row]
        didUpdate(year: year)
    }
}
