//
//  TransparentBGViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/10/12.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class TransparentBGViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.alpha(0.4)
        self.navigationItem.setHidesBackButton(true, animated: false)

        view = UIView()
              view.backgroundColor = UIColor(white: 0, alpha: 0.7)

              spinner.translatesAutoresizingMaskIntoConstraints = false
              spinner.startAnimating()
              view.addSubview(spinner)

              spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
              spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
