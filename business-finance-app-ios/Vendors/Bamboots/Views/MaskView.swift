//
//  MaskView.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

public class MaskView: UIView, Maskable {
    
    public var maskId: String = "MaskView"
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var contentView: UIView!
    
    public init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.clear
        
        Bundle(for: MaskView.classForCoder()).loadNibNamed("MaskView", owner: self, options: nil)
        self.addSubView(contentView, insets: .zero)
        
        activityIndicator.startAnimating()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        activityIndicator.stopAnimating()
    }
}
