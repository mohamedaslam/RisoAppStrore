//
//  HomeDashboardViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/11/7.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import ANActivityIndicator
enum Pages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
    case pageThree

    var name: String {
        switch self {
        case .pageZero:
            return "This is page zero"
        case .pageOne:
            return "This is page one"
        case .pageTwo:
            return "This is page two"
        case .pageThree:
            return "This is page two"
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        case .pageThree:
            return 3
        }
    }
}

protocol updateCategoryDelegate: AnyObject {
    func updateCatergoryData(pagesIndex: Int,isYearSelected : Bool,getIndex : Int, approvedInvoice : Int, monthlyYearlyOverview:MonthlyYearlyOverview)
}

class HomeDashboardViewController: BaseViewController,updatePieChartCategoryDelegate, UITextViewDelegate {
    weak var delegate: updateCategoryDelegate?

    struct State {
        var monthlyOverviews: [MonthlyYearlyOverview]
        var products: [Product] {
            return Array(Set<Product>(monthlyOverviews
                .map { $0.monthly[8].productsOverviews }
                .reduce([Product]()) {
                    var aux = $0
                    aux.append(contentsOf: $1.map({$0.product}))
                    return aux
            }))
                .filter{ !$0.hideFromRainbow }
                .filter{ $0.active }
                .sorted { (product1, product2) -> Bool in
                return product1.id < product2.id
            }
        }
        
        var selectedIndex: Int {
            set {
                _selectedIndex = minmax(0, newValue, max(monthlyOverviews.count - 1, 0))
            }
            get {
                return _selectedIndex
            }
        }
        
        private var _selectedIndex: Int
        
        init(monthlyOverviews: [MonthlyYearlyOverview], selectedIndex: Int = 0) {
            self.monthlyOverviews = monthlyOverviews
            self._selectedIndex   = minmax(0, selectedIndex, max(monthlyOverviews.count - 1, 0))
        }
        
        func progress(for product: Product) -> CGFloat {
            return CGFloat(0.0)
        }
        
        func secondProgress(for product: Product) -> CGFloat {
            return CGFloat(0.0)
        }
        
        func selectedOverview() -> MonthlyYearlyOverview? {
            guard monthlyOverviews.isNotEmpty else { return nil }
            guard (0..<monthlyOverviews.count).contains(selectedIndex) else { return nil }
            return monthlyOverviews[selectedIndex]
        }
    }

    // Outlets
    @IBOutlet weak var productsProgressView: ProductsProgressView!
    @IBOutlet weak var accreditedValueLabel: CountingLabel! {
        didSet {
            accreditedValueLabel?.font = UIFont.appFont(ofSize: 35, weight: .medium, compact: true)
        }
    }
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var accreditedTextLabel: UILabel!
    var productsStackView: UIStackView!
    var monthlyBtn : UIButton = UIButton()
    var yearlyBtn: UIButton = UIButton()
    var questionMarkBtn : UIButton = UIButton()
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    private var notificationMessages: [NotificationModel] = []
    private var state: State = State(monthlyOverviews: [], selectedIndex: 0)
    private var selectedYear: Int = Date.currentYear
    private var selectedMonth: Int = Date.currentMonth
    var getIndex: Int = 0
    var getProductID : Int = 0
    var getNotificationID : Int = 0
    var getMonthConfirmationStatus: CurrentMonthDocument?
    var checkInitialSetupDone: Bool = false
    var firstTimeShowPop: Bool = false
    let notificationBadgeBtn = BadgedButtonItem(with: UIImage(named: "Vector"))
    private var benefit: [Benefit] = []
    var getBadgeCountValue : Int = 0
    private(set) var monthlyOverview: MonthlyOverview?
    private(set) var monthlyYearlyOverview: MonthlyYearlyOverview?
    private var isMonthlyStutsComform: Bool = true
    var isYearlySelected: Bool = false
    var tourGuideTransparentBGView : UIView = UIView()
    var configMonthlyYearlyBtnBGView = UIView()
    var downArrowImg: UIImageView = UIImageView()
    var datePickerYearItems: [Int] = []
    var datePickerMonthYearItems: [MonthYear] = []
    var currentMonthYear: MonthYear = (month: Date.currentMonth, year: Date.currentYear)
    var selectMonthBGView: UIView = UIView()
    var selectYearBGView: UIView = UIView()
    var pieChartView: PieChartView?
    var ypieChartView: PieChartView?
    var TpieChartView: PieChartView?
    var getItems = [PieItem]()
    var accreditedValueLab: UILabel = UILabel()
    var amountLeftValueLab: UILabel = UILabel()
    var yaccreditedValueLab: UILabel = UILabel()
    var yamountLeftValueLab: UILabel = UILabel()
    var TaccreditedValueLab: UILabel = UILabel()
    var TamountLeftValueLab: UILabel = UILabel()
    var amountLeftLab: UILabel = UILabel()
    var accreditedLab: UILabel = UILabel()
    var yamountLeftLab: UILabel = UILabel()
    var yaccreditedLab: UILabel = UILabel()
    var noOfApprovedInvoicesLab: UILabel = UILabel()
    var circleUpdateValueBGView: UIView = UIView()
    var ycircleUpdateValueBGView: UIView = UIView()
    var sorryNoBenefitAvlLab: UITextView = UITextView()

    var tourGuideTextAmountArrowImgView: UIImageView = UIImageView()
    var tourGuideAmountArrowImgView: UIImageView = UIImageView()
    
    var scrollView: UIScrollView = UIScrollView()
    var transparentScrollView: UIScrollView = UIScrollView()
    var transparentPageControl: UIPageControl = UIPageControl()

    var tipsAllTransparentBGView : UIView = UIView()
    var tipAllScrollView: UIScrollView = UIScrollView()
    var tipAllPageControl: UIPageControl = UIPageControl()

    var tipsCashTransparentBGView : UIView = UIView()
    var tipCashScrollView: UIScrollView = UIScrollView()
    var tipsCashPageControl: UIPageControl = UIPageControl()
    
