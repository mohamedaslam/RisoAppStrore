//
//  RepeatViewController.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/6/30.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
enum RepeatDateCellType: Int {
    case Weekly = 0
    case Monthly = 1
    case Yearly = 2
    case AllType = 3
}
protocol VC2Delegate: class {
    func updateLabel(withText text: String)
}

class RepeatViewController: BaseViewController {
    weak var delegate: SendDataDelegte?
    weak var delegateEdit: SendDataFromEditDelegte?
    var getSelectedMonthDays: [Int] = []
    var getSelectedYearlyMonthDays: [Int] = []
    var selectedMonthDays: [Int] = []

    var tableViewBGView: UIView = UIView()
    var weeklyBGView: UIView = UIView()
    let tableView_Height = 150 * AutoSizeScaleX
    lazy var repeatArr: [Int] = {
        var arr = [Int]()
        arr = [0,0,0,0,0,0,0]
        return arr
    }()
    let cellID = "cellID"
    lazy var weeklyView: RepeatWeeklyView = {
        var weeklyView = RepeatWeeklyView()
        weeklyView.delegate = self
        return weeklyView
    }()
    lazy var monthlyView: RepeatMonthlyView = {
        var monthlyView = RepeatMonthlyView()
        monthlyView.delegate = self
        return monthlyView
    }()
    lazy var yearlyView: RepeatYearlyView = {
        var yearlyView = RepeatYearlyView()
        yearlyView.delegate = self
        return yearlyView
    }()
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var monthlyBGView: RepeatMonthlyView!
    var tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
    lazy var sectionTitleArr: [String] = {
        var arr = [String]()
        arr = ["Wöchentlich", "Monatlich", "Jährlich"]
        return arr
    }()
    var selectedRow = 0
    var getSelectedMonth : Int = 1
    var editReminderRepeatModel: ReminderRepeatModel?
    var getSelectedFrequency : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Wiederholen"
        view.backgroundColor = .white
        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(tapBackBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        configTableView()
    }
    
    private func configTableView() {

        let tableViewBGView: UIView = UIView()
        tableViewBGView.backgroundColor = .white
        tableViewBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        tableViewBGView.layer.shadowColor = UIColor.black.cgColor
        tableViewBGView.layer.shadowOffset = CGSize.zero
        tableViewBGView.layer.shadowOpacity = 0.12
        tableViewBGView.layer.shadowRadius = 3
        self.view.addSubview(tableViewBGView)
        self.tableViewBGView = tableViewBGView
        tableViewBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.height.equalTo(tableView_Height)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        tableViewBGView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(tableViewBGView)
        }
        self.tableView = tableView
        
