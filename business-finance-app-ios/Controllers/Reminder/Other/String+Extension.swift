//
//  String+Extension.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2019/4/12.
//  Copyright © 2022 Mohammed Aslam Shaik. All rights reserved.
//

import UIKit
let OnlyOnce = "00000000"
let EveryDay = "11111111"
public extension String {

    func getRepeatStr() -> String {
        var repeatStr = ""
        if self == OnlyOnce {
            repeatStr.append("OnlyOnce")
        } else if self == EveryDay {
            repeatStr.append("EveryDay")
        } else {
            var index = 0
            while index < self.count {
                let i = self.index(self.startIndex, offsetBy: index)
                if self[i] == "1" {
                    switch index {
                    case 0:
                        repeatStr.append("Montag ")
                    case 1:
                        repeatStr.append("Dienstag ")
                    case 2:
                        repeatStr.append("Mittwoch ")
                    case 3:
                        repeatStr.append("Donnerstag ")
                    case 4:
                        repeatStr.append("Freitag ")
                    case 5:
                        repeatStr.append("Samstag ")
                    case 6:
                        repeatStr.append("Sonntag ")
                    default:
                        print(index)
                    }
                }
                index += 1
            }
        }
        return repeatStr
    }
    
    func getRepeatArr() -> [Int] {
        if self == OnlyOnce {
            return [0, 0, 0, 0, 0, 0, 0]
        } else if self == EveryDay {
            return [1, 1, 1, 1, 1, 1, 1]
        } else {
            var index = 0
            var repeatArr: [Int] = []
            while index < self.count {
                let i = self.index(self.startIndex, offsetBy: index)
                repeatArr.append(self[i] == "1" ? 1 : 0)
                index += 1
            }
            return repeatArr
        }
    }
    
    /// subStringToIndex, include index
    func subStringTo(index: Int) -> String {
        let index: String.Index = self.index(self.startIndex, offsetBy: index)
        let newStr: String = String(self[...index])
        return newStr
    }
    
    func conversionToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date: Date = dateFormatter.date(from: self)!
        return date
    }
    
    /// - Returns: current time
    static func getCurrentTime() -> String {
        let date: Date = Date.init()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    /// - Parameter timeStr: timestamp
    /// - Returns: time
    static func convertStrToTime(timeStr: String) -> String {
        let date: Date = Date.init(timeIntervalSince1970: Double(timeStr)!)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    

    /// - Parameter timeStr: timestamp
    /// - Returns: time
    static func convertStrToTimeSinceReferenceDate(timeStr: String) -> String {
        let date: Date = Date.init(timeIntervalSinceReferenceDate: Double(timeStr)!)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    /// - Parameter timeStr: timestamp
    /// - Returns: timeHH:mm
    static func convertStrToHour(timeStr: String) -> String {
        let date: Date = Date.init(timeIntervalSinceReferenceDate: Double(timeStr)!)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    /// - Parameter date: datetime
    /// - Returns: timeHH:mm
    static func getTimeFromDate(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    static func getDOBFromDate(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    static func getTimeFromTimeInterval(timeInterval: Int64) -> String {
        let date: Date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    

}
