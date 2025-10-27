//
//  UIView+Borders.swift
//  Pods
//
//  Created by Razvan Rusu on 22/06/2017.
//  Copyright © 2017 Viable Labs. All rights reserved.
//

import UIKit

public enum BorderPosition: Int {
    case top = 0, bottom, left, right
}

public extension UIView {
    fileprivate static var auxDefaultBorderColor: UIColor?
    fileprivate static let baseBorderLayerTag: Int = 32147582
    
    /// Default color to use for borders that don't specify a color.
    public var defaultBorderColor: UIColor {
        get {
            if self.responds(to: #selector(getter: UIView.tintColor)) {
                return self.tintColor
            } else {
                return UIColor.blue
            }
        }
    }
    
    /// The size of a device pixel
    public static var devicePixelSize: CGFloat {
        get {
            return 1.0 / (UIScreen.main.scale > 0 ? UIScreen.main.scale : 1.0)
        }
    }
    
    // ########################################################################
    // MARK: Complete Border
    // ########################################################################
    
    /**
     *  Add a border to a view with the line width of one retina pixel.
     */
    public func addRetinaPixelBorder() {
        self.addRetinaPixelBorderWithColor(self.defaultBorderColor)
    }
    
    /**
     *  Add a border to a view with the line width of one retina pixel with the specified color.
     *
     *  - parameter color: color of the line
     */
    public func addRetinaPixelBorderWithColor(_ color: UIColor) {
        self.addBorderWithColor(color, andWidth: UIView.devicePixelSize)
    }
    
    /**
     *  Add a border to a view with the specified line width and the specified color.
     *
     *  - parameter color: color of the line
     *  - parameter lineWidth: the width of the line in logical px. Use @c devicePixelSize to get a single retina/device pixel line.
     */
    public func addBorderWithColor(_ color: UIColor, andWidth lineWidth: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = lineWidth
    }
    
    // ########################################################################
    // MARK: Single side Border
    // ########################################################################
    
    /**
     *  Add a single retina pixel line to the specified side of the view.
     *
     *  - parameter position: the side of the view to which the line should be added
     */
    public func addRetinaPixelBorderAtPosition(_ position: BorderPosition) {
        self.addRetinaPixelBorderWithColor(self.defaultBorderColor, atPosition: position)
    }
    
    /**
     *  Add a single retina pixel line to the specified side of the view with the specified color.
     *
     *  - parameter color: color of the line
     *  - parameter position: the side of the view to which the line should be added
     */
    public func addRetinaPixelBorderWithColor(_ color: UIColor, atPosition position: BorderPosition) {
        self.addBorderWithColor(color, andWidth: UIView.devicePixelSize, atPosition: position)
    }
    
    /**
     *  Add a line to the specified side of the view with the specified line width.
     *
     *  - parameter lineWidth: the width of the line in logical px. Use @c devicePixelSize to get a single retina/device pixel line.
     *  - parameter position: the side of the view to which the line should be added
     */
    public func addBorderWithWidth(_ lineWidth: CGFloat, atPosition position: BorderPosition) {
        self.addBorderWithColor(self.defaultBorderColor, andWidth: lineWidth, atPosition: position)
    }
    
    /**
     *  Add a line to the specified side of the view with the specified color and the specified line width.
     *
     *  - parameter color: color of the line
     *  - parameter lineWidth: the width of the line in logical px. Use @c devicePixelSize to get a single retina/device pixel line.
     *  - parameter position: the side of the view to which the line should be added
     */
    public func addBorderWithColor(_ color: UIColor, andWidth lineWidth: CGFloat, atPosition position: BorderPosition) {
        //min lineweight is one device pixel
        self.addBorderWithColor(color, andWidth: lineWidth, atPosition: position, leftMargin: 0.0, rightMargin: 0.0)
    }
    
    /**
     *  Add a line to the specified side of the view with! the specified color ,specified line width and side paddings.
     *
     *  - parameter color: color of the line
     *  - parameter lineWidth: the width of the line in logical px. Use @c devicePixelSize to get a single retina/device pixel line.
     *  - parameter position: the side of the view to which the line should be added
     */
    
    public func addBorderWithColor(_ color: UIColor, andWidth lineWidth: CGFloat, atPosition position: BorderPosition, leftMargin: CGFloat, rightMargin: CGFloat) {
        
        //min lineweight is one device pixel
        let borderWidth = max(UIView.devicePixelSize, lineWidth)
        let border = CALayer()
        
        switch position {
        case .top:
            border.frame = CGRect(x: leftMargin, y: 0, width: self.frame.size.width - leftMargin - rightMargin, height: borderWidth)
            break
        case .bottom:
            border.frame = CGRect(x: leftMargin, y: self.frame.size.height - borderWidth, width: self.frame.size.width - leftMargin - rightMargin, height: borderWidth)
            break
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.size.height)
            break
        case .right:
            border.frame = CGRect(x: self.frame.size.width - borderWidth, y: 0, width: borderWidth, height: self.frame.size.height)
            break
        }
        
        border.backgroundColor = color.cgColor
        self.removeBorderAtPosition(position)
        border.setValue(self.tagForPosition(position), forKey: "tag")
        self.layer.addSublayer(border)
    }
    
    // ########################################################################
    // MARK: Border Removal
    // ########################################################################
    
    /**
     *  Remove the line at the specified side of the view.
     *
     *  - parameter position: the side of the view from which lines should be removed
     */
    public func removeBorderAtPosition(_ position: BorderPosition){
        let borderTag = self.tagForPosition(position)
        
        var toRemove: CALayer?
        
        if let layersArray = self.layer.sublayers {
            for layer in layersArray {
                //                if (layer == nil) {
                //                if let currentLayer = layer as? CALayer {
                if let layerTag = layer.value(forKey: "tag") as? Int , layerTag == borderTag {
                    toRemove = layer
                    break
                }
            }
            //            }
        }
        if let layerToBeRemoved = toRemove {
            layerToBeRemoved.removeFromSuperlayer()
        }
    }
    
    /**
     *  Remove the lines from all sides of the view.
     */
    public func removeAllBorders() {
        self.removeBorderAtPosition(.top)
        self.removeBorderAtPosition(.bottom)
        self.removeBorderAtPosition(.left)
        self.removeBorderAtPosition(.right)
    }
    
    // ########################################################################
    // MARK: Layer tags handling
    // ########################################################################
    
    private func tagForPosition(_ position: BorderPosition) -> Int {
        let layerTag = UIView.baseBorderLayerTag
        switch position {
        case .top:
            return layerTag
            
        case .bottom:
            return layerTag + 1
            
        case .left:
            return layerTag + 2
            
        case .right:
            return layerTag + 3
        }
    }
}

