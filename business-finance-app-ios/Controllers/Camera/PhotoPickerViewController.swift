//
//  PhotoPickerViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 08/06/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class PhotoPickerViewController: BaseViewController {
    static func instantiate() -> PhotoPickerViewController {
        let storyboard = UIStoryboard(storyboard: .camera)
        let vc: PhotoPickerViewController = storyboard.instantiateViewController()
        return vc
    }
}

extension PhotoPickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
