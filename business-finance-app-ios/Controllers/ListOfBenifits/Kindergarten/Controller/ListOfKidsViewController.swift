//
//  ListOfKidsViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2022/12/1.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class ListOfKidsViewController:  BaseViewController {
    private var tableView: UITableView!
    private var getUserProductID : Int = 0
    private var topBGView: UIView = UIView()
    var store: ScanStore = ScanStore()
    private var kindergartenKidsDetails: [KindergartenKid] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getKindergartenKidsList()
        self.navigationItem.title = "Wählen Sie Kind aus"
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
        self.topBGView = topBGView
        topBGView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(56 * AutoSizeScaleX)
        }

        let yourReminderlab: UILabel = UILabel()
        yourReminderlab.text = "Deine Kinder"
        yourReminderlab.textAlignment = .center
        yourReminderlab.font = .systemFont(ofSize: 12 * AutoSizeScaleX, weight: .regular)
        topBGView.addSubview(yourReminderlab)
        yourReminderlab.snp.makeConstraints { (make) in
            make.centerX.equalTo(topBGView)
            make.width.equalTo(100 * AutoSizeScaleX)
            make.height.equalTo(10 * AutoSizeScaleX)
            make.top.equalTo(20 * AutoSizeScaleX)
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
        tableView.backgroundColor = .white
        
        self.view.addSubview(tableView)
        self.tableView = tableView
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBGView.snp_bottom).offset(-18 * AutoSizeScaleX)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-20 * AutoSizeScaleX)
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
        getKindergartenKidsList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func tapBackBtnAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ListOfKidsViewController: UITableViewDataSource, UITableViewDelegate {
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
        return 96
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CellID"
        var cell: ListOfSelectKidTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? ListOfSelectKidTableViewCell
        if cell == nil {
            cell = ListOfSelectKidTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        var getKindergartenKidsDetails : KindergartenKid = self.kindergartenKidsDetails[indexPath.row]
       cell?.childNameLab.text  = getKindergartenKidsDetails.name
        
        cell?.kindergartenNameLab.text = getKindergartenKidsDetails.kinder_garden_name
        if(getKindergartenKidsDetails.is_applicable == false){
            cell?.inactiveStatusLab.isHidden = false
            cell?.childNameLab.textColor = .lightGray
            cell?.kindergartenNameLab.textColor = .lightGray
        }else{
            cell?.inactiveStatusLab.isHidden = true
            cell?.childNameLab.textColor = UIColor(hexString: "#2B395C")
            cell?.kindergartenNameLab.textColor = .black

        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let getKindergartenKidsDetails : KindergartenKid = self.kindergartenKidsDetails[indexPath.row]
        if(getKindergartenKidsDetails.is_applicable == true){
        var storee: ScanStore = ScanStore(
            image: nil,
            extraImages: [],
            product: nil,
            kindergartenKid :getKindergartenKidsDetails,
            disabledProducts: client.currentMonthOverview?.disabledProducts ?? [],
            checkedDisclaimers: [],
            benefitProductID: getKindergartenKidsDetails.user_product_id,
            judgeKidView: 1,
            kidDetails: getKindergartenKidsDetails.id)
            storee.setImage(store.image)
            let controller = ScanConfirmationViewController.instantiate(with: storee)
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            self.alterView(getMessage: "Inaktives Kind kann keine Rechnung hochladen")
        }
    }
    
 
    
    func alterView(getMessage : String){
        let alert = UIAlertController(title: getMessage, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in

            }))
            self.present(alert, animated: true, completion: {
            })
    }
    
    @objc func uploadButtonCickAction(sender: UIButton){
        let btnPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: btnPoint)
        let getKindergartenKidsDetails : KindergartenKid = self.kindergartenKidsDetails[indexPath!.row]
        var store: ScanStore = ScanStore(
            image: nil,
            extraImages: [],
            product: nil,
            kindergartenKid :getKindergartenKidsDetails,
            disabledProducts: client.currentMonthOverview?.disabledProducts ?? [],
            checkedDisclaimers: [],
            benefitProductID: getKindergartenKidsDetails.user_product_id,
            judgeKidView: 1,
            kidDetails: getKindergartenKidsDetails.id
        )
        
        let controller = ReceiptImagePickerViewController.instantiate(store: store, canDismiss: true)
        self.navigationController?.pushViewController(controller, animated: true)
       // let nav = BaseNavigationController(rootViewController: controller)
        controller.didSelectImage = { image in
            store.setImage(image)
//                    // Show multi page picker
//                    let controller = MultiPictureScanViewController.instantiate(with: store)
//                    self.pushViewController(controller, animated: true)
                    let controller = ScanConfirmationViewController.instantiate(with: store)
                    self.navigationController?.pushViewController(controller, animated: true)
                    // Show disclaimer
        }
    }

}
