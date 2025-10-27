//
//  MultiScanTableViewCell.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import Device
class MultiScanTableViewCell: UITableViewCell {
    enum Section {
        case photo(UIImage, Bool)
        case add
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            guard let label = titleLabel else { return }
            label.textColor = UIColor.App.Text.light
            label.font = UIFont.appFont(ofSize: 15, weight: .regular)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    private let itemSpacing: CGFloat = 2
    private var sections: [Section] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                
                self.collectionView.reloadData()
                
                let contentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
                self.collectionViewHeightConstraint.constant = contentHeight
                
                UIView.animate(withDuration: 0, animations: {
                    self.layoutIfNeeded()
                    self.heightChanged?()
                })
            }
        }
    }
    
    private var contentHeight: CGFloat {
        return collectionView?.collectionViewLayout.collectionViewContentSize.height ?? 0.0
    }
    
    var shouldDelete: ((Int) -> Void)?
    var shouldAdd: (() -> Void)?
    var heightChanged: (() -> ())?
    
    private var numberOfPhotosPerPage: Int {
        switch Device.size() {
            case Size.screen3_5Inch, Size.screen4Inch:
                return 3
            default:
                return 3
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor                 = superview?.backgroundColor
        
        collectionView?.delegate        = self
        collectionView?.dataSource      = self
        collectionView?.backgroundColor = superview?.backgroundColor
    }
    
    func configure(with photos: [UIImage]) {
        if photos.count == 1 {
            titleLabel.text = "scan.photos-taken.one".localized
        } else {
            titleLabel.text = String(format: "scan.photos-taken.other".localized, "\(photos.count)")
        }
        
        var sections = photos.enumerated().map { Section.photo($1, $0 != 0) }
        sections.append(.add)
        
        self.sections = sections
    }
}

extension MultiScanTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.item]
        
        switch sectionType {
        case .photo(let photo, let canRemove):
            let cell: ScanThumbnailCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.imageView.image = photo
            
            if canRemove {
                cell.removeButtonPressed = { [weak self] in
                    self?.shouldDelete?(indexPath.item)
                }
                cell.removeButton.isUserInteractionEnabled = true
                cell.removeButton.isHidden                 = false
            } else {
                cell.removeButtonPressed                   = nil
                cell.removeButton.isUserInteractionEnabled = false
                cell.removeButton.isHidden                 = true
            }
            return cell
        case .add:
            let cell: AddPhotoCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            return cell
        }
    }
}

extension MultiScanTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Calculate this dynamically (based on screen size)
        
        let containerWidth = collectionView.bounds.width / CGFloat(numberOfPhotosPerPage)
        let itemSize = Int(containerWidth - itemSpacing * (CGFloat(numberOfPhotosPerPage - 1)))
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = sections[indexPath.item]
        
        switch sectionType {
        case .photo(_):
            return
        case .add:
            shouldAdd?()
            return
        }
    }
}
