//
//  ViewReminderViewController.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/7/11.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit


class ViewReminderViewController: BaseViewController{
 
    var getReminder : Reminder?
    var titleBGView : UIView = UIView()
    var descriptionBGView : UIView = UIView()
    var timeBGView : UIView = UIView()
    var repeatBGView : UIView = UIView()
    var titleTF : UITextField = UITextField()
    private var destribeTextView: UITextView = UITextView()
    private let destribeMaxLength = 50
    private var countLab: UILabel = UILabel()
    private var placeholderLabel: UILabel = UILabel()
    var descriptionTF : UITextField = UITextField()
    var timeRightArrow: UIImageView = UIImageView()
    var timePickerView: UIView = UIView()
    private var isTimePickerOpened: Bool = false
    var date: Date = Date()
    var datePicker: UIDatePicker = UIDatePicker()
    var selectedTimeLab: UILabel = UILabel()
    var monthBgView: UIView = UIView()
    var getRepeatStr: String?
    let monthlyArray: Array = [ "3", "4", "6","23"]
    var repeatStr: String = ""
    private var collectionView: UICollectionView!
    let list = [["Tue", "Wed","Fri"]]
    var cellHeight: CGFloat = 0
    let cellID = "cellID"
    var reminderOccurlab : UILabel = UILabel()
    var reminderMonthLab : UILabel = UILabel()
    var getReminderItems: Items!
    var getSelectedData: [Int] = []
    var getSelectedMonthDay: [Int] = []

    var getSelectedMonth: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Erinnerung ansehen"

