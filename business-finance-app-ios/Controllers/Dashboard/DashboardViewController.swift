//
//  DashboardViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import Device
import ANActivityIndicator

class DashboardViewController: BaseViewController {
    @IBOutlet weak var statisticsContainerView: UIView! {
        didSet {
            statisticsContainerView?.clipsToBounds = false
        }
    }
    
    @IBOutlet weak var statisticsBackgroundView: UIView! {
        didSet {
            statisticsBackgroundView?.clipsToBounds = false
            statisticsBackgroundView.set(shadowType: .subtle)
        }
    }
    
    @IBOutlet weak var productsBackgroundView: UIView! {
        didSet {
            productsBackgroundView?.clipsToBounds = false
            productsBackgroundView.set(shadowType: .subtle)
        }
    }
    
    @IBOutlet weak var productsContainerView: UIStackView! {
        didSet {
            if let products = hidenProducts {
                for index in 0..<products.count {
                    let product = products[index]
                    let view = UIView()
                    
                    let leftLabel = UILabel()
                    leftLabel.translatesAutoresizingMaskIntoConstraints = false
                    leftLabel.text = product.product.name.uppercased()
                    leftLabel.font = UIFont.appFont(ofSize: 13, weight: .regular)
                    leftLabel.textColor = UIColor.App.Text.light
                    leftLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
                    view.addSubview(leftLabel)
                    
                    leftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                    leftLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
                    
                    let valuelabel = UILabel()
                    valuelabel.translatesAutoresizingMaskIntoConstraints = false
                    valuelabel.font = UIFont.appFont(ofSize: 20, weight: .medium, compact: true)
                    valuelabel.textColor = UIColor.App.Text.dark
                    valuelabel.text = Int(product.totalAmount - product.remainingAmount).priceAsString()
                    view.addSubview(valuelabel)
                    
                    valuelabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                    valuelabel.leftAnchor.constraint(equalTo: leftLabel.rightAnchor, constant: 5).isActive = true
                    
                    let rightlabel = UILabel()
                    rightlabel.translatesAutoresizingMaskIntoConstraints = false
                    rightlabel.text = "/ \(Int(product.totalAmount).priceAsString())"
                    rightlabel.font = UIFont.appFont(ofSize: 20, weight: .medium, compact: true)
                    rightlabel.textColor = UIColor.App.Text.light
                    view.addSubview(rightlabel)
                    
                    rightlabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                    rightlabel.leftAnchor.constraint(equalTo: valuelabel.rightAnchor).isActive = true
                    
                    let imageView = UIImageView()
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.image = #imageLiteral(resourceName: "chevron-button").withRenderingMode(.alwaysTemplate)
                    imageView.tintColor = UIColor(hexString: "#246AFF")
                    view.addSubview(imageView)
                    
                    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                    imageView.leftAnchor.constraint(equalTo: rightlabel.rightAnchor, constant: 20).isActive = true
                    imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
                    
                    view.tag = index
                    
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showProduct))
                    tapGestureRecognizer.cancelsTouchesInView = true
                    tapGestureRecognizer.numberOfTapsRequired = 1
                    view.addGestureRecognizer(tapGestureRecognizer)
                    
                    productsContainerView.addArrangedSubview(view)
                }
            }
        }
    }
    
    @IBOutlet weak var amountLeftTextLabel: UILabel! {
        didSet {
            guard let label = amountLeftTextLabel else { return }
            label.font = UIFont.appFont(ofSize: 13, weight: .regular)
            label.textColor = UIColor.App.Text.light
            label.text = "dashboard.amountLeft".localized
        }
    }
    @IBOutlet weak var amountLeftValueLabel: UILabel! {
        didSet {
            guard let label = amountLeftValueLabel else { return }
            label.font = UIFont.appFont(ofSize: 20, weight: .medium, compact: true)
            label.textColor = UIColor.App.Text.dark
            label.text = 0.0.priceAsString()
        }
    }
    @IBOutlet weak var approvedInvoicesTextLabel: UILabel! {
        didSet {
            guard let label = approvedInvoicesTextLabel else { return }
            label.font = UIFont.appFont(ofSize: 13, weight: .regular)
            label.textColor = UIColor.App.Text.light
            label.text = "dashboard.approved-invoices".localized
        }
    }
    @IBOutlet weak var approvedInvoicesValueLabel: UILabel! {
        didSet {
            guard let label = approvedInvoicesValueLabel else { return }
            label.font = UIFont.appFont(ofSize: 20, weight: .medium, compact: true)
            label.textColor = UIColor.App.Text.dark
            label.text = "0"
        }
    }
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLabel: UILabel! {
        didSet {
            guard let label = noDataLabel else { return }
            label.text = " "
        }
    }
    
    @IBOutlet weak var backgroundViewExpandedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewCollapsedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var statisticsContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var statisticsContainerHeightConstraint: NSLayoutConstraint!
    
    private(set) var monthlyOverview: MonthlyOverview?
    private var shouldRefreshLayout: Bool = true
    
    var hidenProducts: [ProductOverview]? {
        guard let over = monthlyOverview else { return nil }
        
        return over.productsOverviews
            .filter{ $0.product.hideFromRainbow }
            .sorted { (product1, product2) -> Bool in
                return product1.product.id < product2.product.id
        }
    }
    
    var openStatistics: (() -> Void)?
    var openProduct: ((ProductOverview) -> Void)?
    
    var viewHeight: CGFloat {
        return view.bounds.height
    }
    
    deinit {
        statisticsContainerView?.removeGestureRecognizers()
    }
}

