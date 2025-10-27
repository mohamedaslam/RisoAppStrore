//
//  ProductsOverviewContainerViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import Parchment
import ANActivityIndicator

extension ProductsOverviewContainerViewController {
    static func instantiate(with monthlyOverviews: MonthlyYearlyOverview,
                            selectedIndex: Int,
                            selectMonth: Int,
                            selectedYear: Int,
                            getCategory:Int,
                            isYearSelected: Bool) -> ProductsOverviewContainerViewController {

            let storyboard = UIStoryboard(storyboard: .dashboard)
            let vc: ProductsOverviewContainerViewController = storyboard.instantiateViewController()
            vc.state = State(monthlyOverviews: monthlyOverviews.monthly, selectedIndex: selectedIndex)
            vc.selectedYear = selectedYear
            vc.selectMonth = selectMonth
            vc.selectedMonth = selectedIndex
            vc.monthlyYearlyOverview = monthlyOverviews
            vc.isYearSelected = isYearSelected
            vc.getCategory = getCategory
            return vc
    }
}

class ProductsOverviewContainerViewController: PagedContainerViewController {
    struct State {
        var monthlyOverviews: [MonthlyOverviewData]
        var products: [Product] {
            return Array(Set<Product>(monthlyOverviews
                .map { $0.productsOverviews }
                .reduce([Product]()) {
                    var aux = $0
                    aux.append(contentsOf: $1.map({$0.product}))
                    return aux
            }))
                .sorted { (product1, product2) -> Bool in
                return product1.id < product2.id
            }
        }
        
        var selectedIndex: Int {
            set {
                _selectedIndex = minmax(0, newValue, max(monthlyOverviews.count - 1, 0))
            }
            get {
                return _selectedIndex
            }
        }
        
        private var _selectedIndex: Int
        init(monthlyOverviews: [MonthlyOverviewData], selectedIndex: Int = 0) {
            self.monthlyOverviews = monthlyOverviews
            self._selectedIndex   = minmax(0, selectedIndex, max(monthlyOverviews.count - 1, 0))
        }
    }
    
    private var datePickerItems: [Int] = []
    private var selectedYear: Int = Date.currentYear
    private var selectedMonth: Int = Date.currentMonth
    private var selectMonth: Int = Date.currentMonth
    private var getCategory : Int = 0
    private var state = State(monthlyOverviews: [])
    var monthlyYearlyOverview: MonthlyYearlyOverview?
    private var monthlyOverview: MonthlyOverviewData?
    var isYearSelected : Bool = false
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Lifecycle

extension ProductsOverviewContainerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title                 = "productsOverview.title".localized
        let startingYear = client.firstDocumentUploadDate?.year ?? Date.currentYear
        datePickerItems       = Array(startingYear...Date.currentYear).reversed()
        datePicker.dataSource = self
        datePicker.delegate   = self
        setupScreens(for: state.monthlyOverviews)
        datePickerButton.setTitle("\(selectedYear)", for: .normal)
        datePickerButton.sizeToFit()
        reloadData()
    }
    
    func update(overviews: [MonthlyOverviewData]) {
        guard overviews.isNotEmpty else { return }
        
        var index = max(0, overviews.count - 1)
        if state.monthlyOverviews.count == overviews.count {
            index = state.selectedIndex
        }
        self.state = State(monthlyOverviews: overviews, selectedIndex: index)
        setupScreens(for: state.monthlyOverviews)
    }
    
    private func reloadData() {
        ANActivityIndicatorPresenter.shared.showIndicator()

        let operation = BlockOperation { [unowned self] in
            let group = DispatchGroup()

            //MonthlyYearlyOverview
            group.enter()
            client.getMonthlyYearlyOverviews(month: nil, year: selectedYear) { [weak self] (monthlyYearlyOverviewData) in
                guard let `self` = self else {
                    group.leave()
                    return
                }
                self.monthlyYearlyOverview = monthlyYearlyOverviewData
                group.leave()
            }
            group.notify(queue: DispatchQueue.main, execute: { [weak self] in
                guard let `self` = self else { return }

                UIView.animate(withDuration: 0.3, animations: { [self] in
//                    self.productsStackView.alpha          = 1.0
                    self.state.monthlyOverviews = self.monthlyYearlyOverview!.monthly
                    self.update(overviews: state.monthlyOverviews)
                    ANActivityIndicatorPresenter.shared.hideIndicator()

                })

            })
        }
        
        operation.start()
    }
    private func setupScreens(for overviews: [MonthlyOverviewData]) {
        guard overviews.isNotEmpty else { return }
        
        if overviews.count == viewControllers.count {
            // Let's reuse them
            for (index, overview) in overviews.enumerated() {
                guard let controller = viewControllers.value(at: index) as? ProductsOverviewViewController else { continue }
                controller.title = Date.monthName(for: Int(overview.month) ?? 0)
                controller.update(with: overview)
            }
        } else {
            viewControllers = overviews.map({
                let controller = ProductsOverviewViewController.instantiate(with: $0,yearlyOverview: self.monthlyYearlyOverview!.yearly,month:self.selectedMonth,year: selectedYear,selectMonth:selectMonth,getCategory: self.getCategory, isYearlySelected: false)
                controller.title = Date.monthName(for: Int($0.month) ?? 0)
                return controller
            })
            pagingViewController?.reloadData()
        }

        let pagingItem = PagingIndexItem(
            index: state.selectedIndex,
            title: Date.monthName(for: Int(state.monthlyOverviews[state.selectedIndex].month) ?? 0) ?? ""
        )

        pagingViewController?.select(pagingItem: pagingItem)
    }
    
    private func didUpdate(year: Int) {
        guard selectedYear != year, year <= Date.currentYear else { return }
        selectedYear = year
        datePickerButton.setTitle("\(year)", for: .normal)
        datePickerButton.sizeToFit()
        reloadData()
    }
}

// MARK: - UIPickerViewDataSource
extension ProductsOverviewContainerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datePickerItems.count
    }
}

// MARK: - UIPickerViewDelegate
extension ProductsOverviewContainerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let year = datePickerItems[row]
        return "\(year)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = datePickerItems[row]
        didUpdate(year: year)
    }
}

extension ProductsOverviewContainerViewController: PagingViewControllerDelegate {
    func pagingViewController<T>(
        _ pagingViewController: PagingViewController<T>,
        didScrollToItem pagingItem: T,
        startingViewController: UIViewController?,
        destinationViewController: UIViewController,
        transitionSuccessful: Bool) {
        
        guard let pagingItem = pagingItem as? PagingIndexItem else { return }
        self.state.selectedIndex = pagingItem.index
    }
}
