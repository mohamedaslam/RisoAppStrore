//
//  ProductDotView.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 25/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

class ProductDotView: UIView {
    private let dot: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        return view
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.appFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.lineBreakMode = .byClipping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(dot)
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            dot.leadingAnchor.constraint(equalTo: leadingAnchor),
            dot.centerYAnchor.constraint(equalTo: centerYAnchor),
            dot.heightAnchor.constraint(equalToConstant: 8),
            dot.widthAnchor.constraint(equalToConstant: 8),
            textLabel.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 10),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
            ])
    }
    
    func configure(with product: Product) {
        dot.backgroundColor = UIColor(hexString: product.hexColor)
        let productName: NSMutableAttributedString = NSMutableAttributedString(string: product.name)
        if product.yearlyLimit {
            productName.append(NSMutableAttributedString(string: " "))
            let attributes = [NSAttributedString.Key.backgroundColor : UIColor(hexString: "#477ddf"), NSAttributedString.Key.font: textLabel.font.withSize(12)];
            productName.append(NSMutableAttributedString(string: "‎\u{00A0}Jahr‎\u{00A0}", attributes: attributes))
        }
        textLabel.attributedText = productName
    }
}
