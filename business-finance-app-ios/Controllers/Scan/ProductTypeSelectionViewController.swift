//
//  ProductTypeSelectionViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
//import ImagePicker

enum ScanStep {
    case pictureTaking
    case productType
    case multiScan
    case confirmation
}

// MARK: = Class + Properties
class ProductTypeSelectionViewController: BaseViewController {
    enum Section {
        case header
        case product(Product)
    }
    
    @IBOutlet weak var tableView: UITableView!
    private var store: ScanStore = ScanStore()
    private var sections: [Section] = []
    private var lastSelectedIndexPath: IndexPath? = nil
    private var kindergartenKidsDetails: [KindergartenKid] = []

    deinit {
        
    }
}


// MARK: - Instantiation
extension ProductTypeSelectionViewController {
    static func instantiate(store: ScanStore) -> ProductTypeSelectionViewController {
        let storyboard = UIStoryboard(storyboard: .scan)
        let vc: ProductTypeSelectionViewController = storyboard.instantiateViewController()
        vc.store = store
        return vc
    }
}

// MARK: - Lifecycle
extension ProductTypeSelectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        self.sections = [.header]
        // Put available products first
        self.sections.append(contentsOf: client.products
            .filter { !store.disabledProducts.contains($0) }
            .map { Section.product($0) }
        )
        // And disabled one afterwards
        self.sections.append(contentsOf: client.products
            .filter { store.disabledProducts.contains($0) }
            .map { Section.product($0) }
        )
        
        self.tableView.reloadData()
        
        client.getListOfKindergartenKids { (kidDetail) in
            self.kindergartenKidsDetails = kidDetail
        }
//        setNextStepButton(enabled: store.product != nil)
        
//        if let _ = navigationController?.viewControllers.first as? ImagePickerController {
//            navigationController?.setViewControllers([self], animated: false)
//        }
    }
    
//    private func setNextStepButton(enabled: Bool) {
//        nextStepButton.isDeactivated = !enabled
//    }
    
    private func setupViews() {
        statusBarStyle = .darkContent
        view.backgroundColor          = UIColor.App.TableView.grayBackground
        
        // TableView
        tableView?.tableFooterView    = UIView()
        tableView?.dataSource         = self
        tableView?.delegate           = self
        tableView?.rowHeight          = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 110
        tableView?.backgroundColor    = view.backgroundColor
        tableView?.allowsMultipleSelection = false
        tableView.allowsSelection = true
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        
        navigationController?.navigationBar.barTintColor = UIColor.App.TableView.grayBackground
        navigationController?.navigationBar.tintColor    = UIColor.App.Text.dark
        
//        // Testing purposes
        let closeButton = UIBarButtonItem(
            image: #imageLiteral(resourceName: "back").template,
            style: .plain,
            target: self,
            action: #selector(close)
        )
        closeButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = closeButton
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        setNextStepButton(enabled: store.product != nil)
    }
    
    @objc
    private func close() {
        ApplicationDelegate.setupNavigationBarAppearance(with: .lightContent)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Actions
extension ProductTypeSelectionViewController {
//    @IBAction func nextStepButtonDidTouch(_ sender: UIButton) {
//        guard let product = store.product else { return }
//        if product.isMultiPage {
//            // Show multi page picker
//            let controller = MultiPictureScanViewController.instantiate(with: store)
//            navigationController?.pushViewController(controller, animated: true)
//        } else {
//            let controller = ScanConfirmationViewController.instantiate(with: store)
//            navigationController?.pushViewController(controller, animated: true)
//            // Show disclaimer
//        }
//    }
}

// MARK: - UITableViewDataSource
extension ProductTypeSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = sections[indexPath.row]
        
        switch sectionType {
        case .header:
            let cell = ScanStepHeaderTableViewCell.dequeue(in: tableView)
            cell.titleLabel.text = "scan.selectProduct.title".localized
            cell.stepLabel.text  = "scan.selectProduct.step".localized
            return cell
        case .product(let product):
            let cell = ProductTypeTableViewCell.dequeue(in: tableView)
            var state: ProductTypeTableViewCell.ProductSelectionState = .deselected
            if let selectedProduct = self.store.product, selectedProduct == product {
                state = .selected
            }
            if store.disabledProducts.contains(product) {
                state = .disabled
            }
            cell.configure(with: product, state: state)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ProductTypeSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = sections[indexPath.row]
        
        switch sectionType {
        case .header:
            tableView.deselectRow(at: indexPath, animated: true)
            return
        case .product(let product):
            guard !store.disabledProducts.contains(product) else { return }
            
            if let lastSelectedIndexPath = self.lastSelectedIndexPath {
                (tableView.cellForRow(at: lastSelectedIndexPath) as? ProductTypeTableViewCell)?.set(state: .deselected, animated: true)
            }
    
            store.product = product
//            setNextStepButton(enabled: store.product != nil)
            
            var state: ProductTypeTableViewCell.ProductSelectionState = .deselected
            if let selectedProduct = self.store.product, selectedProduct == product {
                state = .selected
            }
            
            if store.disabledProducts.contains(product) { state = .disabled }
            (tableView.cellForRow(at: indexPath) as? ProductTypeTableViewCell)?.set(state: state, animated: true)
            
            self.lastSelectedIndexPath = indexPath
            
            if(product.name == "Kindergarten Allowance"){
                let controller = ListOfKidsViewController()
                controller.store = store
                navigationController?.pushViewController(controller, animated: true)
            }else{
                if product.isMultiPage {
                    // Show multi page picker
                    let controller = MultiPictureScanViewController.instantiate(with: store)
                    navigationController?.pushViewController(controller, animated: true)
                } else {
                    let controller = ScanConfirmationViewController.instantiate(with: store)
                    navigationController?.pushViewController(controller, animated: true)
                    // Show disclaimer
                }

            }
            
            return
        }
    }
}
