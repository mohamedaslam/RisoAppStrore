//
//  PieLayer.swift
//  PieChartView
//
//  Created by Damon Cricket on 10.09.2019.
//  Copyright © 2019 DC. All rights reserved.
//

import UIKit

// MARK: - PieLayer

class PieLayer: CALayer {

    var startAngle: CGFloat = 0.0
    
    var endAngle: CGFloat = 0.0
    
    var radius: CGFloat = 0.0
    
    var thickness: CGFloat = 0.0
    
    var color: CGColor = UIColor.clear.cgColor
    
    // MARK: - Object LifeCycle
    
    override init() {
        super.init()
        
        postInitSetup()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
        if let pieLayer = layer as? PieLayer {
            startAngle = pieLayer.startAngle
            endAngle = pieLayer.endAngle
            radius = pieLayer.radius
            thickness = pieLayer.thickness
            color = pieLayer.color
        }
        
        postInitSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(layer: aDecoder)
        
        postInitSetup()
    }
    
    func postInitSetup() {
        allowsEdgeAntialiasing = true
        contentsScale = UIScreen.main.scale
        needsDisplayOnBoundsChange = true
    }
    
    // MARK: - Draw
    
    override open func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        UIGraphicsPushContext(ctx)
        
        ctx.setLineWidth(thickness)
        
        let path = CGMutablePath()
        
        path.addArc(center: CGPoint(x: bounds.maxX/2.0, y: bounds.maxY/2.0), radius: radius + thickness/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        ctx.addPath(path)
        
        ctx.setFillColor(UIColor.clear.cgColor)
        ctx.setStrokeColor(color)
        
        ctx.strokePath()
        
        UIGraphicsPopContext()
    }
}
