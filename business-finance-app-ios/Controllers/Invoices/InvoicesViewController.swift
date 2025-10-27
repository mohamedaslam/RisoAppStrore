//
//  InvoicesViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class InvoicesViewController: BaseViewController {
    enum Section: Equatable {
        case pendingInvoicesCount(Int)
        case documents([Document])
    }
    
    @IBOutlet weak var tableView: UITableView!
    private var sections: [Section] = []
    private var documents: [Document] = []
    private(set) var product: Product?
    private var month = Date.currentMonth
    private var year = Date.currentYear
    private var refreshControl = UIRefreshControl()
    private var didRefresh: Bool = false
    private var didLayoutSubviews: Bool = false
    private var pendingInvoicesCount: Int = 0
    
    deinit {
        
    }
}

func ==(lhs: InvoicesViewController.Section, rhs: InvoicesViewController.Section) -> Bool {
    switch (lhs, rhs) {
    case (.pendingInvoicesCount, .pendingInvoicesCount): return true
    case (.documents, .documents): return true
    default: return false
    }
}

// MARK: - Instantiation
extension InvoicesViewController {
    static func instantiate(with product: Product, month: Int, year: Int) -> InvoicesViewController {
        let storyboard = UIStoryboard(storyboard: .invoices)
        let vc: InvoicesViewController = storyboard.instantiateViewController()
        vc.product = product
        vc.month = month
        vc.year  = year
        return vc
    }
}

// MARK: - Lifecycle
extension InvoicesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        reloadData { }
    }
    
    func update(for monthYear: MonthYear) {
        self.month = monthYear.month
        self.year = monthYear.year
        
        reloadData { }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
    }
    
    private func reloadData(completion: @escaping () -> Void) {
        let operation = BlockOperation { [weak self] in
            guard let `self` = self else { return }
            let group = DispatchGroup()
            
            group.enter()
            self.client.getDocuments(
                month: self.month,
                year: self.year,
                product: self.product
            ) { [weak self] (documents) in
                guard let `self` = self else { return }
                self.documents = documents
                group.leave()
            }
            
            if self.year == Date.currentYear && self.month == Date.currentMonth {
                group.enter()
                self.client.getDocumentsPendingCount(
                    month: self.month,
                    year:  self.year,
                    product: self.product
                ) { [weak self] (count) in
                    guard let `self` = self else { return }
                    self.pendingInvoicesCount = count
                    group.leave()
                }
            } else {
                self.pendingInvoicesCount = 0
            }
            
            group.notify(queue: .main) { [weak self] in
                guard let `self` = self else { return }
                
                self.sections = []
                
                if self.month == Date.currentMonth
                    && self.year == Date.currentYear
                    && self.pendingInvoicesCount > 0{
                    self.sections.append(.pendingInvoicesCount(self.pendingInvoicesCount))
                }
                
                if self.documents.isNotEmpty {
                    self.sections.append(.documents(self.documents))
                }
                
                if self.documents.isEmpty {
                    self.showEmptyStatus(for: EmptyStatus.noInvoices(
                        productName: self.product?.name ?? "",
                        dateText: Date.monthName(for: self.month) ?? ""
                    ))
                } else {
                    self.hideEmptyStatus()
                }
                
                self.tableView?.reloadData()
                
                completion()
            }
        }
        operation.start()
    }
    
    private func setupViews() {
        view.backgroundColor            = UIColor.App.TableView.grayBackground
        tableView?.backgroundColor      = view.backgroundColor
        tableView?.dataSource           = self
        tableView?.delegate             = self
        tableView?.estimatedRowHeight   = 140
        tableView?.rowHeight            = UITableView.automaticDimension
        tableView?.separatorStyle       = .none
        tableView?.tableFooterView      = UIView()
        tableView?.alwaysBounceVertical = false
        
        refreshControl.tintColor = UIColor.App.Text.light
        refreshControl.addTarget(self, action: #selector(shouldRefresh), for: .valueChanged)
        tableView?.refreshControl = refreshControl
    }
    
    @objc
    private func shouldRefresh() {
        didRefresh = true
        reloadData {
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didLayoutSubviews {
            tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
            didLayoutSubviews = true
        }
    }
}

// MARK: - UITableViewDataSource
extension InvoicesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .pendingInvoicesCount: return 1
        case .documents(let documents): return documents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case let .pendingInvoicesCount(count):
            let cell = UITableViewCell.empty()
            cell.textLabel?.text = (count == 1)
                ? "invoice.pendingcount.one".localized
                : String(format: "invoice.pendingcount.more".localized, count)
            cell.backgroundColor = UIColor.App.Invoice.Status.pending.alpha(0.5)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.App.Text.dark
            cell.textLabel?.font = UIFont.appFont(ofSize: 13, weight: .semibold)
            return cell
        case .documents(let documents):
            let invoice   = documents[indexPath.row]
            let cell      = InvoiceTableViewCell.dequeue(in: tableView)
            let viewModel = InvoiceTableViewCellViewModel(invoice: invoice)
            cell.configure(with: viewModel)
            return cell
        }
        
    }
}

// MARK: - UITableViewDelegate
extension InvoicesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? InvoiceTableViewCell {
            cell.selectionStyle = .none
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = sections[section]
        
        switch sectionType {
        case .pendingInvoicesCount: return .tiny
        case .documents: return 5.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .tiny
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
