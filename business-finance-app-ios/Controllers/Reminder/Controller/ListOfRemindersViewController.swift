//
//  ListOfRemindersViewController.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/6/20.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import SnapKit
import ANActivityIndicator
import Alamofire
class ListOfRemindersViewController:  BaseViewController {
    private var reminders: [Reminder] = []
    var tableView: UITableView!
    var getTurnONOFFNotificationStr : String = ""
    var getReminderItems: Items!
    var getSelectedData: [Int] = []
    var getSelectedMonth: Int = 1
    var getReminder : Reminder?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Erinnerungen"
        view.backgroundColor = UIColor.App.TableView.grayBackground

        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(tapBackBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        
        let headerView: UIView = UIView(frame: CGRect(x: 0.0, y: 80.0, width: Screen_Width, height: 7 * AutoSizeScaleX))
        let footerView: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Screen_Width, height: 7 * AutoSizeScaleX))

        let topBGView: UIView = UIView()
        topBGView.backgroundColor = .white
        view.addSubview(topBGView)
        topBGView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(120 * AutoSizeScaleX)
        }

        let createReminderBtn: UIButton = UIButton(type: .custom)
        createReminderBtn.backgroundColor = UIColor(hexString: "#3868F6")
        createReminderBtn.setTitleColor(.white, for: .normal)
        createReminderBtn.setTitle( "Neue Erinnerung einrichten", for: .normal)
        createReminderBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        createReminderBtn.layer.shadowColor = UIColor.black.cgColor
        createReminderBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        createReminderBtn.layer.shadowOpacity = 0.12
        createReminderBtn.layer.shadowRadius = 3
        createReminderBtn.addTarget(self, action: #selector(createReminderBtnAction(sender:)), for: .touchUpInside)
        topBGView.addSubview(createReminderBtn)
        createReminderBtn.snp.makeConstraints { (make) in
            make.right.equalTo(topBGView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(topBGView).offset(20 * AutoSizeScaleX)
            make.top.equalTo(20 * AutoSizeScaleX)
            make.height.equalTo(56 * AutoSizeScaleX)
        }
        
        let yourReminderlab: UILabel = UILabel()
        yourReminderlab.text = "Ihre Erinnerungen"
        yourReminderlab.textAlignment = .center
        yourReminderlab.font = .systemFont(ofSize: 12 * AutoSizeScaleX, weight: .regular)
        topBGView.addSubview(yourReminderlab)
        yourReminderlab.snp.makeConstraints { (make) in
            make.centerX.equalTo(topBGView)
            make.width.equalTo(100 * AutoSizeScaleX)
            make.height.equalTo(10 * AutoSizeScaleX)
            make.bottom.equalTo(topBGView.snp_bottom).offset(-2 * AutoSizeScaleX)
        }
        
        let leftSeparateLineLab: UILabel = UILabel()
        leftSeparateLineLab.backgroundColor = .lightGray
        topBGView.addSubview(leftSeparateLineLab)
        leftSeparateLineLab.snp.makeConstraints { (make) in
            make.left.equalTo(topBGView).offset(10 * AutoSizeScaleX)
            make.right.equalTo(yourReminderlab.snp_left).offset(-6 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
            make.centerY.equalTo(yourReminderlab)
        }
        
        let rightSeparateLineLab: UILabel = UILabel()
        rightSeparateLineLab.backgroundColor = .lightGray
        topBGView.addSubview(rightSeparateLineLab)
        rightSeparateLineLab.snp.makeConstraints { (make) in
            make.right.equalTo(topBGView).offset(-10 * AutoSizeScaleX)
            make.left.equalTo(yourReminderlab.snp_right).offset(6 * AutoSizeScaleX)
            make.height.equalTo(1 * AutoSizeScaleX)
            make.centerY.equalTo(yourReminderlab)
        }

        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        
        self.view.addSubview(tableView)
        self.tableView = tableView
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBGView.snp_bottom)
            make.bottom.left.right.equalTo(self.view)
        }
        getReminderList()
    }
    
    func getReminderList(){
        client.getReminderList { (reminders) in
            self.reminders = reminders
            self.tableView.reloadData()
        }
    }
    
