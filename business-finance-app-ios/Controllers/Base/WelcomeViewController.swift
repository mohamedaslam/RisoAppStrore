//
//  WelcomeViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 19/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController {
    static func instantiate() -> WelcomeViewController {
        let storyboard = UIStoryboard(storyboard: .main)
        let vc: WelcomeViewController = storyboard.instantiateViewController()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        handleApplicationStart()
//    }
//
//    func handleApplicationStart() {
//        ApplicationDelegate.handle(flow: .authentication)
//    }
}