        configWeeklyView()
        configMonthlyView()
        configYearlyView()
    }
    
    private func configWeeklyView() {
        let weeklyView: RepeatWeeklyView = RepeatWeeklyView()
        weeklyView.delegate = self
        weeklyView.repeatArr = self.repeatArr
        weeklyView.isHidden = false

        self.view.addSubview(weeklyView)
        weeklyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableViewBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(self.view).offset(-10 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(10 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-10 * AutoSizeScaleX)
        }
        self.weeklyView = weeklyView
    }
    
    private func configMonthlyView() {
        let monthlyBGView: RepeatMonthlyView = RepeatMonthlyView()
        monthlyBGView.isHidden = true
        monthlyBGView.delegate = self
        self.view.addSubview(monthlyBGView)
        self.monthlyBGView = monthlyBGView
        monthlyBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableViewBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(self.view).offset(-10 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(10 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-10 * AutoSizeScaleX)
        }
    }
    
    private func configYearlyView() {
        let yearlyView: RepeatYearlyView = RepeatYearlyView()
        yearlyView.delegate = self
        yearlyView.isHidden = true
        self.view.addSubview(yearlyView)
        yearlyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableViewBGView.snp_bottom).offset(10 * AutoSizeScaleX)
            make.bottom.equalTo(self.view).offset(-10 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(10 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-10 * AutoSizeScaleX)
        }
        self.yearlyView = yearlyView
    }
    
    @objc func tapBackBtnAction(sender: UIButton) {
        if (!(self.getSelectedMonthDays ).isEmpty || !(self.weeklyView.getSelectedWeekes ).isEmpty || !(self.getSelectedYearlyMonthDays ).isEmpty)  {

            if(self.getSelectedFrequency == "Wöchentlich"){
                self.getSelectedFrequency = "Wöchentlich"
            }else if(self.getSelectedFrequency == "Monatlich"){
                self.getSelectedFrequency = "Monatlich"
            }else if (self.getSelectedFrequency == "Jährlich"){
                self.getSelectedFrequency = "Jährlich"
            }
        
        if(self.getSelectedFrequency == "Wöchentlich"){
            if(!(self.weeklyView.getSelectedWeekes ).isEmpty){
             let _ = self.navigationController?.popViewController(animated: true)

            delegate?.sendData(frequency:  self.getSelectedFrequency, weekDaysArray: self.weeklyView.getSelectedWeekes, weekNumberArray: self.weeklyView.repeatArr,getYearMonth: self.getSelectedMonth)
            }else{
                let alert = UIAlertController(title: "Bitte auswählen \(self.getSelectedFrequency)".localized, message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok".localized, style:
                    UIAlertAction.Style.default) {
                       UIAlertAction in
                }
                let cancelAction = UIAlertAction(title: "Abbrechen".localized, style:
                    UIAlertAction.Style.cancel) {
                       UIAlertAction in
                    let _ = self.navigationController?.popViewController(animated: true)

                    }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
                
            }
        }else if(self.getSelectedFrequency == "Monatlich"){
            self.getSelectedMonthDays = StructOperation.glovalVariable.getSelectedMonthArrat;

            if(!(self.getSelectedMonthDays ).isEmpty){
                let _ = self.navigationController?.popViewController(animated: true)
                delegate?.sendData(frequency:  self.getSelectedFrequency, weekDaysArray: self.getSelectedMonthDays.uniqued(), weekNumberArray: self.weeklyView.repeatArr,getYearMonth: self.getSelectedMonth)
            }else{
                let alert = UIAlertController(title: "Bitte auswählen \(self.getSelectedFrequency)".localized, message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok".localized, style:
                    UIAlertAction.Style.default) {
                       UIAlertAction in
                }
                let cancelAction = UIAlertAction(title: "Abbrechen".localized, style:
                    UIAlertAction.Style.cancel) {
                       UIAlertAction in
                    let _ = self.navigationController?.popViewController(animated: true)

                    }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
                
            }

        }else if(self.getSelectedFrequency == "Jährlich"){
            self.getSelectedYearlyMonthDays = StructOperation.glovalVariable.getSelectedMonthArrat;
            self.getSelectedMonth = StructOperation.glovalVariable.getSelectedMonth;
            if(!(self.getSelectedYearlyMonthDays ).isEmpty){
                let _ = self.navigationController?.popViewController(animated: true)
                delegate?.sendData(frequency:  self.getSelectedFrequency, weekDaysArray: self.getSelectedYearlyMonthDays.uniqued(), weekNumberArray: self.weeklyView.repeatArr,getYearMonth: self.getSelectedMonth)
            }else{
                let alert = UIAlertController(title: "Bitte auswählen \(self.getSelectedFrequency)".localized, message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok".localized, style:
                    UIAlertAction.Style.default) {
                       UIAlertAction in
                }
                let cancelAction = UIAlertAction(title: "Abbrechen".localized, style:
                    UIAlertAction.Style.cancel) {
                       UIAlertAction in
                    let _ = self.navigationController?.popViewController(animated: true)

                    }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
                
            }

        }else{
            let alert = UIAlertController(title: "Bitte auswählen \(self.getSelectedFrequency)".localized, message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok".localized, style:
                UIAlertAction.Style.default) {
                   UIAlertAction in
            }
            let cancelAction = UIAlertAction(title: "Abbrechen".localized, style:
                UIAlertAction.Style.cancel) {
                   UIAlertAction in
                let _ = self.navigationController?.popViewController(animated: true)

                }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
        }

        }else{
//            UIApplication.shared.showAlertWith(title: "Bitte auswählen \(self.getSelectedFrequency)".localized, message: "")
            let alert = UIAlertController(title: "Bitte auswählen \(self.getSelectedFrequency)".localized, message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok".localized, style:
                UIAlertAction.Style.default) {
                   UIAlertAction in
            }
            let cancelAction = UIAlertAction(title: "Abbrechen".localized, style:
                UIAlertAction.Style.cancel) {
                   UIAlertAction in
                let _ = self.navigationController?.popViewController(animated: true)

                }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
    }

}
extension RepeatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RepeatDateCellType.AllType.rawValue
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView_Height / 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: self.cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: self.cellID)
        }
        if(self.getSelectedFrequency == "Wöchentlich"){
            selectedRow = 0
            self.getSelectedFrequency = "Wöchentlich"
            self.weeklyView.isHidden = false
            self.weeklyView.tableView.isHidden = false
            self.monthlyBGView.isHidden = true
            self.yearlyView.isHidden = true
            self.yearlyView.calendarView.removeFromSuperview()
            self.monthlyBGView.calendarView.removeFromSuperview()
  
        }else if(self.getSelectedFrequency == "Monatlich"){
            selectedRow = 1
            self.getSelectedFrequency = "Monatlich"
            self.weeklyView.isHidden = true
            self.monthlyBGView.isHidden = false
            self.yearlyView.isHidden = true
            self.yearlyView.calendarView.removeFromSuperview()

        }else if(self.getSelectedFrequency == "Jährlich"){
            selectedRow = 2
            self.getSelectedFrequency = "Jährlich"
            self.weeklyView.isHidden = true
            self.monthlyBGView.isHidden = true
            self.yearlyView.isHidden = false
            self.monthlyBGView.calendarView.removeFromSuperview()

        }
        if(self.getSelectedFrequency == sectionTitleArr[indexPath.row]){
           
            cell?.accessoryType = indexPath.row == selectedRow ? .checkmark : .none
        }else{
            cell?.accessoryType = .none
        }
        if(self.getSelectedFrequency == "weekly"){

        }else if(self.getSelectedFrequency == "monthly"){

        }else if(self.getSelectedFrequency == "yearly"){

        }

        cell?.textLabel?.text = sectionTitleArr[indexPath.row]
        cell?.textLabel?.textColor = UIColor(hexString: "#2B395C")
      

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getSelectedMonth = 7
        let getSelectedData: [Int] = []
        StructOperation.glovalVariable.getSelectedMonth = self.getSelectedMonth
        StructOperation.glovalVariable.getSelectedMonthArrat = getSelectedData
        selectedRow = indexPath.row
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        
        if(sectionTitleArr[indexPath.row] == "Wöchentlich"){
            self.getSelectedFrequency = "Wöchentlich"
            for getDay in self.yearlyView.calendarView.selectedDates
            {
                let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
                let myStringDate = formatter.string(from: getDay)
                    guard let date = formatter.date(from: myStringDate) else {
                        return
                    }
                self.yearlyView.calendarView.deselect(date)
            }
            for getDay in self.monthlyView.calendarView.selectedDates
            {
                let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
                let myStringDate = formatter.string(from: getDay)
                    guard let date = formatter.date(from: myStringDate) else {
                        return
                    }
                self.monthlyView.calendarView.deselect(date)
            }
        }else if(sectionTitleArr[indexPath.row] == "Monatlich"){
            self.getSelectedFrequency = "Monatlich"
            self.weeklyView.repeatArr = [0,0,0,0,0,0,0]
            self.weeklyView.tableView.reloadData()
            self.yearlyView.calendarView.select(self.dateFormatter.date(from: "2023/01/01"))
            for getDay in self.yearlyView.calendarView.selectedDates
            {
                let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
                let myStringDate = formatter.string(from: getDay)
                    guard let date = formatter.date(from: myStringDate) else {
                        return
                    }
                self.yearlyView.calendarView.deselect(date)
                self.yearlyView.calendarView.deselect(self.dateFormatter.date(from: "2023/01/01")!)
            }
            let primes:[Int] = StructOperation.glovalVariable.getSelectedMonthArrat;
            for prime in primes {
                self.yearlyView.calendarView.select(self.dateFormatter.date(from: "2023/01/\(prime)"))
            }
            self.monthlyView.calendarView.select(self.dateFormatter.date(from: "2023/01/01"))
            for getDay in self.monthlyView.calendarView.selectedDates
            {
                let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
                let myStringDate = formatter.string(from: getDay)
                    guard let date = formatter.date(from: myStringDate) else {
                        return
                    }
                self.monthlyView.calendarView.deselect(date)
                self.monthlyView.calendarView.deselect(self.dateFormatter.date(from: "2023/01/01")!)
            }
            self.monthlyView.getOnlyDay()
        }else if(sectionTitleArr[indexPath.row] == "Jährlich"){
            self.getSelectedFrequency = "Jährlich"
            self.weeklyView.repeatArr = [0,0,0,0,0,0,0]
            self.weeklyView.tableView.reloadData()
            self.monthlyView.calendarView.select(self.dateFormatter.date(from: "2023/01/01"))
            for getDay in self.monthlyView.calendarView.selectedDates
            {
                let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
                let myStringDate = formatter.string(from: getDay)
                    guard let date = formatter.date(from: myStringDate) else {
                        return
                    }
                self.monthlyView.calendarView.deselect(date)
                self.monthlyView.calendarView.deselect(self.dateFormatter.date(from: "2023/01/01")!)
            }
            
            self.yearlyView.calendarView.select(self.dateFormatter.date(from: "2023/01/01"))
            for getDay in self.yearlyView.calendarView.selectedDates
            {
                let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
                let myStringDate = formatter.string(from: getDay)
                    guard let date = formatter.date(from: myStringDate) else {
                        return
                    }
                self.yearlyView.calendarView.deselect(date)
                self.yearlyView.calendarView.deselect(self.dateFormatter.date(from: "2023/01/01")!)
            }
            self.yearlyView.getOnlyDay()
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        switch indexPath.row {
        case RepeatDateCellType.Weekly.rawValue:
            self.weeklyView.isHidden = false
            self.weeklyView.tableView.isHidden = false
            self.monthlyBGView.isHidden = true
            self.monthlyBGView.getSelectedMonthDays.removeAll()
            self.yearlyView.getSelectedMonthDays.removeAll()
            self.yearlyView.isHidden = true
            self.yearlyView.calendarView.removeFromSuperview()
            self.monthlyBGView.calendarView.removeFromSuperview()
        case RepeatDateCellType.Monthly.rawValue:
            self.weeklyView.isHidden = true
            self.monthlyBGView.isHidden = false
            self.yearlyView.isHidden = true
            self.yearlyView.calendarView.removeFromSuperview()
            self.yearlyView.getSelectedMonthDays.removeAll()
            self.monthlyBGView.calendarViewfunc()
        case RepeatDateCellType.Yearly.rawValue:
            self.weeklyView.isHidden = true
            self.monthlyBGView.isHidden = true
            self.yearlyView.isHidden = false
            self.monthlyBGView.calendarView.removeFromSuperview()
            self.monthlyBGView.getSelectedMonthDays.removeAll()
            self.yearlyView.calenderView()
            self.yearlyView.getCurrentMonthFun()
        default:
            print("default")
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}


extension RepeatViewController: RepeatWeeklyViewDelegate {
    func selectedRepeatStr(repeatArr: [Int]) {
    }
}
extension RepeatViewController: RepeatMonthlyViewDelegate {
    func selectedMonthlyRepeatStr(repeatArr: [Int]) {
        self.getSelectedMonthDays = repeatArr
    }
}
extension RepeatViewController: RepeatYearlyViewDelegate {
    func selectedYearlyRepeatStr(repeatArr: [Int]) {
        self.getSelectedYearlyMonthDays = repeatArr
        StructOperation.glovalVariable.getSelectedMonthArrat = self.getSelectedYearlyMonthDays
    }
    
    func selectedYearlyRepeatStr(repeatArr: [Int], getMonth: Int) {
        self.getSelectedYearlyMonthDays = repeatArr
        self.getSelectedMonth = getMonth
        StructOperation.glovalVariable.getSelectedMonth = self.getSelectedMonth
        StructOperation.glovalVariable.getSelectedMonthArrat = self.getSelectedYearlyMonthDays
    }
}
