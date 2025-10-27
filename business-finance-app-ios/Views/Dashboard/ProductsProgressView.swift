//
//  ProductsProgressView.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

protocol ProductsProgressViewDataSource: class {
    func numberOfItemsInProductsProgressView(_ productsProgressView: ProductsProgressView) -> UInt
    
    func productsProgressView(_ productsProgressView: ProductsProgressView,
                              colorForItemAt index: Int) -> UIColor
    
    func productsSecondProgressView(_ productsProgressView: ProductsProgressView,
                              colorForItemAt index: Int) -> UIColor
    
    func productsProgressView(_ productsProgressView: ProductsProgressView,
                              valueForItemAt index: Int) -> CGFloat
    
    func productsProgressView(_ productsProgressView: ProductsProgressView,
                              secondValueForItemAt index: Int) -> CGFloat
}

class ProductsProgressView: UIView {
    private(set) var numberOfItems: Int = 0
    
    weak var dataSource: ProductsProgressViewDataSource? {
        didSet {
            reloadData(animated: false)
        }
    }
    
    private var items: [CAShapeLayer] = []
    private var secondItems: [CAShapeLayer] = []
    private var itemsBackgrounds: [CAShapeLayer] = []
    var animationDuration: TimeInterval = 0.4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.App.primary
        numberOfItems   = 0
    }
    
    func reloadData(animated: Bool) {
        guard let dataSource = self.dataSource else { return }
        self.numberOfItems = Int(dataSource.numberOfItemsInProductsProgressView(self))
        
        items.forEach { $0.removeFromSuperlayer() }
        items.removeAll()
        secondItems.forEach { $0.removeFromSuperlayer() }
        secondItems.removeAll()
        itemsBackgrounds.forEach { $0.removeFromSuperlayer() }
        itemsBackgrounds.removeAll()
        
        let itemSpacing : CGFloat  = 1
        let lineWidth   : CGFloat = 8.0
        var radius      : CGFloat = (bounds.width - lineWidth) / 2.0
    
        for _ in (0..<numberOfItems) {
            let arc = UIBezierPath(
                arcCenter: CGPoint(x: bounds.width / 2, y:  bounds.height),
                radius: radius,
                startAngle: CGFloat.pi,
                endAngle: 0,
                clockwise: true
            )
            
            let bgLayer = CAShapeLayer()
            bgLayer.path = arc.cgPath
            bgLayer.backgroundColor = UIColor.clear.cgColor
            bgLayer.strokeColor = UIColor.white.alpha(0.1).cgColor
            bgLayer.fillColor = superview?.backgroundColor?.cgColor
                ?? UIColor.App.primary.cgColor
            bgLayer.lineWidth   = lineWidth
            layer.addSublayer(bgLayer)
            itemsBackgrounds.append(bgLayer)
            
            radius = radius - lineWidth - itemSpacing
        }
        
        radius = (bounds.width - lineWidth) / 2.0
        
        for index in (0..<numberOfItems) {
            let arc = UIBezierPath(
                arcCenter: CGPoint(x: bounds.width / 2, y:  bounds.height),
                radius: radius,
                startAngle: CGFloat.pi,
                endAngle: 0,
                clockwise: true
            )

            let color = dataSource.productsProgressView(self, colorForItemAt: index)
            
            let halfCircleLayer = CAShapeLayer()
            halfCircleLayer.path = arc.cgPath
            halfCircleLayer.backgroundColor = UIColor.clear.cgColor
            halfCircleLayer.strokeColor = color.cgColor
            halfCircleLayer.fillColor = UIColor.clear.cgColor
            halfCircleLayer.lineWidth   = lineWidth
            halfCircleLayer.strokeStart = 0.0
            halfCircleLayer.strokeEnd   = 0.0
            layer.addSublayer(halfCircleLayer)
            items.append(halfCircleLayer)
            
            let secondColor = dataSource.productsSecondProgressView(self, colorForItemAt: index)
            
            let halfSecondCircleLayer = CAShapeLayer()
            halfSecondCircleLayer.path = arc.cgPath
            halfSecondCircleLayer.backgroundColor = UIColor.clear.cgColor
            halfSecondCircleLayer.strokeColor = secondColor.cgColor
            halfSecondCircleLayer.fillColor = UIColor.clear.cgColor
            halfSecondCircleLayer.lineWidth   = lineWidth
            halfSecondCircleLayer.strokeStart = 0.0
            halfCircleLayer.strokeEnd   = 0.0
            layer.addSublayer(halfSecondCircleLayer)
            secondItems.append(halfSecondCircleLayer)
            
            radius = radius - lineWidth - itemSpacing
        }
        
        reloadProgress(animated: animated)
    }
    
    func reloadProgress(animated: Bool) {
        guard let dataSource = self.dataSource else { return }
        for (index, item) in items.enumerated() {
            let progress       = dataSource.productsProgressView(self, valueForItemAt: index)
            if animated {
                let strokeStart = item.strokeEnd
                let duration: TimeInterval = animationDuration
                
                let animation       = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration  = duration
                animation.fromValue = strokeStart
                animation.toValue   = progress
                animation.fillMode  = CAMediaTimingFillMode.forwards
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.isRemovedOnCompletion = false
                item.strokeEnd = progress
                item.add(animation, forKey: "progress_animation_\(index)")
            } else {
                item.strokeEnd = progress
            }
        }
        
        for (index, item) in secondItems.enumerated() {
            let progress       = dataSource.productsProgressView(self, secondValueForItemAt: index)
            if animated {
                let strokeStart = item.strokeEnd
                let duration: TimeInterval = animationDuration
                
                let animation       = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration  = duration
                animation.fromValue = strokeStart
                animation.toValue   = progress
                animation.fillMode  = CAMediaTimingFillMode.forwards
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.isRemovedOnCompletion = false
                item.strokeEnd = progress
                item.add(animation, forKey: "progress_second_animation_\(index)")
            } else {
                item.strokeEnd = progress
            }
        }
    }
}
