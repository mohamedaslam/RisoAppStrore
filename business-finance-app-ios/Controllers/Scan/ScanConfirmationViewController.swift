//
//  ScanConfirmationViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

extension ScanConfirmationViewController {
    static func instantiate(with store: ScanStore) -> ScanConfirmationViewController {
        let storyboard = UIStoryboard(storyboard: .scan)
        let vc: ScanConfirmationViewController = storyboard.instantiateViewController()
        vc.store = store
        return vc
    }
}

class ScanConfirmationViewController: BaseViewController {
    enum Section {
        case header
        case disclaimer(Disclaimer)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uploadButton: Button! {
        didSet {
            uploadButton?.setTitle("Upload".localized, for: .normal)
        }
    }
    
    private var store = ScanStore()
    private var sections = [Section]()
}

extension ScanConfirmationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [.header, .disclaimer(.regulations)]
        
        uploadButton.isDeactivated = !(store.checkedDisclaimers.isNotEmpty && store.checkedDisclaimers.reduce(true) {
            return $0 && Disclaimer.all.contains($1)
        })
        if let checkProduct = self.store.product{
            title  = store.product?.name
        }else{
            title = "Kindergarten"
        }
        view.backgroundColor               = UIColor.App.TableView.grayBackground
        tableView?.backgroundColor         = view.backgroundColor
        tableView?.dataSource              = self
        tableView?.delegate                = self
        tableView?.tableFooterView         = UIView()
        tableView?.tableHeaderView         = UIView()
        tableView?.rowHeight               = UITableView.automaticDimension
        tableView?.estimatedRowHeight      = 100
        tableView?.allowsMultipleSelection = true
        if #available(iOS 13.0, *){
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor.clear
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = navBarAppearance
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = navBarAppearance
        }
        let closeButton = UIBarButtonItem(
            image: #imageLiteral(resourceName: "back").template,
            style: .plain,
            target: self,
            action: #selector(close)
        )
        closeButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = closeButton
    }
    @objc
    private func close() {
        ApplicationDelegate.setupNavigationBarAppearance(with: .lightContent)
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        uploadButton.set(shadowType: .subtle)
    }
}

extension ScanConfirmationViewController {
    @IBAction func uploadButtonDidTouch(_ sender: UIButton) {
        sender.begin()

        if let checkProduct = self.store.product{
            client.saveScan(store: store) { [weak self] (success) in
                sender.end()
                guard let `self` = self else { return }
                guard success else { return }
                NotificationCenter.default.post(name: .willRequireContentUpdate, object: nil)
                let controller = SuccessfulScanViewController.instantiate()
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.setViewControllers([controller], animated: true)
            }
        }else{
            client.uploadKidReceipt(store: store) { [weak self] (success) in
                sender.end()
                guard let `self` = self else { return }
                guard success else { return }
                NotificationCenter.default.post(name: .willRequireContentUpdate, object: nil)
                let controller = SuccessfulScanViewController.instantiate()
                controller.isBenefitView = true
                self.navigationController?.pushAndHideTabBar(controller)
            }
        }

    }
}

extension ScanConfirmationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = sections[indexPath.row]
        switch sectionType {
        case .header:
            let cell = ScanStepHeaderTableViewCell.dequeue(in: tableView)
            cell.titleLabel.text = "scan.confirmInvoice.title".localized
            if let judgeKidViewStatus = self.store.judgeKidView{
                if(judgeKidViewStatus == 1){
                    cell.stepLabel.text = "2/2"
                }else{
                    cell.stepLabel.text  = "scan.confirmInvoice.step".localized
                }
            }
            return cell
        case .disclaimer(let disclaimer):
            let cell = CheckboxSelectionTableViewCell.dequeue(in: tableView)
            cell.contentLabel.attributedText = disclaimer.attributedText
            cell.checkboxDidTouch = { [weak self] isChecked in
                guard let `self` = self else { return }

                if isChecked {
                    if !self.store.checkedDisclaimers.contains(disclaimer) {
                        self.store.checkedDisclaimers.append(disclaimer)
                    }
                    self.uploadButton.isDeactivated = !(self.store.checkedDisclaimers.isNotEmpty && self.store.checkedDisclaimers.reduce(true) {
                        return $0 && Disclaimer.all.contains($1)
                        })
                } else {
                    if let indexOf = self.store.checkedDisclaimers.firstIndex(of: disclaimer) {
                        self.store.checkedDisclaimers.remove(at: indexOf)
                    }
                    self.uploadButton.isDeactivated = !(self.store.checkedDisclaimers.isNotEmpty && self.store.checkedDisclaimers.reduce(true) {
                        return $0 && Disclaimer.all.contains($1)
                    })
                }
            }
            return cell
        }
    }
}

extension ScanConfirmationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = sections[indexPath.row]
        switch sectionType {
        case .header:
            break
        case .disclaimer:
//            client.getAllProducts { (products) in
//
//            }
            if let product = store.product{
                let controller = DisclaimerDetailsViewController(product: product)
                navigationController?.pushViewController(controller, animated: true)
            }else{
                let controller = DisclaimerDetailsViewController(store: store)
                navigationController?.pushViewController(controller, animated: true)
            }

//            guard let product = store.product else { return }

        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}

class CheckboxSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var checkboxButton: UIButton! {
        didSet {
            checkboxButton?.tintColor = UIColor.App.Button.backgroundColor
        }
    }
    
    @IBOutlet weak var contentLabel: UILabel!
    var checkboxDidTouch: ((Bool) -> Void)?
    var isChecked: Bool = false {
        didSet {
            checkboxButton.setImage(isChecked ? #imageLiteral(resourceName: "checkbox-button-selected") : #imageLiteral(resourceName: "checkbox-button-deselected"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = superview?.backgroundColor ?? .clear
        checkboxButton.setImage(isChecked ? #imageLiteral(resourceName: "checkbox-button-selected") : #imageLiteral(resourceName: "checkbox-button-deselected"), for: .normal)
    }
    
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        let block = { [weak self] in
//            guard let `self` = self else { return }
//            self.checkboxButton.setImage(selected ? #imageLiteral(resourceName: "checkbox-button-selected") : #imageLiteral(resourceName: "checkbox-button-deselected"), for: .normal)
//        }
//
//        UIView.animate(withDuration: animated ? 0.3 : 0)  {
//            block()
//        }
//    }
    
    @IBAction func checkboxButtonDidTouch(_ sender: Any) {
        isChecked = !isChecked
        checkboxDidTouch?(isChecked)
    }
}
