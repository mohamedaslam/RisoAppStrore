//
//  SuccessfulScanViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 30/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

extension SuccessfulScanViewController {
    static func instantiate() -> SuccessfulScanViewController {
        let storyboard = UIStoryboard(storyboard: .scan)
        let vc: SuccessfulScanViewController = storyboard.instantiateViewController()
        return vc
    }
}

class SuccessfulScanViewController: BaseViewController {
    var isBenefitView: Bool = false
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            guard let label = titleLabel else { return }
            label.font          = UIFont.appFont(ofSize: 20, weight: .semibold)
            label.textAlignment = .center
            label.textColor     = .white
            label.text          = "scan.success.titleText".localized
        }
    }
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            guard let label = detailsLabel else { return }
            label.font          = UIFont.appFont(ofSize: 15, weight: .regular)
            label.textAlignment = .center
            label.textColor     = .white
            label.text          = "scan.success.detailsText".localized
        }
    }
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            guard let button = dismissButton else { return }
            button.set(style: .filled)
            button.setTitle("OK".localized, for: .normal)
        }
    }
    deinit {
        
    }
}

extension SuccessfulScanViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.addTarget(self,
                                action: #selector(dismissButtonDidTouch),
                                for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dismissButton.set(shadowType: .subtle)
    }
}

extension SuccessfulScanViewController {
    @objc
    private func dismissButtonDidTouch() {
        if isBenefitView {
            dismiss(animated: true, completion: nil)
            for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: KindergartenListViewController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
        }else{
            ApplicationDelegate.setupNavigationBarAppearance(with: .lightContent)
            dismiss(animated: true, completion: nil)
        }
    }
}