        view.backgroundColor = UIColor.App.TableView.grayBackground
        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(tapBackBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        
        let editBtn =  UIButton(type: .custom)
        editBtn.setTitle("Bearbeiten", for: .normal)
        editBtn.addTarget(self, action: #selector(tapEditBtnAction(sender:)), for: .touchUpInside)
        editBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        editBtn.sizeToFit()
        let barEditButton = UIBarButtonItem(customView: editBtn)
        navigationItem.rightBarButtonItem = barEditButton
        
        let titleBGView: UIView = UIView()
        titleBGView.backgroundColor = .white
        titleBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        titleBGView.layer.shadowColor = UIColor.black.cgColor
        titleBGView.layer.shadowOffset = CGSize.zero
        titleBGView.layer.shadowOpacity = 0.12
        titleBGView.layer.shadowRadius = 3
        self.view.addSubview(titleBGView)
        self.titleBGView = titleBGView
        titleBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let nameTF: UITextField = UITextField()
        nameTF.placeholder = "Titel *"
        nameTF.textAlignment = .center
        nameTF.isUserInteractionEnabled = false
        nameTF.text = self.getReminder?.title
        nameTF.textColor = UIColor(hexString: "#2B395C")
        titleBGView.addSubview(nameTF)
        titleTF = nameTF
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(titleBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(titleBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(titleBGView)
        }
        
        let descriptionBGView: UIView = UIView()
        descriptionBGView.backgroundColor = .white
        descriptionBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        descriptionBGView.layer.shadowColor = UIColor.black.cgColor
        descriptionBGView.layer.shadowOffset = CGSize.zero
        descriptionBGView.layer.shadowOpacity = 0.12
        descriptionBGView.layer.shadowRadius = 3
        self.view.addSubview(descriptionBGView)
        self.descriptionBGView = descriptionBGView
        descriptionBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleBGView.snp_bottom).offset(16 * AutoSizeScaleX)
            make.left.right.equalTo(titleBGView)
            make.height.equalTo(70 * AutoSizeScaleX)
        }

        let destribeTextView: UITextView = UITextView()
        destribeTextView.font = UIFont.appFont(ofSize: 16, weight: .regular)
        destribeTextView.textColor = UIColor(hexString: "#2B395C")
        destribeTextView.textAlignment = .center
        destribeTextView.isUserInteractionEnabled = false
        destribeTextView.returnKeyType = .done
        destribeTextView.text = self.getReminder?.description
        destribeTextView.font = .systemFont(ofSize: 16)
        descriptionBGView.addSubview(destribeTextView)
        destribeTextView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.titleTF)
            make.top.equalTo(self.descriptionBGView).offset(4 * AutoSizeScaleX)
            make.bottom.equalTo(self.descriptionBGView)
        }
        self.destribeTextView = destribeTextView

        placeholderLabel = UILabel()
        placeholderLabel.text = "Beschreibung..."
        placeholderLabel.sizeToFit()
        self.destribeTextView.addSubview(placeholderLabel)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.isHidden = !destribeTextView.text.isEmpty
        placeholderLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.destribeTextView)
            make.left.equalTo(4 * AutoSizeScaleX)
             make.height.equalTo(self.destribeTextView)
            make.centerY.equalTo(self.destribeTextView).offset(-4 * AutoSizeScaleX)
        }
        
        let timeBGView: UIView = UIView()
        timeBGView.backgroundColor = .white
        timeBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        timeBGView.layer.shadowColor = UIColor.black.cgColor
        timeBGView.layer.shadowOffset = CGSize.zero
        timeBGView.layer.shadowOpacity = 0.12
        timeBGView.layer.shadowRadius = 3
        self.view.addSubview(timeBGView)
        self.timeBGView = timeBGView
        timeBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionBGView.snp_bottom).offset(16 * AutoSizeScaleX)
            make.left.right.height.equalTo(titleBGView)
        }

        let selectedTimeLab: UILabel = UILabel()
        selectedTimeLab.textColor = .lightGray
        selectedTimeLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        selectedTimeLab.text = self.getReminder?.reminderTime
        selectedTimeLab.isUserInteractionEnabled = false
        selectedTimeLab.textColor = UIColor(hexString: "#2B395C")
        selectedTimeLab.textAlignment = .center
        self.timeBGView.addSubview(selectedTimeLab)
        self.selectedTimeLab = selectedTimeLab
        selectedTimeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.titleTF)
            make.top.bottom.equalTo(self.timeBGView)
        }

        let repeatBGView: UIView = UIView()
        repeatBGView.backgroundColor = .white
        repeatBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        repeatBGView.layer.shadowColor = UIColor.black.cgColor
        repeatBGView.layer.shadowOffset = CGSize.zero
        repeatBGView.layer.shadowOpacity = 0.12
        repeatBGView.layer.shadowRadius = 3
        self.view.addSubview(repeatBGView)
        self.repeatBGView = repeatBGView
        repeatBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeBGView.snp_bottom).offset(16 * AutoSizeScaleX)
            make.left.right.height.equalTo(titleBGView)
        }

        let selectedRepeatLab: UILabel = UILabel()
        selectedRepeatLab.textColor = .lightGray
        selectedRepeatLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        if(self.getReminder?.frequency == "weekly"){
            selectedRepeatLab.text = "Wöchentlich"
        }else if(self.getReminder?.frequency == "monthly"){
            selectedRepeatLab.text = "Monatlich"
        }else if(self.getReminder?.frequency == "yearly"){
            selectedRepeatLab.text = "Jährlich"
        }
        selectedRepeatLab.textColor = UIColor(hexString: "#2B395C")
        selectedRepeatLab.textAlignment = .center
        self.repeatBGView.addSubview(selectedRepeatLab)
        selectedRepeatLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.titleTF)
            make.top.bottom.equalTo(self.repeatBGView)
        }
        self.getRepeatStr = self.getReminder?.frequency

        let monthBgView: UIView = UIView()
        monthBgView.backgroundColor = UIColor.App.TableView.grayBackground
        monthBgView.layer.cornerRadius = 6 * AutoSizeScaleX
        monthBgView.layer.borderWidth = 1 * AutoSizeScaleX
        monthBgView.layer.borderColor = UIColor.lightGray.cgColor
        monthBgView.layer.shadowColor = UIColor.black.cgColor
        monthBgView.layer.shadowOffset = CGSize.zero
        monthBgView.layer.shadowOpacity = 0.12
        monthBgView.layer.shadowRadius = 3
        self.view.addSubview(monthBgView)
        self.monthBgView = monthBgView
        monthBgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.repeatBGView.snp_bottom).offset(12 * AutoSizeScaleX)
            make.height.equalTo(40 * AutoSizeScaleX)
            make.width.equalTo(80 * AutoSizeScaleX)
            make.centerX.equalTo(self.view)
        }
        
        let reminderMonthLab: UILabel = UILabel()
        reminderMonthLab.textColor = UIColor(hexString: "#2B395C")
        reminderMonthLab.textAlignment = .center
        reminderMonthLab.sizeToFit()
        reminderMonthLab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        self.monthBgView.addSubview(reminderMonthLab)
        self.reminderMonthLab = reminderMonthLab
        reminderMonthLab.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(monthBgView)
        }
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 50 * AutoSizeScaleX, height: 50 * AutoSizeScaleX)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.App.TableView.grayBackground

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ViewReminderCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
        if (self.getRepeatStr == "yearly"){
            collectionView.snp.makeConstraints { (make) in
                make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
                make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
                make.top.equalTo(self.monthBgView.snp_bottom).offset(5 * AutoSizeScaleX)
                make.height.equalTo(240 * AutoSizeScaleX)
            }
        }else{
            collectionView.snp.makeConstraints { (make) in
                make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
                make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
                make.top.equalTo(self.repeatBGView.snp_bottom).offset(5 * AutoSizeScaleX)
                make.height.equalTo(240 * AutoSizeScaleX)
            }
        }

        
        let reminderOccurlab: UILabel = UILabel()
        reminderOccurlab.text = "Eine Erinnerung erfolgt jeden \(self.monthlyArray.joined())\n"
        reminderOccurlab.textColor = .lightGray
        reminderOccurlab.textAlignment = .left
        reminderOccurlab.numberOfLines = 0
        reminderOccurlab.sizeToFit()
        reminderOccurlab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        self.view.addSubview(reminderOccurlab)
        self.reminderOccurlab = reminderOccurlab
        reminderOccurlab.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-16 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(16 * AutoSizeScaleX)
            make.height.equalTo(80 * AutoSizeScaleX)
            make.top.equalTo(self.collectionView.snp_bottom)
        }
        
        if(self.getRepeatStr == "weekly"){
            for value in self.getReminder!.items {
                getReminderItems = value
                self.getSelectedMonthDay.append(getReminderItems.week_day!)
                self.getSelectedMonthDay.sort()
            }
            var getDatee = ""
            for value in self.getSelectedMonthDay {
                if(value  == 6){
                    getDatee = "Sonntag "
                }else if(value  == 0){
                    getDatee = "Montag "
                }else if(value  == 1){
                    getDatee = "Dienstag "
                }else if(value  == 2){
                    getDatee = "Mittwoch "
                }else if(value  == 3){
                    getDatee = "Donnerstag "
                }else if(value  == 4){
                    getDatee = "Freitag "
                }else if(value  == 5){
                    getDatee = "Samstag "
                }
                let getFinalDatee = "  \(getDatee)"
               self.repeatStr.append(getFinalDatee)
            }
            let splitStringArray = self.repeatStr.split(separator: " ").map({ (substring) in
            return String(substring) })
            let completeURL = "Eine Erinnerung erfolgt jeden \(splitStringArray.joinedWithComma())."
            self.reminderOccurlab.text = completeURL
            if(self.getReminder!.items.count<1){
                self.reminderOccurlab.isHidden = true
                self.reminderMonthLab.isHidden = true
                self.monthBgView.isHidden = true
            }else{
                self.reminderOccurlab.text = completeURL
            }
            
        }else if (self.getRepeatStr == "monthly"){
            for value in self.getReminder!.items {
                getReminderItems = value
                self.getSelectedMonthDay.append(getReminderItems.day_of_month!)
                self.getSelectedMonthDay.sort()
            }
            var completeURL = ""
            for value in self.getSelectedMonthDay
            {
                var getDatee = " \(String(value.ordinal)),"
                if value == self.getSelectedMonthDay.uniqued().last {
                    getDatee = "und \(String(value)),"
                    }
                if value == self.getSelectedMonthDay.uniqued().first {
                    getDatee = " \(String(value)),"
                    }
                self.repeatStr.append(getDatee)
                var finalWeekStr = self.repeatStr
                if(finalWeekStr.count > 12){
                    finalWeekStr.removeLast()
                }
                completeURL  = "Eine Erinnerung erfolgt monatlich am \(self.getSelectedMonthDay.map(String.init).joinedWithComma())."
                self.reminderOccurlab.text = completeURL
            }
            if(self.getReminder!.items.count<1){
                self.reminderOccurlab.isHidden = true
                self.reminderMonthLab.isHidden = true
                self.monthBgView.isHidden = true
            }else{
                self.reminderOccurlab.text = completeURL
            }
        }else if (self.getRepeatStr == "yearly"){
            var getMonth = ""
            for value in self.getReminder!.items {
                getReminderItems = value
                self.getSelectedMonthDay.append(getReminderItems.day_of_month!)
                self.getSelectedMonthDay.sort()
            }
            for value in self.getSelectedMonthDay{
                var getDatee = " \(String(value.ordinal)),"
                if value == self.getSelectedMonthDay.uniqued().last {
                    getDatee = "und \(String(value)),"
                    }
                if value == self.getSelectedMonthDay.uniqued().first {
                    getDatee = " \(String(value)),"
                    }
                self.repeatStr.append(getDatee)
                var finalWeekStr = self.repeatStr
                if(finalWeekStr.count > 12){
                    finalWeekStr.removeLast()
                }

                    if(getReminderItems.reminder_month  == 1){
                        getMonth = "Januar"
                    }else if(getReminderItems.reminder_month  == 2){
                        getMonth = "Februar"
                    }else if(getReminderItems.reminder_month  == 3){
                        getMonth = "März"
                    }else if(getReminderItems.reminder_month  == 4){
                        getMonth = "April"
                    }else if(getReminderItems.reminder_month  == 5){
                        getMonth = "May"
                    }else if(getReminderItems.reminder_month  == 6){
                        getMonth = "Juni"
                    }else if(getReminderItems.reminder_month  == 7){
                        getMonth = "Juli"
                    }else if(getReminderItems.reminder_month  == 8){
                        getMonth = "August"
                    }else if(getReminderItems.reminder_month  == 9){
                        getMonth = "September"
                    }else if(getReminderItems.reminder_month  == 10){
                        getMonth = "Oktober"
                    }else if(getReminderItems.reminder_month  == 11){
                        getMonth = "November"
                    }else if(getReminderItems.reminder_month  == 12){
                        getMonth = "Dezember"
                    }
                self.getSelectedMonth = getReminderItems.reminder_month ?? 0
            }

            let stringArray = self.getSelectedMonthDay.map(String.init)
            let completeURL = "Eine Erinnerung erfolgt jeden Jahr in \(getMonth) auf der \(stringArray.joinedWithComma())."
                if(self.getReminder!.items.count<1){
                self.reminderOccurlab.isHidden = true
                self.reminderMonthLab.isHidden = true
                self.monthBgView.isHidden = true
            }else{
                self.reminderOccurlab.text = completeURL
                self.reminderMonthLab.text = getMonth
            }
        }
    }
    
    func createButtons(named: [String]) -> [UIButton]{
       return named.map { letter in
         let button = UIButton()
         button.translatesAutoresizingMaskIntoConstraints = false
         button.setTitle(letter, for: .normal)
         button.backgroundColor = .green
         button.setTitleColor( .blue , for: .normal)
         return button
       }
    }

    @objc
    private func showMoreSection() {
        let controller = EditReminderViewController()
        controller.getReminder = self.getReminder;
        navigationController?.pushAndHideTabBar(controller)
    }
    
    @objc func tapBackBtnAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapEditBtnAction(sender: UIButton){
               
        if(self.getReminder?.type == "default"){
            UIApplication.shared.showAlertWith(title: "Sie haben keinen Zugriff zum Bearbeiten dieser Erinnerung".localized,
                                               message: "")
        }else{
            let controller = EditReminderViewController()
            controller.getReminder = self.getReminder
            controller.getSelectedData = self.getSelectedData
            controller.getSelectedMonth = self.getSelectedMonth
            self.navigationController?.pushAndHideTabBar(controller)
        }
    }

    
    @objc func datePickerValueChanged() {
        self.selectedTimeLab.text = String.getTimeFromDate(date: self.datePicker.date)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        if (self.getRepeatStr == "yearly"){
            collectionView.snp.makeConstraints { (make) in
                make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
                make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
                make.top.equalTo(self.monthBgView.snp_bottom).offset(5 * AutoSizeScaleX)
                make.height.equalTo(height * AutoSizeScaleX)
            }
        }else{
            collectionView.snp.makeConstraints { (make) in
                make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
                make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
                make.top.equalTo(self.repeatBGView.snp_bottom).offset(5 * AutoSizeScaleX)
                make.height.equalTo(height * AutoSizeScaleX)
            }
        }
        self.view.layoutIfNeeded()
    }
}

