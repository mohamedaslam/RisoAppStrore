//
//  PieChartView.swift
//  PieChartView
//
//  Created by Damon Cricket on 10.09.2019.
//  Copyright © 2019 DC. All rights reserved.
//

import UIKit

// MARK: - PieChartView

class PieChartView: UIView {
    
    var pieLayers: [PieLayer] = []

    // MARK: - Adjust
    
    func adjust(withItems items: [PieItem]) {
        for pieLayer in pieLayers {
            pieLayer.removeFromSuperlayer()
        }
        
        pieLayers.removeAll()
        
        let radiansPerPercent = degreesToRadians(360.0)  / 100.0
        
        var lastAngle: CGFloat = 0.0
        
        let space: CGFloat = degreesToRadians(0.0)
        
        for item in items {
            let percent = CGFloat(item.percent)
            let length = radiansPerPercent * percent
            let startAngle = lastAngle
            let endAngle = startAngle + length - space
            lastAngle = endAngle + space
            
            let pieView = PieLayer()
            pieView.startAngle = startAngle
            pieView.endAngle = endAngle
            pieView.radius = bounds.size.width/2.0 - item.thickness
            pieView.color = item.color.cgColor
            pieView.thickness = item.thickness
            pieView.frame = bounds
            layer.addSublayer(pieView)
            pieLayers.append(pieView)
        }
    }
}

func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
    return (CGFloat.pi * degrees) / CGFloat(180.0)
}

func radiansToDegrees(_ radians: CGFloat) -> CGFloat {
    return (CGFloat(180.0) * radians) / CGFloat.pi
}
