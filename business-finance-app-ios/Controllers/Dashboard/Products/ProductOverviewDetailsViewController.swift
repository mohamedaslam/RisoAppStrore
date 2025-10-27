//
//  ProductOverviewDetailsViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

extension ProductOverviewDetailsViewController {
    static func instantiate(with productOverview: ProductOverview, month: Int, year: Int) -> ProductOverviewDetailsViewController {
        let storyboard = UIStoryboard(storyboard: .dashboard)
        let vc: ProductOverviewDetailsViewController = storyboard.instantiateViewController()
        vc.productOverview = productOverview
        vc.month           = month
        vc.year            = year
        return vc
    }
}

class ProductOverviewDetailsViewController: BaseViewController {
    enum Section: Equatable {
        case statisticsHeader
        case pendingInvoices(Int)
        case invoices([Document])
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStatusContainer: UIView!
    @IBOutlet weak var sadReceiptImageView: UIImageView!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var emptyStatusLabel: UILabel! {
        didSet {
            guard let label = emptyStatusLabel else { return }
            label.textColor = UIColor.App.Text.light
            label.textAlignment = .center
            label.font = UIFont.appFont(ofSize: 15, weight: .regular)
        }
    }
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            guard let button = addButton else { return }
            button.setTitle(nil, for: .normal)
            button.tintColor          = UIColor.App.Button.tintColor
            button.backgroundColor    = UIColor.App.Button.backgroundColor
            button.layer.cornerRadius = 30
            button.setImage(#imageLiteral(resourceName: "add-big-icon"), for: UIControl.State())
        }
    }
    
    private var documents: [Document] = []
    private var pendingInvoicesCount: Int = 0
    
    private var sections: [Section] = []
    private(set) var productOverview: ProductOverview?
    private var month: Int = Date.currentMonth
    private var year: Int = Date.currentYear
    private var refreshControl = UIRefreshControl()

}

func ==(lhs: ProductOverviewDetailsViewController.Section, rhs: ProductOverviewDetailsViewController.Section) -> Bool {
    switch (lhs, rhs) {
    case (.statisticsHeader, .statisticsHeader):
        return true
    case (.pendingInvoices(_), .pendingInvoices(_)):
        return true
    case (.invoices(_), .invoices(_)):
        return true
    default:
        return false
    }
}

extension ProductOverviewDetailsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [.statisticsHeader]
        setupViews()
        reloadData()
    }
    
    private func setupViews() {
        title = productOverview?.product.name
        
        view.backgroundColor            = UIColor.App.TableView.grayBackground
        tableView?.backgroundColor      = view.backgroundColor
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: .tiny)) // CGRect(origin: .zero, size: view.bounds.size))
        headerView.backgroundColor = UIColor.App.primary
        tableView?.tableHeaderView = headerView
        tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: .tiny))
