//
//  EditReminderViewController.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/7/13.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
protocol SendDataFromEditDelegte: class {
    func sendData(frequency: String,weekDaysArray :[Int],weekNumberArray :[Int],getYearMonth : Int)
}

class EditReminderViewController: BaseViewController,SendDataFromEditDelegte,SendDataDelegte  {
    
    var titleBGView : UIView = UIView()
    var descriptionBGView : UIView = UIView()
    var timeBGView : UIView = UIView()
    var repeatBGView : UIView = UIView()
    var titleTF : UITextField = UITextField()
    var descriptionTF : UITextField = UITextField()
    var timeRightArrow: UIImageView = UIImageView()
    var timePickerView: UIView = UIView()
    private var isTimePickerOpened: Bool = false
    var date: Date = Date()
    var datePicker: UIDatePicker = UIDatePicker()
    var selectedTimeLab: UILabel = UILabel()
    private var destribeTextView: UITextView = UITextView()
    private let destribeMaxLength = 50
    private var countLab: UILabel = UILabel()
    private var placeholderLabel: UILabel = UILabel()
    var selectedRepeatLab: UILabel = UILabel()
    var getReminder : Reminder?
    var getSelectedData: [Int] = []
    var frequencyStr: String = ""
    var getSelectedMonth : Int = 1
    lazy var repeatArr: [Int] = {
        var arr = [Int]()
        arr = [0,0,0,0,0,0,0]
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.App.TableView.grayBackground
        self.navigationItem.title = "Erinnerung bearbeiten"

        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(notification:)), name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(notification:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing(notification:)), name: UITextView.textDidEndEditingNotification, object: nil)
        
        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(tapBackBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        
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
        nameTF.clearButtonMode = UITextField.ViewMode.always
        nameTF.placeholder = "Titel *"
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
            make.left.right.height.equalTo(titleBGView)
        }

        let destribeTextView: UITextView = UITextView()
        destribeTextView.font = UIFont.appFont(ofSize: 16, weight: .regular)
        destribeTextView.textColor = UIColor(hexString: "#2B395C")
        destribeTextView.text = getReminder?.description
        destribeTextView.delegate = self
        destribeTextView.returnKeyType = .done
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
        
        let countLab: UILabel = UILabel()
        countLab.text = "0/\(self.destribeMaxLength)"
        countLab.textColor = .lightGray
        countLab.font = UIFont.appFont(ofSize: 12 * AutoSizeScaleX, weight: .regular)
        descriptionBGView.addSubview(countLab)
        countLab.snp.makeConstraints { (make) in
            make.top.equalTo(destribeTextView.snp_bottom).offset(-20 * AutoSizeScaleX)
            make.right.equalTo(descriptionBGView)
            make.height.equalTo(20 * AutoSizeScaleX)
            make.width.equalTo(36 * AutoSizeScaleX)
        }
        self.countLab = countLab
        self.countLab.text = "\(self.destribeTextView.text.count)/\(self.destribeMaxLength)"
        
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
        let tapTimeBGBtn: UIButton = UIButton(type: .custom)
        tapTimeBGBtn.addTarget(self, action: #selector(tapTimeBGBtnAction(sender:)), for: .touchUpInside)
        timeBGView.addSubview(tapTimeBGBtn)
        tapTimeBGBtn.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalTo(timeBGView)
        }

        let timeLab: UILabel = UILabel()
        timeLab.textColor = .lightGray
        timeLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        timeLab.text = "Zeit"
        timeLab.textColor = UIColor(hexString: "#2B395C")
        timeLab.textAlignment = .left
        self.timeBGView.addSubview(timeLab)
        timeLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleTF)
            make.width.equalTo(100 * AutoSizeScaleX)
            make.top.bottom.equalTo(self.timeBGView)
        }
        
        let timeRightArrow: UIImageView = UIImageView()
        timeRightArrow.image = UIImage.init(named: "back_Icon")
        self.timeBGView.addSubview(timeRightArrow)
        timeRightArrow.snp.makeConstraints { (make) in
            make.right.equalTo(self.timeBGView).offset(-20 * AutoSizeScaleX)
            make.centerY.equalTo(self.timeBGView)
            make.width.height.equalTo(18 * AutoSizeScaleX)
        }
        self.timeRightArrow = timeRightArrow
        
        let selectedTimeLab: UILabel = UILabel()
        selectedTimeLab.textColor = .lightGray
        selectedTimeLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        selectedTimeLab.text = self.getReminder?.reminderTime
        selectedTimeLab.textAlignment = .right
        self.timeBGView.addSubview(selectedTimeLab)
        self.selectedTimeLab = selectedTimeLab
        selectedTimeLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.timeRightArrow.snp_left).offset(-10 * AutoSizeScaleX)
            make.width.equalTo(100 * AutoSizeScaleX)
            make.top.bottom.equalTo(timeLab)
        }
        
        let timePickerView: UIView = UIView()
        timePickerView.backgroundColor = .white
        timePickerView.layer.cornerRadius = 2 * AutoSizeScaleX
        timePickerView.layer.shadowColor = UIColor.black.cgColor
        timePickerView.layer.shadowOffset = CGSize.zero
        timePickerView.layer.shadowOpacity = 0.12
        timePickerView.layer.shadowRadius = 3
        self.view.addSubview(timePickerView)
        self.timePickerView = timePickerView
        timePickerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeBGView.snp_bottom).offset(0 * AutoSizeScaleX)
            make.left.right.equalTo(titleBGView)
            make.height.equalTo(0 * AutoSizeScaleX)
        }
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.date = self.date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        timePickerView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.top.bottom.right.left.equalTo(timePickerView)
        }
        self.datePicker = datePicker
        
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
            make.top.equalTo(self.timePickerView.snp_bottom).offset(16 * AutoSizeScaleX)
            make.left.right.height.equalTo(titleBGView)
        }
        
        let tapRepeatBGBtn: UIButton = UIButton(type: .custom)
        tapRepeatBGBtn.addTarget(self, action: #selector(tapRepeatBGBtnAction(sender:)), for: .touchUpInside)
        repeatBGView.addSubview(tapRepeatBGBtn)
        tapRepeatBGBtn.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalTo(repeatBGView)
        }
        
        let repeatLab: UILabel = UILabel()
        repeatLab.textColor = .lightGray
        repeatLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
        repeatLab.text = "Wiederholen"
        repeatLab.textColor = UIColor(hexString: "#2B395C")
        repeatLab.textAlignment = .left
        self.repeatBGView.addSubview(repeatLab)
        repeatLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleTF)
            make.width.equalTo(100 * AutoSizeScaleX)
            make.top.bottom.equalTo(self.repeatBGView)
        }
        
        let repeatRightArrow: UIImageView = UIImageView()
        repeatRightArrow.image = UIImage.init(named: "back_Icon")
        self.repeatBGView.addSubview(repeatRightArrow)
        repeatRightArrow.snp.makeConstraints { (make) in
            make.right.equalTo(self.repeatBGView).offset(-20 * AutoSizeScaleX)
            make.centerY.equalTo(self.repeatBGView)
            make.width.height.equalTo(18 * AutoSizeScaleX)
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
        selectedRepeatLab.textAlignment = .right
        self.repeatBGView.addSubview(selectedRepeatLab)
        self.selectedRepeatLab = selectedRepeatLab
        selectedRepeatLab.snp.makeConstraints { (make) in
            make.right.equalTo(repeatRightArrow.snp_left).offset(-10 * AutoSizeScaleX)
            make.width.equalTo(100 * AutoSizeScaleX)
            make.top.bottom.equalTo(repeatLab)
        }
        
        
        
        let deleteReminderBtn: UIButton = UIButton(type: .custom)
        deleteReminderBtn.setTitleColor(UIColor(hexString: "#FF0000"), for: .normal)
        deleteReminderBtn.setTitle( "Erinnerung löschen", for: .normal)
        deleteReminderBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        deleteReminderBtn.layer.borderWidth = 1 * AutoSizeScaleX
        deleteReminderBtn.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
        deleteReminderBtn.layer.shadowColor = UIColor.black.cgColor
        deleteReminderBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        deleteReminderBtn.layer.shadowOpacity = 0.12
        deleteReminderBtn.layer.shadowRadius = 3
        deleteReminderBtn.addTarget(self, action: #selector(deleteReminderBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(deleteReminderBtn)
        deleteReminderBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let cancleBtn: UIButton = UIButton(type: .custom)
        cancleBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        cancleBtn.setTitle( "Abbrechen", for: .normal)
        cancleBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        cancleBtn.layer.borderWidth = 1 * AutoSizeScaleX
        cancleBtn.layer.borderColor = UIColor(hexString: "#3868F6").cgColor
        cancleBtn.layer.shadowColor = UIColor.black.cgColor
        cancleBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        cancleBtn.layer.shadowOpacity = 0.12
        cancleBtn.layer.shadowRadius = 3
        cancleBtn.addTarget(self, action: #selector(cancelReminderBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(deleteReminderBtn.snp_top).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let saveBtn: UIButton = UIButton(type: .custom)
        saveBtn.backgroundColor = UIColor(hexString: "#3868F6")
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.setTitle( "Änderungen speichern", for: .normal)
        saveBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        saveBtn.addTarget(self, action: #selector(saveReminderBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(cancleBtn.snp_top).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        if(self.selectedRepeatLab.text == "Wöchentlich"){
        for getvalue in self.getSelectedData{
            if(getvalue == 1){
                self.repeatArr[getvalue] = 1
            }else if(getvalue == 2){
                self.repeatArr[getvalue] = 1
            }else if(getvalue == 3){
                self.repeatArr[getvalue] = 1
            }else if(getvalue == 4){
                self.repeatArr[getvalue] = 1
            }else if(getvalue == 5){
                self.repeatArr[getvalue] = 1
            }else if(getvalue == 6){
                self.repeatArr[getvalue] = 1
            }else if(getvalue == 0){
                self.repeatArr[getvalue] = 1
            }
        }
        }
    }
    
    func sendData(frequency: String, weekDaysArray: [Int], weekNumberArray: [Int], getYearMonth: Int) {
        self.getSelectedData = weekDaysArray
        self.repeatArr = weekNumberArray
        self.selectedRepeatLab.text = frequency
        self.getSelectedMonth = getYearMonth
        self.repeatArr = weekNumberArray
    }
    
    @objc func deleteReminderBtnAction(sender: UIButton) {
        let alert = UIAlertController(title: "Erinnerung löschen", message: "Sind Sie sicher, dass Sie diese Erinnerung löschen möchten?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Löschen", style:
            UIAlertAction.Style.default) {

               UIAlertAction in
            ApplicationDelegate.client.deleteReminder(reminderID: self.getReminder!.hashValue) { [self] message in
                guard let message = message else { return }
                self.alterView(getMessage: message)
            }
        }
        let cancelAction = UIAlertAction(title: "Abbrechen", style:
            UIAlertAction.Style.cancel) {
               UIAlertAction in
            }
        // Add the actions
        okAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alterView(getMessage : String){
        let alert = UIAlertController(title: getMessage, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: ListOfRemindersViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
            }))

            self.present(alert, animated: true, completion: {
            })
    }
    @objc func cancelReminderBtnAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
          sender.backgroundColor = UIColor(hexString: "#1E4199")
            sender.setTitleColor(UIColor.white, for: .normal)
           }
        else{
            sender.backgroundColor = UIColor.white
            sender.setTitleColor(UIColor(hexString: "#1E4199"), for: .normal)
         }
        self.navigationController?.popViewController(animated: true)
    }
    @objc func saveReminderBtnAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
          sender.backgroundColor = UIColor(hexString: "#1E4199")
            sender.setTitleColor(UIColor.white, for: .normal)
           }
        else{
            sender.backgroundColor = UIColor.white
            sender.setTitleColor(UIColor(hexString: "#1E4199"), for: .normal)
         }
        var results : [[String: Any]] = [[String: Any]]()

        if(self.selectedRepeatLab.text == "Wöchentlich"){
            for (i, content) in self.getSelectedData.uniqued().enumerated() {
                results.append(["day_of_month": "","reminder_month": "","week_day": content])
                }
            client.editReminderNew(title: self.titleTF.text!, description: self.destribeTextView.text, time: self.selectedTimeLab.text!, frequency: "weekly", weekDays: results,reminderID: getReminder!.hashValue){ message in
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                        for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: ListOfRemindersViewController.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                    }))
                    self.present(alert, animated: true, completion: {
                    })
                let controller = ListOfRemindersViewController()
                self.navigationController?.pushAndHideTabBar(controller)
            }
        }else if(self.selectedRepeatLab.text == "Monatlich"){
            for (i, content) in self.getSelectedData.uniqued().enumerated() {
                results.append(["day_of_month": content,"reminder_month": "","week_day": ""])
                }
            client.editReminderNew(title: self.titleTF.text!, description: self.destribeTextView.text, time: self.selectedTimeLab.text!, frequency:"monthly", weekDays: results,reminderID: getReminder!.hashValue){ message in
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                        for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: ListOfRemindersViewController.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                    }))
                    self.present(alert, animated: true, completion: {
                    })
            }
        }else if(self.selectedRepeatLab.text == "Jährlich"){
            for (i, content) in self.getSelectedData.uniqued().enumerated() {
                results.append(["day_of_month": content,"reminder_month": self.getSelectedMonth,"week_day": ""])
                }
            client.editReminderNew(title: self.titleTF.text!, description: self.destribeTextView.text, time: self.selectedTimeLab.text!, frequency: "yearly", weekDays: results,reminderID: getReminder!.hashValue){ message in
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                        for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: ListOfRemindersViewController.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                    }))
                    self.present(alert, animated: true, completion: {
                    })
            }
        }
    }
    
    @objc func tapRepeatBGBtnAction(sender: UIButton) {
        let controller = RepeatViewController()
        controller.delegateEdit = self
        controller.delegate = self
        controller.getSelectedFrequency = self.selectedRepeatLab.text!
        controller.repeatArr = self.repeatArr
        controller.delegate = self
        controller.monthlyView.getSelectedData = getSelectedData
        controller.selectedMonthDays = getSelectedData
        controller.yearlyView.getAlreadyselectedMonth = self.getSelectedMonth
        StructOperation.glovalVariable.getSelectedMonth = self.getSelectedMonth
        StructOperation.glovalVariable.getSelectedMonthArrat = self.getSelectedData
        self.navigationController?.pushAndHideTabBar(controller)
    }
        @objc func tapTimeBGBtnAction(sender: UIButton) {
        guard let button = sender as? UIButton else { return }
        if !button.isSelected {
            button.isSelected = true

            UIView.animate(withDuration: 0.3) {
                self.timeRightArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                self.timePickerView.snp.updateConstraints { make in
                    make.height.equalTo(160 * AutoSizeScaleX)
                }
                self.repeatBGView.snp.updateConstraints { make in
                    make.top.equalTo(self.timePickerView.snp_bottom).offset(6 * AutoSizeScaleX)
                }
            }
        }
        else {
            button.isSelected = false

            UIView.animate(withDuration: 0.3) {
                self.timeRightArrow.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                self.timePickerView.snp.updateConstraints { make in
                    make.height.equalTo(0 * AutoSizeScaleX)
                }
                self.repeatBGView.snp.updateConstraints { make in
                    make.top.equalTo(self.timePickerView.snp_bottom).offset(20 * AutoSizeScaleX)
                }
            }
        }
    }
    
    @objc func datePickerValueChanged() {
        self.selectedTimeLab.text = String.getTimeFromDate(date: self.datePicker.date)
    }
    
    @objc func tapBackBtnAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - TextView Notifications

    @objc func textViewDidChange(notification: Notification) {
        placeholderLabel.isHidden = !self.destribeTextView.text.isEmpty

        if self.destribeTextView.markedTextRange == nil {
            if self.destribeTextView.text.count > self.destribeMaxLength {
                self.destribeTextView.text = self.destribeTextView.text.subStringTo(index: self.destribeMaxLength - 1)
            }
            self.countLab.text = "\(self.destribeTextView.text.count)/\(self.destribeMaxLength)"
        }
    }
    
    @objc func textViewDidBeginEditing(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (isFinish) in
                if isFinish && !self.destribeTextView.isFirstResponder {
                    NotificationCenter.default.post(name: UITextView.textDidEndEditingNotification, object: self.destribeTextView)
                }
            })
        }
    }
    
    @objc func textViewDidEndEditing(notification: Notification) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }


}

extension EditReminderViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputModeStr = textView.textInputMode?.primaryLanguage
        if inputModeStr == TextInputModeStr && (textView.selectedTextRange?.start == textView.endOfDocument) && self.destribeMaxLength == textView.text?.count {
            return false
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension EditReminderViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
}