extension ViewReminderViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getSelectedMonthDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ViewReminderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ViewReminderCollectionViewCell
        getReminderItems = self.getReminder!.items[indexPath.row]
        if(self.getRepeatStr == "weekly"){
            var getDatee = ""
            if(self.getSelectedMonthDay[indexPath.row]  == 6){
                getDatee = "So"
            }else if(self.getSelectedMonthDay[indexPath.row]  == 0){
                getDatee = "Mo"
            }else if(self.getSelectedMonthDay[indexPath.row]  == 1){
                getDatee = "Di"
            }else if(self.getSelectedMonthDay[indexPath.row]  == 2){
                getDatee = "Mi"
            }else if(self.getSelectedMonthDay[indexPath.row]  == 3){
                getDatee = "Do"
            }else if(self.getSelectedMonthDay[indexPath.row]  == 4){
                getDatee = "Fr"
            }else if(self.getSelectedMonthDay[indexPath.row]  == 5){
                getDatee = "Sa"
            }
            let getFinalDatee = "\(getDatee)"
            self.getSelectedData.append(self.getSelectedMonthDay[indexPath.row])
            cell.lab.text = getFinalDatee
            
        }else if (self.getRepeatStr == "monthly"){
            cell.lab.text = "\(self.getSelectedMonthDay[indexPath.row])"
            self.getSelectedData.append(self.getSelectedMonthDay[indexPath.row])
        }else if (self.getRepeatStr == "yearly"){
            cell.lab.text = "\(self.getSelectedMonthDay[indexPath.row])"
            self.getSelectedData.append(self.getSelectedMonthDay[indexPath.row])
        }
        return cell
    }
        
    func displayReminderText(){

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth: CGFloat = flowLayout.itemSize.width
        let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
        var cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
        var collectionWidth = collectionView.frame.size.width
        var totalWidth: CGFloat
        if #available(iOS 11.0, *) {
            collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        }
        repeat {
            totalWidth = cellWidth * cellCount + cellSpacing * (cellCount - 1)
            cellCount -= 1
        } while totalWidth >= collectionWidth

        if (totalWidth > 0) {
            let edgeInset = (collectionWidth - totalWidth) / 2
            return UIEdgeInsets.init(top: flowLayout.sectionInset.top, left: edgeInset, bottom: flowLayout.sectionInset.bottom, right: edgeInset)
        } else {
            return flowLayout.sectionInset
        }
    }
}
extension ViewReminderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(list.count == 0){
            self.cellHeight = 80
        }else if(list.count == 1){
            self.cellHeight = 140
        }else if(list.count == 2){
            self.cellHeight = 160
        }
        return self.cellHeight * AutoSizeScaleX
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ViewReminderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? ViewReminderTableViewCell
        if cell == nil {
            cell = ViewReminderTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        return cell!
    }


}
extension Int {
    var ordinal: String {
        get {
            var suffix = "th"
            switch self % 10 {
                case 1:
                    suffix = "st"
                case 2:
                    suffix = "nd"
                case 3:
                    suffix = "rd"
                default: ()
            }
            if 10 < (self % 100) && (self % 100) < 20 {
                suffix = "th"
            }
            return String(self) + suffix
        }
    }
}

extension Array where Iterator.Element == String {
    func joinedWithCommaInt(useOxfordComma: Bool = false, maxItemCount: Int = -1) -> String {
        let result: String
        if maxItemCount >= 0 && count > maxItemCount {
            result = self[0 ..< maxItemCount].joined(separator: ", ") + ", etc"
        } else if count >= 2 {
            let lastIndex = count - 1
            let extraComma = (useOxfordComma && count > 2) ? "," : ""
            result = self[0 ..< lastIndex].joined(separator: ", ") + extraComma + " und " + self[lastIndex]
        } else if count == 1 {
            result = self[0]
        } else {
            result = ""
        }

        return result
    }
}
