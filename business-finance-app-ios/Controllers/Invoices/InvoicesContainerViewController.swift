//
//  InvoicesContainerViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import Parchment

typealias MonthYear = (month: Int, year: Int)

// Minimum date that one can pick
// NOTE: Will be changed to the month and year related to the
// app release date

class InvoicesContainerViewController: PagedContainerViewController {
    private var datePickerItems: [MonthYear] = []
    private var products: [Product] = []
    private var selectedIndex = 0
    var getBadgeCountValue : Int = 0
    private var currentMonthYear: MonthYear = (month: Date.currentMonth, year: Date.currentYear)
    let notificationBadgeBtn = BadgedButtonItem(with: UIImage(named: "Vector"))
    private var notificationMessages: [NotificationModel] = []

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Lifecycle

extension InvoicesContainerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .willRequireContentUpdate, object: nil, queue: .main) { (notification) in
            self.updateScreens(for: self.products)
        }
        
        let startYear = client.firstDocumentUploadDate?.year ?? Date.currentYear
        let endYear   = Date.currentYear
        let startMonth = client.firstDocumentUploadDate?.month ?? Date.currentMonth
        
        datePickerButton.setTitle(
            text(forSelectedMonthYear: (month: Date.currentMonth, year: Date.currentYear)),
            for: .normal
        )
        datePickerButton.sizeToFit()
        datePickerItems = []
        
        for year in Array(startYear...endYear) {
            if year == startYear {
                if year == Date.currentYear {
                    // Show only available months
                    datePickerItems.insert(
                        contentsOf: Array(startMonth...Date.currentMonth).map {
                            (month: $0, year: year)
                            }.reversed(),
                        at: 0
                    )
                } else {
                    // Show only available months
                    datePickerItems.insert(
                        contentsOf: Array(startMonth...12).map {
                            (month: $0, year: year)
                            }.reversed(),
                        at: 0
                    )
                }
            } else {
                // Show only available months
                datePickerItems.insert(
                    contentsOf: Array(1...12).map {
                        (month: $0, year: year)
                        }.reversed(),
                    at: 0
                )
            }
        }
        
        datePicker.dataSource = self
        datePicker.delegate = self
        
        self.pagingViewController?.dataSource = self
        self.pagingViewController?.delegate   = self
        
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
//            self.notificationBadgeBtn.setBadge(with:0)
//            UserDefaults.standard.set(0, forKey: "BadgeCountValue")
//            UserDefaults.standard.set(0, forKey: "UpdatedBadgeCountValue")
//            self.getBadgeCountValue = 0
            self.navigationController?.pushAndHideTabBar(controller)
        }

        notificationBadgeBtn.tapAction = {
            let controller = ListOfNotificationsViewController()
            self.notificationBadgeBtn.setBadge(with:0)
            self.navigationController?.pushAndHideTabBar(controller)
        }
        navigationItem.leftBarButtonItems = [moreBarButtonItem,notificationBadgeBtn];

        client.getAllProducts { (products) in
            self.products = products
            print(products)
            self.setupScreens(for: products)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
    }

    
    @objc
    private func reminderBtn() {
        let controller = ListOfRemindersViewController()
        navigationController?.pushAndHideTabBar(controller)
    }
    private func setupScreens(for products: [Product]) {
        viewControllers = products.map({
            let controller = InvoicesViewController.instantiate(
                with: $0,
                month: currentMonthYear.month,
                year: currentMonthYear.year
            )
            controller.title = $0.name
            let _ = controller.view
            return controller
        })
        pagingViewController?.reloadData()
    }
    
    private func updateScreens(for products: [Product]) {
        viewControllers.forEach {
            guard let controller = $0 as? InvoicesViewController else { return }
            if let product = controller.product, products.contains(product) {
                controller.update(for: self.currentMonthYear)
            }
        }
    }
    
    @objc
    private func showMoreSection() {
        let controller = MoreViewController.instantiate()
        navigationController?.pushAndHideTabBar(controller)
    }
    
    private func reloadScreens(for date: MonthYear) {
        
    }
}

extension InvoicesContainerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datePickerItems.count
    }
}

extension InvoicesContainerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let date = datePickerItems[row]
        
        let components = DateComponents(
            calendar: Calendar.current,
            year: date.year,
            month: date.month,
            day: 15,
            hour: 12,
            minute: 0,
            second: 0
        )
        
        if let text = components.date?.toFormat("MMMM yyyy") {
            return text
        } else {
            return "\(date.month)" + " " + "\(date.year)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let date = datePickerItems[row]
        didSelect(date)
    }
    
    func didSelect(_ date: MonthYear) {
        datePickerButton.setTitle(text(forSelectedMonthYear: date), for: .normal)
        datePickerButton.sizeToFit()
        self.currentMonthYear = date
        updateScreens(for: products)
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
        
        return components.date?.toFormat("MMMM yyyy")
    }
}

extension InvoicesContainerViewController: PagingViewControllerDelegate {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>,
                                 isScrollingFromItem currentPagingItem: T,
                                 toItem upcomingPagingItem: T?,
                                 startingViewController: UIViewController,
                                 destinationViewController: UIViewController?,
                                 progress: CGFloat) where T : PagingItem, T : Comparable, T : Hashable {
        let newProgress = progress >= 0 ? progress : -1.0 * progress
        startingViewController.view.alpha = 1.0 - newProgress
        destinationViewController?.view.alpha = newProgress
    }
    
    func pagingViewController<T>(
        _ pagingViewController: PagingViewController<T>,
        didScrollToItem pagingItem: T,
        startingViewController: UIViewController?,
        destinationViewController: UIViewController,
        transitionSuccessful: Bool) {
        
        guard let pagingItem = pagingItem as? PagingIndexItem else { return }
        destinationViewController.view.alpha = 1.0
        self.selectedIndex = pagingItem.index
    }
}
