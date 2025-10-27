//
//  CountingLabel.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 23/04/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import UIKit

public class CountingLabel: UILabel {
    
    let kCounterRate: Float = 3.0
    
    public enum AnimationType {
        case linear
        case easeIn
        case easeOut
        case easeInOut
    }
    
    public enum CountingType {
        case Int
        case Float
        case Custom
        case Currency
    }
    
    var start: Float = 0.0
    var end: Float = 0.0
    var timer: Timer?
    var progress: TimeInterval!
    var lastUpdate: TimeInterval!
    var duration: TimeInterval!
    var countingType: CountingType!
    var animationType: AnimationType!
    public var format: String = "%.2f"
    
    var currentValue: Float {
        if (progress >= duration) {
            return end
        }
        let percent = Float(progress / duration)
        let update = updateCounter(percent)
        return start + (update * (end - start));
    }
    
    public func countFrom(
        fromValue: Float,
        to toValue: Float,
        withDuration duration: TimeInterval,
        andAnimationType aType: AnimationType,
        andCountingType cType: CountingType) {
        
        // Set values
        self.start = fromValue
        self.end = toValue
        self.duration = duration
        self.countingType = cType
        self.animationType = aType
        self.progress = 0.0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        
        // Invalidate and nullify timer
        killTimer()
        
        // Handle no animation
        if (duration == 0.0) {
            updateText(toValue)
            return
        }
        
        // Create timer
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(updateValue),
            userInfo: nil, repeats: true
        )
    }
    
    func updateText(_ value: Float) {
        switch countingType! {
        case .Int:
            self.text = "\(Int(value))"
        case .Float:
            self.text = String(format: "%.2f", value)
        case .Custom:
            self.text = String(format: format, value)
        case .Currency:
            self.text = value.priceAsString()
        }
    }
    
    @objc
    func updateValue() {
        
        // Update the progress
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        // End when timer is up
        if (progress >= duration) {
            killTimer()
            progress = duration
        }
        
        updateText(currentValue)
    }
    
    func killTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateCounter(_ t: Float) -> Float {
        switch animationType! {
        case .linear:
            return t
        case .easeIn:
            return powf(t, kCounterRate)
        case .easeOut:
            return 1.0 - powf((1.0 - t), kCounterRate)
        case .easeInOut:
            var t = t
            var sign = 1.0;
            let r = Int(kCounterRate)
            if (r % 2 == 0) {
                sign = -1.0
            }
            t *= 2;
            if (t < 1) {
                return 0.5 * powf(t, kCounterRate)
            } else {
                return Float(sign * 0.5) * (powf(t-2, kCounterRate) + Float(sign * 2))
            }
            
        }
    }
}