//    func getReminderList(){
//        client.getReminderList { (reminders) in
//            self.reminders = reminders
//            self.tableView.reloadData()
//        }
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReminderList()
    }
    
    @objc func createReminderBtnAction(sender: UIButton) {
        var list: [[String: Any]] = [[String: Any]]()
        var dic: [String: Any] = [String: Any]()
        dic = ["reminder_month": 2, "day_of_month": 12, "week_day": 1 ]
        list.append(dic)
        let controller = CreateReminderViewController()
        self.navigationController?.pushAndHideTabBar(controller)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func tapBackBtnAction(sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
         //   if controller.isKind(of: DashboardContainerViewController.self) {
            if controller.isKind(of: HomeDashboardViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: InvoicesContainerViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: BenifitsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}

extension ListOfRemindersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CellID"
        var cell: ListOfReminderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? ListOfReminderTableViewCell
        if cell == nil {
            cell = ListOfReminderTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        var getReminder : Reminder = self.reminders[indexPath.row]
        cell?.reminderNameLab.text  = getReminder.title
        cell?.reminderTime.text = getReminder.reminderTime
        cell?.reminderSubTitleLab.text = getReminder.description
        if(getReminder.frequency == "weekly"){
            cell?.reminderDay.text = "Wöchentlich"
        }else if(getReminder.frequency == "monthly"){
            cell?.reminderDay.text = "Monatlich"
        }else if(getReminder.frequency == "yearly"){
            cell?.reminderDay.text = "Jährlich"
        }
        if getReminder.deleted_at!.isEmpty {
            cell?.reminderNameLab.textColor = UIColor(hexString: "#2B395C")
        }else{
            cell?.reminderNameLab.textColor = .lightGray
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let getReminder : Reminder = self.reminders[indexPath.row]
        self.getSelectedData.removeAll()
        if(getReminder.frequency == "weekly"){
            for value in getReminder.items {
                self.getReminderItems = value
                self.getSelectedData.append(self.getReminderItems.week_day ?? 0)
            }
        }
        if (getReminder.frequency == "yearly"){
            for value in getReminder.items {
                self.getReminderItems = value
                self.getSelectedMonth = self.getReminderItems.reminder_month ?? 0
                self.getSelectedData.append(self.getReminderItems.day_of_month ?? 0)
            }
        }
        if (getReminder.frequency == "monthly"){
            for value in getReminder.items {
                self.getReminderItems = value
                self.getSelectedData.append(self.getReminderItems.day_of_month ?? 0)

            }
        }
    let controller = ViewReminderViewController()
    controller.getReminder = getReminder
    controller.getSelectedData = self.getSelectedData.uniqued()
    controller.getSelectedMonth = self.getSelectedMonth
    self.navigationController?.pushAndHideTabBar(controller)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let getReminder : Reminder = self.reminders[indexPath.row]
        let delete = UITableViewRowAction(style: .default, title: "Löschen") { (action:UITableViewRowAction, indexPath:IndexPath) in
            let getReminder : Reminder = self.reminders[indexPath.row]
            if(getReminder.type == "default"){
                UIApplication.shared.showAlertWith(title: "Sie haben keinen Zugriff zum Löschen dieser Erinnerung",message: "")
            }else{
                let alert = UIAlertController(title: "Erinnerung löschen", message: "Sind Sie sicher, dass Sie diese Erinnerung löschen möchten?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Löschen", style:
                    UIAlertAction.Style.default) {
                       UIAlertAction in
                    let getReminder : Reminder = self.reminders[indexPath.row]
                    ApplicationDelegate.client.deleteReminder(reminderID: getReminder.hashValue) { message in
                        guard let message = message else { return }
                        self.getReminderList()
                        UIApplication.shared.showAlertWith(title: message,message: "")
                    }
                }
                let cancelAction = UIAlertAction(title: "Abbrechen", style:
                    UIAlertAction.Style.cancel) {
                       UIAlertAction in
                    }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        delete.backgroundColor = UIColor(hexString: "#FF0000")
       
        if getReminder.deleted_at!.isEmpty {
            self.getTurnONOFFNotificationStr = "Stummschalten"
        }else{
            self.getTurnONOFFNotificationStr = "Einschalten"
        }

        let more = UITableViewRowAction(style: .default, title: self.getTurnONOFFNotificationStr) { (action:UITableViewRowAction, indexPath:IndexPath) in
            let getReminder : Reminder = self.reminders[indexPath.row]
            ApplicationDelegate.client.reminderOnOFF(reminderID: getReminder.hashValue) { message in
                guard let message = message else { return }
                self.getReminderList()
                UIApplication.shared.showAlertWith(title: message,message: "")
            }
        }
        more.backgroundColor = UIColor(hexString: "#F3D63F")
        let edit = UITableViewRowAction(style: .default, title: "Bearbeiten") { (action:UITableViewRowAction, indexPath:IndexPath) in
            if(getReminder.type == "default"){
                UIApplication.shared.showAlertWith(title: "Sie haben keinen Zugriff zum Bearbeiten dieser Erinnerung".localized, message: "")
            }else{
                
                if(getReminder.frequency == "weekly"){
                    for value in getReminder.items {
                        self.getReminderItems = value
                        self.getSelectedData.append(self.getReminderItems.week_day ?? 0)
                    }
                }
                
                if (getReminder.frequency == "yearly"){
                    for value in getReminder.items {
                        self.getReminderItems = value
                        self.getSelectedMonth = self.getReminderItems.reminder_month ?? 0
                        self.getSelectedData.append(self.getReminderItems.day_of_month ?? 0)
                    }
                }
                
                if (getReminder.frequency == "monthly"){
                    for value in getReminder.items {
                        self.getReminderItems = value
                        self.getSelectedData.append(self.getReminderItems.day_of_month ?? 0)
                    }
                }
                    let controller = EditReminderViewController()
                    controller.getReminder = getReminder
                    controller.getSelectedData.removeAll()
                    controller.getSelectedData = self.getSelectedData.uniqued()
                    controller.getSelectedMonth = self.getSelectedMonth
                    self.navigationController?.pushAndHideTabBar(controller)
            }

        }
        edit.backgroundColor = UIColor(hexString: "#4CD964")
        return [delete, more,edit]
    }

}
