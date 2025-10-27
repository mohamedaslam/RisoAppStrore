//
//  CategoryVC.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/12/13.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

protocol updatePieChartCategoryDelegate: AnyObject {
    func updateSelectedPiechart(categoryType: Int,selectedPage : Int)
}

class CategoryVC: BaseViewController,updateCategoryDelegate, UITextViewDelegate {

    weak var delegate: updatePieChartCategoryDelegate?

    var titleLabel: UILabel?
    
    var page: Pages
    var allCatergoryView: UIView = UIView()
    var allBtn: UIButton = UIButton()
    var cashBtn: UIButton = UIButton()
    var vouchersBtn: UIButton = UIButton()
    var deviceBtn: UIButton = UIButton()
    var getCategory : Int = 0
    var getIndex: Int = 0
    var getMonth: Int = 0
    var getYear: Int = 0
    var noOfApprovedInvoice: Int = 0
    var noOfApprovedInvoicesLab: UILabel = UILabel()
    var isYearlySelected: Bool = false
    private(set) var monthlyYearlyOverview: MonthlyYearlyOverview?
    var currentMonthYear: MonthYear = (month: Date.currentMonth, year: Date.currentYear)
    var sorryNoBenefitAvlLab: UITextView = UITextView()
    private var collectionView: UICollectionView!
    var topBGView: UIView = UIView()
    var getUserName: String = ""
    let risoWebsiteURL = "https://www.riso-app.de/";
    let privacyURL = "https://www.riso-app.de/";
    init(with page: Pages ,isYearSelected : Bool,getIndex:Int,getMonth:Int,getYear:Int,approvedInvoice:Int,monthlyYearlyOverview : MonthlyYearlyOverview) {
        self.page = page
        self.isYearlySelected = isYearSelected
        self.getIndex = getIndex
        self.getMonth = getMonth
        self.getYear = getYear
        self.noOfApprovedInvoice = approvedInvoice
        self.monthlyYearlyOverview = monthlyYearlyOverview
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profile = ApplicationDelegate.client.loggedUser {
            self.getUserName = profile.name
        }
        allCatergorySetupView()
        cashCatergorySetupView()
        vouchersCatergorySetupView()
        deviceCatergorySetupView()

        let topBGView: UIView = UIView()
        topBGView.isHidden = false
        view.addSubview(topBGView)
        self.topBGView = topBGView
        topBGView.snp.makeConstraints { (make) in
            make.top.equalTo(10 * AutoSizeScaleX)
            make.left.right.equalTo(view)
            make.height.equalTo(28 * AutoSizeScaleX)
        }
        
        let approvedInvoiceslab: UILabel = UILabel()
        approvedInvoiceslab.text = "Akzeptierte Belege"
        approvedInvoiceslab.textAlignment = .left
        approvedInvoiceslab.textColor = .white
        approvedInvoiceslab.font = .systemFont(ofSize: 13 * AutoSizeScaleX, weight: .regular)
        self.topBGView.addSubview(approvedInvoiceslab)
        approvedInvoiceslab.snp.makeConstraints { (make) in
            make.top.equalTo(10 * AutoSizeScaleX)
            make.width.equalTo(120 * AutoSizeScaleX)
            make.height.equalTo(14 * AutoSizeScaleX)
            make.left.equalTo(24 * AutoSizeScaleX)
        }
                
        let noOfApprovedInvoicesLab: UILabel = UILabel()
        noOfApprovedInvoicesLab.textAlignment = .right
        noOfApprovedInvoicesLab.font = .systemFont(ofSize: 12 * AutoSizeScaleX, weight: .regular)
        noOfApprovedInvoicesLab.text = "102"
        noOfApprovedInvoicesLab.textColor = .white
        self.topBGView.addSubview(noOfApprovedInvoicesLab)
        self.noOfApprovedInvoicesLab = noOfApprovedInvoicesLab
        noOfApprovedInvoicesLab.snp.makeConstraints { (make) in
            make.top.equalTo(10 * AutoSizeScaleX)
            make.width.equalTo(24 * AutoSizeScaleX)
            make.height.equalTo(14 * AutoSizeScaleX)
            make.right.equalTo(-20 * AutoSizeScaleX)
        }
        
        let dottedLineImg: UIImageView = UIImageView()
        dottedLineImg.image = UIImage.init(named: "dottedLine")
        dottedLineImg.contentMode = .scaleAspectFit
        self.topBGView.addSubview(dottedLineImg)
        dottedLineImg.snp.makeConstraints { (make) in
            make.left.equalTo(approvedInvoiceslab.snp_right).offset(2 * AutoSizeScaleX)
            make.right.equalTo(noOfApprovedInvoicesLab.snp_left).offset(-2 * AutoSizeScaleX)
            make.height.equalTo(4 * AutoSizeScaleX)
            make.bottom.equalTo(approvedInvoiceslab)
        }

        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 50 * AutoSizeScaleX, height: 50 * AutoSizeScaleX)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeProductListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(approvedInvoiceslab.snp_bottom).offset(4 * AutoSizeScaleX)
            make.bottom.equalTo(self.view)

        }
        if(page.index == 0){
            self.allCatergoryView.isHidden = true
            self.topBGView.isHidden = false
            self.collectionView.isHidden = false
            allBtnSliderAction()
        }else if(page.index == 1){
            self.allCatergoryView.isHidden = true
            self.topBGView.isHidden = false
            self.collectionView.isHidden = false
            cashBtnSliderAction()
        }else if(page.index == 2){
            self.allCatergoryView.isHidden = true
            self.topBGView.isHidden = false
            self.collectionView.isHidden = false
            vouchersBtnSliderAction()
        }else if(page.index == 3){
            self.allCatergoryView.isHidden = true
            self.topBGView.isHidden = true
            self.collectionView.isHidden = true
            deviceBtnSliderAction()
        }
        self.noOfApprovedInvoicesLab.text = String(self.noOfApprovedInvoice)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func allCatergorySetupView(){
        let allCatergoryView: UIView = UIView()
        self.view.addSubview(allCatergoryView)
        self.allCatergoryView = allCatergoryView
        allCatergoryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    
    func cashCatergorySetupView(){

    }
    
    func vouchersCatergorySetupView(){

    }
    
    func deviceCatergorySetupView(){
       
        let sorryNoBenefitAvlLab: UITextView = UITextView()
        sorryNoBenefitAvlLab.backgroundColor = .clear
        sorryNoBenefitAvlLab.isUserInteractionEnabled = true
        sorryNoBenefitAvlLab.isSelectable = true
        sorryNoBenefitAvlLab.delegate = self
        sorryNoBenefitAvlLab.dataDetectorTypes = .link
        self.view.addSubview(sorryNoBenefitAvlLab)
        self.sorryNoBenefitAvlLab = sorryNoBenefitAvlLab
        sorryNoBenefitAvlLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(10 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(100 * AutoSizeScaleX)
        }
        let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
       let attributedText = self.sorryNoBenefitAvlLab.attributedText

       let range = (str as NSString).range(of: "unserer Webseite")

        let attributedString = NSMutableAttributedString(string: str)
       attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
       var foundRange = attributedString.mutableString.range(of: "unserer Webseite")
       attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
       self.sorryNoBenefitAvlLab.attributedText = attributedString
       self.sorryNoBenefitAvlLab.textColor = UIColor.white
       self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
       self.sorryNoBenefitAvlLab.textAlignment = .center
    }
    
    
    @objc func allBtnAction(sender: UIButton!) {
        allBtnSliderAction()
    }
    
    @objc func cashBtnAction(sender: UIButton!) {
        cashBtnSliderAction()
    }
    
    @objc func vouchersBtnAction(sender: UIButton!) {
        vouchersBtnSliderAction()
    }
    
    func allBtnSliderAction(){
        self.sorryNoBenefitAvlLab.isHidden = true

        UIView.animate(withDuration: 0.3) {
            self.allBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.getCategory = 0
            self.collectionView.reloadData()
        }
        self.delegate?.updateSelectedPiechart(categoryType: self.getCategory,selectedPage:  self.getCategory)
        if(isYearlySelected == true){
            let getYearlyCategoryData = self.monthlyYearlyOverview?.yearly.productsOverviews
            for index in 0..<(getYearlyCategoryData!.count) {
                self.noOfApprovedInvoice += getYearlyCategoryData?[index].approvedInvoicesCount ?? 0
            }
            if(page.index == 0 && getYearlyCategoryData?.count == 0){
                self.topBGView.isHidden = true
            }else{
                self.topBGView.isHidden = false
            }
        }else{
            let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews

            for index in 0..<(getMonthlyCategoryData!.count) {
                self.noOfApprovedInvoice += getMonthlyCategoryData?[index].approvedInvoicesCount ?? 0
            }
            if(page.index == 0 && getMonthlyCategoryData?.count == 0){
                self.topBGView.isHidden = true
            }else{
                self.topBGView.isHidden = false
            }
        }
        self.noOfApprovedInvoicesLab.text = String(self.noOfApprovedInvoice)

    }
    
    func cashBtnSliderAction(){
        self.sorryNoBenefitAvlLab.isHidden = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()

            self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.getCategory = 1
            self.collectionView.reloadData()
        }
        self.delegate?.updateSelectedPiechart(categoryType: self.getCategory,selectedPage:  self.getCategory)
        if(isYearlySelected == true){
            let getYearlyCategoryData = self.monthlyYearlyOverview?.yearly.productsOverviews.filter({$0.product.category_type == self.getCategory})
            for index in 0..<(getYearlyCategoryData!.count) {
                self.noOfApprovedInvoice += getYearlyCategoryData?[index].approvedInvoicesCount ?? 0
            }
        }else{
            let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews.filter({$0.product.category_type == self.getCategory})

            for index in 0..<(getMonthlyCategoryData!.count) {
                self.noOfApprovedInvoice += getMonthlyCategoryData?[index].approvedInvoicesCount ?? 0
            }
        }
        self.noOfApprovedInvoicesLab.text = String(self.noOfApprovedInvoice)
    }
    
    func vouchersBtnSliderAction(){
        self.sorryNoBenefitAvlLab.isHidden = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()

            self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.getCategory = 2
            self.collectionView.reloadData()
        }
        self.delegate?.updateSelectedPiechart(categoryType: self.getCategory,selectedPage:  self.getCategory)
        if(isYearlySelected == true){
            let getYearlyCategoryData = self.monthlyYearlyOverview?.yearly.productsOverviews.filter({$0.product.category_type == self.getCategory})
            for index in 0..<(getYearlyCategoryData!.count) {
                self.noOfApprovedInvoice += getYearlyCategoryData?[index].approvedInvoicesCount ?? 0
            }
        }else{
            let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews.filter({$0.product.category_type == self.getCategory})

            for index in 0..<(getMonthlyCategoryData!.count) {
                self.noOfApprovedInvoice += getMonthlyCategoryData?[index].approvedInvoicesCount ?? 0
            }
        }
        self.noOfApprovedInvoicesLab.text = String(self.noOfApprovedInvoice)

    }
    
    func deviceBtnSliderAction(){
        UIView.animate(withDuration: 0.3) {
            self.allBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.getCategory = 3
            self.sorryNoBenefitAvlLab.isHidden = false
        }
        self.delegate?.updateSelectedPiechart(categoryType: self.getCategory,selectedPage:self.getCategory)

    }

}
extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isYearlySelected == true){
            if(self.getCategory == 0){
                let getYearlyCategoryData = self.monthlyYearlyOverview?.yearly.productsOverviews
                return getYearlyCategoryData?.count ?? 0
            }else{
                let getYearlyCategoryData = self.monthlyYearlyOverview?.yearly.productsOverviews.filter({$0.product.category_type == self.getCategory})
                if(self.getCategory == 0 && getYearlyCategoryData?.count == 0 ){
                    self.topBGView.isHidden = true
                    self.collectionView.isHidden = true
                    deviceCatergorySetupView()
                }
                
                if(self.getCategory == 1 && getYearlyCategoryData?.count == 0 ){
                    self.topBGView.isHidden = true
                    self.collectionView.isHidden = true
                    deviceCatergorySetupView()
                }
                
                if(self.getCategory == 2 && getYearlyCategoryData?.count == 0 ){
                    self.topBGView.isHidden = true
                    self.collectionView.isHidden = true
                    deviceCatergorySetupView()
                }
                if(self.getCategory == 3 && getYearlyCategoryData?.count == 0 ){
                    self.topBGView.isHidden = true
                    self.collectionView.isHidden = true
                    sorryNoBenefitAvlLab.isSelectable = true
                    sorryNoBenefitAvlLab.dataDetectorTypes = .link
                    self.sorryNoBenefitAvlLab.delegate = self
                    let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
                  let attributedText = self.sorryNoBenefitAvlLab.attributedText
                  let range = (str as NSString).range(of: "")
                 let attributedString = NSMutableAttributedString(string: str)
                  attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                  self.sorryNoBenefitAvlLab.attributedText = attributedString
                  self.sorryNoBenefitAvlLab.textColor = UIColor.white
                  self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                  self.sorryNoBenefitAvlLab.textAlignment = .center
                }
                return getYearlyCategoryData?.count ?? 0
            }
        }else{
            if(self.getCategory == 0){
                let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
                return getMonthlyCategoryData?.count ?? 0
                if(self.getCategory == 0 && getMonthlyCategoryData?.count == 0 ){
                    self.topBGView.isHidden = true
                    self.collectionView.isHidden = true
                    deviceCatergorySetupView()
                }
            }else{
                
                let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews.filter({$0.product.category_type == self.getCategory})
                if(self.getCategory == 0 && getMonthlyCategoryData?.count == 0 ){
                    self.topBGView.isHidden = true
                    self.collectionView.isHidden = true
                    deviceCatergorySetupView()
                }
                
                if(self.getCategory == 1 && getMonthlyCategoryData?.count == 0 ){
                    self.topBGView.isHidden = true
                    self.collectionView.isHidden = true
                    deviceCatergorySetupView()
                }
                
                if(self.getCategory == 2 && getMonthlyCategoryData?.count == 0 ){
                    self.topBGView.isHidden = true
                    self.collectionView.isHidden = true
                    deviceCatergorySetupView()
                }
                if(self.getCategory == 3 && getMonthlyCategoryData?.count == 0 ){
                    self.topBGView.isHidden = true
                    self.collectionView.isHidden = true

                    sorryNoBenefitAvlLab.isSelectable = true
                    sorryNoBenefitAvlLab.dataDetectorTypes = .link
                    self.sorryNoBenefitAvlLab.delegate = self
                    let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
                  let attributedText = self.sorryNoBenefitAvlLab.attributedText
                  let range = (str as NSString).range(of: "")
                 let attributedString = NSMutableAttributedString(string: str)
                  attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                  self.sorryNoBenefitAvlLab.attributedText = attributedString
                  self.sorryNoBenefitAvlLab.textColor = UIColor.white
                  self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                  self.sorryNoBenefitAvlLab.textAlignment = .center
                }
                return getMonthlyCategoryData?.count ?? 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeProductListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeProductListCollectionViewCell
        if(isYearlySelected == true){
            if(self.getCategory == 0){
                let getYearlyCategoryData = self.monthlyYearlyOverview?.yearly.productsOverviews

                cell.bgView.backgroundColor = UIColor(hexString: getYearlyCategoryData?[indexPath.row].product.hexColor ?? "")
                cell.nameLab.text = getYearlyCategoryData?[indexPath.row].product.name ?? ""
                let accreditedAmount = (((getYearlyCategoryData?[indexPath.row].totalAmount)!)-((getYearlyCategoryData?[indexPath.row].remainingAmount)!))
                cell.totalAmountLab.text = "\(accreditedAmount.priceAsString())/ \(getYearlyCategoryData?[indexPath.row].totalAmount.priceAsString() ?? "")"
            }else{
                let getYearlyCategoryData = self.monthlyYearlyOverview?.yearly.productsOverviews.filter({$0.product.category_type == self.getCategory})

                cell.bgView.backgroundColor = UIColor(hexString: getYearlyCategoryData?[indexPath.row].product.hexColor ?? "")
                cell.nameLab.text = getYearlyCategoryData?[indexPath.row].product.name ?? ""
                let accreditedAmount = (((getYearlyCategoryData?[indexPath.row].totalAmount)!)-((getYearlyCategoryData?[indexPath.row].remainingAmount)!))
                cell.totalAmountLab.text = "\(accreditedAmount.priceAsString())/ \(getYearlyCategoryData?[indexPath.row].totalAmount.priceAsString() ?? "")"
            }

        }else{
            if(self.getCategory == 0){
                let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
                cell.bgView.backgroundColor = UIColor(hexString: getMonthlyCategoryData?[indexPath.row].product.hexColor ?? "")
                cell.nameLab.text = getMonthlyCategoryData?[indexPath.row].product.name ?? ""
                let accreditedAmount = (((getMonthlyCategoryData?[indexPath.row].totalAmount)!)-((getMonthlyCategoryData?[indexPath.row].remainingAmount)!))
                cell.totalAmountLab.text = "\(accreditedAmount.priceAsString())/ \(getMonthlyCategoryData?[indexPath.row].totalAmount.priceAsString() ?? "")"
            }else{
                let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews.filter({$0.product.category_type == self.getCategory})
                cell.bgView.backgroundColor = UIColor(hexString: getMonthlyCategoryData?[indexPath.row].product.hexColor ?? "")
                cell.nameLab.text = getMonthlyCategoryData?[indexPath.row].product.name ?? ""
                let accreditedAmount = (((getMonthlyCategoryData?[indexPath.row].totalAmount)!)-((getMonthlyCategoryData?[indexPath.row].remainingAmount)!))
                cell.totalAmountLab.text = "\(accreditedAmount.priceAsString())/ \(getMonthlyCategoryData?[indexPath.row].totalAmount.priceAsString() ?? "")"
            }

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160 * AutoSizeScaleX, height: 52 * AutoSizeScaleX)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(isYearlySelected == true){
            if(self.getCategory == 0){
                let overviews = self.monthlyYearlyOverview?.yearly.productsOverviews
                guard (0..<overviews!.count).contains(indexPath.row) else { return }

                let productOverview = overviews![indexPath.row]
                
                client.getVoucherProduct(vouchersProductID:productOverview.product.userProductDetails.id) { (getVoucherProductData) in
           
                    if(productOverview.product.product_code == "danke_bonus"){
                        let controller = DankeBonusViewController()
                        controller.userProductID = productOverview.product.userProductDetails.id
                        controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                        controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                        controller.value_spent = getVoucherProductData?.value_spent ?? ""
                        controller.budget = getVoucherProductData?.min_value ?? 0
                        controller.isYearSelected = true
                        controller.month = 0
                        controller.year = self.getYear
                        controller.still_possible = getVoucherProductData?.still_possible ?? 0
                        controller.userProductID = productOverview.product.userProductDetails.id
                        controller.productID = productOverview.product.userProductDetails.product_id
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }else if (productOverview.product.product_code == "sachbezug"){
                        let controller = SachbezugViewController()
                        controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                        controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                        controller.value_spent = getVoucherProductData?.value_spent ?? ""
                        controller.budget = getVoucherProductData?.min_value ?? 0
                        controller.isYearSelected = true
                        controller.month = 0
                        controller.year = self.getYear
                        controller.still_possible = getVoucherProductData?.still_possible ?? 0
                        controller.userProductID = productOverview.product.userProductDetails.id
                        controller.productID = productOverview.product.userProductDetails.product_id
                        controller.isSachbezugPage = true
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }else{

                let controller = ProductOverviewDetailsViewController.instantiate(
                    with: productOverview,
                    month: -1,
                    year: self.currentMonthYear.year
                )
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }
                }
            }else{
                let overviews = self.monthlyYearlyOverview?.yearly.productsOverviews.filter({$0.product.category_type == self.getCategory})
                guard (0..<overviews!.count).contains(indexPath.row) else { return }

                let productOverview = overviews![indexPath.row]

                client.getVoucherProduct(vouchersProductID:productOverview.product.userProductDetails.id) { (getVoucherProductData) in
           
                    if(productOverview.product.product_code == "danke_bonus"){
                        let controller = DankeBonusViewController()
                        controller.userProductID = productOverview.product.userProductDetails.id
                        controller.productID = productOverview.product.userProductDetails.product_id
                        controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                        controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                        controller.value_spent = getVoucherProductData?.value_spent ?? ""
                        controller.isYearSelected = true
                        controller.month = 0
                        controller.year = self.getYear
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
                        controller.year = self.getYear
                        controller.still_possible = getVoucherProductData?.still_possible ?? 0
                        controller.userProductID = productOverview.product.userProductDetails.id
                        controller.productID = productOverview.product.userProductDetails.product_id
                        controller.isSachbezugPage = true
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }else{
                let controller = ProductOverviewDetailsViewController.instantiate(
                    with: productOverview,
                    month: -1,
                    year: self.currentMonthYear.year
                )
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }
                }
            }

        }else{
            if(self.getCategory == 0){
                let overviews = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
                guard (0..<overviews!.count).contains(indexPath.row) else { return }

                let productOverview = overviews![indexPath.row]
                client.getVoucherProduct(vouchersProductID:productOverview.product.userProductDetails.id) { (getVoucherProductData) in
           
                    if(productOverview.product.product_code == "danke_bonus"){
                        let controller = DankeBonusViewController()
                        controller.userProductID = productOverview.product.userProductDetails.id
                        controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                        controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                        controller.value_spent = getVoucherProductData?.value_spent ?? ""
                        controller.budget = getVoucherProductData?.min_value ?? 0
                        controller.isYearSelected = false
                        controller.month = self.getMonth
                        controller.year = self.getYear
                        controller.still_possible = getVoucherProductData?.still_possible ?? 0
                        controller.productID = productOverview.product.userProductDetails.product_id
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }else if (productOverview.product.product_code == "sachbezug"){
                        let controller = SachbezugViewController()
                        controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                        controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                        controller.value_spent = getVoucherProductData?.value_spent ?? ""
                        controller.budget = getVoucherProductData?.min_value ?? 0
                        controller.isYearSelected = false
                        controller.month = self.getMonth
                        controller.year = self.getYear
                        controller.still_possible = getVoucherProductData?.still_possible ?? 0
                        controller.userProductID = productOverview.product.userProductDetails.id
                        controller.productID = productOverview.product.userProductDetails.product_id
                        controller.isSachbezugPage = true
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }else{
                        let productOverview = overviews![indexPath.row]
                        let controller = ProductOverviewDetailsViewController.instantiate(
                            with: productOverview,
                            month:self.currentMonthYear.month,
                            year: self.currentMonthYear.year
                        )
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }
                }
            }else{
                           
                let overviews = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews.filter({$0.product.category_type == self.getCategory})
                          
                guard (0..<overviews!.count).contains(indexPath.row) else { return }
                let productOverview = overviews![indexPath.row]
                client.getVoucherProduct(vouchersProductID:productOverview.product.userProductDetails.id) { (getVoucherProductData) in
                    if(productOverview.product.product_code == "danke_bonus"){
                        let controller = DankeBonusViewController()
                        controller.userProductID = productOverview.product.userProductDetails.id
                        controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                        controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                        controller.value_spent = getVoucherProductData?.value_spent ?? ""
                        controller.budget = getVoucherProductData?.min_value ?? 0
                        controller.isYearSelected = false
                        controller.month = self.getMonth
                        controller.year = self.getYear
                        controller.productID = productOverview.product.userProductDetails.product_id
                        controller.still_possible = getVoucherProductData?.still_possible ?? 0
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }else if (productOverview.product.product_code == "sachbezug"){
                        let controller = SachbezugViewController()
                        controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                        controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                        controller.value_spent = getVoucherProductData?.value_spent ?? ""
                        controller.budget = getVoucherProductData?.min_value ?? 0
                        controller.isYearSelected = false
                        controller.month = self.getMonth
                        controller.year = self.getYear
                        controller.still_possible = getVoucherProductData?.still_possible ?? 0
                        controller.userProductID = productOverview.product.userProductDetails.id
                        controller.productID = productOverview.product.userProductDetails.product_id
                        controller.isSachbezugPage = true
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }else{
                        let controller = ProductOverviewDetailsViewController.instantiate(
                            with: productOverview,
                            month:self.currentMonthYear.month,
                            year: self.currentMonthYear.year
                        )
                        self.navigationController?.pushAndHideTabBar(controller, animated: true)
                    }
                }
            }
        }
    }
    func updateCatergoryData(pagesIndex: Int,isYearSelected : Bool,getIndex : Int, approvedInvoice : Int, monthlyYearlyOverview:MonthlyYearlyOverview){
        self.isYearlySelected = isYearSelected
        self.getIndex = getIndex
        self.noOfApprovedInvoice = approvedInvoice
        self.monthlyYearlyOverview = monthlyYearlyOverview
        self.noOfApprovedInvoicesLab.text = String(self.noOfApprovedInvoice)

    }
}
extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

extension UITextViewDelegate{
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
       return false
     }
}