    var pageControl: UIPageControl = UIPageControl()
    var categoryPageControl: UIPageControl = UIPageControl()
    var getCategory : Int = 0
    var noOfapprovedInvoice : Int = 0
    var allBtn: UIButton = UIButton()
    var cashBtn: UIButton = UIButton()
    var vouchersBtn: UIButton = UIButton()
    var deviceBtn: UIButton = UIButton()
    internal let datePickerYearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "donwArrow").original, for: .normal)
        button.setTitle(" \(Date.currentYear) ", for: UIControl.State())
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        button.centerTextAndImage(spacing: 10.0)
        button.sizeToFit()
        return button
    }()
    internal let datePickerMonthYearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "donwArrow").original, for: .normal)
        button.setTitle(" \(Date.currentYear) ", for: UIControl.State())
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        button.centerTextAndImage(spacing: 10.0)
        button.sizeToFit()
        return button
    }()
    var datePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    var datePickerMonthYear: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    internal let invisibleMonthTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.isHidden = true
        return textField
    }()
    internal let invisibleYearTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.isHidden = true
        return textField
    }()
    internal let dotIndicatorView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 2.5
        return view
    }()
    let risoWebsiteURL = "https://www.riso-app.de/";

    private var availableMonths: [Int] {
        let currentMonth = Date.currentMonth
        let currentYear  = Date.currentYear
        
        if selectedYear == currentYear {
            // If we have a first receipt upload date
            if let date = client.firstDocumentUploadDate {
                // and it's from the current year
                if date.year == currentYear {
                    // return the interval between that month and the current month
                    return Array(date.month...currentMonth)
                } else if selectedYear == date.year {
                    // Check if the selected year is the same with the date year
                    // else return the interval between that month and the end of the year
                    return Array(date.month...12)
                } else if self.selectedYear == currentYear {
                    return Array(1...currentMonth)
                } else {
                    return Array(1...12)
                }
            } else {
                // If not, show just the current month
                return [currentMonth]
            }
        } else {
            // Not the current year
            if let date = client.firstDocumentUploadDate {
                if date.year == currentYear {
                    // return the interval between that month and the current month
                    return Array(date.month...currentMonth)
                } else if self.selectedYear == date.year {
                    // Check if the selected year is the same with the date year
                    // else return the interval between that month and the end of the year
                    return Array(date.month...12)
                } else if self.selectedYear == currentYear {
                    return Array(1...currentMonth)
                } else {
                    return Array(1...12)
                }
            } else {
                // This should not happen if we don't have this date
                return []
            }
        }
    }
    

    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator                                       = UIActivityIndicatorView(style : .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color                                     = UIColor.App.Button.backgroundColor
        indicator.hidesWhenStopped                          = true
        return indicator
    }()
      
    // PageViewController
    private var categoryPageController: UIPageViewController?
    private var pages: [Pages] = Pages.allCases
    private var currentIndex: Int = 0
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: .willRequireContentUpdate, object: nil, queue: .main) { (notification) in
            self.reloadData()
        }
        NotificationCenter.default.addObserver(forName: .shouldUpdateDashboard, object: nil, queue: .main) { notification in
            self.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let isTravelNotification = ITNSUserDefaults.object(forKey: "isTravelNotification") as? Bool
            if (isTravelNotification == true) {
                if let is_user_travel_set = ITNSUserDefaults.value(forKey: "is_user_travel_set") as? String {
                    if(is_user_travel_set == "1"){
                if let getProductID = ITNSUserDefaults.value(forKey: "UserTravel_product_id") as? String {
                    self.getProductID = Int(getProductID) ?? 0
                    let controller = ViewDailyCommuterViewController()
                    controller.getUserProductID = self.getProductID
                    self.navigationController?.pushAndHideTabBar(controller)
                }
                    }else{
                        if let getProductID = ITNSUserDefaults.value(forKey: "UserTravel_product_id") as? String {
                            self.getProductID = Int(getProductID) ?? 0
                            let controller = DailyCommuterViewController()
                            controller.getUserProductID = self.getProductID
                            self.navigationController?.pushAndHideTabBar(controller)
                        }
                    }
                }
                ITNSUserDefaults.set(false, forKey: "isTravelNotification")
                ITNSUserDefaults.set(true, forKey: "isAlreadyTravelNotification")

            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let isKinderNotification = ITNSUserDefaults.object(forKey: "isKinderNotification") as? Bool
            if (isKinderNotification == true) {
                if let is_user_kinder_set = ITNSUserDefaults.value(forKey: "is_user_kinder_set") as? String {
                    if(is_user_kinder_set == "1"){
                        let controller = KindergartenListViewController()
                        self.navigationController?.pushAndHideTabBar(controller)
                    }else{
                        let controller = KindergartenSetupViewController()
                        controller.getTitle = "Ersteinrichtung  "
                        self.navigationController?.pushAndHideTabBar(controller)
                    }
                }
                //self.getKindergartenDetails()
                ITNSUserDefaults.set(false, forKey: "isKinderNotification")
                ITNSUserDefaults.set(true, forKey: "isAlreadyKinderNotification")

            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let receviedReminderPushNotification = ITNSUserDefaults.object(forKey: "receviedReminderPushNotification") as? Bool
            if (receviedReminderPushNotification == true) {
                let controller = ListOfRemindersViewController()
                self.navigationController?.pushAndHideTabBar(controller)
                //self.getKindergartenDetails()
                ITNSUserDefaults.set(false, forKey: "receviedReminderPushNotification")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {

            let receviedInternetPushNotification = ITNSUserDefaults.object(forKey: "receviedInternetPushNotification") as? Bool
            if (receviedInternetPushNotification == true) {
                self.client.getMonthlyYearlyOverviews(month: nil, year: self.selectedYear) { (monthlyYearlyOverviewData) in
                    self.monthlyYearlyOverview = monthlyYearlyOverviewData
                    let getSelectedMonth = String(format: "%02d", self.currentMonthYear.month)
                    let getIndex = self.monthlyYearlyOverview?.monthly.firstIndex(where: {$0.month.starts(with: getSelectedMonth)})
                    self.getIndex = getIndex ?? 0
                    let overviews = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
                    let getInternetIndex = overviews!.firstIndex(where: {$0.product.name.starts(with: "Internet")})
                    let productOverview = overviews![getInternetIndex ?? 0]
                    let controller = ProductOverviewDetailsViewController.instantiate(
                        with: productOverview,
                        month:self.getIndex,
                        year: Date.currentYear
                    )
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }
                ITNSUserDefaults.set(false, forKey: "receviedInternetPushNotification")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let receviedSachenPushNotification = ITNSUserDefaults.object(forKey: "receviedSachenPushNotification") as? Bool
            if (receviedSachenPushNotification == true) {
                self.client.getMonthlyYearlyOverviews(month: nil, year: self.selectedYear) { (monthlyYearlyOverviewData) in
                    self.monthlyYearlyOverview = monthlyYearlyOverviewData
                    let getSelectedMonth = String(format: "%02d", self.currentMonthYear.month)
                    let getIndex = self.monthlyYearlyOverview?.monthly.firstIndex(where: {$0.month.starts(with: getSelectedMonth)})
                    self.getIndex = getIndex ?? 0
                    let overviews = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
                    let getInternetIndex = overviews!.firstIndex(where: {$0.product.name.starts(with: "Sachen")})
                    let productOverview = overviews![getInternetIndex ?? 0]
                    let controller = ProductOverviewDetailsViewController.instantiate(
                        with: productOverview,
                        month:self.getIndex,
                        year: Date.currentYear
                    )
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }
                ITNSUserDefaults.set(false, forKey: "receviedSachenPushNotification")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let receviedGeburtstagPushNotification = ITNSUserDefaults.object(forKey: "receviedGeburtstagPushNotification") as? Bool
            if (receviedGeburtstagPushNotification == true) {
                self.client.getMonthlyYearlyOverviews(month: nil, year: self.selectedYear) { (monthlyYearlyOverviewData) in
                    self.monthlyYearlyOverview = monthlyYearlyOverviewData
                    let getSelectedMonth = String(format: "%02d", self.currentMonthYear.month)
                    let getIndex = self.monthlyYearlyOverview?.monthly.firstIndex(where: {$0.month.starts(with: getSelectedMonth)})
                    self.getIndex = getIndex ?? 0
                    let overviews = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
                    let getInternetIndex = overviews!.firstIndex(where: {$0.product.name.starts(with: "Geburtstag")})
                    let productOverview = overviews![getInternetIndex ?? 0]
                    let controller = ProductOverviewDetailsViewController.instantiate(
                        with: productOverview,
                        month:self.getIndex,
                        year: Date.currentYear
                    )
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }
                ITNSUserDefaults.set(false, forKey: "receviedGeburtstagPushNotification")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let receviedErholungPushNotification = ITNSUserDefaults.object(forKey: "receviedErholungPushNotification") as? Bool
            if (receviedErholungPushNotification == true) {
                self.client.getMonthlyYearlyOverviews(month: nil, year: self.selectedYear) { (monthlyYearlyOverviewData) in
                    self.monthlyYearlyOverview = monthlyYearlyOverviewData
                    let getSelectedMonth = String(format: "%02d", self.currentMonthYear.month)
                    let getIndex = self.monthlyYearlyOverview?.monthly.firstIndex(where: {$0.month.starts(with: getSelectedMonth)})
                    self.getIndex = getIndex ?? 0
                    let overviews = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
                    let getInternetIndex = overviews!.firstIndex(where: {$0.product.name.starts(with: "Erholung")})
                    let productOverview = overviews![getInternetIndex ?? 0]
                    let controller = ProductOverviewDetailsViewController.instantiate(
                        with: productOverview,
                        month:self.getIndex,
                        year: Date.currentYear
                    )
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }
                ITNSUserDefaults.set(false, forKey: "receviedErholungPushNotification")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let receviedErholungPushNotification = ITNSUserDefaults.object(forKey: "receviedFoodPushNotification") as? Bool
            if (receviedErholungPushNotification == true) {
                self.client.getMonthlyYearlyOverviews(month: nil, year: self.selectedYear) { (monthlyYearlyOverviewData) in
                    self.monthlyYearlyOverview = monthlyYearlyOverviewData
                    let getSelectedMonth = String(format: "%02d", self.currentMonthYear.month)
                    let getIndex = self.monthlyYearlyOverview?.monthly.firstIndex(where: {$0.month.starts(with: getSelectedMonth)})
                    self.getIndex = getIndex ?? 0
                    let overviews = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
                    let getInternetIndex = overviews!.firstIndex(where: {$0.product.name.starts(with: "Mittagessen")})
                    let productOverview = overviews![getInternetIndex ?? 0]
                    let controller = ProductOverviewDetailsViewController.instantiate(
                        with: productOverview,
                        month:self.getIndex,
                        year: Date.currentYear
                    )
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
                }
                ITNSUserDefaults.set(false, forKey: "receviedFoodPushNotification")
            }
        }
        configBtnBGViewMethod()
        setupViews()
        reloadData()
        self.setupPageController()

    }
    private func setupPageController() {
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let getNotificationID = ITNSUserDefaults.value(forKey: "notification_id") as? String {
            let getNotificationIDValue = Int(getNotificationID ?? "")!

            ApplicationDelegate.client.updateNotificationMsg(Id:getNotificationIDValue) { [self] message in
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.client.getNotificationMessagesList { (notifications) in
                self.notificationMessages = notifications
                let readNotificationCount = self.notificationMessages.filter{ $0.is_read == 0 }
                self.notificationBadgeBtn.setBadge(with:readNotificationCount.count)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getMonthlyConfirmation()
        }
       // self.reloadData()
    }
    
    func getKindergartenDetails(){
        client.getListOfKindergartenKids { (kidDetail) in
            if(kidDetail.count >= 1){
                    let controller = KindergartenListViewController()
                    self.navigationController?.pushAndHideTabBar(controller)
                }else{
                    let controller = KindergartenSetupViewController()
                    controller.getTitle = "Ersteinrichtung  "
                    self.navigationController?.pushAndHideTabBar(controller)
                }
        }
    }
    
    func getUserTravelDetails(){

        client.getUserTravelData { (userTravel) in
            if(userTravel?.home_address_line1 != nil || userTravel?.home_address_line2 != nil){
                if let getProductID = ITNSUserDefaults.value(forKey: "UserTravel_product_id") as? String {
                    self.getProductID = Int(getProductID) ?? 0
                    let controller = ViewDailyCommuterViewController()
                    controller.getUserProductID = self.getProductID
                    self.navigationController?.pushAndHideTabBar(controller)
                }
            }else{
                if let getProductID = ITNSUserDefaults.value(forKey: "UserTravel_product_id") as? String {
                    self.getProductID = Int(getProductID) ?? 0
                    let controller = DailyCommuterViewController()
                    controller.getUserProductID = self.getProductID
                    self.navigationController?.pushAndHideTabBar(controller)
                }
            }
        }
    }
    
    func getMonthlyConfirmation(){

        let controller = TransparentBGViewController()
        controller.removeFromParent()
        client.getMonthlyTravelStatusAddress{ (getMonthConfirmationStatus) in
            if(getMonthConfirmationStatus?.is_need_initial_setup == 1){
                if(self.checkInitialSetupDone == false){
                    if(self.firstTimeShowPop == true){
                        self.firstTimeShowPop = false
                        let isAlreadyTravelNotification = ITNSUserDefaults.object(forKey: "isAlreadyTravelNotification") as? Bool
                        if (isAlreadyTravelNotification == true) {
                            ITNSUserDefaults.set(false, forKey: "isAlreadyTravelNotification")

                        }else{
                        if let getProductID = ITNSUserDefaults.value(forKey: "UserTravel_product_id") as? String {
                            self.getProductID = Int(getProductID) ?? 0
                            self.tourGuideTransparentBGView.isHidden = true
                            let controller = DailyCommuterViewController()
                            controller.getUserProductID = self.getProductID
                            self.navigationController?.pushAndHideTabBar(controller)
                        }
                        }
                    }
                }
            }
            if(getMonthConfirmationStatus?.is_need_monthly_confirmation == 1){
                let controller = DailyCommuterMonthlyConfirmationVC()
                self.navigationController?.pushAndHideTabBar(controller,animated: false)
                self.tourGuideTransparentBGView.isHidden = true
            }
            

            if(getMonthConfirmationStatus?.is_need_initial_setup_for_kinder == 1){
                    if(self.firstTimeShowPop == true){
                        self.firstTimeShowPop = false
                        let isAlreadyKinderNotification = ITNSUserDefaults.object(forKey: "isAlreadyKinderNotification") as? Bool
                        if (isAlreadyKinderNotification == true) {
                            ITNSUserDefaults.set(false, forKey: "isAlreadyKinderNotification")

                        }else{
                            let controller = KindergartenSetupViewController()
                            controller.getTitle = "Ersteinrichtung  "
                            self.navigationController?.pushAndHideTabBar(controller)
                            self.tourGuideTransparentBGView.isHidden = true
                        }
                    }
                }

            if(getMonthConfirmationStatus?.is_need_monthly_confirmation_for_kinder == 1){
                let controller = KindergartenMonthlyConfirmationVC()
                self.navigationController?.pushAndHideTabBar(controller)
                self.tourGuideTransparentBGView.isHidden = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configBtnBGViewMethod(){

        let monthlyBtn = UIButton(type: .custom)
        monthlyBtn.setTitle("MONATLICH", for: .normal)
        monthlyBtn.titleLabel?.font = .systemFont(ofSize:15*AutoSizeScaleX)
        monthlyBtn.contentVerticalAlignment = .center
        monthlyBtn.setTitleColor(.white, for: .normal)
        monthlyBtn.clipsToBounds = true
        monthlyBtn.addTarget(self, action:#selector(self.monthlyBtnAction), for: .touchUpInside)
        self.view.addSubview(monthlyBtn)
        self.monthlyBtn = monthlyBtn
        monthlyBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(6 * AutoSizeScaleX)
            make.centerX.equalTo(view)
            make.width.equalTo(90 * AutoSizeScaleX)
            make.height.equalTo(40 * AutoSizeScaleX)
        }

        let yearlyBtn = UIButton(type: .custom)
        yearlyBtn.setTitle("JÄHRLICH", for: .normal)
        yearlyBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        yearlyBtn.titleLabel?.font = .systemFont(ofSize:15*AutoSizeScaleX)
        yearlyBtn.contentVerticalAlignment = .center
        yearlyBtn.clipsToBounds = true
        yearlyBtn.addTarget(self, action:#selector(self.yearlyBtnAction), for: .touchUpInside)
        self.view.addSubview(yearlyBtn)
        self.yearlyBtn = yearlyBtn
        yearlyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(monthlyBtn.snp_right).offset(10 * AutoSizeScaleX)
            make.width.height.top.equalTo(monthlyBtn)
        }
        
        
        let scrollView: UIScrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: Screen_Width * 2, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(yearlyBtn.snp_bottom).offset(8 * AutoSizeScaleX)
            make.left.right.equalTo(self.view)
            make.height.equalTo(270 * AutoSizeScaleX)
        }
        self.scrollView = scrollView

        let pageControl: UIPageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.App.PageIndicator.default
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.addTarget(self, action: #selector(HomeDashboardViewController.pageChanged), for: .valueChanged)
        self.view.addSubview(pageControl)
        self.pageControl = pageControl
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp_bottom).offset(4 * AutoSizeScaleX)
            make.left.right.equalTo(self.view)
            make.height.equalTo(24 * AutoSizeScaleX)
            make.centerX.equalTo(self.view)
        }
        
        monthlyPiechartUISetup()
        yearlyPiechartUISetup()
        
        let questionMarkBtn = UIButton(type: .custom)
        questionMarkBtn.setTitle("?", for: .normal)
        questionMarkBtn.setTitleColor(UIColor.white, for: .normal)
        questionMarkBtn.titleLabel?.font =  UIFont.appFont(ofSize: 30, weight: .semibold)
        questionMarkBtn.contentVerticalAlignment = .center
        questionMarkBtn.clipsToBounds = true
        questionMarkBtn.layer.cornerRadius = 15 * AutoSizeScaleX
        questionMarkBtn.addTarget(self, action:#selector(self.questionMarkBtnAction), for: .touchUpInside)
        self.view.addSubview(questionMarkBtn)
        self.questionMarkBtn = questionMarkBtn
        questionMarkBtn.snp.makeConstraints { (make) in
            make.top.equalTo(monthlyBtn.snp_bottom).offset(10 * AutoSizeScaleX)
            make.right.equalTo(-18 * AutoSizeScaleX)
            make.width.height.equalTo(30 * AutoSizeScaleX)
        }

        let startingYear = client.firstDocumentUploadDate?.year ?? Date.currentYear
        datePickerYearItems = Array(startingYear...Date.currentYear).reversed()

        datePicker.dataSource = self
        datePicker.delegate = self
        
        //MONTH YEAR
        let startYear = client.firstDocumentUploadDate?.year ?? Date.currentYear
        let endYear   = Date.currentYear
        let startMonth = client.firstDocumentUploadDate?.month ?? 0
        
        datePickerMonthYearButton.setTitle(
            text(forSelectedMonthYear: (month: self.currentMonthYear.month, year: self.currentMonthYear.year)),
            for: .normal
        )
        datePickerMonthYearButton.sizeToFit()
        datePickerMonthYearItems = []
        if(startMonth  == Date.currentMonth && startYear == Date.currentYear){
            datePickerMonthYearItems.insert(
                        contentsOf: Array(startMonth...Date.currentMonth).map {
                            (month: $0, year: Date.currentYear)
                        }.reversed(),
                        at: 0
            )
        }else{
            datePickerMonthYearItems.insert(
                        contentsOf: Array(1...Date.currentMonth).map {
                            (month: $0, year: Date.currentYear)
                        }.reversed(),
                        at: 0
            )
        }
        datePickerMonthYear.dataSource = self
        datePickerMonthYear.delegate = self

    }
    @objc
    private func datePickerButtonDidTouch(_ sender: UIButton) {
        if invisibleYearTextField.isFirstResponder {
            view.endEditing(true)
        }
        invisibleYearTextField.becomeFirstResponder()
    }
    
    @objc
    private func datePickerMonthYearButtonDidTouch(_ sender: UIButton) {
        self.isYearlySelected = true
        if invisibleMonthTextField.isFirstResponder {
            view.endEditing(true)
        }
        invisibleMonthTextField.becomeFirstResponder()
    }
    
    @objc func questionMarkBtnAction(sender: UIButton!) {
            
        if(self.getCategory == 0){
        let window = UIApplication.shared.windows.last!

        let tipsAllTransparentBGView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height))
        tipsAllTransparentBGView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        tipsAllTransparentBGView.isHidden = false
        window.addSubview(tipsAllTransparentBGView)
        self.tipsAllTransparentBGView = tipsAllTransparentBGView
        
        let tipAllScrollView: UIScrollView = UIScrollView()
        tipAllScrollView.delegate = self
        tipAllScrollView.bounces = false
        tipAllScrollView.contentSize = CGSize(width: Screen_Width * 3, height: 0)
        tipAllScrollView.showsHorizontalScrollIndicator = false
        tipAllScrollView.isScrollEnabled = true
        tipAllScrollView.isPagingEnabled = true
        self.tipsAllTransparentBGView.addSubview(tipAllScrollView)
        tipAllScrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.tipsAllTransparentBGView)
            make.bottom.equalTo(-2 * AutoSizeScaleX)
        }
        self.tipAllScrollView = tipAllScrollView
        
            let pageControl: UIPageControl = UIPageControl()
            pageControl.numberOfPages = 3
            pageControl.currentPage = 0
            pageControl.tintColor = UIColor.gray
            pageControl.currentPageIndicatorTintColor = UIColor.App.PageIndicator.default
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            pageControl.addTarget(self, action: #selector(HomeDashboardViewController.pageAllTipChanged), for: .valueChanged)
            self.tipsAllTransparentBGView.addSubview(pageControl)
            self.tipAllPageControl = pageControl
            pageControl.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.tipsAllTransparentBGView).offset(-30 * AutoSizeScaleX)
                make.left.right.equalTo(self.tipsAllTransparentBGView)
                make.height.equalTo(16 * AutoSizeScaleX)
                make.centerX.equalTo(self.tipsAllTransparentBGView)
            }
            
        let tourGuideTextImgView1: UIImageView = UIImageView()
        tourGuideTextImgView1.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height)
        tourGuideTextImgView1.image = UIImage.init(named: "tip1_All")
        tourGuideTextImgView1.contentMode = .scaleAspectFill
        tipAllScrollView.addSubview(tourGuideTextImgView1)
        
        let tourGuideTextImgView2: UIImageView = UIImageView()
        tourGuideTextImgView2.frame = CGRect(x: Screen_Width, y: 0, width: Screen_Width, height: Screen_Height)
        tourGuideTextImgView2.image = UIImage.init(named: "tip2_All")
        tourGuideTextImgView2.contentMode = .scaleAspectFill
        tipAllScrollView.addSubview(tourGuideTextImgView2)
        
        let tourGuideTextImgView3: UIImageView = UIImageView()
        tourGuideTextImgView3.frame = CGRect(x: Screen_Width * 2, y: 0, width: Screen_Width, height: Screen_Height)
        tourGuideTextImgView3.image = UIImage.init(named: "tip3_All")
        tourGuideTextImgView3.contentMode = .scaleAspectFill
        tipAllScrollView.addSubview(tourGuideTextImgView3)
            
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tipAllhandleTap(_:)))
        tipAllScrollView.addGestureRecognizer(tap)
        }else{
            let window = UIApplication.shared.windows.last!

            let tipsCashTransparentBGView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height))
            tipsCashTransparentBGView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            tipsCashTransparentBGView.isHidden = false
            window.addSubview(tipsCashTransparentBGView)
            self.tipsCashTransparentBGView = tipsCashTransparentBGView
            
            let tipCashScrollView: UIScrollView = UIScrollView()
            tipCashScrollView.delegate = self
            tipCashScrollView.bounces = false
            tipCashScrollView.contentSize = CGSize(width: Screen_Width * 3, height: 0)
            tipCashScrollView.showsHorizontalScrollIndicator = false
            tipCashScrollView.isScrollEnabled = true
            tipCashScrollView.isPagingEnabled = true
            self.tipsCashTransparentBGView.addSubview(tipCashScrollView)
            tipCashScrollView.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(self.tipsCashTransparentBGView)
                make.bottom.equalTo(-2 * AutoSizeScaleX)
            }
            self.tipCashScrollView = tipCashScrollView
            
            let pageControl: UIPageControl = UIPageControl()
            pageControl.numberOfPages = 3
            pageControl.currentPage = 0
            pageControl.tintColor = UIColor.gray
            pageControl.currentPageIndicatorTintColor = UIColor.App.PageIndicator.default
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            pageControl.addTarget(self, action: #selector(HomeDashboardViewController.pageCashTipChanged), for: .valueChanged)
            self.tipsCashTransparentBGView.addSubview(pageControl)
            self.tipsCashPageControl = pageControl
            pageControl.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.tipCashScrollView).offset(-30 * AutoSizeScaleX)
                make.left.right.equalTo(self.tipCashScrollView)
                make.height.equalTo(16 * AutoSizeScaleX)
                make.centerX.equalTo(self.tipCashScrollView)
            }
            
            let tourGuideTextImgView1: UIImageView = UIImageView()
            tourGuideTextImgView1.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height)
            tourGuideTextImgView1.image = UIImage.init(named: "tip5_cash")
            tourGuideTextImgView1.contentMode = .scaleAspectFill
            tipCashScrollView.addSubview(tourGuideTextImgView1)
            
            let tourGuideTextImgView2: UIImageView = UIImageView()
            tourGuideTextImgView2.frame = CGRect(x: Screen_Width, y: 0, width: Screen_Width, height: Screen_Height)
            tourGuideTextImgView2.image = UIImage.init(named: "tip6_cash")
            tourGuideTextImgView2.contentMode = .scaleAspectFill
            tipCashScrollView.addSubview(tourGuideTextImgView2)
            
            let tourGuideTextImgView3: UIImageView = UIImageView()
            tourGuideTextImgView3.frame = CGRect(x: Screen_Width * 2, y: 0, width: Screen_Width, height: Screen_Height)
            tourGuideTextImgView3.image = UIImage.init(named: "tip7_cash")
            tourGuideTextImgView3.contentMode = .scaleAspectFill
            tipCashScrollView.addSubview(tourGuideTextImgView3)
          
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tipCashhandleTap(_:)))
            tipsCashTransparentBGView.addGestureRecognizer(tap)
        }
    }
    
    @objc func monthlyBtnAction(sender: UIButton!) {
        ANActivityIndicatorPresenter.shared.showIndicator()
        if self.scrollView.contentOffset.x > 0 {
            self.scrollView.contentOffset.x -=  self.view.bounds.width
        }
        self.isYearlySelected = false
        self.datePickerYearButton.isHidden = true
        self.datePickerMonthYearButton.isHidden = false
        self.datePickerMonthYearButton.setTitle(
            text(forSelectedMonthYear: (month: self.currentMonthYear.month, year: self.currentMonthYear.year)),
            for: .normal
        )
        if(self.selectedYear == Date.currentYear){
            self.selectedYear = Date.currentYear
            
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.monthlyBtn.snp.updateConstraints { (make) in
                make.centerX.equalTo(self.view)
            }
            self.yearlyBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.monthlyBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
        }
        reloadData()
    }
    
    @objc func yearlyBtnAction(sender: UIButton!) {
        ANActivityIndicatorPresenter.shared.showIndicator()
        scrollView.contentSize = CGSize(width: Screen_Width * 2, height: 0)
        if (self.scrollView.contentOffset.x < self.view.bounds.width * 2) {
            self.scrollView.contentOffset.x +=  self.view.bounds.width
        }
        self.isYearlySelected = true
        
        if(self.selectedYear == Date.currentYear){
            self.selectedYear = Date.currentYear
        }
        self.datePickerMonthYearButton.isHidden = true
        self.datePickerYearButton.isHidden = false
        self.datePickerYearButton.setTitle(" \(self.selectedYear) ", for: UIControl.State())
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.monthlyBtn.snp.updateConstraints { (make) in
                make.centerX.equalTo(self.view).offset(-100 * AutoSizeScaleX)
            }
        }
        self.yearlyBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
        self.monthlyBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        reloadData()
        categoryAll()
    }
    
    @objc func categoryAll(){
        self.categoryPageControl.currentPage = 0
        self.pieChartView?.isHidden = false
        self.ypieChartView?.isHidden = false
        self.sorryNoBenefitAvlLab.isHidden = true
        self.allBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
        self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        self.deviceBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        self.getCategory = 0
        if(self.monthlyYearlyOverview == nil){
            
        }else{
            let categoryVC: CategoryVC = CategoryVC(with: self.pages[self.getCategory],isYearSelected: self.isYearlySelected,getIndex: self.getIndex,getMonth:self.currentMonthYear.month,getYear: self.currentMonthYear.year,approvedInvoice: 0,monthlyYearlyOverview: self.monthlyYearlyOverview!)
                categoryVC.delegate = self
                self.categoryPageController?.setViewControllers([categoryVC], direction: .forward, animated: true, completion: nil)
                self.categoryPageController?.didMove(toParent: self)
                self.updatePieChart(category: self.getCategory)
        }

        if(self.getCategory == 2){
            let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
           let attributedText = self.sorryNoBenefitAvlLab.attributedText

           let range = (str as NSString).range(of: "unserer Webseite")

            let attributedString = NSMutableAttributedString(string: str)
           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
           var foundRange = attributedString.mutableString.range(of: "unserer Webseite")
           attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
           self.sorryNoBenefitAvlLab.textColor = UIColor.white
           self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
           self.sorryNoBenefitAvlLab.textAlignment = .center        }else if(self.getCategory == 1 || self.getCategory == 0){
            let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
           let range = (str as NSString).range(of: "unserer Webseite")
            let attributedString = NSMutableAttributedString(string: str)
           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
           var foundRange = attributedString.mutableString.range(of: "unserer Webseite")
           attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
           self.sorryNoBenefitAvlLab.textColor = UIColor.white
           self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
           self.sorryNoBenefitAvlLab.textAlignment = .center        }
        else if(self.getCategory == 3){
            sorryNoBenefitAvlLab.isSelectable = true
            sorryNoBenefitAvlLab.dataDetectorTypes = .link
            self.sorryNoBenefitAvlLab.delegate = self
            let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
          let range = (str as NSString).range(of: "")
         let attributedString = NSMutableAttributedString(string: str)
          attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
          self.sorryNoBenefitAvlLab.textColor = UIColor.white
          self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
          self.sorryNoBenefitAvlLab.textAlignment = .center
        }

    }
    @objc func allBtnAction(sender: UIButton!) {
        categoryAll()
    }
    @objc func cashBtnAction(sender: UIButton!) {
        self.categoryPageControl.currentPage = 1
            self.pieChartView?.isHidden = false
            self.ypieChartView?.isHidden = false
        self.sorryNoBenefitAvlLab.isHidden = true

        self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        self.cashBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
        self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        self.deviceBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        guard let overview = self.monthlyYearlyOverview else {
            print("⚠️ monthlyYearlyOverview is nil — Cash button tapped too early")
            self.showErrorToast("Data not ready. Please wait.")
            return
        }
            self.getCategory = 1
            let categoryVC: CategoryVC = CategoryVC(with: self.pages[self.getCategory],isYearSelected: self.isYearlySelected,getIndex: self.getIndex,getMonth:self.currentMonthYear.month,getYear: self.currentMonthYear.year,approvedInvoice: 0,monthlyYearlyOverview: overview)
            categoryVC.delegate = self
            self.categoryPageController?.setViewControllers([categoryVC], direction: .forward, animated: true, completion: nil)
            self.categoryPageController?.didMove(toParent: self)
            self.updatePieChart(category: self.getCategory)
        if(self.getCategory == 2){
            let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."

           let range = (str as NSString).range(of: "unserer Webseite")

            let attributedString = NSMutableAttributedString(string: str)
           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
           var foundRange = attributedString.mutableString.range(of: "unserer Webseite")
           attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
           self.sorryNoBenefitAvlLab.textColor = UIColor.white
           self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
           self.sorryNoBenefitAvlLab.textAlignment = .center
        }else if(self.getCategory == 1 || self.getCategory == 0){
            let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
           let range = (str as NSString).range(of: "unserer Webseite")
            let attributedString = NSMutableAttributedString(string: str)
           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
           var foundRange = attributedString.mutableString.range(of: "unserer Webseite")
           attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
           self.sorryNoBenefitAvlLab.textColor = UIColor.white
           self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
           self.sorryNoBenefitAvlLab.textAlignment = .center
            
        }
        else if(self.getCategory == 3){
            sorryNoBenefitAvlLab.isSelectable = true
            sorryNoBenefitAvlLab.dataDetectorTypes = .link
            self.sorryNoBenefitAvlLab.delegate = self
            let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
          let attributedText = self.sorryNoBenefitAvlLab.attributedText
          let range = (str as NSString).range(of: "")
         let attributedString = NSMutableAttributedString(string: str)
          attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
          self.sorryNoBenefitAvlLab.textColor = UIColor.white
          self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
          self.sorryNoBenefitAvlLab.textAlignment = .center
            
        }
        
    }
    @objc func vouchersBtnAction(sender: UIButton!) {
        self.categoryPageControl.currentPage = 2
        self.pieChartView?.isHidden = false
        self.ypieChartView?.isHidden = false

        self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        self.vouchersBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
        self.deviceBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.getCategory = 2
            let categoryVC: CategoryVC = CategoryVC(with: self.pages[self.getCategory],isYearSelected: self.isYearlySelected,getIndex: self.getIndex,getMonth:self.currentMonthYear.month,getYear: self.currentMonthYear.year,approvedInvoice: 0,monthlyYearlyOverview: self.monthlyYearlyOverview!)
            categoryVC.delegate = self
            self.categoryPageController?.setViewControllers([categoryVC], direction: .forward, animated: true, completion: nil)
            self.categoryPageController?.didMove(toParent: self)
            self.updatePieChart(category: self.getCategory)
        if(self.getCategory == 2){
            let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
           let range = (str as NSString).range(of: "unserer Webseite")
            let attributedString = NSMutableAttributedString(string: str)
           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
           var foundRange = attributedString.mutableString.range(of: "unserer Webseite")
           attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
           //self.sorryNoBenefitAvlLab.attributedText = attributedString
           self.sorryNoBenefitAvlLab.textColor = UIColor.white
           self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
           self.sorryNoBenefitAvlLab.textAlignment = .center
        }else if(self.getCategory == 1 || self.getCategory == 0){
            let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."

           let range = (str as NSString).range(of: "unserer Webseite")

            let attributedString = NSMutableAttributedString(string: str)
           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
           let foundRange = attributedString.mutableString.range(of: "unserer Webseite")
           attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
           self.sorryNoBenefitAvlLab.textColor = UIColor.white
           self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
           self.sorryNoBenefitAvlLab.textAlignment = .center        }
        else if(self.getCategory == 3){
            sorryNoBenefitAvlLab.isSelectable = true
            sorryNoBenefitAvlLab.dataDetectorTypes = .link
            self.sorryNoBenefitAvlLab.delegate = self
            let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
          let attributedText = self.sorryNoBenefitAvlLab.attributedText
          let range = (str as NSString).range(of: "")
         let attributedString = NSMutableAttributedString(string: str)
          attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
          self.sorryNoBenefitAvlLab.textColor = UIColor.white
          self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
          self.sorryNoBenefitAvlLab.textAlignment = .center        }
    }
    @objc func deviceBtnAction(sender: UIButton!) {
        self.categoryPageControl.currentPage = 3
        self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        self.deviceBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.getCategory = 3
            let categoryVC: CategoryVC = CategoryVC(with: self.pages[self.getCategory],isYearSelected: self.isYearlySelected,getIndex: self.getIndex,getMonth:self.currentMonthYear.month,getYear: self.currentMonthYear.year,approvedInvoice: 0,monthlyYearlyOverview: self.monthlyYearlyOverview!)
            categoryVC.delegate = self
            self.categoryPageController?.setViewControllers([categoryVC], direction: .forward, animated: true, completion: nil)
            self.categoryPageController?.didMove(toParent: self)
        self.pieChartView?.isHidden = true
        self.ypieChartView?.isHidden = true
    self.sorryNoBenefitAvlLab.isHidden = true
        if(self.getCategory == 2){
            let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
           let range = (str as NSString).range(of: "unserer Webseite")
            let attributedString = NSMutableAttributedString(string: str)
           attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
           let foundRange = attributedString.mutableString.range(of: "unserer Webseite")
           attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
           self.sorryNoBenefitAvlLab.attributedText = attributedString
           self.sorryNoBenefitAvlLab.textColor = UIColor.white
           self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
           self.sorryNoBenefitAvlLab.textAlignment = .center
        }else if(getCategory == 3){
            sorryNoBenefitAvlLab.isSelectable = true
            sorryNoBenefitAvlLab.dataDetectorTypes = .link
            self.sorryNoBenefitAvlLab.delegate = self
            let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
          let range = (str as NSString).range(of: "")
          let attributedString = NSMutableAttributedString(string: str)
          attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
          self.sorryNoBenefitAvlLab.textColor = UIColor.white
          self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
          self.sorryNoBenefitAvlLab.textAlignment = .center
           }
    }
    private func setupViews() {

        let moreBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-bar-button"), style: .plain, target: self, action: #selector(showMoreSection))
        notificationBadgeBtn.badgeTextColor = .white
        notificationBadgeBtn.badgeTintColor = .red
        notificationBadgeBtn.position = .right
        notificationBadgeBtn.hasBorder = true
        notificationBadgeBtn.borderColor = .red
        notificationBadgeBtn.badgeSize = .large
        notificationBadgeBtn.badgeAnimation = true

        NotificationCenter.default.addObserver(forName: .updateBadgeCountNotificaion, object: nil, queue: .main) { notification in
            DispatchQueue.main.async {
                self.client.getNotificationMessagesList { (notifications) in
                    self.notificationMessages = notifications
                    let readNotificationCount = self.notificationMessages.filter{ $0.is_read == 0 }
                    self.notificationBadgeBtn.setBadge(with:readNotificationCount.count)
                }
            }
        }

        notificationBadgeBtn.tapAction = {
            UserDefaults(suiteName: "group.com.riso.ios-app")?.set(1, forKey: "count")
            UIApplication.shared.applicationIconBadgeNumber = 0
            let controller = ListOfNotificationsViewController()
            controller.monthlyYearlyOverview = self.monthlyYearlyOverview
            self.navigationController?.pushAndHideTabBar(controller)
        }
        navigationItem.leftBarButtonItems = [moreBarButtonItem,notificationBadgeBtn];
        
        let cashBtn = UIButton(type: .custom)
        cashBtn.setTitle("BARGELD", for: .normal)
        cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        cashBtn.titleLabel?.font = .systemFont(ofSize:14*AutoSizeScaleX)
        cashBtn.contentVerticalAlignment = .center
        cashBtn.clipsToBounds = true
        cashBtn.addTarget(self, action:#selector(self.cashBtnAction), for: .touchUpInside)
        self.view.addSubview(cashBtn)
        self.cashBtn = cashBtn
        cashBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(76 * AutoSizeScaleX)
            make.centerX.equalTo(view).offset(-40 * AutoSizeScaleX)
            make.width.equalTo(70 * AutoSizeScaleX)
            make.height.equalTo(30 * AutoSizeScaleX)
        }

        let allBtn = UIButton(type: .custom)
        allBtn.setTitle("ALLE", for: .normal)
        allBtn.titleLabel?.font = .systemFont(ofSize:14*AutoSizeScaleX)
        allBtn.contentVerticalAlignment = .center
        allBtn.setTitleColor(.white, for: .normal)
        allBtn.addTarget(self, action:#selector(self.allBtnAction), for: .touchUpInside)
        allBtn.clipsToBounds = true
        self.view.addSubview(allBtn)
        self.allBtn = allBtn
        allBtn.snp.makeConstraints { (make) in
            make.right.equalTo(cashBtn.snp_left).offset(-10 * AutoSizeScaleX)
            make.width.height.top.equalTo(cashBtn)
        }

        let vouchersBtn = UIButton(type: .custom)
        vouchersBtn.setTitle("GUTSCHEINE", for: .normal)
        vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        vouchersBtn.titleLabel?.font = .systemFont(ofSize:14*AutoSizeScaleX)
        vouchersBtn.contentVerticalAlignment = .center
        vouchersBtn.addTarget(self, action:#selector(self.vouchersBtnAction), for: .touchUpInside)
        vouchersBtn.clipsToBounds = true
        self.view.addSubview(vouchersBtn)
        self.vouchersBtn = vouchersBtn
        vouchersBtn.snp.makeConstraints { (make) in
            make.left.equalTo(cashBtn.snp_right).offset(10 * AutoSizeScaleX)
            make.height.top.equalTo(cashBtn)
            make.width.equalTo(90 * AutoSizeScaleX)
        }
        
        let deviceBtn = UIButton(type: .custom)
        deviceBtn.setTitle("GERÄTE", for: .normal)
        deviceBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        deviceBtn.titleLabel?.font = .systemFont(ofSize:14*AutoSizeScaleX)
        deviceBtn.contentVerticalAlignment = .center
        deviceBtn.addTarget(self, action:#selector(self.deviceBtnAction), for: .touchUpInside)
        deviceBtn.clipsToBounds = true
        self.view.addSubview(deviceBtn)
        self.deviceBtn = deviceBtn
        deviceBtn.snp.makeConstraints { (make) in
            make.left.equalTo(vouchersBtn.snp_right).offset(1 * AutoSizeScaleX)
            make.width.height.top.equalTo(cashBtn)
        }
        cashBtn.isEnabled = false
        vouchersBtn.isEnabled = false
        deviceBtn.isEnabled = false
        self.categoryPageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.categoryPageController?.dataSource = self
        self.categoryPageController?.delegate = self
        self.addChild(self.categoryPageController!)
        self.view.addSubview(self.categoryPageController!.view)
        self.categoryPageController?.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.cashBtn.snp_bottom).offset(4 * AutoSizeScaleX)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-12 * AutoSizeScaleX)
        }

    }
    
    @objc func monthlyPiechartUISetup(){

        
        let selectMonthYearBGView: UIView = UIView()
        selectMonthYearBGView.frame = CGRect(x: Screen_Width/2 - 63 * AutoSizeScaleX, y: 8 * AutoSizeScaleX, width: 126 * AutoSizeScaleX, height: 36 * AutoSizeScaleX)
        selectMonthYearBGView.backgroundColor = .white
        selectMonthYearBGView.layer.cornerRadius = 8 * AutoSizeScaleX
        selectMonthYearBGView.isHidden = true
        self.scrollView.addSubview(selectMonthYearBGView)
        self.selectMonthBGView = selectMonthYearBGView
        view.addSubview(invisibleMonthTextField)
        invisibleMonthTextField.inputView = datePickerMonthYear
        invisibleMonthTextField.attachDismissTooblar(doneButtonTitle: "Done".localized)
        selectMonthBGView.addSubview(datePickerMonthYearButton)
        datePickerMonthYearButton.backgroundColor = .white
        datePickerMonthYearButton.layer.cornerRadius = 8 * AutoSizeScaleX
        datePickerMonthYearButton.isHidden = false
        datePickerMonthYearButton.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(selectMonthBGView)
        }
        datePickerMonthYearButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerMonthYearButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerMonthYearButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerMonthYearButton.addTarget(self, action: #selector(datePickerMonthYearButtonDidTouch(_:)), for: .touchUpInside)
        
        let pieChartBGView: PieChartView = PieChartView()
        pieChartBGView.frame = CGRect(x: Screen_Width/2 - 110 * AutoSizeScaleX, y: 50 * AutoSizeScaleX, width: 220 * AutoSizeScaleX, height: 220 * AutoSizeScaleX)
        pieChartBGView.isHidden = false
        scrollView.addSubview(pieChartBGView)
        self.pieChartView = pieChartBGView
        
        let circleUpdateValueBGView: UIView = UIView()
        circleUpdateValueBGView.backgroundColor = .white
        circleUpdateValueBGView.isHidden = true
        circleUpdateValueBGView.layer.cornerRadius = 83 * AutoSizeScaleX
        scrollView.addSubview(circleUpdateValueBGView)
        self.circleUpdateValueBGView = circleUpdateValueBGView
        circleUpdateValueBGView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(pieChartBGView)
            make.width.height.equalTo(166 * AutoSizeScaleX)
        }
        
        let sorryNoBenefitAvlLab: UITextView = UITextView()
        let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."

       let range = (str as NSString).range(of: "unserer Webseite")

        let attributedString = NSMutableAttributedString(string: str)
       attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
       let foundRange = attributedString.mutableString.range(of: "unserer Webseite")
       attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
       self.sorryNoBenefitAvlLab.textColor = UIColor.white
       self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
       self.sorryNoBenefitAvlLab.textAlignment = .center
        sorryNoBenefitAvlLab.backgroundColor = .clear
        sorryNoBenefitAvlLab.isUserInteractionEnabled = false
        sorryNoBenefitAvlLab.isSelectable = true
        sorryNoBenefitAvlLab.delegate = self
        sorryNoBenefitAvlLab.dataDetectorTypes = .link
        self.view.addSubview(sorryNoBenefitAvlLab)
        self.sorryNoBenefitAvlLab = sorryNoBenefitAvlLab
        sorryNoBenefitAvlLab.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(pieChartBGView)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(100 * AutoSizeScaleX)
        }
        
        let separateLine: UILabel = UILabel()
        separateLine.backgroundColor = .lightGray
        circleUpdateValueBGView.addSubview(separateLine)
        separateLine.snp.makeConstraints { (make) in
            make.left.equalTo(6 * AutoSizeScaleX)
            make.right.equalTo(-6 * AutoSizeScaleX)
            make.centerX.centerY.equalTo(circleUpdateValueBGView)
            make.height.equalTo(0.5 * AutoSizeScaleX)
        }
        let amountLeftValueLab: UILabel = UILabel()
        amountLeftValueLab.textAlignment = .center
        amountLeftValueLab.font = .systemFont(ofSize: 18 * AutoSizeScaleX, weight: .semibold)
        amountLeftValueLab.text = "2.254,05€"
        amountLeftValueLab.textColor = .black
        circleUpdateValueBGView.addSubview(amountLeftValueLab)
        self.amountLeftValueLab = amountLeftValueLab
        amountLeftValueLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(separateLine).offset(-6 * AutoSizeScaleX)
            make.left.right.equalTo(separateLine)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        
        let amountLeftLab: UILabel = UILabel()
        amountLeftLab.textAlignment = .center
        amountLeftLab.font = .systemFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        amountLeftLab.text = "BUDGET"
        amountLeftLab.textColor = .lightGray
        circleUpdateValueBGView.addSubview(amountLeftLab)
        self.amountLeftLab = amountLeftLab
        amountLeftLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(amountLeftValueLab.snp_top).offset(-2 * AutoSizeScaleX)
            make.left.right.equalTo(separateLine)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        
        let accreditedValueLab: UILabel = UILabel()
        accreditedValueLab.textAlignment = .center
        accreditedValueLab.font = .systemFont(ofSize: 18 * AutoSizeScaleX, weight: .semibold)
        accreditedValueLab.text = "0 €"
        accreditedValueLab.textColor = .black
        circleUpdateValueBGView.addSubview(accreditedValueLab)
        self.accreditedValueLab = accreditedValueLab
        accreditedValueLab.snp.makeConstraints { (make) in
            make.top.equalTo(separateLine).offset(6 * AutoSizeScaleX)
            make.left.right.equalTo(separateLine)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        
        let accreditedLab: UILabel = UILabel()
        accreditedLab.textAlignment = .center
        accreditedLab.font = .systemFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        accreditedLab.text = "ANERKANNT"
        accreditedLab.textColor = .lightGray
        circleUpdateValueBGView.addSubview(accreditedLab)
        self.accreditedLab = accreditedLab
        accreditedLab.snp.makeConstraints { (make) in
            make.top.equalTo(accreditedValueLab.snp_bottom).offset(2 * AutoSizeScaleX)
            make.left.right.equalTo(separateLine)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showProduct))
        tapGestureRecognizer.cancelsTouchesInView = true
        tapGestureRecognizer.numberOfTapsRequired = 1
        circleUpdateValueBGView.addGestureRecognizer(tapGestureRecognizer)
    
        
        
        let window = UIApplication.shared.windows.last!

        let tourGuideTransparentBGView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height))
        tourGuideTransparentBGView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        tourGuideTransparentBGView.isHidden = true
        
        window.addSubview(tourGuideTransparentBGView)
        self.tourGuideTransparentBGView = tourGuideTransparentBGView
        
        let transparentScrollView: UIScrollView = UIScrollView()
        transparentScrollView.delegate = self
        transparentScrollView.bounces = false
        transparentScrollView.contentSize = CGSize(width: Screen_Width * 7, height: 0)
        transparentScrollView.showsHorizontalScrollIndicator = false
        transparentScrollView.isScrollEnabled = true
        transparentScrollView.isPagingEnabled = true
        self.tourGuideTransparentBGView.addSubview(transparentScrollView)
        transparentScrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.tourGuideTransparentBGView)
            make.bottom.equalTo(-2 * AutoSizeScaleX)
        }
        self.transparentScrollView = transparentScrollView
        
        let pageControl: UIPageControl = UIPageControl()
        pageControl.numberOfPages = 7
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.App.PageIndicator.default
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.addTarget(self, action: #selector(HomeDashboardViewController.pageTransparentTipChanged), for: .valueChanged)
        self.tourGuideTransparentBGView.addSubview(pageControl)
        self.transparentPageControl = pageControl
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.tourGuideTransparentBGView).offset(-30 * AutoSizeScaleX)
            make.left.right.equalTo(self.tourGuideTransparentBGView)
            make.height.equalTo(16 * AutoSizeScaleX)
            make.centerX.equalTo(self.tourGuideTransparentBGView)
        }

        let tourGuideTextImgView1: UIImageView = UIImageView()
        tourGuideTextImgView1.frame = CGRect(x: 0, y: 0, width: Screen_Width, height: Screen_Height)
        tourGuideTextImgView1.image = UIImage.init(named: "tip1_All")
        tourGuideTextImgView1.contentMode = .scaleAspectFill
        transparentScrollView.addSubview(tourGuideTextImgView1)
        
        let tourGuideTextImgView2: UIImageView = UIImageView()
        tourGuideTextImgView2.frame = CGRect(x: Screen_Width, y: 0, width: Screen_Width, height: Screen_Height)
        tourGuideTextImgView2.image = UIImage.init(named: "tip2_All")
        tourGuideTextImgView2.contentMode = .scaleAspectFill
        transparentScrollView.addSubview(tourGuideTextImgView2)
        
        let tourGuideTextImgView3: UIImageView = UIImageView()
        tourGuideTextImgView3.frame = CGRect(x: Screen_Width * 2, y: 0, width: Screen_Width, height: Screen_Height)
        tourGuideTextImgView3.image = UIImage.init(named: "tip3_All")
        tourGuideTextImgView3.contentMode = .scaleAspectFill
        transparentScrollView.addSubview(tourGuideTextImgView3)
       
        let tourGuideTextImgView4: UIImageView = UIImageView()
        tourGuideTextImgView4.frame = CGRect(x: Screen_Width * 3, y: 0, width: Screen_Width, height: Screen_Height)
        tourGuideTextImgView4.image = UIImage.init(named: "tip4_All")
        tourGuideTextImgView4.contentMode = .scaleAspectFill
        transparentScrollView.addSubview(tourGuideTextImgView4)
        
        let tourGuideTextImgView5: UIImageView = UIImageView()
        tourGuideTextImgView5.frame = CGRect(x: Screen_Width * 4, y: 0, width: Screen_Width, height: Screen_Height)
        tourGuideTextImgView5.image = UIImage.init(named: "tip5_cash")
        tourGuideTextImgView5.contentMode = .scaleAspectFill
        transparentScrollView.addSubview(tourGuideTextImgView5)
        
        let tourGuideTextImgView6: UIImageView = UIImageView()
        tourGuideTextImgView6.frame = CGRect(x: Screen_Width * 5, y: 0, width: Screen_Width, height: Screen_Height)
        tourGuideTextImgView6.image = UIImage.init(named: "tip6_cash")
        tourGuideTextImgView6.contentMode = .scaleAspectFill
        transparentScrollView.addSubview(tourGuideTextImgView6)
        
        let tourGuideTextImgView7: UIImageView = UIImageView()
        tourGuideTextImgView7.frame = CGRect(x: Screen_Width * 6, y: 0, width: Screen_Width, height: Screen_Height)
        tourGuideTextImgView7.image = UIImage.init(named: "tip7_cash")
        tourGuideTextImgView7.contentMode = .scaleAspectFill
        transparentScrollView.addSubview(tourGuideTextImgView7)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tourGuideTransparentBGView.addGestureRecognizer(tap)
        
    }
    
    @objc func yearlyPiechartUISetup(){
        let selectYearBGView: UIView = UIView()
        selectYearBGView.frame = CGRect(x: Screen_Width/2 - 63 * AutoSizeScaleX + Screen_Width, y: 8 * AutoSizeScaleX, width: 126 * AutoSizeScaleX, height: 36 * AutoSizeScaleX)
        selectYearBGView.backgroundColor = .white
        selectYearBGView.layer.cornerRadius = 8 * AutoSizeScaleX
        selectYearBGView.isHidden = true
        self.scrollView.addSubview(selectYearBGView)
        self.selectYearBGView = selectYearBGView
        
        
        //YEARLY
        view.addSubview(invisibleYearTextField)
        invisibleYearTextField.inputView = datePicker
        datePickerYearButton.backgroundColor = .white
        invisibleYearTextField.attachDismissTooblar(doneButtonTitle: "Done".localized)
        datePickerYearButton.layer.cornerRadius = 8 * AutoSizeScaleX
        selectYearBGView.addSubview(datePickerYearButton)
        datePickerYearButton.isHidden = true
        self.isYearlySelected = false
        datePickerYearButton.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(selectYearBGView)
        }
        datePickerYearButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerYearButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerYearButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerYearButton.addTarget(self, action: #selector(datePickerButtonDidTouch(_:)), for: .touchUpInside)
        datePickerYearButton.setTitle(" \(self.selectedYear) ", for: UIControl.State())
        let pieChartBGView: PieChartView = PieChartView()
        pieChartBGView.frame = CGRect(x: Screen_Width/2 - 110 * AutoSizeScaleX + Screen_Width, y: 50 * AutoSizeScaleX, width: 220 * AutoSizeScaleX, height: 220 * AutoSizeScaleX)
        pieChartBGView.isHidden = true
        scrollView.addSubview(pieChartBGView)
        self.ypieChartView = pieChartBGView
        
        let circleUpdateValueBGView: UIView = UIView()
        circleUpdateValueBGView.backgroundColor = .white
        circleUpdateValueBGView.isHidden = false
        circleUpdateValueBGView.layer.cornerRadius = 83 * AutoSizeScaleX
        scrollView.addSubview(circleUpdateValueBGView)
        self.ycircleUpdateValueBGView = circleUpdateValueBGView
        circleUpdateValueBGView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(pieChartBGView)
            make.width.height.equalTo(166 * AutoSizeScaleX)
        }
        
        let separateLine: UILabel = UILabel()
        separateLine.backgroundColor = .lightGray
        circleUpdateValueBGView.addSubview(separateLine)
        separateLine.snp.makeConstraints { (make) in
            make.left.equalTo(6 * AutoSizeScaleX)
            make.right.equalTo(-6 * AutoSizeScaleX)
            make.centerX.centerY.equalTo(circleUpdateValueBGView)
            make.height.equalTo(0.5 * AutoSizeScaleX)
        }
        let amountLeftValueLab: UILabel = UILabel()
        amountLeftValueLab.textAlignment = .center
        amountLeftValueLab.font = .systemFont(ofSize: 18 * AutoSizeScaleX, weight: .semibold)
        amountLeftValueLab.text = "2.254,05€"
        amountLeftValueLab.textColor = .black
        circleUpdateValueBGView.addSubview(amountLeftValueLab)
        self.yamountLeftValueLab = amountLeftValueLab
        amountLeftValueLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(separateLine).offset(-6 * AutoSizeScaleX)
            make.left.right.equalTo(separateLine)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        
        let amountLeftLab: UILabel = UILabel()
        amountLeftLab.textAlignment = .center
        amountLeftLab.font = .systemFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        amountLeftLab.text = "NOCH MÖGLICH"
        amountLeftLab.textColor = .lightGray
        circleUpdateValueBGView.addSubview(amountLeftLab)
        self.yamountLeftLab = amountLeftLab
        amountLeftLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(amountLeftValueLab.snp_top).offset(-2 * AutoSizeScaleX)
            make.left.right.equalTo(separateLine)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        
        let accreditedValueLab: UILabel = UILabel()
        accreditedValueLab.textAlignment = .center
        accreditedValueLab.font = .systemFont(ofSize: 18 * AutoSizeScaleX, weight: .semibold)
        accreditedValueLab.text = "0 €"
        accreditedValueLab.textColor = .black
        circleUpdateValueBGView.addSubview(accreditedValueLab)
        self.yaccreditedValueLab = accreditedValueLab
        accreditedValueLab.snp.makeConstraints { (make) in
            make.top.equalTo(separateLine).offset(6 * AutoSizeScaleX)
            make.left.right.equalTo(separateLine)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        
        let accreditedLab: UILabel = UILabel()
        accreditedLab.textAlignment = .center
        accreditedLab.font = .systemFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        accreditedLab.text = "ANERKANNT"
        accreditedLab.textColor = .lightGray
        circleUpdateValueBGView.addSubview(accreditedLab)
        self.yaccreditedLab = accreditedLab
        accreditedLab.snp.makeConstraints { (make) in
            make.top.equalTo(accreditedValueLab.snp_bottom).offset(2 * AutoSizeScaleX)
            make.left.right.equalTo(separateLine)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showProduct))
        tapGestureRecognizer.cancelsTouchesInView = true
        tapGestureRecognizer.numberOfTapsRequired = 1
        circleUpdateValueBGView.addGestureRecognizer(tapGestureRecognizer)

    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.transparentScrollView.contentOffset.x +=  self.view.bounds.width
        let page = Int(transparentScrollView.contentOffset.x / transparentScrollView.frame.size.width)
        self.transparentPageControl.currentPage = page
        if(page == 7){
            self.tourGuideTransparentBGView.removeFromSuperview()
            ITNSUserDefaults.set(false, forKey: "PieChartTourGuideHide")
        }
    }
    
    @objc func tipAllhandleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.tipAllScrollView.contentOffset.x +=  self.view.bounds.width
        let page = Int(tipAllScrollView.contentOffset.x / tipAllScrollView.frame.size.width)
        self.tipAllPageControl.currentPage = page
        if(page == 3){
            self.tipsAllTransparentBGView.removeFromSuperview()
        }
    }
    @objc func tipCashhandleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.tipCashScrollView.contentOffset.x +=  self.view.bounds.width
        let page = Int(tipCashScrollView.contentOffset.x / tipCashScrollView.frame.size.width)
        self.tipsCashPageControl.currentPage = page
        if(page == 3){
            self.tipsCashTransparentBGView.removeFromSuperview()
        }
    }
    
    @objc
    private func showProduct(gesture: UIGestureRecognizer) {


        if(isYearlySelected == true){
            let controller = ProductsOverviewViewController.instantiate(with: self.monthlyYearlyOverview!.monthly[0], yearlyOverview: self.monthlyYearlyOverview!.yearly,month : currentMonthYear.month , year :selectedYear,selectMonth:0,getCategory: self.getCategory,isYearlySelected: true)
            navigationController?.pushAndHideTabBar(controller, animated: true)
        }else{
            let controller = ProductsOverviewContainerViewController.instantiate(
                with: self.monthlyYearlyOverview!,
                selectedIndex: self.getIndex,
                selectMonth: selectedMonth,
                selectedYear: selectedYear,
                getCategory: self.getCategory,
                isYearSelected: false
            )
            navigationController?.pushAndHideTabBar(controller)
        }
    }
    
    private func reloadData() {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let oldNumberOfOverviews = self.state.monthlyOverviews.count
        let oldSelectedIndex     = self.state.selectedIndex
        let operation = BlockOperation { [unowned self] in
            let group = DispatchGroup()
            
            if self.state.monthlyOverviews.isEmpty {
                self.activityIndicator.startAnimating()
            }
            //MonthlyYearlyOverview
            group.enter()
            client.getMonthlyYearlyOverviews(month: nil, year: self.selectedYear) { [weak self] (monthlyYearlyOverviewData) in
                guard let `self` = self else {
                    group.leave()
                    return
                }
                self.monthlyYearlyOverview = monthlyYearlyOverviewData

                let getSelectedMonth = String(format: "%02d", self.currentMonthYear.month)
                let getIndex = self.monthlyYearlyOverview?.monthly.firstIndex(where: {$0.month.starts(with: getSelectedMonth)})
                self.getIndex = getIndex ?? 0
                self.updatePieChart(category: self.getCategory)
                if(monthlyYearlyOverviewData == nil){
                    
                }else{
                    self.categoryAll()
                    self.cashBtn.isEnabled = self.monthlyYearlyOverview != nil
                    self.vouchersBtn.isEnabled = self.monthlyYearlyOverview != nil
                    self.deviceBtn.isEnabled = self.monthlyYearlyOverview != nil

                }
                    
                group.leave()

            }
            group.notify(queue: DispatchQueue.main, execute: { [weak self] in
                guard let `self` = self else { return }

                UIView.animate(withDuration: 0.3, animations: {
                })
                self.activityIndicator.stopAnimating()
            })
        }
        
        operation.start()
        self.cashBtn.isEnabled = self.monthlyYearlyOverview != nil
        self.vouchersBtn.isEnabled = self.monthlyYearlyOverview != nil
        self.deviceBtn.isEnabled = self.monthlyYearlyOverview != nil

    }
    
    private func reloadMonthData() {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let oldNumberOfOverviews = self.state.monthlyOverviews.count
        let oldSelectedIndex     = self.state.selectedIndex
        let operation = BlockOperation { [unowned self] in
            let group = DispatchGroup()
            
            if self.state.monthlyOverviews.isEmpty {
                self.activityIndicator.startAnimating()
            }
            group.enter()
            client.getMonthlyYearlyOverviews(month: self.currentMonthYear.month, year: self.currentMonthYear.year) { [weak self] (monthlyYearlyOverviewData) in
                guard let `self` = self else {
                    group.leave()
                    return
                }
                self.monthlyYearlyOverview = monthlyYearlyOverviewData
                let getSelectedMonth = String(format: "%02d", self.currentMonthYear.month)
                let getIndex = self.monthlyYearlyOverview?.monthly.firstIndex(where: {$0.month.starts(with: getSelectedMonth)})
                self.getIndex = getIndex ?? 0
                self.updatePieChart(category: self.getCategory)
                self.categoryAll()
                group.leave()

            }
            group.notify(queue: DispatchQueue.main, execute: { [weak self] in
                guard let `self` = self else { return }

                UIView.animate(withDuration: 0.3, animations: {
                })

                self.activityIndicator.stopAnimating()
            })
        }
        
        operation.start()
    }
    func updatePieChart(category: Int){

        if ITNSUserDefaults.value(forKey: "FirstTimeDashboard") == nil {
            ITNSUserDefaults.set(false, forKey: "FirstTimeDashboard")
            self.tourGuideTransparentBGView.isHidden = false
        }
        var total_amount_spent = 0.0
        var remainingAmount = 0.0
        var totalApprovedInvoice = 0
        var total_amount = 0.0
        var totalAccreditedAmount = 0.0

        if(isYearlySelected == true){
            
            self.selectYearBGView.isHidden = false
            self.pieChartView?.isHidden = false
            self.ypieChartView?.isHidden = false
            self.circleUpdateValueBGView.isHidden = false
            self.sorryNoBenefitAvlLab.isHidden = true
            let getYearlyCategoryData = self.monthlyYearlyOverview?.yearly.productsOverviews.filter({$0.product.category_type == category})

            for index in 0..<(getYearlyCategoryData!.count) {
                total_amount += getYearlyCategoryData?[index].totalAmount ?? 0.0
                remainingAmount += getYearlyCategoryData?[index].remainingAmount ?? 0.0
                totalApprovedInvoice += getYearlyCategoryData?[index].approvedInvoicesCount ?? 0
            }

            self.noOfapprovedInvoice = totalApprovedInvoice
            for index in 0..<(getYearlyCategoryData!.count) {
                
                let accreditedAmount = (((getYearlyCategoryData?[index].totalAmount)!)-((getYearlyCategoryData?[index].remainingAmount)!))
                let getAccreditedPercentage = ((accreditedAmount)/((total_amount)))*100
                if(getAccreditedPercentage > 0){
                    getItems.append(PieItem(percent: Float(getAccreditedPercentage), thickness: 30.0, color: UIColor(hexString: getYearlyCategoryData?[index].product.hexColor ?? "").alpha(0.7)))
                }
                let getRemainingAmount = (((getYearlyCategoryData?[index].totalAmount)!)-((getYearlyCategoryData?[index].remainingAmount)!))
                var getRemainingFinalAmount = (((getYearlyCategoryData?[index].totalAmount)!)-(getRemainingAmount))
                if(getRemainingFinalAmount == 0.0){
                    getRemainingFinalAmount = getYearlyCategoryData?[index].totalAmount ?? 0.0
                }
                let getPercentage = ((getRemainingFinalAmount)/((total_amount)))*100
                if(getPercentage == getAccreditedPercentage ){
                    if(getRemainingFinalAmount == getYearlyCategoryData?[index].totalAmount){}else{
                        getItems.append(PieItem(percent: Float(getPercentage), thickness: 30.0, color: UIColor(hexString: getYearlyCategoryData?[index].product.hexColor ?? "")))
                    }
                }else{
                    getItems.append(PieItem(percent: Float(getPercentage), thickness: 30.0, color: UIColor(hexString: getYearlyCategoryData?[index].product.hexColor ?? "")))
                }
            }
            totalAccreditedAmount = total_amount - remainingAmount
            if(getYearlyCategoryData?.count == 0){
                self.pieChartView?.isHidden = false
                self.ypieChartView?.isHidden = false
                self.sorryNoBenefitAvlLab.isHidden = true
                
                if(category == 2 || category == 1){
                    let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
                   let range = (str as NSString).range(of: "unserer Webseite")

                    let attributedString = NSMutableAttributedString(string: str)
                   attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                   let foundRange = attributedString.mutableString.range(of: "unserer Webseite")
                   attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
                   self.sorryNoBenefitAvlLab.textColor = UIColor.white
                   self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                   self.sorryNoBenefitAvlLab.textAlignment = .center
                }else if(category == 3){
                    sorryNoBenefitAvlLab.isSelectable = true
                    sorryNoBenefitAvlLab.dataDetectorTypes = .link
                    self.sorryNoBenefitAvlLab.delegate = self
                    let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
                  let range = (str as NSString).range(of: "")
                  let attributedString = NSMutableAttributedString(string: str)
                  attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                  self.sorryNoBenefitAvlLab.textColor = UIColor.white
                  self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                  self.sorryNoBenefitAvlLab.textAlignment = .center
                }else if(category == 0){
                    getItems.append(PieItem(percent: Float(100), thickness: 30.0, color: UIColor.clear))
                }
                if(category == 2 || category == 1){
                    self.sorryNoBenefitAvlLab.isHidden = false
                    let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
                   let range = (str as NSString).range(of: "unserer Webseite")

                    let attributedString = NSMutableAttributedString(string: str)
                   attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                    let foundRange = attributedString.mutableString.range(of: "unserer Webseite")
                   attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
                   self.sorryNoBenefitAvlLab.textColor = UIColor.white
                   self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                   self.sorryNoBenefitAvlLab.textAlignment = .center
    
                }else if(category == 3){
                    self.pieChartView?.isHidden = false
                    self.ypieChartView?.isHidden = false
                    sorryNoBenefitAvlLab.isHidden = true
                    sorryNoBenefitAvlLab.isSelectable = true
                    sorryNoBenefitAvlLab.dataDetectorTypes = .link
                    self.sorryNoBenefitAvlLab.delegate = self
                    let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
                  let range = (str as NSString).range(of: "")
                 let attributedString = NSMutableAttributedString(string: str)
                  attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                  self.sorryNoBenefitAvlLab.textColor = UIColor.white
                  self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                  self.sorryNoBenefitAvlLab.textAlignment = .center
                }
            }
            if(category == 0 ){
                totalAccreditedAmount = self.monthlyYearlyOverview?.yearly.total_amount_spent ?? 0.0
                remainingAmount = self.monthlyYearlyOverview?.yearly.remainingAmount ?? 0.0
                total_amount = self.monthlyYearlyOverview?.yearly.totalAmount ?? 0.0
                let getAccreditedPercentage = ((totalAccreditedAmount)/((total_amount)))*100
                let getRemainingPercentage = ((remainingAmount)/((total_amount)))*100

                for num in 1...2{
                    if(num == 1){
                        getItems.append(PieItem(percent: Float(getAccreditedPercentage), thickness: 30.0, color: UIColor(hexString: "#3868F6").alpha(0.7)))
                    }else{
                        getItems.append(PieItem(percent: Float(getRemainingPercentage), thickness: 30.0, color: UIColor(hexString: "#3868F6")))
                    }
                }
                self.pieChartView?.isHidden = true
                self.ypieChartView?.isHidden = false
                self.sorryNoBenefitAvlLab.isHidden = true
            }

            if(self.getCategory == 0){
                self.yamountLeftLab.text = "BUDGET"
                self.yamountLeftValueLab.textColor = UIColor(hexString: "#3868F6")
                self.yamountLeftLab.textColor = UIColor(hexString: "#3868F6")
                self.yaccreditedValueLab.textColor = UIColor(hexString: "#1E4199")
                self.yaccreditedLab.textColor = UIColor(hexString: "#1E4199")
                self.yamountLeftValueLab.text = String(total_amount.priceAsString())


            }else{
                self.yamountLeftLab.text = "NOCH MÖGLICH"
                self.yamountLeftValueLab.textColor = UIColor(hexString: "#222B45")
                self.yamountLeftLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.yaccreditedValueLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.yaccreditedLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.yamountLeftValueLab.text = String(remainingAmount.priceAsString())
            }
            self.accreditedValueLab.text = String(totalAccreditedAmount.priceAsString())
            self.yaccreditedValueLab.text = String(totalAccreditedAmount.priceAsString())
            self.TamountLeftValueLab.text = String(total_amount.priceAsString())
            self.TaccreditedValueLab.text = String(totalAccreditedAmount.priceAsString())
            self.noOfApprovedInvoicesLab.text = String(totalApprovedInvoice)
            self.pieChartView?.adjust(withItems: getItems)
            self.ypieChartView?.adjust(withItems: getItems)
            self.TpieChartView?.adjust(withItems: getItems)

        }else{
            let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews.filter({$0.product.category_type == category})
            
            for index in 0..<(getMonthlyCategoryData?.count ?? 0) {
                total_amount += getMonthlyCategoryData?[index].totalAmount ?? 0.0
                remainingAmount += getMonthlyCategoryData?[index].remainingAmount ?? 0.0
                totalApprovedInvoice += getMonthlyCategoryData?[index].approvedInvoicesCount ?? 0
            }
            self.noOfapprovedInvoice = totalApprovedInvoice

            self.noOfApprovedInvoicesLab.text = String(totalApprovedInvoice)

            self.selectMonthBGView.isHidden = false
            self.pieChartView?.isHidden = false
            self.sorryNoBenefitAvlLab.isHidden = true
            self.ypieChartView?.isHidden = true
            self.circleUpdateValueBGView.isHidden = false

            for index in 0..<(getMonthlyCategoryData?.count ?? 0) {
                let accreditedAmount = (((getMonthlyCategoryData?[index].totalAmount)!)-((getMonthlyCategoryData?[index].remainingAmount)!))
                let getAccreditedPercentage = ((accreditedAmount)/((total_amount)))*100
                if(getAccreditedPercentage > 0){
                    getItems.append(PieItem(percent: Float(getAccreditedPercentage), thickness: 30.0, color: UIColor(hexString: getMonthlyCategoryData?[index].product.hexColor ?? "").alpha(0.7)))
                }
                let getRemainingAmount = (((getMonthlyCategoryData?[index].totalAmount)!)-((getMonthlyCategoryData?[index].remainingAmount)!))
                var getRemainingFinalAmount = (((getMonthlyCategoryData?[index].totalAmount)!)-(getRemainingAmount))
                if(getRemainingFinalAmount == 0.0){
                    getRemainingFinalAmount = getMonthlyCategoryData?[index].totalAmount ?? 0.0
                }
                let getPercentage = ((getRemainingFinalAmount)/((total_amount)))*100
                if(getPercentage == getAccreditedPercentage){
                    if(getRemainingFinalAmount == getMonthlyCategoryData?[index].totalAmount){}else{
                        getItems.append(PieItem(percent: Float(getPercentage), thickness: 30.0, color: UIColor(hexString: getMonthlyCategoryData?[index].product.hexColor ?? "")))
                    }
                }else{
                    getItems.append(PieItem(percent: Float(getPercentage), thickness: 30.0, color: UIColor(hexString: getMonthlyCategoryData?[index].product.hexColor ?? "")))
                }
            }
            self.pieChartView?.adjust(withItems: getItems)
            self.ypieChartView?.adjust(withItems: getItems)
            self.TpieChartView?.adjust(withItems: getItems)
            totalAccreditedAmount = total_amount - remainingAmount

            if(category == 0 ){
                let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[self.getIndex]
                
                total_amount_spent = getMonthlyCategoryData?.total_amount_spent ?? 0.0
                remainingAmount = getMonthlyCategoryData?.remainingAmount ?? 0.0
                total_amount = getMonthlyCategoryData?.totalAmount ?? 0.0
                let getAccreditedPercentage = ((self.monthlyYearlyOverview?.monthly[self.getIndex].total_amount_spent ?? 0.0)/((total_amount)))*100
                let getRemainingPercentage = ((self.monthlyYearlyOverview?.monthly[self.getIndex].remainingAmount ?? 0.0)/((total_amount)))*100

                for num in 1...2{
                    if(num == 1){
                        getItems.append(PieItem(percent: Float(getRemainingPercentage), thickness: 30.0, color: UIColor(hexString: "#3868F6")))
                    }else{
                        getItems.append(PieItem(percent: Float(getAccreditedPercentage), thickness: 30.0, color: UIColor(hexString: "#3868F6").alpha(0.7)))
                    }
                }
                self.pieChartView?.adjust(withItems: getItems)
                self.TpieChartView?.adjust(withItems: getItems)
                self.pieChartView?.isHidden = false
                self.ypieChartView?.isHidden = true
                self.sorryNoBenefitAvlLab.isHidden = true
                totalAccreditedAmount = total_amount_spent

            }
            if(getMonthlyCategoryData?.count == 0){
                self.pieChartView?.isHidden = false
                self.ypieChartView?.isHidden = false
                self.sorryNoBenefitAvlLab.isHidden = true

                 if(category == 0){
                     self.sorryNoBenefitAvlLab.isHidden = true
                     self.pieChartView?.isHidden = false

                    getItems.append(PieItem(percent: Float(100), thickness: 30.0, color: UIColor.clear))
                 }else{
                     getItems.append(PieItem(percent: Float(100), thickness: 30.0, color: UIColor.white))
                 }
                if(category == 2 || category == 1){
                    self.sorryNoBenefitAvlLab.isHidden = true
                    let str = "Diese Benefit-Gruppe steht Dir aktuell noch nicht zur Verfügung.Infos zu unseren Benefits findest Du auf unserer Webseite.Oder ruf uns einfach an und lass Dich beraten: +49 6223 96 996 58."
                    self.pieChartView?.isHidden = true
                    self.ypieChartView?.isHidden = true
                   let range = (str as NSString).range(of: "unserer Webseite")

                    let attributedString = NSMutableAttributedString(string: str)
                   attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                    let foundRange = attributedString.mutableString.range(of: "unserer Webseite")
                   attributedString.addAttribute(NSAttributedString.Key.link, value: risoWebsiteURL, range: foundRange)
                   //self.sorryNoBenefitAvlLab.attributedText = attributedString
                   self.sorryNoBenefitAvlLab.textColor = UIColor.white
                   self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                   self.sorryNoBenefitAvlLab.textAlignment = .center
                    
                }else if(category == 3){
                    self.sorryNoBenefitAvlLab.isHidden = true
                    sorryNoBenefitAvlLab.isSelectable = true
                    self.pieChartView?.isHidden = true
                    self.ypieChartView?.isHidden = true
                    sorryNoBenefitAvlLab.dataDetectorTypes = .link
                    self.sorryNoBenefitAvlLab.delegate = self
                    let str = "Diese Benefit-Gruppe entwickeln wir gerade.Du darfst gespannt sein: in einigen Monaten findest Du hier alle Informationen."
                  let range = (str as NSString).range(of: "")
                 let attributedString = NSMutableAttributedString(string: str)
                  attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
                 // self.sorryNoBenefitAvlLab.attributedText = attributedString
                  self.sorryNoBenefitAvlLab.textColor = UIColor.white
                  self.sorryNoBenefitAvlLab.font = .systemFont(ofSize: 16 * AutoSizeScaleX, weight: .regular)
                  self.sorryNoBenefitAvlLab.textAlignment = .center                }
            }
            if(category == 0){
                self.amountLeftLab.text = "BUDGET"
                self.amountLeftValueLab.textColor = UIColor(hexString: "#3868F6")
                self.amountLeftLab.textColor = UIColor(hexString: "#3868F6")
                self.accreditedValueLab.textColor = UIColor(hexString: "#1E4199")
                self.accreditedLab.textColor = UIColor(hexString: "#1E4199")
                self.amountLeftValueLab.text = String((total_amount.priceAsString()))
                self.yamountLeftValueLab.text = String((total_amount.priceAsString()))


            }else{
                self.amountLeftLab.text = "NOCH MÖGLICH"
                self.amountLeftValueLab.textColor = UIColor(hexString: "#222B45")
                self.amountLeftLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.accreditedValueLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.accreditedLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.amountLeftValueLab.text = String((remainingAmount.priceAsString()))
                self.yamountLeftValueLab.text = String((remainingAmount.priceAsString()))
            }
            self.accreditedValueLab.text = String((totalAccreditedAmount.priceAsString()))
            self.yaccreditedValueLab.text = String((totalAccreditedAmount.priceAsString()))
            self.TamountLeftValueLab.text = String((total_amount.priceAsString()))
            self.TaccreditedValueLab.text = String((totalAccreditedAmount.priceAsString()))

        }
        ANActivityIndicatorPresenter.shared.hideIndicator()
    }
    
    func updateScreen(month: Int, year: Int){

        if ITNSUserDefaults.value(forKey: "FirstTimeDashboard") == nil {
            ITNSUserDefaults.set(false, forKey: "FirstTimeDashboard")
            self.tourGuideTransparentBGView.isHidden = false
        }
        if(isYearlySelected == true){
            if(self.getCategory == 0){
                self.yamountLeftValueLab.textColor = UIColor(hexString: "#3868F6")
                self.yamountLeftLab.textColor = UIColor(hexString: "#3868F6")
                self.yamountLeftLab.text = "BUDGET"
                self.yaccreditedValueLab.textColor = UIColor(hexString: "#1E4199")
                self.yaccreditedLab.textColor = UIColor(hexString: "#1E4199")
                self.amountLeftValueLab.text = String((self.monthlyYearlyOverview?.yearly.totalAmount.priceAsString())!)
                self.yamountLeftValueLab.text = String((self.monthlyYearlyOverview?.yearly.totalAmount.priceAsString())!)

            }else{
                self.yamountLeftLab.text = "NOCH MÖGLICH"
                self.yamountLeftValueLab.textColor = UIColor(hexString: "#222B45")
                self.yamountLeftLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.yaccreditedValueLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.yaccreditedLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.amountLeftValueLab.text = String((self.monthlyYearlyOverview?.yearly.remainingAmount.priceAsString())!)
                self.yamountLeftValueLab.text = String((self.monthlyYearlyOverview?.yearly.remainingAmount.priceAsString())!)
            }
            self.accreditedValueLab.text = String((self.monthlyYearlyOverview?.yearly.total_amount_spent.priceAsString())!)
            self.yaccreditedValueLab.text = String((self.monthlyYearlyOverview?.yearly.total_amount_spent.priceAsString())!)
            self.TamountLeftValueLab.text = String((self.monthlyYearlyOverview?.yearly.totalAmount.priceAsString())!)
            self.TaccreditedValueLab.text = String((self.monthlyYearlyOverview?.yearly.total_amount_spent.priceAsString())!)
            self.noOfApprovedInvoicesLab.text = String((self.monthlyYearlyOverview?.yearly.approvedInvoicesCount)!)
            self.selectYearBGView.isHidden = false
            self.pieChartView?.isHidden = false
            self.circleUpdateValueBGView.isHidden = false
            self.sorryNoBenefitAvlLab.isHidden = true
            for index in 0..<(self.monthlyYearlyOverview?.yearly.productsOverviews.count)! {
                let accreditedAmount = (((self.monthlyYearlyOverview?.yearly.productsOverviews[index].totalAmount)!)-((self.monthlyYearlyOverview?.yearly.productsOverviews[index].remainingAmount)!))

                let getAccreditedPercentage = ((accreditedAmount)/((self.monthlyYearlyOverview?.yearly.totalAmount)!))*100

                if(getAccreditedPercentage > 0){
                    getItems.append(PieItem(percent: Float(getAccreditedPercentage), thickness: 30.0, color: UIColor(hexString: self.monthlyYearlyOverview?.yearly.productsOverviews[index].product.hexColor ?? "").alpha(0.7)))
                }
                let getRemainingAmount = (((self.monthlyYearlyOverview?.yearly.productsOverviews[index].totalAmount)!)-((self.monthlyYearlyOverview?.yearly.productsOverviews[index].remainingAmount)!))
                var getRemainingFinalAmount = (((self.monthlyYearlyOverview?.yearly.productsOverviews[index].totalAmount)!)-(getRemainingAmount))
                if(getRemainingFinalAmount == 0.0){
                    getRemainingFinalAmount = self.monthlyYearlyOverview?.yearly.productsOverviews[index].totalAmount ?? 0.0
                }
                let getPercentage = ((getRemainingFinalAmount)/((self.monthlyYearlyOverview?.yearly.totalAmount)!))*100
                if(getPercentage == getAccreditedPercentage){
                    if(getRemainingFinalAmount == self.monthlyYearlyOverview?.yearly.productsOverviews[index].totalAmount){}else{
                        getItems.append(PieItem(percent: Float(getPercentage), thickness: 30.0, color: UIColor(hexString: self.monthlyYearlyOverview?.yearly.productsOverviews[index].product.hexColor ?? "")))
                    }
                }else{
                    getItems.append(PieItem(percent: Float(getPercentage), thickness: 30.0, color: UIColor(hexString: self.monthlyYearlyOverview?.yearly.productsOverviews[index].product.hexColor ?? "")))
                }
            }
            self.pieChartView?.adjust(withItems: getItems)
            self.ypieChartView?.adjust(withItems: getItems)

        }else{
            if(self.getCategory == 0){
                self.amountLeftLab.text = "BUDGET"
                self.amountLeftValueLab.textColor = UIColor(hexString: "#3868F6")
                self.amountLeftLab.textColor = UIColor(hexString: "#3868F6")
                self.accreditedValueLab.textColor = UIColor(hexString: "#1E4199")
                self.accreditedLab.textColor = UIColor(hexString: "#1E4199")
                self.amountLeftValueLab.text = String((self.monthlyYearlyOverview?.monthly[self.getIndex].totalAmount.priceAsString())!)
                self.yamountLeftValueLab.text = String((self.monthlyYearlyOverview?.monthly[self.getIndex].totalAmount.priceAsString())!)

            }else{
                self.amountLeftLab.text = "NOCH MÖGLICH"
                self.amountLeftValueLab.textColor = UIColor(hexString: "#222B45")
                self.amountLeftLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.accreditedValueLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.accreditedLab.textColor = UIColor(hexString: "#222B45").alpha(0.6)
                self.amountLeftValueLab.text = String((self.monthlyYearlyOverview?.monthly[self.getIndex].remainingAmount.priceAsString())!)
                self.yamountLeftValueLab.text = String((self.monthlyYearlyOverview?.monthly[self.getIndex].remainingAmount.priceAsString())!)
            }

            self.accreditedValueLab.text = String((self.monthlyYearlyOverview?.monthly[self.getIndex].total_amount_spent.priceAsString())!)
            self.yaccreditedValueLab.text = String((self.monthlyYearlyOverview?.monthly[self.getIndex].total_amount_spent.priceAsString())!)
            self.TamountLeftValueLab.text = String((self.monthlyYearlyOverview?.monthly[self.getIndex].totalAmount.priceAsString())!)
            self.TaccreditedValueLab.text = String((self.monthlyYearlyOverview?.monthly[self.getIndex].total_amount_spent.priceAsString())!)
            self.noOfApprovedInvoicesLab.text = String((self.monthlyYearlyOverview?.monthly[self.getIndex].approvedInvoicesCount)!)
            self.selectMonthBGView.isHidden = false
            self.pieChartView?.isHidden = false
            self.circleUpdateValueBGView.isHidden = false
            self.sorryNoBenefitAvlLab.isHidden = true
            for index in 0..<(self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews.count)! {
                let accreditedAmount = (((self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews[index].totalAmount)!)-((self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews[index].remainingAmount)!))
                let getAccreditedPercentage = ((accreditedAmount)/((self.monthlyYearlyOverview?.monthly[self.getIndex].totalAmount)!))*100
                if(getAccreditedPercentage > 0){
                    getItems.append(PieItem(percent: Float(getAccreditedPercentage), thickness: 30.0, color: UIColor(hexString: self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews[index].product.hexColor ?? "").alpha(0.7)))
                }
                let getRemainingAmount = (((self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews[index].totalAmount)!)-((self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews[index].remainingAmount)!))
                var getRemainingFinalAmount = (((self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews[index].totalAmount)!)-(getRemainingAmount))
                if(getRemainingFinalAmount == 0.0){
                    getRemainingFinalAmount = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews[index].totalAmount ?? 0.0
                }
                let getPercentage = ((getRemainingFinalAmount)/((self.monthlyYearlyOverview?.monthly[self.getIndex].totalAmount)!))*100
                if(getPercentage == getAccreditedPercentage){
                    if(getRemainingFinalAmount == self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews[index].totalAmount){}else{
                        getItems.append(PieItem(percent: Float(getPercentage), thickness: 30.0, color: UIColor(hexString: self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews[index].product.hexColor ?? "")))
                    }
                }else{
                    getItems.append(PieItem(percent: Float(getPercentage), thickness: 30.0, color: UIColor(hexString: self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews[index].product.hexColor ?? "")))
                }
            }
            self.pieChartView?.adjust(withItems: getItems)
            self.ypieChartView?.adjust(withItems: getItems)
            self.TpieChartView?.adjust(withItems: getItems)

        }
        ANActivityIndicatorPresenter.shared.hideIndicator()

    }
    private func configureProgressView(for products: [Product]) {
        if products.isEmpty {
            productsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            UIView.animate(withDuration: 0) { [weak self] in
                self?.productsStackView.layoutIfNeeded()
            }
        } else {
            productsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            let productsPerLine = 2
            let numberOfLines = Int(ceil(CGFloat(products.count) / CGFloat(productsPerLine)))
            var currentLine = -1
            
            let remainingProductSpaces = numberOfLines * productsPerLine - products.count
            
            for (index, product) in products.enumerated() {
                if index % productsPerLine == 0 {
                    let stackView = UIStackView()
                    stackView.axis = .horizontal
                    stackView.distribution = .fillEqually
                    stackView.alignment = .leading
                    stackView.spacing = 0
                    productsStackView.addArrangedSubview(stackView)
                    currentLine += 1
                }

                // TODO: Check for 0 division. Check for out of bounds subscripting
                let stackView = productsStackView.arrangedSubviews[currentLine] as? UIStackView
                let productsView = ProductsView(frame: .zero)
                productsView
                    .widthAnchor
                    .constraint(
                        equalToConstant: productsStackView.bounds.width / CGFloat(productsPerLine)
                    )
                    .isActive = true
                productsView.configure(with: product)
                stackView?.addArrangedSubview(productsView)
            }
            
            if let stackView = productsStackView.arrangedSubviews.last as? UIStackView {
                for _ in Array(0..<remainingProductSpaces) {
                    let emptyView = UIView()
                    emptyView
                        .widthAnchor
                        .constraint(
                            equalToConstant: productsStackView.bounds.width / CGFloat(productsPerLine)
                        )
                        .isActive = true
                    stackView.addArrangedSubview(emptyView)
                }
            }
            //stackViewHeightConstraint.constant      = CGFloat(numberOfLines * 3)
            productsStackView.snp.updateConstraints { (make) in
                make.height.equalTo(28 * CGFloat(numberOfLines * 2) * AutoSizeScaleX)
            }
            UIView.animate(withDuration: 0) { [weak self] in
                self?.productsStackView.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Custom Button Action
    @objc
    private func showMoreSection() {
        let controller = MoreViewController.instantiate()
        navigationController?.pushAndHideTabBar(controller)
    }
    
    func updateSelectedPiechart(categoryType: Int,selectedPage:Int) {
        updatePieChart(category: categoryType)
    }
    
    
}
// MARK: - UIPickerViewDataSource
extension HomeDashboardViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == datePickerMonthYear){
            return datePickerMonthYearItems.count
        }else{
            return datePickerYearItems.count
        }
    }
}

