//
//  ProductTypeTableViewCell.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import Kingfisher

class ProductTypeTableViewCell: UITableViewCell {
    enum ProductSelectionState {
        case deselected
        case selected
        case disabled
    }
    
    @IBOutlet weak var contentContainerView : UIView!
    @IBOutlet weak var iconContainerView    : UIView! {
        didSet {
            guard let view = iconContainerView else { return }
            view.layer.cornerRadius = 30
            view.clipsToBounds = false
        }
    }
    @IBOutlet weak var iconImageView        : UIImageView!
    @IBOutlet weak var checkmarkImageView   : UIImageView! {
        didSet {
            checkmarkImageView.image       = #imageLiteral(resourceName: "checkmark-icon")
            checkmarkImageView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var nameLabel            : UILabel! {
        didSet {
            guard let label = nameLabel else { return }
            label.font = UIFont.appFont(ofSize: 17, weight: .medium)
            label.textColor = UIColor.App.Text.dark
        }
    }
    @IBOutlet weak var commentsLabel        : UILabel! {
        didSet {
            guard let label = commentsLabel else { return }
            label.font = UIFont.appFont(ofSize: 13, weight: .regular)
            label.textColor = UIColor.App.Text.light
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text     = nil
        commentsLabel.text = nil
        backgroundColor    = superview?.backgroundColor
    }
    
    private var product: Product?
    private var state: ProductSelectionState = .deselected
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        contentContainerView?.set(shadowType: .subtle)
    }
    
    func configure(with product: Product, state: ProductSelectionState) {
        self.product = product
        self.state   = state
        
        if let imageURL = product.imageURL {
            self.iconImageView.kf.setImage(with: imageURL)
        } else {
            iconImageView.image = nil
        }
        nameLabel.text = product.name
        set(state: state, animated: false)
    }
    
    func set(state: ProductSelectionState, animated: Bool) {
        let block: (ProductSelectionState) -> Void = { [weak self] in
            guard let `self` = self else { return }
            if let image = self.iconImageView.image {
                self.iconImageView.image = image.template
            }
            
            let state = $0
            switch state {
            case .deselected:
                self.isUserInteractionEnabled             = true
                self.contentContainerView.backgroundColor = UIColor.Palette.white
                self.iconContainerView.backgroundColor    = self.product?.color
                self.iconImageView.tintColor              = UIColor.Palette.white
                self.nameLabel.textColor                  = UIColor.App.Text.dark
                self.commentsLabel.alpha                  = 0.0
                self.checkmarkImageView.alpha             = 0.0
                self.iconContainerView.alpha              = 1.0
                self.nameLabel.alpha                      = 1.0
            case .selected:
                self.isUserInteractionEnabled             = true
                self.contentContainerView.backgroundColor = self.product?.color
                self.iconContainerView.backgroundColor    = UIColor.Palette.white
                self.iconImageView.tintColor              = self.product?.color
                self.nameLabel.textColor                  = UIColor.Palette.white
                self.commentsLabel.alpha                  = 0.0
                self.checkmarkImageView.alpha             = 1.0
                self.iconContainerView.alpha              = 1.0
                self.nameLabel.alpha                      = 1.0
            case .disabled:
                self.isUserInteractionEnabled             = true
                self.contentContainerView.backgroundColor = UIColor.Palette.white
                self.iconContainerView.backgroundColor    = self.product?.color
                self.iconImageView.tintColor              = UIColor.Palette.white
                self.nameLabel.textColor                  = UIColor.App.Text.dark
                self.commentsLabel.alpha                  = 1.0
                self.checkmarkImageView.alpha             = 0.0
                self.iconContainerView.alpha              = 0.2
                self.nameLabel.alpha                      = 0.2
            }
            
            switch state {
            case .deselected:
                self.commentsLabel.text = nil
            case .selected:
                self.commentsLabel.text = nil
            case .disabled:
                self.commentsLabel.text = "scan.selectProduct.disabledClaim".localized()
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) { block(state) }
        } else {
            block(state)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        contentContainerView.backgroundColor = .white
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        contentContainerView.backgroundColor = .white
    }
}
