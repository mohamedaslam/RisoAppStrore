//
//  ViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moreBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "menu-bar-button"),
            style: .plain,
            target: self,
            action: #selector(showMoreSection)
        )
        navigationItem.leftBarButtonItem = moreBarButtonItem
    }
    
    @objc
    private func showMoreSection() {
        let controller = MoreViewController.instantiate()
        navigationController?.pushAndHideTabBar(controller)
    }
}