// MARK: - UIPickerViewDelegate
extension HomeDashboardViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == datePickerMonthYear){
            let date = datePickerMonthYearItems[row]
            
            let components = DateComponents(
                calendar: Calendar.current,
                year: date.year,
                month: date.month,
                day: 15,
                hour: 12,
                minute: 0,
                second: 0
            )
            
            if let text = components.date?.toFormat("MMM yyyy") {
                return text
            } else {
                return "\(date.month)" + " " + "\(date.year)"
            }
        }else{
            let year = datePickerYearItems[row]
            return "\(year)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == datePicker {
            guard row >= 0 && row < datePickerYearItems.count else {
                print("⚠️ Invalid year row index: \(row)")
                return
            }
            selectedYear = datePickerYearItems[row]
            datePickerYearButton.setTitle(" \(selectedYear) ", for: .normal)
            reloadData()
        } else if pickerView == datePickerMonthYear {
            guard row >= 0 && row < datePickerMonthYearItems.count else {
                print("⚠️ Invalid month-year row index: \(row)")
                return
            }
            let monthYear = datePickerMonthYearItems[row]
            currentMonthYear = monthYear
            datePickerMonthYearButton.setTitle(
                text(forSelectedMonthYear: (month: monthYear.month, year: monthYear.year)),
                for: .normal
            )
            reloadData()
        }
    }
    
    private func didSelectYear(_ year: Int) {
        self.isYearlySelected = true
        guard let joinedDate = self.monthlyYearlyOverview?.joined_date else {
               print("⚠️ joined_date missing; skipping year update.")
               return
           }
        self.selectedYear = year
        self.currentMonthYear.year = year
        self.currentMonthYear.month = 12

        self.datePickerYearButton.setTitle("\(year)", for: .normal)
        datePickerYearButton.sizeToFit()
        self.reloadData()
        datePickerMonthYearItems.removeAll()
        if(year == 2023){
            datePickerMonthYearItems.insert(
                contentsOf: Array(1...Date.currentMonth).map {
                    (month: $0, year: year)
                }.reversed(),
                at: 0
            )
            self.currentMonthYear.month = Date.currentMonth

        }
        let startMonth = self.monthlyYearlyOverview?.joined_date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: startMonth!) else {
            return
        }
        formatter.dateFormat = "MM"
        let month = Int(formatter.string(from: date))
        let startYear = client.firstDocumentUploadDate?.year ?? Date.currentYear
        if(year == startYear){
                datePickerMonthYearItems.insert(
                    contentsOf: Array(month!...12).map {
                        (month: $0, year: year)
                    }.reversed(),
                    at: 0
                )
        }else{
            if(year == 2022){
                datePickerMonthYearItems.insert(
                    contentsOf: Array(1...12).map {
                        (month: $0, year: year)
                    }.reversed(),
                    at: 0
                )
            }
        }
    }
    
    func didSelect(_ date: MonthYear) {
        ANActivityIndicatorPresenter.shared.showIndicator()
        self.isYearlySelected = false
        datePickerMonthYearButton.setTitle(text(forSelectedMonthYear: date), for: .normal)
        datePickerMonthYearButton.sizeToFit()
        self.currentMonthYear = date
        self.reloadData()

    }
    
    private func text(forSelectedMonthYear monthYear: MonthYear) -> String? {
        let components = DateComponents(
            calendar: Calendar.current,
            year: monthYear.year,
            month: monthYear.month,
            day: 15,
            hour: 12,
            minute: 0,
            second: 0
        )
        return components.date?.toFormat("MMM yyyy")
    }
}

                                                                                                                        
extension HomeDashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isYearlySelected == true){
            let getYearlyCategoryData = self.monthlyYearlyOverview?.yearly.productsOverviews.filter({$0.product.category_type == self.getCategory})
            return getYearlyCategoryData?.count ?? 0
        }else{
            let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[section].productsOverviews.filter({$0.product.category_type == self.getCategory})
            return getMonthlyCategoryData?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeProductListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeProductListCollectionViewCell
        if(isYearlySelected == true){
            let getYearlyCategoryData = self.monthlyYearlyOverview?.yearly.productsOverviews.filter({$0.product.category_type == self.getCategory})

            cell.bgView.backgroundColor = UIColor(hexString: getYearlyCategoryData?[indexPath.row].product.hexColor ?? "")
            cell.nameLab.text = getYearlyCategoryData?[indexPath.row].product.name ?? ""
            let accreditedAmount = (((getYearlyCategoryData?[indexPath.row].totalAmount)!)-((getYearlyCategoryData?[indexPath.row].remainingAmount)!))
            cell.totalAmountLab.text = "\(accreditedAmount.priceAsString())/ \(getYearlyCategoryData?[indexPath.row].totalAmount.priceAsString() ?? "")"
        }else{
            let getMonthlyCategoryData = self.monthlyYearlyOverview?.monthly[indexPath.row].productsOverviews.filter({$0.product.category_type == self.getCategory})
            cell.bgView.backgroundColor = UIColor(hexString: getMonthlyCategoryData?[indexPath.row].product.hexColor ?? "")
            cell.nameLab.text = getMonthlyCategoryData?[indexPath.row].product.name ?? ""
            let accreditedAmount = (((getMonthlyCategoryData?[indexPath.row].totalAmount)!)-((getMonthlyCategoryData?[indexPath.row].remainingAmount)!))
            cell.totalAmountLab.text = "\(accreditedAmount.priceAsString())/ \(getMonthlyCategoryData?[indexPath.row].totalAmount.priceAsString() ?? "")"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160 * AutoSizeScaleX, height: 52 * AutoSizeScaleX)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(isYearlySelected == true){
            let overviews = self.monthlyYearlyOverview?.yearly.productsOverviews
            guard (0..<overviews!.count).contains(indexPath.row) else { return }
            
            let productOverview = overviews![indexPath.row]
            let controller = ProductOverviewDetailsViewController.instantiate(
                with: productOverview,
                month: -1,
                year: currentMonthYear.year
            )
            navigationController?.pushAndHideTabBar(controller, animated: true)
        }else{
            let overviews = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
            guard (0..<overviews!.count).contains(indexPath.row) else { return }
            
            let productOverview = overviews![indexPath.row]

            if(productOverview.product.name == "Sachbezug"){
                
            }
            if(productOverview.product.name == "Danke-Bonus"){
            }else{
                let controller = ProductOverviewDetailsViewController.instantiate(
                    with: productOverview,
                    month:currentMonthYear.month,
                    year: currentMonthYear.year
                )
                navigationController?.pushAndHideTabBar(controller, animated: true)
            }
        }
    }
    
}

