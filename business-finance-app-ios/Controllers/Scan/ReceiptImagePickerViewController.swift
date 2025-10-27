//
//  ReceiptImagePickerViewController.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 11/06/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import MobileCoreServices
import PDFKit
class ReceiptImagePickerViewController: BaseViewController {
    enum Row {
        case header
        case camera
        case photoLibrary
        case PDFupload
    }
    
    static func instantiate(store: ScanStore, canDismiss: Bool) -> ReceiptImagePickerViewController {
        let storyboard = UIStoryboard(storyboard: .scan)
        let vc: ReceiptImagePickerViewController = storyboard.instantiateViewController()
        vc.store = store
        vc.canDismiss = canDismiss
        return vc
    }
    
    private var store: ScanStore = ScanStore()
    private var rows: [Row] = [.header, .camera, .photoLibrary, .PDFupload]
    private var canDismiss: Bool = false
    
    var didSelectImage: ((UIImage) -> Void)?
    
    private var sourceType: UIImagePickerController.SourceType = .photoLibrary {
        didSet {
            imagePickerController.sourceType = sourceType
        }
    }
    
    private let imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        return controller
    }()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pdfImage: UIImageView!
    deinit {
        
    }
}

extension ReceiptImagePickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        if canDismiss {
            rows = [.header, .camera, .photoLibrary, .PDFupload]
        } else {
            rows = [.camera, .photoLibrary, .PDFupload]
        }
        
        setupViews()
    }
    
    private func setupViews() {
        statusBarStyle = .darkContent
        view.backgroundColor          = UIColor.App.TableView.grayBackground
        
        // TableView
        tableView?.tableFooterView    = UIView()
        tableView?.dataSource         = self
        tableView?.delegate           = self
        tableView?.rowHeight          = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 110
        tableView?.backgroundColor    = view.backgroundColor
        tableView?.allowsMultipleSelection = false
        tableView.allowsSelection = true
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
        
        navigationController?.navigationBar.barTintColor = UIColor.App.TableView.grayBackground
        navigationController?.navigationBar.tintColor    = UIColor.App.Text.dark
        
        self.navigationController?.navigationBar.isTranslucent = false;
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: "#0f429f")

        if canDismiss {
        // Testing purposes
        let closeButton = UIBarButtonItem(
            image: #imageLiteral(resourceName: "dismiss-button").template,
            style: .plain,
            target: self,
            action: #selector(close)
        )
            closeButton.tintColor = UIColor.white
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    @objc
    private func close() {
        if let checkProduct = self.store.product{
            ApplicationDelegate.setupNavigationBarAppearance(with: .lightContent)
            dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)

        }
    }
}

extension ReceiptImagePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = rows[indexPath.row]
        switch rowType {
            
        case .header:
            let cell = ScanStepHeaderTableViewCell.dequeue(in: tableView)
            cell.titleLabel.text = "scan.takePhoto.title".localized
            if let judgeKidViewStatus = self.store.judgeKidView{
                if(judgeKidViewStatus == 1){
                    cell.stepLabel.text = "1/2"
                }else{
                    cell.stepLabel.text = "scan.takePhoto.step".localized
                }
            }
            return cell
        case .camera:
            let cell = ProductTypeTableViewCell.dequeue(in: tableView)
            cell.nameLabel.text = "scan.takePhoto.camera".localized
            cell.nameLabel.numberOfLines = 0
            cell.iconImageView.image = #imageLiteral(resourceName: "camera-icon")
            cell.set(state: .deselected, animated: false)
            cell.iconContainerView.backgroundColor = UIColor.Palette.dodgerBlue
            return cell
        case .photoLibrary:
            let cell = ProductTypeTableViewCell.dequeue(in: tableView)
            cell.nameLabel.text = "scan.takePhoto.gallery".localized
            cell.nameLabel.numberOfLines = 0
            cell.iconImageView.image = #imageLiteral(resourceName: "photo-library-icon")
            cell.set(state: .deselected, animated: false)
            cell.iconContainerView.backgroundColor = UIColor.Palette.dodgerBlue
            return cell
        case .PDFupload:
            let cell = ProductTypeTableViewCell.dequeue(in: tableView)
            cell.nameLabel.text = "scan.takePhoto.pdfUpload".localized
            cell.nameLabel.numberOfLines = 0
            cell.iconImageView.image = #imageLiteral(resourceName: "photo-library-icon")
            cell.set(state: .deselected, animated: false)
            cell.iconContainerView.backgroundColor = UIColor.Palette.dodgerBlue
            return cell
        }
    }
}

