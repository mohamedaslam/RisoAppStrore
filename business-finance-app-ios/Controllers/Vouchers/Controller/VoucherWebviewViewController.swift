//
//  VoucherWebviewViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2023/2/22.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import UIKit
import WebKit

class VoucherWebviewViewController: BaseViewController {
    var getVoucherURLStr: String = "ASC"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.title = "Gutscheine"

        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(tapBackBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(webView)
        let url = URL(string: self.getVoucherURLStr)
        webView.load(URLRequest(url: url!))
        
    }
    
    @objc func tapBackBtnAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