extension HomeDashboardViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
            guard let currentVC = viewController as? CategoryVC else {
                return nil
            }

        var index = currentVC.page.index
        updatePieChart(category: index)
        self.getCategory = index
        if(index == 0){
            self.categoryPageControl.currentPage = 0
            self.pieChartView?.isHidden = false
            self.ypieChartView?.isHidden = false
            self.sorryNoBenefitAvlLab.isHidden = true
            self.allBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.deviceBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        }else if(index == 1){
            self.categoryPageControl.currentPage = 1
            self.pieChartView?.isHidden = false
            self.ypieChartView?.isHidden = false
            self.sorryNoBenefitAvlLab.isHidden = true
            self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.deviceBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        }else if(index == 2){
            self.categoryPageControl.currentPage = 2
            self.pieChartView?.isHidden = false
            self.ypieChartView?.isHidden = false
            self.sorryNoBenefitAvlLab.isHidden = true
            self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.deviceBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        }else if(index == 3){
            self.categoryPageControl.currentPage = 3
            self.pieChartView?.isHidden = true
            self.ypieChartView?.isHidden = true
            self.sorryNoBenefitAvlLab.isHidden = true
            self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.deviceBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
        }
            if index == 0 {
                return nil
            }
            index -= 1
        let vc: CategoryVC = CategoryVC(with: pages[index],isYearSelected: self.isYearlySelected,getIndex: self.getIndex,getMonth:self.currentMonthYear.month,getYear: self.currentMonthYear.year,approvedInvoice: 0,monthlyYearlyOverview: self.monthlyYearlyOverview!)
        delegate?.updateCatergoryData(pagesIndex: 0, isYearSelected: self.isYearlySelected, getIndex: self.getIndex, approvedInvoice: self.noOfapprovedInvoice, monthlyYearlyOverview: self.monthlyYearlyOverview!)
            return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? CategoryVC else {
            return nil
        }
        
        var index = currentVC.page.index
        updatePieChart(category: index)
        if(index == 0){
            self.categoryPageControl.currentPage = 0
            self.pieChartView?.isHidden = false
            self.ypieChartView?.isHidden = false
            self.sorryNoBenefitAvlLab.isHidden = true
            self.allBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.deviceBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        }else if(index == 1){
            self.categoryPageControl.currentPage = 1

            self.pieChartView?.isHidden = false
            self.ypieChartView?.isHidden = false
            self.sorryNoBenefitAvlLab.isHidden = true
            self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.deviceBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        }else if(index == 2){
            self.categoryPageControl.currentPage = 2

            self.pieChartView?.isHidden = false
            self.ypieChartView?.isHidden = false
            self.sorryNoBenefitAvlLab.isHidden = true
            self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
            self.deviceBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
        }else if(index == 3){
            self.categoryPageControl.currentPage = 3

            self.pieChartView?.isHidden = true
            self.ypieChartView?.isHidden = true
            self.sorryNoBenefitAvlLab.isHidden = true
            self.allBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.cashBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.vouchersBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            self.deviceBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
        }
        self.getCategory = index
        if index >= self.pages.count - 1 {
            return nil
        }
        index += 1
        let vc: CategoryVC = CategoryVC(with: pages[index],isYearSelected: self.isYearlySelected,getIndex: self.getIndex,getMonth:self.currentMonthYear.month,getYear: self.currentMonthYear.year,approvedInvoice: 0,monthlyYearlyOverview: self.monthlyYearlyOverview!)
        return vc
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {


    }
}



