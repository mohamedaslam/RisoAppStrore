//
//  ImagePickerViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 08/06/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class ImagePickerViewController: BaseViewController {
    static func instantiate() -> ImagePickerViewController {
        let storyboard = UIStoryboard(storyboard: .camera)
        let vc: ImagePickerViewController = storyboard.instantiateViewController()
        return vc
    }
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var photoButton: UIButton!
    @IBOutlet private weak var libraryButton: UIButton!
    
    private lazy var cameraViewController: CameraViewController = {
        let controller = CameraViewController.instantiate()
        return controller
    }()
    private lazy var photoPickerViewController: PhotoPickerViewController = {
        let controller = PhotoPickerViewController.instantiate()
        return controller
    }()
}

// MARK: - Lifecycle
extension ImagePickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTargets()
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        cameraViewController.addAsChild(for: self, containerView: containerView)
    }
}

// MARK: - Actions
extension ImagePickerViewController {
    private func setupTargets() {
        photoButton.addTarget(self, action: #selector(photoButtonDidTouch(_:)), for: .touchUpInside)
        libraryButton.addTarget(self, action: #selector(libraryButtonDidTouch(_:)), for: .touchUpInside)
    }
    
    @objc
    private func photoButtonDidTouch(_ sender: UIButton) {
        photoPickerViewController.removeFromParent()
        cameraViewController.addAsChild(for: self, containerView: containerView)
    }
    
    @objc
    private func libraryButtonDidTouch(_ sender: UIButton) {
        cameraViewController.removeFromParent()
        photoPickerViewController.addAsChild(for: self, containerView: containerView)
    }
}
