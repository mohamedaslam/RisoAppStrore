//
//  InvoiceTableViewCell.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit
import SwiftDate

class InvoiceTableViewCellViewModel {
    let nameText: String
    let priceText: String
    let descriptionText: String
    let collapsedComments: String
    let expandedComments: String
    let statusImage: UIImage?
    
    init(invoice: Document) {
        self.nameText          = invoice.name
        self.priceText         = invoice.price.priceAsString()
        
        switch invoice.status {
        case .approved:
            self.collapsedComments = invoice.comments ?? ""
            self.expandedComments  = invoice.comments ?? ""
        case .rejected:
            self.collapsedComments = invoice.rejectionComments ?? ""
            self.expandedComments  = invoice.rejectionComments ?? ""
        default:
            self.collapsedComments = ""
            self.expandedComments  = ""
        }
        
        let stringDate = invoice.date?.toFormat("dd.MM.yyyy") ?? "N/A"
        self.descriptionText = [stringDate, invoice.location]
            .compactMap { $0 }
            .filter { $0.trim().isNotEmpty }
            .joined(separator: " | ")
        
        switch invoice.status {
        case .approved:
            statusImage = #imageLiteral(resourceName: "invoice-status-approved")
        case .rejected:
            statusImage = #imageLiteral(resourceName: "invoice-status-rejected")
        case .new, .transcribe:
            statusImage = nil
        }
    }
}

class InvoiceTableViewCell: UITableViewCell {
    @IBOutlet weak var contentContainerView: UIView! {
        didSet {
            contentContainerView?.clipsToBounds = false
        }
    }
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            guard let label = nameLabel else { return }
            label.numberOfLines = 0
            label.textColor     = UIColor.App.Text.dark
            label.font          = UIFont.appFont(ofSize: 17, weight: .medium)
            label.textAlignment = .left
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            guard let label = descriptionLabel else { return }
            label.numberOfLines = 0
            label.textColor     = UIColor.App.Text.light
            label.font          = UIFont.appFont(ofSize: 13, weight: .regular)
            label.textAlignment = .left
        }
    }
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            guard let label = priceLabel else { return }
            label.numberOfLines = 0
            label.textColor     = UIColor.App.Text.dark
            label.font          = UIFont.appFont(ofSize: 17, weight: .medium)
            label.textAlignment = .left
        }
    }
    @IBOutlet weak var commentsLabel: UILabel! {
        didSet {
            guard let label = commentsLabel else { return }
            label.numberOfLines = 0
            label.textColor     = UIColor.App.Text.dark
            label.font          = UIFont.appFont(ofSize: 15, weight: .regular)
            label.textAlignment = .left
        }
    }
}

extension InvoiceTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = superview?.backgroundColor ?? .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        contentContainerView.set(shadowType: .subtle)
    }
}

extension InvoiceTableViewCell {
    func configure(with viewModel: InvoiceTableViewCellViewModel) {
        statusImageView.image = viewModel.statusImage
        nameLabel.text        = viewModel.nameText
        priceLabel.text       = viewModel.priceText
        descriptionLabel.text = viewModel.descriptionText
        commentsLabel.text    = viewModel.collapsedComments
    }
}
