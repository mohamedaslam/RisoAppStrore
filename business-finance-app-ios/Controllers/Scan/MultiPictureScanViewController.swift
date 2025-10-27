//
//  MultiPictureScanViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
//import ImagePicker
//import Lightbox

extension MultiPictureScanViewController {
    static func instantiate(with store: ScanStore) -> MultiPictureScanViewController {
        let storyboard = UIStoryboard(storyboard: .scan)
        let vc: MultiPictureScanViewController = storyboard.instantiateViewController()
        vc.store      = store
        vc.tempImages = store.extraImages
        return vc
    }
}

class MultiPictureScanViewController: BaseViewController {
    enum Section {
        case header
        case photos([UIImage])
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextStepButton: UIButton! {
        didSet {
            nextStepButton.setTitle("scan.multiScan.buttonText".localized, for: .normal)
        }
    }
    
    private var store: ScanStore = ScanStore()
    private var tempImages: [UIImage] = []
    private var sections: [Section] = []
    
    deinit {
        
    }
}

extension MultiPictureScanViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadSections(for: store)
        
        title = store.product?.name
        view.backgroundColor          = UIColor.App.TableView.grayBackground
        
        let tintColor = UIColor.App.Text.dark
        navigationController?.navigationBar.barTintColor = UIColor.App.TableView.grayBackground
        navigationController?.navigationBar.tintColor    = tintColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : tintColor]
        navigationItem.backBarButtonItem?.tintColor = tintColor
        
        tableView?.dataSource         = self
        tableView?.delegate           = self
        tableView?.rowHeight          = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 100
        tableView?.tableHeaderView    = UIView()
        tableView?.tableFooterView    = UIView()
        tableView?.backgroundColor    = view.backgroundColor
        if #available(iOS 13.0, *){
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor.clear
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = navBarAppearance
            UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = navBarAppearance
        }
        let closeButton = UIBarButtonItem(
            image: #imageLiteral(resourceName: "back").template,
            style: .plain,
            target: self,
            action: #selector(close)
        )
        closeButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc
    private func close() {
        ApplicationDelegate.setupNavigationBarAppearance(with: .lightContent)
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nextStepButton.set(style: .filled)
        nextStepButton.set(shadowType: .subtle)
    }
    
    private func reloadSections(for store: ScanStore) {
        sections = [.header]
        if let image = store.image {
            var images = [image]
            images.append(contentsOf: tempImages)
            sections.append(.photos(images))
        } else {
            sections.append(.photos(tempImages))
        }
    }
    
    func takePicture() {
        let controller = ReceiptImagePickerViewController.instantiate(store: store, canDismiss: false)
        controller.didSelectImage = { [weak self] image in
            guard let `self` = self else { return }
            
            self.tempImages.append(image)
            DispatchQueue.main.async {
                self.reloadSections(for: self.store)
                self.tableView.reloadData()
                if let _ = self.navigationController?.viewControllers.last as? ReceiptImagePickerViewController {
                    let _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
        navigationController?.pushViewController(controller, animated: true)
//
//        let imagePicker = ImagePickerController(configuration: cameraConfiguration)
//        imagePicker.delegate = self
//
//        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func nextStepButtonDidTouch(_ sender: UIButton) {
        store.setExtraImages(tempImages)
        let controller = ScanConfirmationViewController.instantiate(with: store)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MultiPictureScanViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = sections[indexPath.row]
        
        switch sectionType {
        case .header:
            let cell = UITableViewCell.empty()
            cell.backgroundColor = tableView.backgroundColor
            
            if (store.product?.name.lowercased() ?? "").contains("internet") {
                cell.textLabel?.text = "scan.multi-scan.internetClaim".localized()
            } else {
                cell.textLabel?.text = String(
                    format: "scan.multi-scan.headerText".localized,
                    store.product?.name ?? ""
                )
            }
            cell.textLabel?.textColor = UIColor.App.Text.dark
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.appFont(ofSize: 20, weight: .medium)

            return cell
        case .photos(let photos):
            let cell = MultiScanTableViewCell.dequeue(in: tableView)
            cell.heightChanged = { [weak self] in
                guard let `self` = self else { return }
                UIView.setAnimationsEnabled(false)
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                UIView.setAnimationsEnabled(true)
            }
            
            cell.configure(with: photos)
            cell.shouldDelete = { [weak self] index in
                guard let `self` = self else { return }
                var auxIndex = index
                if self.store.image != nil {
                    auxIndex -= 1
                }
                guard (0..<self.tempImages.count).contains(auxIndex) else { return }
                self.tempImages.remove(at: auxIndex)
                self.reloadSections(for: self.store)
                self.tableView.reloadData()
            }
            cell.shouldAdd = { [weak self] in
                guard let `self` = self else { return }
                self.takePicture()
            }
            return cell
        }
    }
}

extension MultiPictureScanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}

//extension MultiPictureScanViewController: ImagePickerDelegate {
//    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//
//    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        guard images.count > 0 else { return }
//
//        let lightboxImages = images.map {
//            return LightboxImage(image: $0)
//        }
//
//        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
//        imagePicker.present(lightbox, animated: true, completion: nil)
//    }
//
//    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        self.tempImages.append(contentsOf: images)
//        DispatchQueue.main.async {
//            self.reloadSections(for: self.store)
//            self.tableView.reloadData()
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//}
