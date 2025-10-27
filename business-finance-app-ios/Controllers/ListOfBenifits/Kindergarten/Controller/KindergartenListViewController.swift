//
//  KindergartenListViewController.swift
//  BFA
//
//  Created by Mohammed Aslam on 2022/9/12.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import SnapKit
import ANActivityIndicator
import Alamofire

class KindergartenListViewController:  BaseViewController {
    private var reminders: [Reminder] = []
    private var tableView: UITableView!
    private var getTurnONOFFNotificationStr : String = ""
    private var getReminderItems: Items!
    private var getSelectedData: [Int] = []
    private var getSelectedMonth: Int = 1
    private var getReminder : Reminder?
    var getUserProductID : Int = 0
    private var tourGuideTransparentBGView : UIView = UIView()
    private var addNewChildBtn : UIButton = UIButton()
    private var topBGView: UIView = UIView()
    private var kindergartenKidsDetails: [KindergartenKid] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getKindergartenKidsList()
        self.navigationItem.title = "Kindergarten"
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
            make.height.equalTo((90 * CGFloat(self.kindergartenKidsDetails.count)) + 20 * AutoSizeScaleX)
        }


        let addNewChildBtn: UIButton = UIButton(type: .custom)
        addNewChildBtn.backgroundColor = UIColor(hexString: "#3868F6")
        addNewChildBtn.setTitleColor(.white, for: .normal)
        addNewChildBtn.setTitle( "Neues Kind hinzufügen", for: .normal)
        addNewChildBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        addNewChildBtn.layer.shadowColor = UIColor.black.cgColor
        addNewChildBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        addNewChildBtn.layer.shadowOpacity = 0.12
        addNewChildBtn.layer.shadowRadius = 3
        addNewChildBtn.addTarget(self, action: #selector(addNewChildBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(addNewChildBtn)
        addNewChildBtn.snp.makeConstraints { (make) in
            make.right.equalTo(topBGView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(topBGView).offset(20 * AutoSizeScaleX)
            make.top.equalTo(self.tableView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(56 * AutoSizeScaleX)
        }
        
        let tourGuideTransparentBGView: UIView = UIView()
        tourGuideTransparentBGView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        tourGuideTransparentBGView.isHidden = true
        view.addSubview(tourGuideTransparentBGView)
        self.tourGuideTransparentBGView = tourGuideTransparentBGView
        tourGuideTransparentBGView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(view)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tourGuideTransparentBGView.addGestureRecognizer(tap)
        
        let uploadBtnBGView: UIView = UIView()
        uploadBtnBGView.backgroundColor = UIColor.white
        uploadBtnBGView.layer.cornerRadius = 26 * AutoSizeScaleX
        tourGuideTransparentBGView.addSubview(uploadBtnBGView)
        uploadBtnBGView.snp.makeConstraints { (make) in
            make.right.equalTo(tourGuideTransparentBGView).offset(-28 * AutoSizeScaleX)
            make.top.equalTo(tourGuideTransparentBGView).offset(66 * AutoSizeScaleX)
            make.height.width.equalTo(52 * AutoSizeScaleX)
        }
        let uploadBtn: UIButton = UIButton(type: .custom)
        uploadBtn.layer.cornerRadius = 21 * AutoSizeScaleX
        uploadBtn.backgroundColor = UIColor(hexString: "#F3D63F")
        uploadBtn.setImage(UIImage(named: "uploadPending"), for: .normal)
        uploadBtnBGView.addSubview(uploadBtn)
        uploadBtn.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(uploadBtnBGView)
            make.height.width.equalTo(42 * AutoSizeScaleX)
        }
        
        let tourGuideArrowImgView: UIImageView = UIImageView()
        tourGuideArrowImgView.image = UIImage.init(named: "tourGuideArrow")
        tourGuideArrowImgView.contentMode = .scaleAspectFit
        tourGuideTransparentBGView.addSubview(tourGuideArrowImgView)
        tourGuideArrowImgView.snp.makeConstraints { (make) in
            make.right.equalTo(uploadBtnBGView.snp_centerX)
            make.top.equalTo(uploadBtnBGView.snp_bottom).offset(6 * AutoSizeScaleX)
            make.height.equalTo(24 * AutoSizeScaleX)
            make.width.equalTo(60 * AutoSizeScaleX)
        }
        
        let tourGuideTextImgView: UIImageView = UIImageView()
        tourGuideTextImgView.image = UIImage.init(named: "tourGuideText")
        tourGuideTextImgView.contentMode = .scaleAspectFit
        tourGuideTransparentBGView.addSubview(tourGuideTextImgView)
        tourGuideTextImgView.snp.makeConstraints { (make) in
            make.right.equalTo(tourGuideArrowImgView.snp_left)
            make.top.equalTo(tourGuideArrowImgView.snp_bottom).offset(-16 * AutoSizeScaleX)
            make.height.equalTo(32 * AutoSizeScaleX)
            make.width.equalTo(150 * AutoSizeScaleX)
        }

    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.tourGuideTransparentBGView.removeFromSuperview()
    }
    
    func getKindergartenKidsList(){

        client.getListOfKindergartenKids { (kidDetail) in
            self.kindergartenKidsDetails = kidDetail
            if((self.tableView) != nil){
                self.updateUI()
            }
            if ITNSUserDefaults.value(forKey: "FirstTime") == nil {
                ITNSUserDefaults.set(false, forKey: "FirstTime")
                if(self.kindergartenKidsDetails.count == 1){
                    self.tourGuideTransparentBGView.isHidden = false
                }else{
                    self.tourGuideTransparentBGView.isHidden = true
                }
            }

            self.tableView.reloadData()
        }
    }
    
    func updateUI(){
        let getHeight = (90 * CGFloat(self.kindergartenKidsDetails.count) + 20 )
        if (getHeight > Screen_Height - NavigationBar_Height - 150){
            self.tableView.snp.updateConstraints { (make) in
                make.height.equalTo(Screen_Height - NavigationBar_Height - 150 * AutoSizeScaleX)
            }
        }else{
            self.tableView.snp.updateConstraints { (make) in
                make.height.equalTo((90 * CGFloat(self.kindergartenKidsDetails.count)) + 20 * AutoSizeScaleX)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getKindergartenKidsList()
    }
    
    @objc func addNewChildBtnAction(sender: UIButton) {
        let controller = KindergartenSetupViewController()
        controller.getTitle = "Neues Kind"
        self.navigationController?.pushAndHideTabBar(controller)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func tapBackBtnAction(sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
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
            if controller.isKind(of: ProductOverviewDetailsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}

extension KindergartenListViewController: UITableViewDataSource, UITableViewDelegate {
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
        var cell: ListOfKindergartenTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? ListOfKindergartenTableViewCell
        if cell == nil {
            cell = ListOfKindergartenTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        var getKindergartenKidsDetails : KindergartenKid = self.kindergartenKidsDetails[indexPath.row]
       cell?.childNameLab.text  = getKindergartenKidsDetails.name
        
        cell?.kindergartenNameLab.text = getKindergartenKidsDetails.kinder_garden_name

        if (getKindergartenKidsDetails.current_month_document?.status == 1){
            cell?.uploadBtn.setImage(UIImage(named: "upload"), for: .normal)
            if(getKindergartenKidsDetails.is_applicable == false){
                cell?.inactiveStatusLab.isHidden = false
                cell?.childNameLab.textColor = .lightGray
                cell?.kindergartenNameLab.textColor = .lightGray
                cell?.uploadBtn.backgroundColor = .lightGray
            }else{
                cell?.inactiveStatusLab.isHidden = true
                cell?.childNameLab.textColor = UIColor(hexString: "#2B395C")
                cell?.uploadBtn.backgroundColor = UIColor(hexString: "#F3D63F")
                cell?.uploadBtn.setImage(UIImage(named: "uploadPending"), for: .normal)

            }

        }
        if (getKindergartenKidsDetails.current_month_document?.status == 2){
            cell?.uploadBtn.setImage(UIImage(named: "uploadPending"), for: .normal)
            if(getKindergartenKidsDetails.is_applicable == false){
                cell?.inactiveStatusLab.isHidden = false
                cell?.childNameLab.textColor = .lightGray
                cell?.kindergartenNameLab.textColor = .lightGray
                cell?.uploadBtn.backgroundColor = .lightGray

            }else{
                cell?.inactiveStatusLab.isHidden = true
                cell?.childNameLab.textColor = UIColor(hexString: "#2B395C")
                cell?.uploadBtn.backgroundColor = UIColor(hexString: "#F3D63F")
            }
        }
        if (getKindergartenKidsDetails.current_month_document?.status == 3){
            cell?.uploadBtn.setImage(UIImage(named: "uploaded"), for: .normal)
            if(getKindergartenKidsDetails.is_applicable == false){
                cell?.inactiveStatusLab.isHidden = false
                cell?.childNameLab.textColor = .lightGray
                cell?.kindergartenNameLab.textColor = .lightGray
                cell?.uploadBtn.backgroundColor = .lightGray

            }else{
                cell?.inactiveStatusLab.isHidden = true
                cell?.childNameLab.textColor = UIColor(hexString: "#2B395C")
                cell?.uploadBtn.backgroundColor = UIColor(hexString: "#4CD964")
            }
        }
        if (getKindergartenKidsDetails.current_month_document?.status == 4){
            cell?.uploadBtn.setImage(UIImage(named: "reject"), for: .normal)
            if(getKindergartenKidsDetails.is_applicable == false){
                cell?.inactiveStatusLab.isHidden = false
                cell?.childNameLab.textColor = .lightGray
                cell?.kindergartenNameLab.textColor = .lightGray
                cell?.uploadBtn.backgroundColor = .lightGray

            }else{
                cell?.inactiveStatusLab.isHidden = true
                cell?.childNameLab.textColor = UIColor(hexString: "#2B395C")
                cell?.uploadBtn.backgroundColor =  UIColor.red
            }

        }
        if (getKindergartenKidsDetails.current_month_document == nil){
            cell?.uploadBtn.setImage(UIImage(named: "upload"), for: .normal)
            if(getKindergartenKidsDetails.is_applicable == false){
                cell?.inactiveStatusLab.isHidden = false
                cell?.childNameLab.textColor = .lightGray
                cell?.kindergartenNameLab.textColor = .lightGray
                cell?.uploadBtn.backgroundColor = .lightGray

            }else{
                cell?.inactiveStatusLab.isHidden = true
                cell?.childNameLab.textColor = UIColor(hexString: "#2B395C")
                cell?.uploadBtn.backgroundColor = UIColor(hexString: "#3868F6")
            }
        }
        cell?.uploadBtn.tag = indexPath.row
        cell?.uploadBtn.addTarget(self, action: #selector(uploadButtonCickAction(sender:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    let controller = KindergartenViewController()
        var getKindergartenKidsDetails : KindergartenKid = self.kindergartenKidsDetails[indexPath.row]

        controller.getkindergartenKidsDetails = getKindergartenKidsDetails
    self.navigationController?.pushAndHideTabBar(controller)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let getKindergartenKidsDetails : KindergartenKid = self.kindergartenKidsDetails[indexPath.row]
        let delete = UITableViewRowAction(style: .default, title: "löschen") { (action:UITableViewRowAction, indexPath:IndexPath) in

                let alert = UIAlertController(title: "", message: "Bist Du Dir sicher, dass Du mit dem Löschen fortfahren möchtest?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Löschen", style:
                    UIAlertAction.Style.default) {
                       UIAlertAction in

                    ApplicationDelegate.client.deleteKid(userID: getKindergartenKidsDetails.hashValue) { [self] message in
                        guard let message = message else { return }
                        self.alterView(getMessage: message)
                    }
                }
                let cancelAction = UIAlertAction(title: "Absagen", style:
                    UIAlertAction.Style.cancel) {
                       UIAlertAction in
                    }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
        }
        delete.backgroundColor = UIColor(hexString: "#FF0000")

        let edit = UITableViewRowAction(style: .default, title: "Bearbeiten") { (action:UITableViewRowAction, indexPath:IndexPath) in
            let controller = KindergartenEditViewController()
            controller.getkindergartenKidsDetails = getKindergartenKidsDetails
            self.navigationController?.pushAndHideTabBar(controller)
        }
        edit.backgroundColor = UIColor(hexString: "#4CD964")
        return [delete,edit]
    }
    
    func alterView(getMessage : String){
        let alert = UIAlertController(title: getMessage, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                self.getKindergartenKidsList()
            }))

            self.present(alert, animated: true, completion: {
            })
    }
    
    @objc func uploadButtonCickAction(sender: UIButton){
        let index = sender.tag
        var getKindergartenKidsDetails : KindergartenKid = self.kindergartenKidsDetails[index]
        if(getKindergartenKidsDetails.is_applicable == false){
            UIApplication.shared.showAlertWith(title: "Dieses Kind ist nicht für den Bezug von Kindergartengeld geeignet",message: "")

        }else{
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
            controller.didSelectImage = { image in
                store.setImage(image)
                        let controller = ScanConfirmationViewController.instantiate(with: store)
                        self.navigationController?.pushViewController(controller, animated: true)
            }
        }

    }

}
