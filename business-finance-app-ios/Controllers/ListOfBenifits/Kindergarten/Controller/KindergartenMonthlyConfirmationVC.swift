//
//  KindergartenMonthlyConfirmationVC.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/9/17.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class KindergartenMonthlyConfirmationVC: BaseViewController {
    private var kindergartenKidsDetails: [KindergartenKid] = []
    private var tableView: UITableView!
    var isListOfNotificationPage: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.navigationItem.title = "Monatliche Bestätigung"
        self.navigationItem.setHidesBackButton(true, animated: false)

        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Sind Deine Daten zum Kindergartenzuschuss noch aktuell?"
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor(hexString: "#2B395C")
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.appFont(ofSize: 15 * AutoSizeScaleX, weight: .bold)
        titleLabel.sizeToFit()
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
        }
               
        let noBtn: UIButton = UIButton(type: .custom)
        noBtn.setTitleColor(UIColor(hexString: "#FF0000"), for: .normal)
        noBtn.setTitle( "Nein", for: .normal)
        noBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        noBtn.layer.borderWidth = 1 * AutoSizeScaleX
        noBtn.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
        noBtn.layer.shadowColor = UIColor.black.cgColor
        noBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        noBtn.layer.shadowOpacity = 0.12
        noBtn.layer.shadowRadius = 3
        noBtn.addTarget(self, action: #selector(noBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(noBtn)
        noBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(self.view.snp_bottom).offset(-40 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let yesBtn: UIButton = UIButton(type: .custom)
        yesBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        yesBtn.setTitle( "Ja", for: .normal)
        yesBtn.backgroundColor = UIColor(hexString: "#3868F6")
        yesBtn.setTitleColor(.white, for: .normal)
        yesBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        yesBtn.addTarget(self, action: #selector(yesBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(yesBtn)
        yesBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(noBtn.snp_top).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = true
        self.view.addSubview(tableView)
        self.tableView = tableView
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(2 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-2 * AutoSizeScaleX)
            make.bottom.equalTo(yesBtn.snp_top).offset(-10 * AutoSizeScaleX)
        }
    }
    func getKindergartenKidsList(){
        client.getListOfKindergartenKids { (kidDetail) in
            self.kindergartenKidsDetails = kidDetail
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let getNotificationID = ITNSUserDefaults.value(forKey: "notification_id") as? String {
            let getNotificationIDValue = Int(getNotificationID ?? "")!

            ApplicationDelegate.client.updateNotificationMsg(Id:getNotificationIDValue) { [self] message in
            }
        }
        getKindergartenKidsList()
    }
    
    @objc func yesBtnAction(sender: UIButton) {
        self.client.postMonthlyKidConfirmation{ (getPostMonthlyTravelStatus) in
        }
        if(self.isListOfNotificationPage == false){
            ITNSUserDefaults.set(true, forKey: "PieChartTourGuideHide")
        }
        let alert = UIAlertController(title: "Vielen Dank für Deine Bestätigung!", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style:
            UIAlertAction.Style.default) {
               UIAlertAction in
            self.navigationController?.popViewController(animated: false)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)

    }
    @objc func noBtnAction(sender: UIButton) {
        if(self.isListOfNotificationPage == false){
            ITNSUserDefaults.set(true, forKey: "PieChartTourGuideHide")
        }
        let controller = KindergartenListViewController()
        self.navigationController?.pushAndHideTabBar(controller)
    }

}
extension KindergartenMonthlyConfirmationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.kindergartenKidsDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CellID"
        var cell: KindergartenMonthlyConfirmTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? KindergartenMonthlyConfirmTableViewCell
        if cell == nil {
            cell = KindergartenMonthlyConfirmTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        
        var getKindergartenKidsDetails : KindergartenKid = self.kindergartenKidsDetails[indexPath.row]
        if(getKindergartenKidsDetails.is_applicable == false){
            cell?.inactiveStatusLab.isHidden = false
            cell?.childNameLab.textColor = .lightGray
            cell?.kindergartenNameLab.textColor = .lightGray
            cell?.kindergartenAddressLab.textColor = .lightGray
        }else{
            cell?.inactiveStatusLab.isHidden = true
            cell?.childNameLab.textColor =  UIColor(hexString: "#222B45")
            cell?.kindergartenNameLab.textColor = UIColor(hexString: "#2B395C")
            cell?.kindergartenAddressLab.textColor = UIColor(hexString: "#222B45")

        }
        cell?.childNameLab.text  = getKindergartenKidsDetails.name
        cell?.kindergartenAddressLab.text = getKindergartenKidsDetails.kinder_garden_address        
        cell?.kindergartenNameLab.text = getKindergartenKidsDetails.kinder_garden_name
        
        return cell!
    }
    
}
