//
//  Maskable.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation

/// Mask protocol for `Loadable`, View that conforms to this protocol will be treated as mask
public protocol Maskable {
    var maskId: String { get }
}
