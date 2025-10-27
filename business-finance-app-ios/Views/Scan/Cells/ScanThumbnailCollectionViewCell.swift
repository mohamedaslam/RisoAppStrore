//
//  ScanThumbnailCollectionViewCell.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class ScanThumbnailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            guard let imageView = imageView else { return }
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var removeButton: UIButton!
    var removeButtonPressed: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        removeButton.addTarget(self, action: #selector(removeButtonDidTouch), for: .touchUpInside)
    }
    
    @objc
    private func removeButtonDidTouch() {
        removeButtonPressed?()
    }
}
