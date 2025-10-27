//
//  Containable.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 20/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

/// Container protocol for `Loadable`, Objects conforms to this protocol can be used as container for the mask
public protocol Containable {
    func containerView() -> UIView?
}

public extension Containable {
    /// Get latest mask on container
    ///
    /// - Returns: If exists, return latest mask, otherwise return nil
    internal func latestMask() -> UIView? {
        var latestMask: UIView? = nil
        if let container = containerView() {
            for subview in container.subviews {
                if let _ = subview as? Maskable {
                    latestMask = subview
                }
            }
        }
        return latestMask
    }
}
