//
//  DashboardContainerViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import Parchment

// MARK: - Instantiation
extension DashboardContainerViewController {
    static func instantiate() -> DashboardContainerViewController {
        let storyboard = UIStoryboard(storyboard: .dashboard)
        let vc: DashboardContainerViewController = storyboard.instantiateViewController()
        return vc
    }
}

class DashboardContainerViewController: PagedContainerViewController {
    struct State {
        var monthlyOverviews: [MonthlyOverview]
        var products: [Product] {
            return Array(Set<Product>(monthlyOverviews
                .map { $0.productsOverviews }
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
        
        init(monthlyOverviews: [MonthlyOverview], selectedIndex: Int = 0) {
            self.monthlyOverviews = monthlyOverviews
            self._selectedIndex   = minmax(0, selectedIndex, max(monthlyOverviews.count - 1, 0))
        }
        
        func progress(for product: Product) -> CGFloat {
            let monthlyOverview = monthlyOverviews[selectedIndex]
            guard let overview = monthlyOverview
                .productsOverviews
                .filter({ $0.product == product })
                .first
                else {
                    return 0
            }
            
            let total      = overview.totalAmount
            guard total > 0 else { return 0 }
            let accredited = total - overview.remainingAmount
            let progress = accredited / overview.totalAmount
            return CGFloat(progress)
        }
        
        func secondProgress(for product: Product) -> CGFloat {
            let monthlyOverview = monthlyOverviews[selectedIndex]
            guard let overview = monthlyOverview
                .productsOverviews
                .filter({ $0.product == product })
                .first
                else {
                    return 0
            }
            
            let total      = overview.totalAmount
            guard total > 0 else { return 0 }
            let progress = overview.accreditedAmountMonth / overview.totalAmount
            return CGFloat(progress)
        }
        
        func selectedOverview() -> MonthlyOverview? {
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
    @IBOutlet weak var productsStackView: UIStackView!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    private var notificationMessages: [NotificationModel] = []
    // Data Source
    private var state: State = State(monthlyOverviews: [], selectedIndex: 0)
    private var selectedYear: Int = Date.currentYear
    private var selectedMonth: Int = Date.currentMonth
    var getProductID : Int = 0
    var getNotificationID : Int = 0
    var getMonthConfirmationStatus: CurrentMonthDocument?
    var checkInitialSetupDone: Bool = false
    var firstTimeShowPop: Bool = false
    let notificationBadgeBtn = BadgedButtonItem(with: UIImage(named: "Vector"))
    private var benefit: [Benefit] = []
    var getBadgeCountValue : Int = 0

    private var isMonthlyStutsComform: Bool = true
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
    
    private var isBackgroundViewCollapsed: Bool {
        guard let overview = state.selectedOverview() else { return false }
        return overview.isCurrentMonthOverview
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator                                       = UIActivityIndicatorView(style : .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color                                     = UIColor.App.Button.backgroundColor
        indicator.hidesWhenStopped                          = true
        return indicator
    }()
    
    var datePickerItems: [Int] = []
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Lifecycle

extension DashboardContainerViewController {
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
//                self.getUserTravelDetails()
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
//        NotificationCenter.default.addObserver(forName: .clickOnTravelNotificaion, object: nil, queue: .main) { notification in
//
//        }
        setupViews()
        reloadData()
        
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let getNotificationID = ITNSUserDefaults.value(forKey: "notification_id") as? String {
            let getNotificationIDValue = Int(getNotificationID ?? "")!

            ApplicationDelegate.client.updateNotificationMsg(Id:getNotificationIDValue) { [self] message in
            }
        }

//        NotificationCenter.default.addObserver(forName: .clickOnKinderNotificaion, object: nil, queue: .main) { notification in
//
////            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
////                let isKinderNotification = ITNSUserDefaults.object(forKey: "isKinderNotification") as? Bool
////                if (isKinderNotification == true) {
////                    self.getKindergartenDetails()
////                    ITNSUserDefaults.set(false, forKey: "isKinderNotification")
////                }
////            }
//        }
        


        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.client.getNotificationMessagesList { (notifications) in
                self.notificationMessages = notifications
                let readNotificationCount = self.notificationMessages.filter{ $0.is_read == 0 }
                self.notificationBadgeBtn.setBadge(with:readNotificationCount.count)
            }
        }
//        if let getBadgeCount = ITNSUserDefaults.value(forKey: "BadgeCountValue") as? Int {
//            DispatchQueue.main.async {
//                if getBadgeCount != 0 {
//                    self.notificationBadgeBtn.setBadge(with: getBadgeCount)
//                    UIApplication.shared.applicationIconBadgeNumber = getBadgeCount
//                }
//                else {
//                    self.notificationBadgeBtn.setBadge(with: 0)
//                    UIApplication.shared.applicationIconBadgeNumber = 0
//                }
//            }
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getMonthlyConfirmation()
        }
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
                        }
                    }
                }

            if(getMonthConfirmationStatus?.is_need_monthly_confirmation_for_kinder == 1){
                let controller = KindergartenMonthlyConfirmationVC()
                self.navigationController?.pushAndHideTabBar(controller)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.App.TableView.grayBackground
    
        backgroundView.alpha             = 0.0
        accreditedTextLabel.alpha        = 0.0
        productsStackView.alpha          = 0.0
        pagingViewController?.view.alpha = 0.0
        
        let startingYear = client.firstDocumentUploadDate?.year ?? Date.currentYear
        datePickerItems = Array(startingYear...Date.currentYear).reversed()
        datePicker.dataSource = self
        datePicker.delegate = self
        
        let moreBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-bar-button"), style: .plain, target: self, action: #selector(showMoreSection))
//        let moreBarButtonItem1 = UIBarButtonItem(image:UIImage(named: "Vector"), style: .plain, target: self, action: #selector(reminderBtn))
      //  let notificationBarButtonItem = UIBarButtonItem(image:UIImage(named: "Vector"), style: .plain, target: self, action: #selector(notificationBtn))
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
//            self.notificationBadgeBtn.setBadge(with:0)
//            ITNSUserDefaults.set(0, forKey: "BadgeCountValue")
//            ITNSUserDefaults.set(0, forKey: "UpdatedBadgeCountValue")
//            self.getBadgeCountValue = 0
            self.navigationController?.pushAndHideTabBar(controller)
        }
        navigationItem.leftBarButtonItems = [moreBarButtonItem,notificationBadgeBtn];
       // navigationItem.leftBarButtonItems = [moreBarButtonItem];
        let expandedHeight   = Int(view.bounds.height * 0.82 + 12)
        backgroundViewHeightConstraint.constant = CGFloat(expandedHeight)
        UIView.animate(withDuration: 0) { self.view.layoutIfNeeded() }
        
        view.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 24),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor)
        ])
        
        accreditedTextLabel.text = "ACCREDITED".localized

    }
    
    @objc
    private func reminderBtn() {
        let controller = ListOfRemindersViewController()
        navigationController?.pushAndHideTabBar(controller)
    }
    @objc
    private func notificationBtn() {
        let controller = ListOfNotificationsViewController()
        navigationController?.pushAndHideTabBar(controller)
    }
    
    private func reloadData() {
        let year = self.selectedYear
        
        let oldNumberOfOverviews = self.state.monthlyOverviews.count
        let oldSelectedIndex     = self.state.selectedIndex
        
        let operation = BlockOperation { [unowned self] in
            let group = DispatchGroup()
            
            if self.state.monthlyOverviews.isEmpty {
                self.activityIndicator.startAnimating()
            }
            group.enter()
            self.client.getMonthlyOverviews(month: nil, year: year) { [weak self] overviews in
                guard let `self` = self else {
                    group.leave()
                    return
                }
                
                var overviews = overviews
                let availableMonths = self.availableMonths
                overviews = overviews
                    .filter { availableMonths.contains($0.month) }
                    .sorted { $0.month < $1.month }
                
                var index = overviews.enumerated()
                    .filter { $0.element.month == self.selectedMonth }
                    .first?
                    .offset ?? max(0, overviews.count - 1)
                
                if oldNumberOfOverviews == overviews.count {
                    index = oldSelectedIndex
                }
                self.state = State(monthlyOverviews: overviews, selectedIndex: index)
                group.leave()
            }
            
            group.notify(queue: DispatchQueue.main, execute: { [weak self] in
                guard let `self` = self else { return }

                UIView.animate(withDuration: 0.3, animations: {
                    self.accreditedTextLabel.alpha        = 1.0
                    self.backgroundView.alpha             = 1.0
                    self.productsStackView.alpha          = 1.0
                    self.pagingViewController?.view.alpha = 1.0
                })
                
                self.activityIndicator.stopAnimating()
                self.pagingViewController?.delegate = self
                self.productsProgressView?.dataSource = self
                self.setupScreens(for: self.state.monthlyOverviews)
                self.configureProgressView(for: self.state.products)
                self.productsProgressView.reloadData(animated: true)
                
                // Also refresh data for pushed controllers
//                if let pushedControllers = self.navigationController?.viewControllers, pushedControllers.isNotEmpty {
//                    for controller in pushedControllers {
//                        if let productsOverviewController = controller as? ProductsOverviewContainerViewController {
//                            productsOverviewController.update(overviews: self.state.monthlyOverviews)
//                        }
//                    }
//                }
            })
        }
        
        operation.start()
    }
    
    private func configureProgressView(for products: [Product]) {
        if products.isEmpty {
            productsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            stackViewHeightConstraint.constant = 0
            //            stackViewTopConstraint.constant    = 0
            UIView.animate(withDuration: 0) { [weak self] in
                self?.productsStackView.layoutIfNeeded()
            }
        } else {
            productsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            let productsPerLine = 3
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
                let productsView = ProductDotView(frame: .zero)
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
            stackViewHeightConstraint.constant      = CGFloat(numberOfLines * 3)
            UIView.animate(withDuration: 0) { [weak self] in
                self?.productsStackView.layoutIfNeeded()
            }
        }
    }
    
    private func setupScreens(for overviews: [MonthlyOverview]) {
        guard overviews.isNotEmpty else { return }
        
        if overviews.count == viewControllers.count {
            for (index, controller) in viewControllers.enumerated() {
                guard let controller = controller as? DashboardViewController else { continue }
                let overview = overviews[index]
                controller.title = Date.monthName(for: overview.month)
                controller.update(overview: overview)
                controller.openStatistics = { [weak self] in
                    self?.showStatistics(forMonth: overview.month)
                }
                controller.openProduct = { [weak self] (product) in
                    self?.openProduct(product: product)
                }
            }
            
            if let overview = state.selectedOverview() {
                accreditedValueLabel.countFrom(
                    fromValue: 0,
                    to: Float(overview.totalAmount - overview.remainingAmount),
                    withDuration: 0.3,
                    andAnimationType: .easeInOut,
                    andCountingType: .Currency
                )
                
                if (!overview.hasData && overview.isCurrentMonthOverview) {
                    // collapse background
                    productsStackView.alpha = 0
                    let collapsedHeight  = Int(view.bounds.height * 0.64 + 24)
                    backgroundViewHeightConstraint.constant = CGFloat(collapsedHeight)
                    UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
                } else if !overview.isCurrentMonthOverview {
                    // expand background
                    productsStackView.alpha = 1
                    let expandedHeight   = Int(view.bounds.height * 0.82 + 12)
                    backgroundViewHeightConstraint.constant = CGFloat(expandedHeight)
                    UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
                } else {
                    // expand background
                    productsStackView.alpha = 1
                    let expandedHeight   = Int(view.bounds.height * 0.82 + 12)
                    backgroundViewHeightConstraint.constant = CGFloat(expandedHeight)
                    UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
                }
            }
        } else {
            viewControllers = overviews.map { overview in
                let controller = DashboardViewController.instantiate(with: overview)
                controller.title = Date.monthName(for: overview.month)
                controller.openStatistics = { [weak self] in
                    self?.showStatistics(forMonth: overview.month)
                }
                controller.openProduct = { [weak self] (product) in
                    self?.openProduct(product: product)
                }
                return controller
            }
            
            if let lastOverview = overviews.last {
                if (!lastOverview.hasData && lastOverview.isCurrentMonthOverview) {
                    // collapse background
                    productsStackView.alpha = 0
                    let collapsedHeight  = Int(view.bounds.height * 0.64 + 24)
                    backgroundViewHeightConstraint.constant = CGFloat(collapsedHeight)
                    UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
                } else if !lastOverview.isCurrentMonthOverview {
                    // expand background
                    productsStackView.alpha = 1
                    let expandedHeight   = Int(view.bounds.height * 0.82 + 12)
                    backgroundViewHeightConstraint.constant = CGFloat(expandedHeight)
                    UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
                } else {
                    // expand background
                    productsStackView.alpha = 1
                    let expandedHeight   = Int(view.bounds.height * 0.82 + 12)
                    backgroundViewHeightConstraint.constant = CGFloat(expandedHeight)
                    UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
                }
            }
        }
        
        let pagingItem = PagingIndexItem(
            index: state.selectedIndex,
            title: Date.monthName(for: state.monthlyOverviews[state.selectedIndex].month) ?? ""
        )
        
        pagingViewController?.reloadData()
        pagingViewController?.select(pagingItem: pagingItem, animated: false)
    }
    
    private func showStatistics(forMonth month: Int) {
//        let controller = ProductsOverviewContainerViewController.instantiate(
//            with: state.monthlyOverviews,
//            selectedIndex: state.selectedIndex,
//            selectedYear: selectedYear
//        )
//        navigationController?.pushAndHideTabBar(controller)
    }
    
    private func openProduct(product: ProductOverview) {
       let controller = ProductOverviewDetailsViewController.instantiate(
           with: product,
           month: selectedMonth,
           year: selectedYear
       )
        navigationController?.pushAndHideTabBar(controller)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
}

