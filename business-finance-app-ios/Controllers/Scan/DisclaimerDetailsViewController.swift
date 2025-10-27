//
//  DisclaimerDetailsViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 25/06/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import StatusProvider

typealias DisclaimerText = String

class DisclaimerDetailsViewController: BaseViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(product: Product) {
        self.init(nibName: nil, bundle: nil)
        self.product = product
    }
    convenience init(store: ScanStore){
        self.init(nibName:nil, bundle:nil)
        self.store = store
    }
    
    private var product: Product?
    private var store : ScanStore?
    private var state: DataState<[DisclaimerText]> = .initial {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.newState(self.state)
            }
        }
    }
    private var items: [DisclaimerText] = []
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView      = UIView()
        tableView.tableHeaderView      = UIView()
        tableView.rowHeight            = UITableView.automaticDimension
        tableView.estimatedRowHeight   = 100
        tableView.separatorStyle       = .none
        tableView.alwaysBounceVertical = false
        return tableView
    }()
}

extension DisclaimerDetailsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
        if let product = self.product {
            loadTexts(for: product)
        }else{
            client.loadDisclaimerTextsForKindergartenTexts(productID: (store?.kindergartenKid?.product_id)!){ [weak self] (state) in
                self?.state = state
            }
        }
    }
    
    private func configureViews() {
       
        if let product = self.product {
            title = product.name
        }else{
            title = "Kindergarten"
        }
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        view.backgroundColor               = UIColor.App.TableView.grayBackground
        tableView.backgroundColor         = view.backgroundColor
        tableView.dataSource              = self
        tableView.delegate                = self
        tableView.register(DisclaimerDetailsTableViewCell.self, forCellReuseIdentifier: "DisclaimerDetailsTableViewCell")
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
    private func newState(_ state: DataState<[DisclaimerText]>) {
        switch state {
        case .initial, .loading:
            guard items.isEmpty else { break }
            show(status: Status(isLoading: true))
        case .error, .noData:
            items = []
            show(
                status: Status(
                    isLoading: false,
                    title: "something_went_wrong".localized(),
                    description: nil,
                    actionTitle: "please try again".localized(),
                    image: nil, action: { [weak self] in
                        if let product = self?.product {
                            self?.loadTexts(for: product)
                        }
                })
            )
        case let .data(results):
            items = results
            hideStatus()
        }
        
        tableView.reloadData()
    }
    
    private func loadTexts(for product: Product) {
        self.state = .loading
        client.loadDisclaimerTexts(for: product) { [weak self] (state) in
            self?.state = state
        }

    }
}

extension DisclaimerDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = items.value(at: indexPath.row) else { return UITableViewCell.empty() }
        
        let cell = tableView.dequeueReusableCell() as DisclaimerDetailsTableViewCell
        
        cell.numberLabel.attributedText = "\(indexPath.row + 1)."
            .withFont(UIFont.systemFont(ofSize: 15, weight: .semibold))
            .withTextColor(UIColor.App.Text.dark)
        
        cell.detailsLabel.attributedText = item
            .withFont(UIFont.systemFont(ofSize: 15, weight: .regular))
            .withTextColor(UIColor.App.Text.dark)
        
        cell.backgroundColor = tableView.backgroundColor
        return cell
    }
}

extension DisclaimerDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

class DisclaimerDetailsTableViewCell: UITableViewCell {
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
            detailsLabel.firstBaselineAnchor.constraint(equalTo: numberLabel.firstBaselineAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            ])
        
        detailsLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
    }
}
