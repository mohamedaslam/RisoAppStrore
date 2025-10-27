//
//  AppTabBarController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
//import ImagePicker
//import Lightbox

enum Tab {
    case dashboard
   // case invoices
    case benefits
    case add
    var title: String? {
        switch self {
        case .dashboard: return "tab.dashboard".localized
       // case .invoices:  return "tab.invoices".localized
        case .benefits: return "tab.benefits".localized
        case .add:       return nil
        }
    }
    
    var navigationTitle: String? {
        switch self {
        case .dashboard: return "navigation.title.dashboard".localized
       // case .invoices:  return "navigation.title.invoices".localized
        case .benefits:  return "navigation.title.benefits".localized
        case .add:       return nil

        }
    }
    var icon: UIImage? {
        switch self {
        case .dashboard: return #imageLiteral(resourceName: "tab-icon-dashboard")
        //case .invoices:  return #imageLiteral(resourceName: "tab-icon-invoices")
        case .benefits:  return #imageLiteral(resourceName: "Benifits.png")
        case .add:       return nil

        }
    }
    
    var canSelect: Bool {
        switch self {
        case .dashboard: return true
       // case .invoices:  return true
        case .benefits:  return true
        case .add:       return false
        }
    }
}

class AppTabBarController: BaseTabBarController {
    let addButton: UIButton = {
        let button                = UIButton(type : .system)
        button.frame              = CGRect(x: 0, y: 0, width: 60, height: 60)
        button.tintColor          = UIColor.App.Button.tintColor
        button.backgroundColor    = UIColor.App.Button.backgroundColor
        button.layer.cornerRadius = button.bounds.height / 2.0
        button.setImage(#imageLiteral(resourceName: "add-big-icon"), for: UIControl.State())
        return button
    }()
    
    private let apptabs: [Tab] = [.dashboard,.benefits, .add]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers(for: apptabs)
        
        delegate = self
        tabBar.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        addButton.reversesTitleShadowWhenHighlighted = true
        
        NotificationCenter
            .default
            .addObserver(
                forName: .didUpdateUnreadNotifications,
                object: nil, queue: nil
            ) { [weak self] (notification) in
                guard let `self` = self else { return }
                
                let invoiceStatusChangeCount = self.client.unreadNotificationsCount(
                    for: .invoiceGroupStatusChange, .invoiceStatusChange
                )
                
                let reminderCount = self.client.unreadNotificationsCount(for: .expenseTrackingReminder)
                
                DispatchQueue.main.async {
                    let selectedTab = self.apptabs[self.selectedIndex]
                    switch selectedTab {
                    case .dashboard:
//                        self.setBadgeCount(invoiceStatusChangeCount, for: .invoices)
                        self.setBadgeCount(0, for: .dashboard)
//                        self.client.readNotifications(for: .expenseTrackingReminder) {
//
//                        }

//                    case .invoices:
//                        self.setBadgeCount(0, for: .invoices)
//                        self.setBadgeCount(reminderCount, for: .dashboard)
//                        self.client.readNotifications(for: .invoiceGroupStatusChange, .invoiceStatusChange) {
//
//                        }
                    case .benefits:
                        self.setBadgeCount(0, for: .benefits)
                        
                    default:
                        break
                    }
                }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.bringSubviewToFront(addButton)
        addButton.frame.origin.x = Screen_Width - 70 * AutoSizeScaleX
        addButton.frame.origin.y = -17
        addButton.set(shadowType: .subtle)
    }
    
    private func setupControllers(for apptabs: [Tab]) {
        let controllers: [UIViewController] = apptabs.map {
            var root: UIViewController = ViewController()
            
            switch $0 {
            case .dashboard:
                let controller = HomeDashboardViewController()
//                let controller       = DashboardContainerViewController.instantiate()
                controller.title     = $0.navigationTitle
                controller.firstTimeShowPop = true

                root                 = BaseNavigationController(rootViewController: controller)
                //                _ = root.view
                //                _ = controller.view
                break
//            case .invoices:
//                let controller       = InvoicesContainerViewController()
//                controller.title     = $0.navigationTitle
//                root                 = BaseNavigationController(rootViewController: controller)
//                break
            case .benefits:
                let controller       = BenifitsViewController()
                controller.title     = $0.navigationTitle
                root                 = BaseNavigationController(rootViewController: controller)
                break
            case .add:
                root = ViewController()
                break
            }
            
            root.title            = $0.title
            root.tabBarItem.image = $0.icon
            root.view.backgroundColor = .App.primary

            return root
        }
        
        tabBar.barTintColor            = UIColor.App.TabBar.barTintColor
        tabBar.tintColor               = UIColor.App.TabBar.selectedState
        tabBar.unselectedItemTintColor = UIColor.App.TabBar.defaultState
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .App.primary
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        setViewControllers(controllers, animated: false)
    }
    func jumpToBenifitsView(){
        let controller = BenifitsViewController()
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
    @objc
    func addButtonPressed(_ sender: UIButton) {
        startScanFlow(product: nil)
    }
    
    private func setBadgeCount(_ count: Int, for tab: Tab) {
        guard tab.canSelect else { return }
        guard
            let tabIndex = apptabs.firstIndex(of: tab),
            let tabItem = tabBar.items?.value(at: tabIndex) else {
                return
        }
        
        tabItem.badgeValue = count > 0 ? "\(count)" : nil
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
                    if(product.name == "Kindergarten Allowance"){
                        let controller = ListOfKidsViewController()
                        controller.store = store
                        nav.pushViewController(controller, animated: true)
                    }else{
                        let controller = ScanConfirmationViewController.instantiate(with: store)
                        nav.pushViewController(controller, animated: true)
                    }
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
        
//        let imagePicker = ImagePickerViewController.instantiate()
//        let nav = BaseNavigationController(rootViewController: imagePicker)
//        nav.setNavigationBarHidden(true, animated: true)
//        ApplicationDelegate.setupNavigationBarAppearance(with: .default)
//        self.present(nav, animated: true, completion: nil)
//        
//        
//        return
//        var config = cameraConfiguration
//        config.allowMultiplePhotoSelection = false
//
//        let imagePicker = ImagePickerController(configuration: config)
//        imagePicker.delegate = self
//
//        let nav = BaseNavigationController(rootViewController: imagePicker)
//        nav.setNavigationBarHidden(true, animated: true)
//        ApplicationDelegate.setupNavigationBarAppearance(with: .default)
//        self.present(nav, animated: true, completion: nil)
    }
    
    func select(tab: Tab, goToRoot: Bool) {
        guard tab.canSelect else { return }
        guard
            let viewControllers = self.viewControllers,
            let tabIndex = apptabs.firstIndex(of: tab),
            (0..<viewControllers.count).contains(tabIndex) else {
                return
        }
        
        selectedIndex = tabIndex
        
        if let nav = viewControllers[tabIndex] as? BaseNavigationController {
            let _ = nav.popToRootViewController(animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//extension AppTabBarController: ImagePickerDelegate {
//    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
//        ApplicationDelegate.setupNavigationBarAppearance(with: .lightContent)
//
//        if let nav = imagePicker.navigationController {
//            nav.dismiss(animated: true, completion: nil)
//            return
//        }
//
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//
//    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        guard images.count > 0 else { return }
//
//        let lightboxImages = images.map {
//            return LightboxImage(image: $0)
//        }
//
//        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
//        imagePicker.present(lightbox, animated: true, completion: nil)
//    }
//
//    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        guard let image = images.first else { return }
//
//        guard
//            let nav = self.presentedViewController as? BaseNavigationController,
//            let _ = nav.viewControllers.first as? ImagePickerController else {
//                imagePicker.dismiss(animated: true, completion: nil)
//                return
//        }
//
//        let store: ScanStore = ScanStore(
//            image: image,
//            extraImages: [],
//            product: nil,
//            disabledProducts: client.currentMonthOverview?.disabledProducts ?? [],
//            checkedDisclaimers: []
//        )
//        let controller = ProductTypeSelectionViewController.instantiate(store: store)
//        nav.setNavigationBarHidden(false, animated: true)
//        nav.pushViewController(controller, animated: true)
//    }
//}

extension AppTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let controllers = tabBarController.viewControllers else { return false }
        guard
            let selectedViewController = tabBarController.selectedViewController,
            let fromView = selectedViewController.view,
            let toView   = viewController.view else {
                return false
        }
        
        guard
            let toIndex   = controllers.firstIndex(of: viewController) else {
                return false
        }
        
        
        let tab = apptabs[toIndex]
        guard tab.canSelect else { return false }
        
        if fromView == toView { return false }
        
        switch tab {
        case .dashboard:
            self.setBadgeCount(0, for: tab)
//            client.readNotifications(for: .expenseTrackingReminder) {
//                NotificationCenter.default.post(name: .shouldUpdateUnreadNotifications, object: nil, userInfo: nil)
//            }
            break
//        case .invoices:
//            self.setBadgeCount(0, for: tab)
////            client.readNotifications(for: .invoiceGroupStatusChange, .invoiceStatusChange) {
////                NotificationCenter.default.post(name: .shouldUpdateUnreadNotifications, object: nil, userInfo: nil)
////            }
//            break
        case .benefits:
            self.setBadgeCount(0, for: tab)
        default:
            break
        }

        UIView.transition(
            from: fromView,
            to: toView,
            duration: 0.1, options: UIView.AnimationOptions.transitionCrossDissolve) { (success) in
                if success {
                    tabBarController.selectedIndex = toIndex
                }
        }
        return true
    }
}