// MARK: - Actions
extension DashboardContainerViewController {    
    @objc
    private func showMoreSection() {
        let controller = MoreViewController.instantiate()
        navigationController?.pushAndHideTabBar(controller)
    }
    
    private func didSelectYear(_ year: Int) {
        guard year != selectedYear, year <= Date.currentYear else { return }
        self.selectedYear = year
        self.datePickerButton.setTitle("\(year)", for: .normal)
        datePickerButton.sizeToFit()
        self.reloadData()
    }
    
}

// MARK: - UIPickerViewDataSource
extension DashboardContainerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datePickerItems.count
    }
}

// MARK: - UIPickerViewDelegate
extension DashboardContainerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let year = datePickerItems[row]
        return "\(year)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = datePickerItems[row]
        didSelectYear(year)
    }
}

extension DashboardContainerViewController: ProductsProgressViewDataSource {
    func numberOfItemsInProductsProgressView(_ productsProgressView: ProductsProgressView) -> UInt {
        return UInt(state.products.count)
    }
    
    func productsProgressView(_ productsProgressView: ProductsProgressView, colorForItemAt index: Int) -> UIColor {
        return state.products[index].yearlyLimit ? UIColor(hexString: state.products[index].hexColor).alpha(0.3) : UIColor(hexString: state.products[index].hexColor)
    }
    
