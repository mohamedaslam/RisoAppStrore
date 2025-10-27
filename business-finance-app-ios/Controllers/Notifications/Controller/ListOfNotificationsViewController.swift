//
//  ListOfNotificationsViewController.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/10/8.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class ListOfNotificationsViewController: BaseViewController {
    private var notificationMessages: [NotificationModel] = []
    var tableView: UITableView!
    var dataSource : [NotificationModel] = []
    var nextOffset = 0
    var monthlyYearlyOverview: MonthlyYearlyOverview?
    var getIndex: Int = 0
    private lazy var loaderMoreView: UIView = {
        let loaderView = UIActivityIndicatorView(style: .whiteLarge)
        loaderView.color = UIColor.gray
        loaderView.startAnimating()
        return loaderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Benachrichtigungen"
        view.backgroundColor = UIColor.App.TableView.grayBackground

        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(tapBackBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        
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
            make.top.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.left.right.equalTo(self.view)
        }
        getNotificationMessagesList()
    }
    
    func getNotificationMessagesList(){
        client.getNotificationMessagesList { (notifications) in
            self.notificationMessages = notifications
//            self.addElements()
            self.tableView.reloadData()
        }
    }
    
    func addElements() {
        let newOffset = nextOffset+10
        for i in nextOffset..<newOffset {
            dataSource.append(self.notificationMessages[i])
        }
        nextOffset = newOffset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func tapBackBtnAction(sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeDashboardViewController.self) {
//            if controller.isKind(of: DashboardContainerViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: InvoicesContainerViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: BenifitsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}

extension ListOfNotificationsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationMessages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CellID"
        var cell: ListOfNotificationsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? ListOfNotificationsTableViewCell
        if cell == nil {
            cell = ListOfNotificationsTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        var getNotificationMessages : NotificationModel = self.notificationMessages[indexPath.row]
        cell?.benefitNotificationNameLab.text  = getNotificationMessages.title
        cell?.benefitNotificationSubTitleLab.text = getNotificationMessages.description
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
        let date = formatter.date(from: getNotificationMessages.created_at!)
            formatter.dateFormat = "HH:mm"
        let getHours = formatter.string(from: date!)
        formatter.dateFormat = "dd MMM"
        let getDate = formatter.string(from: date!)
        cell?.benefitNotificationTimeLab.text = getHours
        cell?.benefitNotificationDateLab.text = getDate

        cell?.benefitNotificationLetterLab.text = getNotificationMessages.title?.first?.description.capitalized ?? ""
        if(getNotificationMessages.is_read == 0){
            cell?.bgView.backgroundColor = UIColor(hexString: "#3868F6").alpha(0.2)
        }else{
            cell?.bgView.backgroundColor = UIColor.white
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var getNotificationMessages : NotificationModel = self.notificationMessages[indexPath.row]
       // print(getNotificationMessages.id)
        if(getNotificationMessages.product_code  == "kid_monthly_confirmation"){
            let controller = KindergartenMonthlyConfirmationVC()
            controller.isListOfNotificationPage = true
            self.navigationController?.pushAndHideTabBar(controller)
        }
        
        if(getNotificationMessages.product_code  == "travel_monthly_confirmation"){
            let controller = DailyCommuterMonthlyConfirmationVC()
            controller.isListOfNotificationPage = true
            self.navigationController?.pushAndHideTabBar(controller,animated: false)
        }
        if(getNotificationMessages.product_code  == "danke_bonus"){
            client.getVoucherProduct(vouchersProductID:getNotificationMessages.user_product_id) { (getVoucherProductData) in
                    let controller = DankeBonusViewController()
                    controller.userProductID = getVoucherProductData?.id ?? 0
                    controller.productID = getVoucherProductData?.product_id ?? 0
                    controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                    controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                    controller.value_spent = getVoucherProductData?.value_spent ?? ""
                    controller.budget = getVoucherProductData?.min_value ?? 0
                    controller.isYearSelected = true
                    controller.month = 0
                    controller.year = Date.currentYear
                    controller.still_possible = getVoucherProductData?.still_possible ?? 0
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }
        }
        if(getNotificationMessages.product_code  == "sachbezug"){
            client.getVoucherProduct(vouchersProductID:getNotificationMessages.user_product_id) { (getVoucherProductData) in
                    let controller = SachbezugViewController()
                    controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                    controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                    controller.value_spent = getVoucherProductData?.value_spent ?? ""
                    controller.budget = getVoucherProductData?.min_value ?? 0
                    controller.isYearSelected = true
                    controller.month = 0
                    controller.year = Date.currentYear
                    controller.still_possible = getVoucherProductData?.still_possible ?? 0
                    controller.userProductID = getVoucherProductData?.id ?? 0
                    controller.productID = getVoucherProductData?.product_id ?? 0
                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }
        }

        if(getNotificationMessages.product_code  == "travel"){
            if(getNotificationMessages.is_user_travel_set == 1){
                if let getProductID = ITNSUserDefaults.value(forKey: "UserTravel_product_id") as? String {
                    let controller = ViewDailyCommuterViewController()
                    controller.getUserProductID = Int(getProductID) ?? 0
                    self.navigationController?.pushAndHideTabBar(controller)
                }else{
                    let controller = ViewDailyCommuterViewController()
                    controller.getUserProductID = getNotificationMessages.id
                    self.navigationController?.pushAndHideTabBar(controller)
                }
            }else{
                if let getProductID = ITNSUserDefaults.value(forKey: "UserTravel_product_id") as? String {
                    let controller = DailyCommuterViewController()
                    controller.getUserProductID = Int(getProductID) ?? 0
                    self.navigationController?.pushAndHideTabBar(controller)
                }else{
                    let controller = DailyCommuterViewController()
                    controller.getUserProductID = getNotificationMessages.id
                    self.navigationController?.pushAndHideTabBar(controller)
                }
            }
        }
        
        if(getNotificationMessages.product_code  == "kinder"){
            if(getNotificationMessages.is_user_kinder_set == 1){
                let controller = KindergartenListViewController()
                navigationController?.pushAndHideTabBar(controller)
            }else{
                let controller = KindergartenSetupViewController()
                controller.getTitle = "Ersteinrichtung`  "
                self.navigationController?.pushAndHideTabBar(controller)
            }

        }
        if(getNotificationMessages.product_code  == "default" || getNotificationMessages.product_code == "self"){
            let controller = ListOfRemindersViewController()
            self.navigationController?.pushAndHideTabBar(controller)
        }
        
            let getSelectedMonth = String(format: "%02d", Date.currentMonth)
            let getIndex = self.monthlyYearlyOverview?.monthly.firstIndex(where: {$0.month.starts(with: getSelectedMonth)})
            self.getIndex = getIndex ?? 0
            let overviews = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
            var getInternetIndex = 0
            if(getNotificationMessages.product_code  == "internet"){
                (self.tabBarController as? AppTabBarController)?.startScanFlow(product:nil)
//                getInternetIndex = overviews!.firstIndex(where: {$0.product.name.starts(with: "Internet")}) ?? 0
//                let productOverview = overviews![getInternetIndex]
//                    let controller = ProductOverviewDetailsViewController.instantiate(
//                        with: productOverview,
//                        month:self.getIndex,
//                        year: Date.currentYear
//                    )
//                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }else if(getNotificationMessages.product_code  == "sachen"){
                (self.tabBarController as? AppTabBarController)?.startScanFlow(product:nil)

//                getInternetIndex = overviews!.firstIndex(where: {$0.product.name.starts(with: "Sachen")}) ?? 0
//                let productOverview = overviews![getInternetIndex]
//                    let controller = ProductOverviewDetailsViewController.instantiate(
//                        with: productOverview,
//                        month:self.getIndex,
//                        year: Date.currentYear
//                    )
//                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }else if(getNotificationMessages.product_code  == "geburtstag"){
                (self.tabBarController as? AppTabBarController)?.startScanFlow(product:nil)

//                getInternetIndex = overviews!.firstIndex(where: {$0.product.name.starts(with: "Geburtstag")}) ?? 0
//                let productOverview = overviews![getInternetIndex]
//                    let controller = ProductOverviewDetailsViewController.instantiate(
//                        with: productOverview,
//                        month:self.getIndex,
//                        year: Date.currentYear
//                    )
//                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }else if(getNotificationMessages.product_code  == "erholung"){
                (self.tabBarController as? AppTabBarController)?.startScanFlow(product:nil)

//                getInternetIndex = overviews!.firstIndex(where: {$0.product.name.starts(with: "Erholung")}) ?? 0
//                let productOverview = overviews![getInternetIndex]
//                    let controller = ProductOverviewDetailsViewController.instantiate(
//                        with: productOverview,
//                        month:self.getIndex,
//                        year: Date.currentYear
//                    )
//                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }else if(getNotificationMessages.product_code  == "food"){
                (self.tabBarController as? AppTabBarController)?.startScanFlow(product:nil)

//                getInternetIndex = overviews!.firstIndex(where: {$0.product.name.starts(with: "Food")}) ?? 0
//                let productOverview = overviews![getInternetIndex]
//                    let controller = ProductOverviewDetailsViewController.instantiate(
//                        with: productOverview,
//                        month:self.getIndex,
//                        year: Date.currentYear
//                    )
//                    self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }

        ApplicationDelegate.client.updateNotificationMsg(Id: getNotificationMessages.id) { [self] message in
            getNotificationMessagesList()
        }
    }
       
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentCount = self.dataSource.count
        if currentCount < self.notificationMessages.count && indexPath.row == (currentCount-1) { //last row
            self.addData()
            self.setUpLoaderView(toShow: true)
        } else {
            self.setUpLoaderView(toShow: false)
        }
    }
    func addData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.addElements()
            self.tableView.reloadData()
        }
    }

    func setUpLoaderView(toShow: Bool) {
        if toShow {
            self.tableView.tableFooterView?.isHidden = false
            self.tableView.tableFooterView = self.loaderMoreView
        } else {
            self.tableView.tableFooterView = UIView()
        }
    }
    

    
    func alterView(getMessage : String){
        let alert = UIAlertController(title: getMessage, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: ListOfRemindersViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
            }))

            self.present(alert, animated: true, completion: {
            })
    }

}
extension Date {

func timeAgo() -> String {

    let secondsAgo = Int(Date().timeIntervalSince(self))

    let minute = 60
    let hour = 60 * minute
    let day = 24 * hour
    let week = 7 * day
    let month = 4 * week

    let quotient: Int
    let unit: String
    if secondsAgo < minute {
        quotient = secondsAgo
        unit = "sec"
    } else if secondsAgo < hour {
        quotient = secondsAgo / minute
        unit = "min"
    } else if secondsAgo < day {
        quotient = secondsAgo / hour
        unit = "hrs"
    } else if secondsAgo < week {
        quotient = secondsAgo / day
        unit = "d"
    } else if secondsAgo < month {
        quotient = secondsAgo / week
        unit = "w"
    } else {
        quotient = secondsAgo / month
        unit = "m"
    }
    return "\(quotient) \(unit)\(quotient == 1 ? "" : "")"
}
}
