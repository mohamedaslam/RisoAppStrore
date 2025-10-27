//
//  BenifitsViewController.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/8/9.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import ANActivityIndicator

class BenifitsViewController: BaseViewController {
    private var tableView: UITableView!
    private var benefit: [Benefit] = []
    private var getProduct_id : Int = 15
    private let notificationBadgeBtn = BadgedButtonItem(with: UIImage(named: "Vector"))
    private var getBadgeCountValue : Int = 0
    private var getUserTravel: UserTravel?
    private var userProduct: [User_product] = []
    private var notificationMessages: [NotificationModel] = []
    private var monthlyYearlyOverview: MonthlyYearlyOverview?
    private var getIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "Benefits"
        let moreBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "menu-bar-button"),
            style: .plain,
            target: self,
            action: #selector(showMoreSection)
        )
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
            self.navigationController?.pushAndHideTabBar(controller)
        }
        
        navigationItem.leftBarButtonItems = [moreBarButtonItem,notificationBadgeBtn];

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
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.client.getMonthlyYearlyOverviews(month: nil, year: Date.currentYear) { (monthlyYearlyOverviewData) in
            self.monthlyYearlyOverview = monthlyYearlyOverviewData

        }
        
        if let getNotificationID = ITNSUserDefaults.value(forKey: "notification_id") as? String {
            let getNotificationIDValue = Int(getNotificationID ?? "")!

            ApplicationDelegate.client.updateNotificationMsg(Id:getNotificationIDValue) { [self] message in
            }
        }
        DispatchQueue.main.async {
            self.client.getNotificationMessagesList { (notifications) in
                self.notificationMessages = notifications
                let readNotificationCount = self.notificationMessages.filter{ $0.is_read == 0 }
                self.notificationBadgeBtn.setBadge(with:readNotificationCount.count)
            }
        }

        getBenefitsList()
        client.getUserTravelData { (userTravel) in
            self.getUserTravel = userTravel
        }
    }
    
    func getBenefitsList(){
        
        client.getBenefitList { (benefit) in
            //self.benefit = benefit
            self.benefit = benefit
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Custom Button Action
    @objc
    private func showMoreSection() {
        let controller = MoreViewController.instantiate()
        navigationController?.pushAndHideTabBar(controller)
    }
    
    @objc
    private func reminderBtn() {
        let controller = ListOfRemindersViewController()
        navigationController?.pushAndHideTabBar(controller)
    }
    
    @objc func backBtnAction(sender: UIButton) {
        self.view.endEditing(false)
        self.navigationController?.popViewController(animated: true)

    }
    @objc func saveBtnAction(sender: UIButton) {
        
    }
    
    
}
extension BenifitsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.benefit.count
        //return self.benifitsListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CellID"
        var cell: BenifitsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? BenifitsTableViewCell
        if cell == nil {
            cell = BenifitsTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        let getBenefit : Benefit = self.benefit[indexPath.row]
        cell?.benifitsTitleLab.text = getBenefit.name
        cell?.iconContainerView.backgroundColor = UIColor.init(hexString: getBenefit.colour ?? "")
        cell?.iconImageView.kf.setImage(with: getBenefit.imageURL)
        DispatchQueue.main.async {
            ANActivityIndicatorPresenter.shared.showIndicator()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ANActivityIndicatorPresenter.shared.hideIndicator()

        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let getBenefit : Benefit = self.benefit[indexPath.row]
        if let checkIsTravelrSet = getBenefit.is_user_travel_set {
            if(getBenefit.is_user_travel_set == 1){
                let controller = ViewDailyCommuterViewController()
                controller.getUserProductID = getBenefit.getUserProduct.product_id
                navigationController?.pushAndHideTabBar(controller)
            }else{
                let controller = DailyCommuterViewController()
                print(getBenefit.getUserProduct.product_id)
                controller.getUserProductID = getBenefit.getUserProduct.product_id
                controller.getUserTravel = getUserTravel
                navigationController?.pushAndHideTabBar(controller)
            }
        }
        if let checkIsKinderSet = getBenefit.is_user_kinder_set {
            if(getBenefit.is_user_kinder_set == 1){
                let controller = KindergartenListViewController()
                controller.getUserProductID = getBenefit.getUserProduct.id
                navigationController?.pushAndHideTabBar(controller)
            }else{
                let controller = KindergartenSetupViewController()
                controller.getTitle = "Ersteinrichtung"
                navigationController?.pushAndHideTabBar(controller)
            }
        }
        if(getBenefit.product_code  == "internet" || getBenefit.product_code  == "sachen" || getBenefit.product_code  == "geburtstag" || getBenefit.product_code  == "erholung" || getBenefit.product_code  == "food" || getBenefit.product_code == ""){

            let getSelectedMonth = String(format: "%02d", Date.currentMonth)
            let getIndex = self.monthlyYearlyOverview?.monthly.firstIndex(where: {$0.month.starts(with: getSelectedMonth)})
                self.getIndex = getIndex ?? 0
            let overviews = self.monthlyYearlyOverview?.monthly[self.getIndex].productsOverviews
            guard let overviews = overviews else {
                return
            }
            let getInternetIndex = overviews.firstIndex(where: {$0.product.name.starts(with: getBenefit.name)})
            let productOverview = overviews[getInternetIndex ?? 0]
                (self.tabBarController as? AppTabBarController)?.startScanFlow(product: productOverview.product)

        }
        client.getVoucherProduct(vouchersProductID:getBenefit.getUserProduct.id) { (getVoucherProductData) in
            if(getBenefit.product_code  == "danke_bonus"){
                let controller = DankeBonusViewController()
                controller.userProductID = getBenefit.getUserProduct.id
                controller.productID = getBenefit.getUserProduct.product_id
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
            
            if(getBenefit.product_code  == "sachbezug"){
                let controller = SachbezugViewController()
                controller.minPriceValue = getVoucherProductData?.min_value ?? 0
                controller.maxPriceValue = getVoucherProductData?.max_value ?? 0
                controller.value_spent = getVoucherProductData?.value_spent ?? ""
                controller.budget = getVoucherProductData?.min_value ?? 0
                controller.isYearSelected = true
                controller.month = 0
                controller.year = Date.currentYear
                controller.still_possible = getVoucherProductData?.still_possible ?? 0
                controller.userProductID = getBenefit.getUserProduct.id
                controller.productID = getBenefit.getUserProduct.product_id
                self.navigationController?.pushAndHideTabBar(controller, animated: true)
            }
        }


    }
    
    func startScanFlow(product: Product?) {
        var store: ScanStore = ScanStore(
            image: nil,
            extraImages: [],
            product: product,
            disabledProducts: client.currentMonthOverview?.disabledProducts ?? [],
            checkedDisclaimers: []
        )
        let controller = ReceiptImagePickerViewController.instantiate(store: store, canDismiss: true)
        let nav = BaseNavigationController(rootViewController: controller)
        controller.didSelectImage = { image in
            store.setImage(image)
            if let product = store.product {
                if product.isMultiPage {
                    // Show multi page picker
                    let controller = MultiPictureScanViewController.instantiate(with: store)
                    nav.pushViewController(controller, animated: true)
                } else {
                    let controller = ScanConfirmationViewController.instantiate(with: store)
                    nav.pushViewController(controller, animated: true)
                    // Show disclaimer
                }
            } else {
                let controller = ProductTypeSelectionViewController.instantiate(store: store)
                nav.pushViewController(controller, animated: true)
            }
        }
        
        ApplicationDelegate.setupNavigationBarAppearance(with: .default)
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.present(nav, animated: true, completion: nil)
        }

    }
}