// MARK: Instantiation
extension DashboardViewController {
    static func instantiate(with monthlyOverview: MonthlyOverview) -> DashboardViewController {
        let storyboard = UIStoryboard(storyboard: .dashboard)
        let vc: DashboardViewController = storyboard.instantiateViewController()
        vc.monthlyOverview = monthlyOverview
        return vc
    }
}

// MARK: Lifecycle
extension DashboardViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.layoutIfNeeded()
        ANActivityIndicatorPresenter.shared.hideIndicator()

    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .clear
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showStatistics))
        tapGestureRecognizer.cancelsTouchesInView = true
        tapGestureRecognizer.numberOfTapsRequired = 1
       // statisticsContainerView.addGestureRecognizer(tapGestureRecognizer)
        
        updateTexts()
        
    }
    
    func update(overview: MonthlyOverview) {
        self.monthlyOverview = overview
        self.updateTexts()
        self.shouldRefreshLayout = true
        self.view.layoutIfNeeded()
    }
    
    func updateTexts() {
        if let overview = monthlyOverview {
            amountLeftValueLabel?.text = overview.remainingAmount.priceAsString()
            approvedInvoicesValueLabel?.text = "\(overview.approvedInvoicesCount)"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if Device.size() == Size.screen3_5Inch || Device.size() == Size.screen4Inch {
            // iPhone 4, 4S or 5, 5S, SE
            amountLeftTextLabel?.font = UIFont.appFont(ofSize: 12, weight: .regular)
            amountLeftValueLabel?.font = UIFont.appFont(ofSize: 17, weight: .medium, compact: true)
            approvedInvoicesTextLabel?.font = UIFont.appFont(ofSize: 12, weight: .regular)
            approvedInvoicesValueLabel?.font = UIFont.appFont(ofSize: 17, weight: .medium, compact: true)
            statisticsContainerHeightConstraint?.constant = 76
            noDataLabel?.font = UIFont.appFont(ofSize: 12, weight: .regular)
            let height: CGFloat = CGFloat(38 * (hidenProducts?.count ?? 0) + (hidenProducts?.count ?? 0))
            productsContainerView.heightAnchor.constraint(equalToConstant: height).isActive = true
            statisticsContainerTopConstraint?.constant = -38 - height
            UIView.animate(withDuration: 0) { self.view.layoutIfNeeded() }
        } else {
            amountLeftTextLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
            amountLeftValueLabel?.font = UIFont.appFont(ofSize: 20, weight: .medium, compact: true)
            approvedInvoicesTextLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
            approvedInvoicesValueLabel?.font = UIFont.appFont(ofSize: 20, weight: .medium, compact: true)
            statisticsContainerHeightConstraint?.constant = 100
            noDataLabel?.font = UIFont.appFont(ofSize: 15, weight: .regular)
            let height: CGFloat = CGFloat(50 * (hidenProducts?.count ?? 0) + (hidenProducts?.count ?? 0))
            productsContainerView.heightAnchor.constraint(equalToConstant: height).isActive = true
            statisticsContainerTopConstraint?.constant = height > 0 ? -36 - height : -50
            UIView.animate(withDuration: 0) { self.view.layoutIfNeeded() }
        }
        
        guard shouldRefreshLayout else { return }
        shouldRefreshLayout = false
        
        if let overview = monthlyOverview {
            if !overview.hasData && overview.isCurrentMonthOverview {
                backgroundViewCollapsedHeightConstraint.priority = UILayoutPriority(rawValue: 999)
                backgroundViewExpandedHeightConstraint.priority = UILayoutPriority(rawValue: 1)
                UIView.animate(withDuration: 0) {
                    self.noDataView.isHidden = false
                    self.view.layoutIfNeeded()
                }
            } else {
                backgroundViewCollapsedHeightConstraint.priority = UILayoutPriority(rawValue: 1)
                backgroundViewExpandedHeightConstraint.priority = UILayoutPriority(rawValue: 999)
                UIView.animate(withDuration: 0) {
                    self.noDataView.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            backgroundViewCollapsedHeightConstraint.priority = UILayoutPriority(rawValue: 999)
            backgroundViewExpandedHeightConstraint.priority = UILayoutPriority(rawValue: 1)
            UIView.animate(withDuration: 0) {
                self.noDataView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Actions
extension DashboardViewController {
    @IBAction func showStatisticsButtonDidTouch(_ sender: UIButton) {
        showStatistics()
    }
    
    @objc
    private func showStatistics() {
        openStatistics?()
    }
    
    @objc
    private func showProduct(gesture: UIGestureRecognizer) {
        guard let index = gesture.view?.tag, let product = hidenProducts?[index] else { return }
        openProduct?(product)
    }
}
