//
//  RepeatYearlyView.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/7/1.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import FSCalendar


protocol RepeatYearlyViewDelegate: NSObjectProtocol {
    func selectedYearlyRepeatStr(repeatArr: [Int],getMonth : Int)
}
class RepeatYearlyView: UIView {
    weak var delegate: RepeatYearlyViewDelegate?
    var calendarView: FSCalendar!
    var collectionView: UICollectionView!
    var repeatStr: String = "000000"
    var repeatArr: [Int] = []
    var repeatDateArr: [String] = []
    var getMonthStr : String = ""
    var getAlreadyselectedMonth : Int?
    private var selectedMonthIndex = 7
    var selectedIndex : IndexPath = []
    var selectedDateArray: [Date] = []
    var getSelectedYearlyMonthDays: [Int] = []
    var getSelectedMonthDays: [Int] = []

    var calendarEachlab: UILabel = UILabel()
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    var getSelectedMonthStr : String = ""
    var repeatyearlylab: UILabel = UILabel()
    var monthsArray: Array = ["Jan", "Feb", "Mär", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov","Dez"]
    var repeatMonthArr: [Int]!
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
        repeatyearlylab.text = "Eine Erinnerung erfolgt jeden Jahr "
        repeatyearlylab.textColor = .lightGray
        repeatyearlylab.textAlignment = .left
        repeatyearlylab.numberOfLines = 0
        repeatyearlylab.font = UIFont.appFont(ofSize: 12, weight: .regular)
        self.addSubview(repeatyearlylab)
        self.repeatyearlylab = repeatyearlylab
        repeatyearlylab.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(50 * AutoSizeScaleX)
        }
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 76 * AutoSizeScaleX, height: 40 * AutoSizeScaleX)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RepeatYearlyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.addSubview(collectionView)
        self.collectionView = collectionView
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(repeatyearlylab.snp_bottom).offset(5 * AutoSizeScaleX)
            make.height.equalTo(124 * AutoSizeScaleX)
        }
        
        let separateLineLab: UILabel = UILabel()
        separateLineLab.backgroundColor = .lightGray
        self.addSubview(separateLineLab)
        separateLineLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(1 * AutoSizeScaleX)
            make.top.equalTo(collectionView.snp_bottom).offset(6 * AutoSizeScaleX)
        }
        
        let calendarEachlab: UILabel = UILabel()
        calendarEachlab.text = "Jeden"
        calendarEachlab.textColor = .lightGray
        calendarEachlab.textAlignment = .left
        calendarEachlab.font = UIFont.appFont(ofSize: 12, weight: .regular)
        self.addSubview(calendarEachlab)
        self.calendarEachlab = calendarEachlab
        calendarEachlab.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(separateLineLab.snp_bottom).offset(10 * AutoSizeScaleX)
            make.height.equalTo(16 * AutoSizeScaleX)
        }

        getCurrentMonthFun()
        calenderView()
        getCurrentMonthFun()

    }
    func getCurrentMonthFun(){
        var monthInt = 0
        if(getSelectedMonthDays.count>1){
            monthInt = StructOperation.glovalVariable.getSelectedMonth
        }else{
            monthInt = Calendar.current.component(.month, from: Date())
        }
        let getCurrentMonthIndex =  IndexPath(item: monthInt - 1, section: 0)
        selectedIndex = getCurrentMonthIndex
        self.getMonthStr = self.monthsArray[monthInt - 1]
        let completeURL = "Eine Erinnerung erfolgt jeden Jahr \(self.monthsArray[monthInt - 1])"
        self.selectedMonthIndex = monthInt
        self.repeatyearlylab.text = completeURL
        self.collectionView.reloadData()
    }
    func calenderView(){
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
        calendar.appearance.titleSelectionColor = UIColor.black
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.titleTodayColor = UIColor.black
        calendar.weekdayHeight = 0
        calendar.scrollEnabled = false
        calendar.headerHeight = 0
        self.addSubview(calendar)
        self.calendarView = calendar
        calendar.snp.makeConstraints { (make) in
            make.top.equalTo(self.calendarEachlab.snp_bottom).offset(10 * AutoSizeScaleX)
            make.left.equalTo(self).offset(8 * AutoSizeScaleX)
            make.right.equalTo(self).offset(-8 * AutoSizeScaleX)
            make.height.equalTo(210 * AutoSizeScaleX)
        }
        var getMonthIndex = StructOperation.glovalVariable.getSelectedMonth
        getSelectedMonthDays = StructOperation.glovalVariable.getSelectedMonthArrat;

        for prime in getSelectedMonthDays {
            calendar.select(self.dateFormatter.date(from: "2022/\(getMonthIndex)/\(prime)"))
        }
        self.repeatDateArr.removeAll()
        self.getSelectedYearlyMonthDays.removeAll()
        displayReminderText()
    }
}