//        tableView?.contentInset = UIEdgeInsets(top: -headerView.frame.height,
//                                               left: 0,
//                                               bottom: 0,
//                                               right: 0)
        
        tableView?.contentInset = .zero
        tableView?.dataSource = self
        tableView?.delegate  = self
        tableView?.separatorStyle = .none
        tableView?.alwaysBounceVertical = false
        
        if let overview = self.productOverview {
            emptyStatusLabel.attributedText =
                String(format: "productOverview.emptyText".localized, overview.product.name, Date.monthName(for: month) ?? "")
                    .attributedWith(
                        tracking: -26,
                        font: emptyStatusLabel.font
            )
        }
        
        toggleNoDataView(show: false)
        if(self.productOverview?.product.name == "Commuting Allowance" || self.productOverview?.product.name == "Fahrtkostenzuschuss"){
            self.addButton.isHidden = true
            self.emptyStatusLabel.isHidden = true
            self.sadReceiptImageView.isHidden = true
            self.downArrowImageView.isHidden = true
        }else{
            self.addButton.isHidden = false
            self.emptyStatusLabel.isHidden = false
            self.sadReceiptImageView.isHidden = false
            self.downArrowImageView.isHidden = false
        }
        addButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        
        refreshControl.tintColor = UIColor.App.Text.light
        refreshControl.addTarget(self, action: #selector(shouldRefresh), for: .valueChanged)
        tableView?.refreshControl = refreshControl
        
        tableView?.contentInset = .zero
        // tableView?.refreshControl.inset
    }
    
    @objc
    private func shouldRefresh() {
        NotificationCenter.default.post(name: .shouldUpdateDashboard, object: nil)
    }
    
    private func toggleNoDataView(show: Bool) {
        emptyStatusContainer.isHidden      = !show
    }
    
    @objc
    private func addButtonPressed(_ sender: UIButton) {
        //productOverview
        if(self.productOverview?.product.name == "Kindergartenzuschuss"){
            let controller = KindergartenListViewController()
            controller.getUserProductID = productOverview?.product.userProductId ?? 0
            navigationController?.pushAndHideTabBar(controller)
        }else{
            (tabBarController as? AppTabBarController)?.startScanFlow(product: productOverview?.product)
        }
    }
    
    func update(with overview: ProductOverview) {
        self.productOverview = overview
        self.sections = [.statisticsHeader]
        self.reloadData()
    }
    
    private func reloadData() {
        guard let overview = self.productOverview else { return }
        
        let operation = BlockOperation { [weak self] in
            guard let `self` = self else { return }
            
            let group = DispatchGroup()
            let month  = self.month
            let year   = self.year
            let client = self.client
            
            group.enter()
            client.getDocuments(
                month: month,
                year: year,
                product: overview.product
            ) { [weak self] (documents) in
                guard let `self` = self else {
                    group.leave()
                    return
                }
                
                self.documents = documents
                if let indexOf = self.sections.firstIndex(of: .invoices([])) {
                    self.sections[indexOf] = Section.invoices(documents)
                } else {
                    self.sections.append(Section.invoices(documents))
                }

                group.leave()
            }
            
            group.enter()
            client.getDocumentsPendingCount(
                month: month,
                year: year,
                product: overview.product
            ) { [weak self] (count) in
                guard let `self` = self else {
                    group.leave()
                    return
                }
                
                self.pendingInvoicesCount = count
                
                if count == 0 || month != Date.currentMonth {
                    if let indexOf = self.sections.firstIndex(of: .pendingInvoices(0)) {
                        self.sections.remove(at: indexOf)
                    }
                } else {
                    if let indexOf = self.sections.firstIndex(of: .pendingInvoices(0)) {
                        self.sections[indexOf] = .pendingInvoices(count)
                    } else {
                        self.sections.insert(.pendingInvoices(count), at: 1)
                    }
                }
                
                group.leave()
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                let show = self.documents.isEmpty && self.pendingInvoicesCount == 0
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.toggleNoDataView(show: show)
                }
            })
        }
        
        operation.start()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addButton?.set(shadowType: .subtle)
    }
}

extension ProductOverviewDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .pendingInvoices, .statisticsHeader: return 1
        case .invoices(let invoices): return invoices.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let sectionType = sections.value(at: indexPath.section) else {
            return UITableViewCell.empty()
        }
        
        switch sectionType {
        case .statisticsHeader:
            let cell = ProductOverviewHeaderTableViewCell.dequeue(in: tableView)
            cell.configure(with: productOverview)
            return cell
        case .pendingInvoices(let count):
            let cell = UITableViewCell.empty()
            cell.textLabel?.text = (count == 1)
                ? "invoice.pendingcount.one".localized
                : String(format: "invoice.pendingcount.more".localized, count)
            cell.backgroundColor = UIColor.App.Invoice.Status.pending.alpha(0.5)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.App.Text.dark
            cell.textLabel?.font = UIFont.appFont(ofSize: 13, weight: .semibold)
            return cell
        case .invoices(let invoices):
            let invoice = invoices[indexPath.row]
            let cell = InvoiceTableViewCell.dequeue(in: tableView)
            let viewModel = InvoiceTableViewCellViewModel(invoice: invoice)
            cell.configure(with: viewModel)
            return cell
        }
    }
}

extension ProductOverviewDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .tiny
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = sections[section]
        
        switch sectionType {
        case .statisticsHeader:
            return .tiny
        case .pendingInvoices:
            return .tiny
        case .invoices:
            return 5
        }
    }
}