extension ReceiptImagePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        imagePickerController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        imagePickerController.navigationBar.barTintColor = UIColor.App.primary
        imagePickerController.navigationBar.tintColor = UIColor.white
        imagePickerController.navigationBar.isTranslucent = false
        imagePickerController.navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor.white
        ]
        
        let rowType = rows[indexPath.row]
        switch rowType {
        case .header:
            return
        case .camera:
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
            return
        case .photoLibrary:
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
            sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
            return
        case .PDFupload:
            let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            self.present(importMenu, animated: true, completion: nil)
            return
        }
    }
}

extension ReceiptImagePickerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
 let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            picker.dismiss(animated: true) {
                self.didSelectImage?(image.resized(to: CGSize(width: image.size.width, height: image.size.height))!)
               // self.didSelectImage?(image)
            }
        } else{
            picker.dismiss(animated: true) {
                
            }
            print("Something went wrong")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIImagePickerController {
    open override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    open override var childForStatusBarStyle: UIViewController? { return nil }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

extension ReceiptImagePickerViewController: UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }

        let data = NSData(contentsOf: myURL)
        do{
            //let getPDFImage = drawPDFfromURL(url: myURL)
            //let getPDFImage = renderPDFKitImage(from: myURL)
//            let getPDFImage = renderAllPDFPagesAsImages(from: myURL)
//            self.didSelectImage?(getPDFImage)
            if let images = renderAllPDFPagesAsImages(from: myURL) as [UIImage]?,
               let combinedImage = combineImagesVertically(images) {
                self.didSelectImage?(combinedImage)
                
            }
        }catch{
            print(error)
        }
    }

    func combineImagesVertically(_ images: [UIImage]) -> UIImage? {
        guard !images.isEmpty else { return nil }

        let totalWidth = images.map { $0.size.width }.max() ?? 0
        let totalHeight = images.reduce(0) { $0 + $1.size.height }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: totalWidth, height: totalHeight), false, 0)

        var yOffset: CGFloat = 0
        for image in images {
            image.draw(in: CGRect(x: 0, y: yOffset, width: image.size.width, height: image.size.height))
            yOffset += image.size.height
        }

        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return combinedImage
    }
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
       // dismiss(animated: true, completion: nil)
    }
}

func generatePdfThumbnail(of thumbnailSize: CGSize , for documentUrl: URL, atPage pageIndex: Int) -> UIImage? {
    let pdfDocument = PDFDocument(url: documentUrl)
    let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
    return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
}
func renderPDFKitImage(from url: URL, pageIndex: Int = 0, scale: CGFloat = 1.0) -> UIImage? {
    guard let pdfDoc = PDFDocument(url: url),
          let page = pdfDoc.page(at: pageIndex) else {
        print("PDF or page not found")
        return nil
    }

    let pageRect = page.bounds(for: .mediaBox)
    let size = CGSize(width: pageRect.width * scale, height: pageRect.height * scale)

    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    guard let ctx = UIGraphicsGetCurrentContext() else {
        return nil
    }

    ctx.saveGState()
    ctx.translateBy(x: 0, y: size.height)
    ctx.scaleBy(x: 1.0, y: -1.0)
    ctx.scaleBy(x: scale, y: scale)

    page.draw(with: .mediaBox, to: ctx)
    ctx.restoreGState()

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
}

func renderAllPDFPagesAsImages(from url: URL, scale: CGFloat = 1.0) -> [UIImage] {
    guard let pdfDoc = PDFDocument(url: url) else {
        print("PDF document not found.")
        return []
    }
    
    var images: [UIImage] = []
    
    for pageIndex in 0..<pdfDoc.pageCount {
        guard let page = pdfDoc.page(at: pageIndex) else { continue }
        
        let pageRect = page.bounds(for: .mediaBox)
        let size = CGSize(width: pageRect.width * scale, height: pageRect.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            continue
        }
        
        ctx.saveGState()
        ctx.translateBy(x: 0, y: size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.scaleBy(x: scale, y: scale)
        
        page.draw(with: .mediaBox, to: ctx)
        ctx.restoreGState()
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            images.append(image)
        }
        
        UIGraphicsEndImageContext()
    }
    
    return images
}
func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }

        var width: CGFloat = 0
        var height: CGFloat = 0
        
        // calculating overall page size
        for index in 1...document.numberOfPages {
            print("index: \(index)")
            if let page = document.page(at: index) {
                let pageRect = page.getBoxRect(.mediaBox)
                width = max(width, pageRect.width)
                height = height + pageRect.height
            }
        }

        // now creating the image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))

        let image = renderer.image { (ctx) in
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            for index in 1...document.numberOfPages {
                
                if let page = document.page(at: index) {
                    let pageRect = page.getBoxRect(.mediaBox)
                    ctx.cgContext.translateBy(x: 0.0, y: -pageRect.height)
                    ctx.cgContext.drawPDFPage(page)
                }
            }
            
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
        }
        return image
    }

extension UIImage {
  func resized(to newSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    defer { UIGraphicsEndImageContext() }

    draw(in: CGRect(origin: .zero, size: newSize))
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}

