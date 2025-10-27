//
//  ActivityIndicator.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

public class ActivityIndicator: UIActivityIndicatorView, Maskable {
    
    public var maskId: String = "ActivityIndicator"
    
    public override init(style: UIActivityIndicatorView.Style = .gray) {
        super.init(style: style)
        
        backgroundColor = UIColor.white
        startAnimating()
    }
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        stopAnimating()
    }
}