extension HomeDashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView == self.scrollView){
        if scrollView.isEqual(self.scrollView) && (scrollView.isDragging || scrollView.isDecelerating) {
            let currentPage: Int = Int(round(scrollView.contentOffset.x / Screen_Width))
            if(currentPage == 1){

                self.isYearlySelected = true
                self.datePickerYearButton.isHidden = false
                self.datePickerMonthYearButton.isHidden = true
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                    self.monthlyBtn.snp.updateConstraints { (make) in
                        make.centerX.equalTo(self.view).offset(-100 * AutoSizeScaleX)
                    }
                }
                self.yearlyBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
                self.monthlyBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
            }else{
                self.isYearlySelected = false
                self.datePickerYearButton.isHidden = true
                self.datePickerMonthYearButton.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                    self.monthlyBtn.snp.updateConstraints { (make) in
                        make.centerX.equalTo(self.view)
                    }
                    self.yearlyBtn.setTitleColor(UIColor.App.TabBar.defaultState, for: .normal)
                    self.monthlyBtn.setTitleColor(UIColor.App.TabBar.selectedState, for: .normal)
                }
            }
        }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == self.scrollView){

        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
            if(page == 0){
                self.datePickerMonthYearButton.setTitle(
                    text(forSelectedMonthYear: (month: self.currentMonthYear.month, year: self.currentMonthYear.year)),
                    for: .normal
                )
                reloadData()
            }else{
                reloadData()
            }
        }else if(scrollView == self.transparentScrollView){
            let currentPage: Int = Int(round(self.transparentScrollView.contentOffset.x / self.transparentScrollView.frame.size.width))
            self.transparentPageControl.currentPage = currentPage
            if(currentPage == 6){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {                 self.tourGuideTransparentBGView.removeFromSuperview()
                }
            }
        }else if(scrollView == self.tipAllScrollView){
            let currentPage: Int = Int(round(self.tipAllScrollView.contentOffset.x / self.tipAllScrollView.frame.size.width))
            self.tipAllPageControl.currentPage = currentPage

            if(currentPage == 2){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.tipsAllTransparentBGView.removeFromSuperview()
                }
            }

        }else if(scrollView == self.tipCashScrollView){
            let currentPage: Int = Int(round(self.tipCashScrollView.contentOffset.x / self.tipCashScrollView.frame.size.width))
            self.tipsCashPageControl.currentPage = currentPage
            if(currentPage == 2){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.tipsCashTransparentBGView.removeFromSuperview()
                }
            }

        }
    }
    
    @objc func pageChanged(_ sender: UIPageControl) {
        var frame = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated:true)
    }
    
    @objc func pageCashTipChanged(_ sender: UIPageControl) {
        var frame = self.tipCashScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        self.tipCashScrollView.scrollRectToVisible(frame, animated:true)
    }
    
    @objc func pageAllTipChanged(_ sender: UIPageControl) {
        var frame = self.tipAllScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        self.tipAllScrollView.scrollRectToVisible(frame, animated:true)
    }
    
    @objc func pageTransparentTipChanged(_ sender: UIPageControl) {
        var frame = self.transparentScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        self.transparentScrollView.scrollRectToVisible(frame, animated:true)
    }
}
extension UIScrollView {

    func setCurrentPage(position: Int) {
        var frame = self.frame;
        frame.origin.x = frame.size.width * CGFloat(position)
        frame.origin.y = 0
        scrollRectToVisible(frame, animated: true)
    }

}

