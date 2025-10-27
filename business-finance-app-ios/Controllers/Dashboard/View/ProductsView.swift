//
//  ProductsView.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/11/9.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class ProductsView: UIView {
    private let dot: UIView = {
        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        return view
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.appFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.lineBreakMode = .byClipping
        return label
    }()
    private let amountTextLabel: UILabel = {
        let amountTextLabel = UILabel()
        amountTextLabel.translatesAutoresizingMaskIntoConstraints = false
        amountTextLabel.textAlignment = .center
        amountTextLabel.font = UIFont.appFont(ofSize: 14, weight: .regular)
        amountTextLabel.textColor = .white
        amountTextLabel.numberOfLines = 0
        amountTextLabel.adjustsFontSizeToFitWidth = true
        amountTextLabel.minimumScaleFactor = 0.8
        amountTextLabel.lineBreakMode = .byClipping
        return amountTextLabel
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
        addSubview(amountTextLabel)

        dot.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.equalTo(144 * AutoSizeScaleX)
            make.height.equalTo(44 * AutoSizeScaleX)
            make.top.equalTo(4 * AutoSizeScaleX)
        }
        
        textLabel.snp.makeConstraints{ (make) in
            make.centerY.equalTo(dot).offset(-6 * AutoSizeScaleX)
            make.left.right.equalTo(dot)
            make.height.equalTo(12)
        }
        amountTextLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(textLabel.snp_bottom).offset(2 * AutoSizeScaleX)
            make.left.right.equalTo(dot)
            make.height.equalTo(12)
        }

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
        amountTextLabel.text = "10$/100$"
    }
}
