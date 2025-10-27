//
//  ProductOverviewTableViewCell.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 24/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class ProductOverviewTableViewCell: UITableViewCell {
    @IBOutlet weak var contentContainerView         : UIView!
    @IBOutlet weak var iconContainerView            : UIView!
    @IBOutlet weak var iconImageView                : UIImageView!
    @IBOutlet weak var nameLabel                    : UILabel! {
        didSet {
            guard let label = nameLabel else { return }
            label.font = UIFont.appFont(ofSize: 13, weight: .regular)
            label.textColor = UIColor.App.Text.dark
            label.textAlignment = .left
        }
    }
    @IBOutlet weak var expensesLabel                : UILabel! {
        didSet {
            guard let label = expensesLabel else { return }
            label.font = UIFont.appFont(ofSize: 13, weight: .regular)
            label.textColor = UIColor.App.Text.dark
            label.textAlignment = .right
        }
    }
    @IBOutlet weak var invoicesCountLabel           : UILabel! {
        didSet {
            guard let label = invoicesCountLabel else { return }
            label.font = UIFont.appFont(ofSize: 11, weight: .regular)
            label.textColor = UIColor.App.Text.light
            label.textAlignment = .left
        }
    }
    @IBOutlet weak var remainingAmountLabel         : UILabel! {
        didSet {
            guard let label = remainingAmountLabel else { return }
            label.font = UIFont.appFont(ofSize: 13, weight: .regular, compact: true)
            label.textColor = UIColor.App.Text.dark
            label.textAlignment = .right
        }
    }
    @IBOutlet weak var disclosureIndicatorImageView : UIImageView!
    private var product: Product?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.App.primary.alpha(0.1)
    }
    
    func configure(with productOverview: ProductOverview) {
        let product = productOverview.product
        self.product = productOverview.product
        
        backgroundColor = superview?.backgroundColor ?? .clear
        
        iconContainerView.backgroundColor = product.color
        iconImageView.kf.setImage(with: product.imageURL)
        
        disclosureIndicatorImageView.image = #imageLiteral(resourceName: "chevron-button").template
        disclosureIndicatorImageView.tintColor = UIColor.App.DisclosureIndicator.light
        
        nameLabel.text                    = product.name
        
        expensesLabel.attributedText = [
            " \(Double((productOverview.totalAmount - productOverview.remainingAmount)).priceAsString())"
                .withFont(UIFont.appFont(ofSize: 13, weight: .medium, compact: true))
                .withTextColor(UIColor.App.Text.dark),
            " / \(Double((productOverview.totalAmount)).priceAsString())"
            .withFont(UIFont.appFont(ofSize: 13, weight: .medium, compact: true))
            .withTextColor(UIColor.App.Text.dark),
        ].merged()
        
        invoicesCountLabel.text = String(
            format: "productOverview.invoicesCount".localized,
            "\(productOverview.approvedInvoicesCount)"
        )
        
        remainingAmountLabel.text = String(
            format: "productOverview.atDisposal".localized,
            "\(Double((productOverview.remainingAmount)).priceAsString())"
        )
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentContainerView.backgroundColor = .white
        iconContainerView.backgroundColor = product?.color
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentContainerView.backgroundColor = .white
        iconContainerView.backgroundColor = product?.color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
        contentContainerView.set(shadowType: .subtle)
        iconContainerView.layer.cornerRadius = min(
            iconContainerView.bounds.height,
            iconContainerView.bounds.width
        ) / 2.0
    }
}