extension RepeatYearlyView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RepeatYearlyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RepeatYearlyCollectionViewCell
        cell.lab.text = self.monthsArray[indexPath.item]
        if selectedIndex == indexPath {
           cell.isSelected = true
            cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
         } else {
           cell.isSelected = false
             cell.bgView.layer.borderColor = UIColor.white.cgColor
         }
        getOnlyDay()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        collectionView.reloadData()
        self.calendarView.removeFromSuperview()
        self.calenderView()
        self.repeatDateArr.removeAll()
        self.getSelectedYearlyMonthDays.removeAll()
        for getDay in calendarView.selectedDates
        {
            let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
            let myStringDate = formatter.string(from: getDay)
                guard let date = formatter.date(from: myStringDate) else {
                    return
                }
            calendarView.deselect(date)
        }
        self.getSelectedMonthStr = self.monthsArray[indexPath.item]
        self.getMonthStr = self.monthsArray[indexPath.item]
        self.repeatArr.removeAll()
        if(getSelectedMonthStr == "Jan"){
            selectedMonthIndex = 1
        }else if(getSelectedMonthStr == "Feb"){
            selectedMonthIndex = 2
        }else if(getSelectedMonthStr == "Mär"){
            selectedMonthIndex = 3
        }else if(getSelectedMonthStr == "Apr"){
            selectedMonthIndex = 4
        }else if(getSelectedMonthStr == "Mai"){
            selectedMonthIndex = 5
        }else if(getSelectedMonthStr == "Jun"){
            selectedMonthIndex = 6
        }else if(getSelectedMonthStr == "Jul"){
            selectedMonthIndex = 7
        }else if(getSelectedMonthStr == "Aug"){
            selectedMonthIndex = 8
        }else if(getSelectedMonthStr == "Sep"){
            selectedMonthIndex = 9
        }else if(getSelectedMonthStr == "Okt"){
            selectedMonthIndex = 10
        }else if(getSelectedMonthStr == "Nov"){
            selectedMonthIndex = 11
        }else if(getSelectedMonthStr == "Dez"){
            selectedMonthIndex = 12
        }
        let selectedMonth = "2022/\(selectedMonthIndex)/01"
        self.calendarView.setCurrentPage(self.dateFormatter.date(from: selectedMonth)!, animated: false)
        displayReminderText()
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
        var finalWeekStr = self.repeatStr
        if(finalWeekStr.count > 12){
            finalWeekStr.removeLast()
        }
        let replaced = finalWeekStr.replacingOccurrences(of: self.repeatStr , with: "\(self.repeatStr )")
        if(self.getMonthStr == "Jan"){
            self.getMonthStr = "Januar"
        }else if(self.getMonthStr == "Feb"){
            self.getMonthStr = "Februar"
        }else if(self.getMonthStr == "Mär"){
            self.getMonthStr = "März"
        }else if(self.getMonthStr == "Apr"){
            self.getMonthStr = "April"
        }else if(self.getMonthStr == "Mai"){
            self.getMonthStr = "May"
        }else if(self.getMonthStr == "Jun"){
            self.getMonthStr = "Juni"
        }else if(self.getMonthStr == "Jul"){
            self.getMonthStr = "Juli"
        }else if(self.getMonthStr == "Aug"){
            self.getMonthStr = "August"
        }else if(self.getMonthStr == "Sep"){
            self.getMonthStr = "September"
        }else if(self.getMonthStr == "Okt"){
            self.getMonthStr = "Oktober"
        }else if(self.getMonthStr == "Nov"){
            self.getMonthStr = "November"
        }else if(self.getMonthStr == "Dez"){
            self.getMonthStr = "Dezember"
        }
        let completeURL = "Eine Erinnerung erfolgt jeden Jahr in \(self.getMonthStr) auf der \(self.repeatDateArr.joinedWithComma())."
        self.repeatyearlylab.text = completeURL
        if(replaced.count < 1){
            self.repeatyearlylab.isHidden = true
        }else{
            self.repeatyearlylab.isHidden = false
        }
    }
}

extension RepeatYearlyView: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            self.calendarView.isUserInteractionEnabled = true
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
        self.getSelectedYearlyMonthDays.removeAll()
    
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
            self.getSelectedYearlyMonthDays.append(getIntDay!)
            self.repeatDateArr.append(getIntDay!.ordinal)
        }
        StructOperation.glovalVariable.getSelectedMonthArrat = self.getSelectedYearlyMonthDays
        StructOperation.glovalVariable.getSelectedMonth = selectedMonthIndex
        displayReminderText()
        self.delegate?.selectedYearlyRepeatStr(repeatArr: self.getSelectedYearlyMonthDays.uniqued(), getMonth: selectedMonthIndex)
    }
}


extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
