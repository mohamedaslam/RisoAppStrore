//
//  CameraViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 08/06/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class CameraViewController: BaseViewController {
    static func instantiate() -> CameraViewController {
        let storyboard = UIStoryboard(storyboard: .camera)
        let vc: CameraViewController = storyboard.instantiateViewController()
        return vc
    }
    
    let cameraView : CameraView = {
        let cameraView = CameraView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        return cameraView
    }()
}

extension CameraViewController {
    override func loadView() {
        super.loadView()
        view.addSubview(cameraView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        cameraView.configureFocus()
    }
    
    /**
     * Start the session of the camera.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let session = cameraView.session, session.isRunning == true {
            return
        }
        cameraView.startSession()
    }
}
