//
//  RepeatMonthlyView.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/7/1.
//  Copyright © 2022 Viable Labs. All rights reserved.
//
class StructOperation {
  struct glovalVariable {
      static var getSelectedMonth = Int();
      static var getSelectedMonthArrat: [Int] = [Int]();
      static var repeatDateArr: [String] = []

 }
}
import UIKit
import FSCalendar
protocol RepeatMonthlyViewDelegate: NSObjectProtocol {
    func selectedMonthlyRepeatStr(repeatArr: [Int])
}

class RepeatMonthlyView: UIView {
    var calendarView: FSCalendar!
    weak var delegate: RepeatMonthlyViewDelegate?

    var repeatStr: String = "000000"
    var repeatArr: [Int] = []
    var repeatDateArr: [String] = []
    private var selectedMonthIndex = 0
    var selectedIndex : IndexPath = []
    var selectedDateArray: [Date] = []
    var getSelectedMonthDays: [Int] = []
    var getSelectedData: [Int] = []

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    var repeatyearlylab: UILabel = UILabel()
    var calendarEachlab: UILabel = UILabel()
    var editReminderRepeatModel: ReminderRepeatModel?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configCollection()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configCollection() {
        
        let repeatyearlylab: UILabel = UILabel()
        repeatyearlylab.text = "Eine Erinnerung erfolgt monatlich am "
        repeatyearlylab.textColor = .lightGray
        repeatyearlylab.textAlignment = .left
        repeatyearlylab.numberOfLines = 0
        repeatyearlylab.font = .systemFont(ofSize: 12 * AutoSizeScaleX, weight: .regular)
        self.addSubview(repeatyearlylab)
        self.repeatyearlylab = repeatyearlylab
        repeatyearlylab.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(30 * AutoSizeScaleX)
        }
        
        let calendarEachlab: UILabel = UILabel()
        calendarEachlab.text = "Jeden"
        calendarEachlab.textColor = .lightGray
        calendarEachlab.textAlignment = .left
        calendarEachlab.font = .systemFont(ofSize: 12 * AutoSizeScaleX, weight: .regular)
        self.addSubview(calendarEachlab)
        self.calendarEachlab = calendarEachlab
        calendarEachlab.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(repeatyearlylab.snp_bottom).offset(5 * AutoSizeScaleX)
            make.height.equalTo(16 * AutoSizeScaleX)
        }
        calendarViewfunc()
    }
    
    func calendarViewfunc(){
        let calendar: FSCalendar = FSCalendar()
        calendar.backgroundColor = .white
        calendar.dataSource = self
        calendar.delegate = self
        calendar.placeholderType = .none
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        calendar.calendarWeekdayView.isHidden = true
        calendar.calendarHeaderView.isHidden = true
        calendar.backgroundColor = UIColor.white
        calendar.allowsMultipleSelection = true
        calendar.appearance.borderRadius = 0
        calendar.appearance.borderSelectionColor = UIColor(hexString: "#1E4199")
        calendar.appearance.selectionColor = UIColor.clear
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.titleTodayColor = UIColor.black
        calendar.appearance.titleSelectionColor = UIColor.black
        
        calendar.weekdayHeight = 0
        calendar.headerHeight = 0
        calendar.select(self.dateFormatter.date(from: "2023/01/00"))
        calendar.scrollEnabled = false
        self.addSubview(calendar)
        self.calendarView = calendar
        calendar.snp.makeConstraints { (make) in
            make.top.equalTo(calendarEachlab.snp_bottom).offset(10 * AutoSizeScaleX)
            make.left.equalTo(self).offset(8 * AutoSizeScaleX)
            make.right.equalTo(self).offset(-8 * AutoSizeScaleX)
            make.height.equalTo(210 * AutoSizeScaleX)
        }
        let primes:[Int] = StructOperation.glovalVariable.getSelectedMonthArrat;
        for prime in primes {
            calendar.select(self.dateFormatter.date(from: "2023/01/\(prime)"))
        }
        self.repeatDateArr.removeAll()
        getOnlyDay()

    }
    
    func displayReminderText(){
        self.repeatStr = ""
        for value in self.repeatDateArr.uniqued(){
            var getDatee = "  \(String(value)),"
            if value == self.repeatDateArr.uniqued().last {
                getDatee = "und \(String(value)),"
                }
            if value == self.repeatDateArr.uniqued().first {
                getDatee = " \(String(value)),"
                }
           self.repeatStr.append(getDatee)
        }
        self.repeatDateArr.joinedWithComma()
        var finalWeekStr = self.repeatStr
        if(finalWeekStr.count > 12){
            finalWeekStr.removeLast()
        }
        let replaced = finalWeekStr.replacingOccurrences(of: self.repeatStr , with: "\(self.repeatStr )")
        let completeURL = "Eine Erinnerung erfolgt monatlich am \(self.repeatDateArr.joinedWithComma())."
        self.repeatyearlylab.text = completeURL
        if(replaced.count < 1){
            self.repeatyearlylab.isHidden = true
        }else{
            self.repeatyearlylab.isHidden = false
        }
    }
    
}

extension RepeatMonthlyView: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        getOnlyDay()
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        getOnlyDay()
    }
    
    func getOnlyDay(){
        self.repeatDateArr.removeAll()
        self.getSelectedMonthDays.removeAll()
        selectedDateArray = calendarView.selectedDates.sorted()
        for name in selectedDateArray
        {
            let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
            let myStringDate = formatter.string(from: name)
                guard let date = formatter.date(from: myStringDate) else {
                    return
                }
                formatter.dateFormat = "dd"
                let day = formatter.string(from: date)
            let getIntDay: Int? = Int(day)
            self.getSelectedMonthDays.append(getIntDay!)
            self.repeatDateArr.append(getIntDay!.ordinal)
        }
        StructOperation.glovalVariable.getSelectedMonthArrat = self.getSelectedMonthDays
        displayReminderText()
        self.delegate?.selectedMonthlyRepeatStr(repeatArr: self.getSelectedMonthDays.uniqued())
    }
}

extension Array where Iterator.Element == String {
    func joinedWithComma(useOxfordComma: Bool = false, maxItemCount: Int = -1) -> String {
        let result: String
        if maxItemCount >= 0 && count > maxItemCount {
            result = self[0 ..< maxItemCount].joined(separator: ", ") + ", etc"
        } else if count >= 2 {
            let lastIndex = count - 1
            let extraComma = (useOxfordComma && count > 2) ? "," : ""
            result = self[0 ..< lastIndex].joined(separator: ", ") + extraComma + " and " + self[lastIndex]
        } else if count == 1 {
            result = self[0]
        } else {
            result = ""
        }

        return result
    }
}
