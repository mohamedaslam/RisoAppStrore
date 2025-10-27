//
//  EmptyStatusView.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 26/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation
import StatusProvider

open class EmptyStatusView: UIView, StatusView {
    
    public var view: UIView {
        return self
    }
    
    public var status: StatusModel? {
        didSet {
            
            guard let status = status else { return }
            
            imageView.image = status.image
            titleLabel.text = status.title
            descriptionLabel.text = status.description
            actionButton.setTitle(status.actionTitle, for: UIControl.State())
            
            if status.isLoading {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
            
            imageView.isHidden = imageView.image == nil
            titleLabel.isHidden = titleLabel.text == nil
            descriptionLabel.isHidden = descriptionLabel.text == nil
            actionButton.isHidden = status.action == nil
            
            verticalStackView.isHidden = imageView.isHidden && descriptionLabel.isHidden && actionButton.isHidden
        }
    }
    
    public let titleLabel: UILabel = {
        $0.textColor = UIColor.App.Text.dark
        $0.font = UIFont.appFont(ofSize: 17, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        
        return $0
    }(UILabel())
    
    public let descriptionLabel: UILabel = {
        $0.textColor = UIColor.App.Text.light
        $0.font = UIFont.appFont(ofSize: 15, weight: .regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        
        return $0
    }(UILabel())
    
    public let activityIndicatorView: UIActivityIndicatorView = {
        $0.isHidden = true
        $0.hidesWhenStopped = true
        #if os(tvOS)
        $0.activityIndicatorViewStyle = .whiteLarge
        #endif
        
        #if os(iOS)
        $0.style = .gray
        #endif
        return $0
    }(UIActivityIndicatorView(style: .whiteLarge))
    
    public let imageView: UIImageView = {
        $0.contentMode = .center
        
        return $0
    }(UIImageView())
    
    let actionButton: UIButton = {
        
        return $0
    }(UIButton(type: .system))
    
    public let verticalStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .center
        
        return $0
    }(UIStackView())
    
    public let horizontalStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        
        return $0
    }(UIStackView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        actionButton.addTarget(self, action: #selector(EmptyStatusView.actionButtonAction), for: .touchUpInside)
        
        addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(activityIndicatorView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(imageView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(actionButton)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc func actionButtonAction() {
        status?.action?()
    }
    
    open override var tintColor: UIColor! {
        didSet {
            titleLabel.textColor = tintColor
            descriptionLabel.textColor = tintColor
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
