//
//  PagedContainerViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 25/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Parchment

class PagedContainerViewController: BaseViewController {
    internal weak var pagingViewController: PagingViewController<PagingIndexItem>?
    internal var viewControllers: [UIViewController] = []
    // Progamatically added views
    internal let datePickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "collapseButton").original, for: .normal)
        button.setTitle(" \(Date.currentYear) ", for: UIControl.State())
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        button.centerTextAndImage(spacing: 10.0)
        button.sizeToFit()
        return button
    }()
    internal let datePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    internal let invisibleTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.isHidden = true
        return textField
    }()
    internal let dotIndicatorView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = UIColor.App.TableView.grayBackground
        
        let pagingViewController: PagingViewController<PagingIndexItem> = PagingViewController.create()
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        self.pagingViewController = pagingViewController
        self.pagingViewController?.dataSource = self
    
        view.addSubview(invisibleTextField)
        invisibleTextField.inputView = datePicker
        invisibleTextField.attachDismissTooblar(doneButtonTitle: "Done".localized)
        
        // Buttons
        let barButtonItem = UIBarButtonItem(customView: datePickerButton)
        navigationItem.rightBarButtonItem = barButtonItem
        datePickerButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        datePickerButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        view.addSubview(dotIndicatorView)
        NSLayoutConstraint.activate([
            dotIndicatorView.heightAnchor.constraint(equalToConstant: 5),
            dotIndicatorView.widthAnchor.constraint(equalTo: dotIndicatorView.heightAnchor),
            dotIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dotIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ])
        view.bringSubviewToFront(dotIndicatorView)
        
        datePickerButton.addTarget(self, action: #selector(datePickerButtonDidTouch(_:)), for: .touchUpInside)
    }
    
    @objc
    private func datePickerButtonDidTouch(_ sender: UIButton) {
        if invisibleTextField.isFirstResponder {
            view.endEditing(true)
        }
        invisibleTextField.becomeFirstResponder()
    }
}


extension PagedContainerViewController: PagingViewControllerDataSource {
    public func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int {
        return viewControllers.count
    }
    
    public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        return PagingIndexItem(index: index, title: viewControllers[index].title ?? "") as! T
    }
    
    public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }
}