    func productsSecondProgressView(_ productsProgressView: ProductsProgressView, colorForItemAt index: Int) -> UIColor {
        return state.products[index].yearlyLimit ? UIColor(hexString: state.products[index].hexColor): UIColor.clear
    }
    
    func productsProgressView(_ productsProgressView: ProductsProgressView, valueForItemAt index: Int) -> CGFloat {
        let product = state.products[index]
        return state.progress(for: product)
    }
    
    func productsProgressView(_ productsProgressView: ProductsProgressView, secondValueForItemAt index: Int) -> CGFloat {
        let product = state.products[index]
        return  product.yearlyLimit ? state.secondProgress(for: product) : 0
    }
}

extension DashboardContainerViewController: PagingViewControllerDelegate {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>,
                                 isScrollingFromItem currentPagingItem: T,
                                 toItem upcomingPagingItem: T?,
                                 startingViewController: UIViewController,
                                 destinationViewController: UIViewController?,
                                 progress: CGFloat) where T : PagingItem, T : Comparable, T : Hashable {
        
        guard
            let startIndex = (currentPagingItem as? PagingIndexItem)?.index,
            let startOverview = state.monthlyOverviews.value(at: startIndex),
            let endIndex = (upcomingPagingItem as? PagingIndexItem)?.index,
            let endOverview = state.monthlyOverviews.value(at: endIndex) else {
                return
        }
        
        let newProgress      = progress >= 0 ? progress : (-1.0 * progress)
        let expandedHeight   = Int(view.bounds.height * 0.82 + 12)
        let collapsedHeight  = Int(view.bounds.height * 0.64 + 24)
        let remainingHeight  = CGFloat(abs(expandedHeight - collapsedHeight))
        let heightPercentage = CGFloat(remainingHeight) * newProgress
        
        if ((!endOverview.hasData && endOverview.isCurrentMonthOverview) && !startOverview.isCurrentMonthOverview) {
            // collapse background
            productsStackView.alpha = 1.0 - newProgress
            let nextConstant = Int(CGFloat(expandedHeight) - heightPercentage)
            backgroundViewHeightConstraint.constant = CGFloat(nextConstant)
            UIView.animate(withDuration: 0) { self.view.layoutIfNeeded() }
        } else if !endOverview.isCurrentMonthOverview && (!startOverview.hasData && startOverview.isCurrentMonthOverview) {
            // expand background
            let nextConstant = Int(CGFloat(collapsedHeight) + heightPercentage)
            productsStackView.alpha = newProgress
            backgroundViewHeightConstraint.constant = CGFloat(nextConstant)
            UIView.animate(withDuration: 0) { self.view.layoutIfNeeded() }
        } else {
            productsStackView.alpha = 1.0
            backgroundViewHeightConstraint.constant = CGFloat(expandedHeight)
            UIView.animate(withDuration: 0) { self.view.layoutIfNeeded() }
        }
    }
    
    func pagingViewController<T>(
        _ pagingViewController: PagingViewController<T>,
        didScrollToItem pagingItem: T,
        startingViewController: UIViewController?,
        destinationViewController: UIViewController,
        transitionSuccessful: Bool) {
        
        guard let pagingItem = pagingItem as? PagingIndexItem else { return }
        self.state.selectedIndex = pagingItem.index
        let overview = self.state.monthlyOverviews[pagingItem.index]
        let toValue = Float(overview.totalAmount - overview.remainingAmount)
        
        accreditedValueLabel.countFrom(
            fromValue: 0,
            to: toValue,
            withDuration: 0.3,
            andAnimationType: .easeInOut,
            andCountingType: .Currency
        )
        
        productsProgressView.reloadProgress(animated: true)
    }
}
