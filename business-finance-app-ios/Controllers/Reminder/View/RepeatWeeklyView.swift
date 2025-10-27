//
//  RepeatWeeklyView.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/6/30.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
protocol RepeatWeeklyViewDelegate: NSObjectProtocol {
    func selectedRepeatStr(repeatArr: [Int])
}

class RepeatWeeklyView: UIView {
    var weeklyBGView: UIView = UIView()
    let contentView_Height = 8.0 * 50 * AutoSizeScaleX
    let cell_Height = 50 * AutoSizeScaleX
    var repeatStr: String = "0000000"
    let cellID = "cellID"
    let dateArr: Array = [" Montag ", " Dienstag ", " Mittwoch ", " Donnerstag ", " Freitag ", " Samstag ", " Sonntag "]
    var repeatArr: [Int]!
    var getSelectedWeekes: [Int] = []
    let weekDaysArray = [0,1, 2, 3, 4,5,6]
    let weeklyArray = [0, 1, 0, 1, 0, 0, 1]
    var getDate :[Int]!
    weak var delegate: RepeatWeeklyViewDelegate?
    var contentView: UIView!
    var tableView: UITableView!
    var repeatReminderlab: UILabel = UILabel()
    var editReminderRepeatModel: ReminderRepeatModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(white: 0.5, alpha: 0.5)
            
        configContentView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configContentView() {
        if self.repeatArr == nil {
            self.repeatArr = self.repeatStr.getRepeatArr()
        }
        let weeklyBGView: UIView = UIView()
        weeklyBGView.backgroundColor = .white
        self.addSubview(weeklyBGView)
        self.weeklyBGView = weeklyBGView
        weeklyBGView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
        
        let repeatReminderlab: UILabel = UILabel()
        repeatReminderlab.textColor = .lightGray
        repeatReminderlab.textAlignment = .left
        repeatReminderlab.numberOfLines = 0
        repeatReminderlab.font = UIFont.appFont(ofSize: 12, weight: .regular)
        weeklyBGView.addSubview(repeatReminderlab)
        self.repeatReminderlab = repeatReminderlab
        repeatReminderlab.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(weeklyBGView)
            make.height.equalTo(30 * AutoSizeScaleX)
        }
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(repeatReminderlab.snp_bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(CGFloat(self.dateArr.count) * self.cell_Height)
        }
        self.tableView = tableView
    }
}
extension RepeatWeeklyView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cell_Height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID)
            cell?.selectionStyle = .none
        }

        cell?.tintColor = UIColor(hexString: "#3868F6")
        cell?.textLabel?.textColor = UIColor(hexString: "#2B395C")
        cell?.textLabel?.text = self.dateArr[indexPath.row]
        cell?.accessoryType = self.repeatArr[indexPath.row] == 1 ? .checkmark : .none
        if self.repeatArr[indexPath.row] == 1 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            self.getSelectedWeekes.append(weekDaysArray[indexPath.row])
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        displayReminderText()

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.repeatArr[indexPath.row] = 1
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        self.getSelectedWeekes.append(weekDaysArray[indexPath.row])
        displayReminderText()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let index = self.getSelectedWeekes.firstIndex(of: weekDaysArray[indexPath.row]) {
            self.getSelectedWeekes.remove(at: index)
        }
        self.repeatArr[indexPath.row] = 0
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        displayReminderText()
    }
    
    func displayReminderText(){
        self.delegate?.selectedRepeatStr(repeatArr: self.repeatArr)
        self.repeatStr = ""
        
        for value in repeatArr {
           self.repeatStr.append(String(value))
        }
        var finalWeekStr = self.repeatStr.getRepeatStr()
        if(finalWeekStr.count > 12){
            finalWeekStr.removeLast()
        }
        
        let splitStringArray = self.repeatStr.getRepeatStr().split(separator: " ").map({ (substring) in
        return String(substring) })
       let replaced = finalWeekStr.replacingOccurrences(of: self.repeatStr.getRepeatStr() ?? "", with: "\(self.repeatStr.getRepeatStr() ?? "")")
        let completeURL = "Eine Erinnerung erfolgt alle \(splitStringArray.joinedWithComma()). "
        self.repeatReminderlab.text = completeURL
        if(finalWeekStr.count < 6){
            self.repeatReminderlab.isHidden = true
        }else{
            self.repeatReminderlab.isHidden = false
        }

    }

}
extension StringProtocol {
    var words: [SubSequence] {
        return split { !$0.isLetter }
    }
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}
