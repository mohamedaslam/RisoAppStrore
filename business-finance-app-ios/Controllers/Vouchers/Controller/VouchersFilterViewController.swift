//
//  VouchersFilterViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/14.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import UIKit
import DLRadioButton
import RangeSeekSlider

class VouchersFilterViewController: BaseViewController {
    var radioButtons : DLRadioButton!;
    var rangeSliderCurrency: RangeSeekSlider!
    private var collectionView: UICollectionView!
    private var vendor: [Vendor] = []
    private var vendorList: [VendorsList] = []
    var bottomBtnsBGView: UIView = UIView()
    var selectedIndex : IndexPath = []
    var userProductID: Int = 0
    var productID: Int = 0
    var venderIDStr: String = "2,1"
    var priceSortStr: String = "ASC"
    var minPriceValue: Int = 0
    var maxPriceValue: Int = 50
    var minUpdatedPriceValue: Int = 0
    var maxUpdatedPriceValue: Int = 50
    var getSelectedVendorIds = ""
    var getSelectedVendorIdArray = [Int]()
    var isSachbezugPage : Bool = false
    var isSachbezugDefaultVouchersPage : Bool = false
    var getSelectedVendorIDSet: Set = [-1]
    var closeBtnBGView: UIView = UIView()
    var radioButtonBGView : UIView = UIView()
    var pleaseChooseVendorsLab: UILabel = UILabel()
    var sortByPriceLab: UILabel = UILabel()
    var valueLab: UILabel = UILabel()
    var year : Int = 2023
    var month : Int = 0
    var isYearSelected : Bool = false
    var value_spent: String = "ASC"
    var budget: Int = 0
    var still_possible: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.init(hexString: "#D8D6D6")
        self.view.backgroundColor = UIColor.App.TableView.grayBackground
        self.navigationItem.title = "Filter"
        
        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(tapBackBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        
        configUISetup()

    }
    @objc func tapBackBtnAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configRadioButtonBGViewSetup(){
        let radioButtonBGView: UIView = UIView()
        self.view.addSubview(radioButtonBGView)
        self.radioButtonBGView = radioButtonBGView
        radioButtonBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(14 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        let sortByPriceLab: UILabel = UILabel()
        sortByPriceLab.text = "Nach Preis sortieren"
        sortByPriceLab.sizeToFit()
        sortByPriceLab.font = UIFont.appFont(ofSize: 17, weight: .semibold)
        sortByPriceLab.textColor = UIColor.init(hexString: "#2B395C")
        self.radioButtonBGView.addSubview(sortByPriceLab)
        self.sortByPriceLab = sortByPriceLab
        sortByPriceLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.radioButtonBGView).offset(20 * AutoSizeScaleX)
            make.width.equalTo(200 * AutoSizeScaleX)
            make.height.equalTo(24 * AutoSizeScaleX)
            make.top.equalTo(self.radioButtonBGView).offset(10 * AutoSizeScaleX)
        }

        
        let frame = CGRect(x: 220, y: 14, width: 100, height: 20);
        let firstRadioButton = createRadioButton(frame: frame, title: "asc", color: UIColor.init(hexString: "#3868F6"));
        
        //other buttons
        let colorNames = ["desc", "desc"];
        let colors = [UIColor.init(hexString: "#3868F6"), UIColor.clear,];
        var i = 0;
        var otherButtons : [DLRadioButton] = [];
        for color in colors {
            let frame = CGRect(x: 320 + 20 * CGFloat(i), y: 14  , width: 100, height: 20);
            let radioButton = createRadioButton(frame: frame, title: colorNames[i] + " ", color: color);
//            if (i % 2 == 0) {
//                radioButton.isIconSquare = true;
//            }
            if (i > 1) {
                // put icon on the right side
                radioButton.isIconOnRight = true;
                radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right;
            }
            otherButtons.append(radioButton);
            i += 1;
        }
        
        firstRadioButton.otherButtons = otherButtons;
        firstRadioButton.otherButtons[1].isSelected = true;
    }
    func configUISetup(){

        configRadioButtonBGViewSetup()
        configMultipleBtnsBottomSetup()

        configCollectionView()
    }
    
    func configCollectionView(){
        
        
   let valueLab: UILabel = UILabel()
   valueLab.text = "Wert"
   valueLab.sizeToFit()
   valueLab.font = UIFont.appFont(ofSize: 17, weight: .semibold)
   valueLab.textColor = UIColor.init(hexString: "#2B395C")
   self.view.addSubview(valueLab)
 self.valueLab = valueLab
   valueLab.snp.makeConstraints { (make) in
       make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
       make.width.equalTo(60 * AutoSizeScaleX)
       make.height.equalTo(24 * AutoSizeScaleX)
       make.top.equalTo(sortByPriceLab.snp_bottom).offset(20 * AutoSizeScaleX)
   }
        
        let rangeSlider = RangeSeekSlider();
        self.view.addSubview(rangeSlider);
        self.rangeSliderCurrency = rangeSlider
        rangeSliderCurrency.delegate = self
        rangeSliderCurrency.minValue = CGFloat(Float(self.minPriceValue))
        rangeSliderCurrency.maxValue = CGFloat(Float(self.maxPriceValue))
        rangeSliderCurrency.selectedMinValue = CGFloat(Float(self.minPriceValue))
        rangeSliderCurrency.selectedMaxValue = CGFloat(Float(self.maxPriceValue))
        rangeSliderCurrency.minDistance = CGFloat(Float(self.minPriceValue))
        rangeSliderCurrency.maxDistance = CGFloat(Float(self.maxPriceValue))
        rangeSliderCurrency.handleColor = UIColor.App.Button.tintColor
        rangeSliderCurrency.handleDiameter = 30.0
        rangeSliderCurrency.handleBorderColor = .lightGray.alpha(0.5)
        rangeSliderCurrency.handleBorderWidth = 0.7
        rangeSliderCurrency.minLabelColor = UIColor.init(hexString: "#2B395C")
        rangeSliderCurrency.maxLabelColor = UIColor.init(hexString: "#2B395C")
        self.minUpdatedPriceValue = self.minPriceValue
        self.maxUpdatedPriceValue = self.maxPriceValue
        rangeSliderCurrency.minLabelFont = UIFont(name: "ChalkboardSE-Regular", size: 15.0)!
        rangeSliderCurrency.maxLabelFont = UIFont(name: "ChalkboardSE-Regular", size: 15.0)!
        rangeSlider.snp.makeConstraints { (make) in
            make.left.equalTo(valueLab.snp_right).offset(6 * AutoSizeScaleX)
            make.right.equalTo(-20 * AutoSizeScaleX)
            make.height.equalTo(50 * AutoSizeScaleX)
            make.centerY.equalTo(valueLab)
        }
        
        let pleaseChooseVendorsLab: UILabel = UILabel()
        pleaseChooseVendorsLab.text = "Bitte wählen Sie Ihre Lieferanten aus"
        pleaseChooseVendorsLab.sizeToFit()
        pleaseChooseVendorsLab.textAlignment = .center
        pleaseChooseVendorsLab.font = UIFont.appFont(ofSize: 17, weight: .semibold)
        pleaseChooseVendorsLab.textColor = UIColor.init(hexString: "#2B395C")
        self.view.addSubview(pleaseChooseVendorsLab)
        self.pleaseChooseVendorsLab = pleaseChooseVendorsLab
        pleaseChooseVendorsLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(30 * AutoSizeScaleX)
            make.top.equalTo(rangeSlider.snp_bottom).offset(30 * AutoSizeScaleX)
        }
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 120 * AutoSizeScaleX, height: 120 * AutoSizeScaleX)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 4, bottom: 10, right: 4)
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VendorsListsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(pleaseChooseVendorsLab.snp_bottom).offset(4 * AutoSizeScaleX)
            make.bottom.equalTo(self.bottomBtnsBGView.snp_top)
        }
        getVendorsList(userProductID: self.userProductID, voucherID: self.productID)
        
    }
    
    private func createRadioButton(frame : CGRect, title : String, color : UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.appFont(ofSize: 16, weight: .regular)
        radioButton.setTitle(title, for: []);
        radioButton.setTitleColor(color, for: []);
        radioButton.iconColor = color;
        radioButton.indicatorColor = color;
        
        radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(VouchersFilterViewController.logSelectedButton), for: UIControl.Event.touchUpInside);
        self.radioButtonBGView.addSubview(radioButton);
        
        return radioButton;
    
    }
    
    func getVendorsList(userProductID: Int, voucherID: Int){
        client.getVendorsData(userProductID:userProductID, voucherID: productID) { (vendor) in
            self.vendorList = vendor
            self.collectionView.reloadData()
        }
    }

    func configSingleBtnBottomSetup(){
        let closeBtnBGView: UIView = UIView()
        closeBtnBGView.backgroundColor = .white
        closeBtnBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        closeBtnBGView.layer.shadowColor = UIColor.black.cgColor
        closeBtnBGView.layer.shadowOffset = CGSize.zero
        closeBtnBGView.layer.shadowOpacity = 0.12
        closeBtnBGView.layer.shadowRadius = 3
        self.view.addSubview(closeBtnBGView)
        self.closeBtnBGView = closeBtnBGView
        closeBtnBGView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view)
            make.height.equalTo(100 * AutoSizeScaleX)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        let closeBtn: UIButton = UIButton(type: .custom)
        closeBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        closeBtn.setTitle( "Close", for: .normal)
        closeBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        closeBtn.layer.borderWidth = 1 * AutoSizeScaleX
        closeBtn.layer.borderColor = UIColor(hexString: "#3868F6").cgColor
        closeBtn.layer.shadowColor = UIColor.black.cgColor
        closeBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        closeBtn.layer.shadowOpacity = 0.12
        closeBtn.layer.shadowRadius = 3
        closeBtn.addTarget(self, action: #selector(closeBtnAction(sender:)), for: .touchUpInside)
        self.closeBtnBGView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(closeBtnBGView).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(closeBtnBGView).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(-30 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
    }
    
    func configMultipleBtnsBottomSetup(){
        
        let bottomBtnsBGView: UIView = UIView()
        bottomBtnsBGView.backgroundColor = .white
        bottomBtnsBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        bottomBtnsBGView.layer.shadowColor = UIColor.black.cgColor
        bottomBtnsBGView.layer.shadowOffset = CGSize.zero
        bottomBtnsBGView.layer.shadowOpacity = 0.12
        bottomBtnsBGView.isHidden = true
        bottomBtnsBGView.layer.shadowRadius = 3
        self.view.addSubview(bottomBtnsBGView)
        self.bottomBtnsBGView = bottomBtnsBGView
        bottomBtnsBGView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view)
            make.height.equalTo(160 * AutoSizeScaleX)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        let clearBtn: UIButton = UIButton(type: .custom)
        clearBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        clearBtn.setTitle( "Filter zurücksetzen", for: .normal)
        clearBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        clearBtn.layer.borderWidth = 1 * AutoSizeScaleX
        clearBtn.layer.borderColor = UIColor(hexString: "#3868F6").cgColor
        clearBtn.layer.shadowColor = UIColor.black.cgColor
        clearBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        clearBtn.layer.shadowOpacity = 0.12
        clearBtn.layer.shadowRadius = 3
        clearBtn.addTarget(self, action: #selector(clearBtnAction(sender:)), for: .touchUpInside)
        self.bottomBtnsBGView.addSubview(clearBtn)
        clearBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let showVouchersBtn: UIButton = UIButton(type: .custom)
        showVouchersBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        showVouchersBtn.setTitle( "Alle ausgewählten Gutscheine anzeigen", for: .normal)
        showVouchersBtn.backgroundColor = UIColor(hexString: "#3868F6")
        showVouchersBtn.setTitleColor(.white, for: .normal)
        showVouchersBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        showVouchersBtn.addTarget(self, action: #selector(showVouchersBtnAction(sender:)), for: .touchUpInside)
        self.bottomBtnsBGView.addSubview(showVouchersBtn)
        showVouchersBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(clearBtn.snp_top).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
    }
    
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
//        self.closeBtnBGView.isHidden = true
        self.bottomBtnsBGView.isHidden = false
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        } else {
            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
            self.priceSortStr = radioButton.selected()!.titleLabel!.text!
        }
    }

    @objc func closeBtnAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @objc func clearBtnAction(sender: UIButton) {

        rangeSliderCurrency.minValue = CGFloat(Float(self.minPriceValue))
        rangeSliderCurrency.maxValue = CGFloat(Float(self.maxPriceValue))
        self.collectionView.removeFromSuperview()
        self.rangeSliderCurrency.removeFromSuperview()
        self.pleaseChooseVendorsLab.removeFromSuperview()
        self.radioButtonBGView.removeFromSuperview()
        self.getSelectedVendorIDSet.removeAll()
        self.valueLab.removeFromSuperview()
        self.getSelectedVendorIDSet.insert(-1)
        self.configRadioButtonBGViewSetup()
        self.configCollectionView()
    }
    
    @objc func showVouchersBtnAction(sender: UIButton) {
        self.getSelectedVendorIds.removeAll()
        for elem in self.getSelectedVendorIDSet {
            self.getSelectedVendorIds.append("\(elem),")
        }

        if(self.isSachbezugPage == true){
            let controller = SachbezugViewController()
            controller.userProductID = self.userProductID
            controller.productID = self.productID
            controller.vendorIDStr = self.getSelectedVendorIds
            controller.priceSortStr = self.priceSortStr
            controller.minPriceValue = self.minUpdatedPriceValue
            controller.maxPriceValue = self.maxUpdatedPriceValue
            controller.isFilterApplied = true
            controller.vendorsCount = self.getSelectedVendorIDSet.count
            controller.value_spent = self.value_spent
            controller.budget = self.budget
            controller.isYearSelected = self.isYearSelected
            controller.month = self.month
            controller.year = self.year
            controller.still_possible = self.still_possible
            navigationController?.pushAndHideTabBar(controller, animated: true)
            
        }else if(self.isSachbezugDefaultVouchersPage == true){
            let controller = VouchersEditViewController()
            controller.userProductID = self.userProductID
            controller.vendorIDStr = self.getSelectedVendorIds
            controller.priceSortStr = self.priceSortStr
            controller.minPriceValue = self.minUpdatedPriceValue
            controller.maxPriceValue = self.maxUpdatedPriceValue
            navigationController?.pushAndHideTabBar(controller, animated: true)
        }else{
            let controller = DankeBonusViewController()
            controller.userProductID = self.userProductID
            controller.productID = self.productID
            controller.vendorIDStr = self.getSelectedVendorIds
            controller.priceSortStr = self.priceSortStr
            controller.minPriceValue = self.minUpdatedPriceValue
            controller.maxPriceValue = self.maxUpdatedPriceValue
            controller.isFilterApplied = true
            controller.vendorsCount = self.getSelectedVendorIDSet.count
            controller.value_spent = self.value_spent
            controller.budget = self.budget
            controller.isYearSelected = self.isYearSelected
            controller.month = self.month
            controller.year = self.year
            controller.still_possible = self.still_possible
            navigationController?.pushAndHideTabBar(controller, animated: true)
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VouchersFilterViewController: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSliderCurrency {
            self.minUpdatedPriceValue = Int(minValue)
            self.maxUpdatedPriceValue = Int(maxValue)
            self.bottomBtnsBGView.isHidden = false
        }
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}

extension VouchersFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vendorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: VendorsListsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VendorsListsCollectionViewCell
        let getVendor : VendorsList = self.vendorList[indexPath.row]
//        cell.vouchersCountLab.text = getVendor.vouchers_count
        cell.logoImageView.kf.setImage(with: getVendor.imageURL)
        cell.vouchersCountLab.text = "\(getVendor.vouchers_count ?? 0) Gutscheine"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100 * AutoSizeScaleX, height: 100 * AutoSizeScaleX)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! VendorsListsCollectionViewCell
        if cell.isSelected == true {
            cell.backgroundColor = UIColor.init(hexString: "#1E4199")
            cell.bgView.backgroundColor = UIColor.init(hexString: "#edf1fa")
        }else{
            cell.backgroundColor = UIColor.clear
            cell.bgView.backgroundColor = UIColor.white

        }
        let getVendor : VendorsList = self.vendorList[indexPath.row]
        self.bottomBtnsBGView.isHidden = false
        self.getSelectedVendorIDSet.insert(getVendor.vouchers[0].vendor_id)

    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! VendorsListsCollectionViewCell
        if cell.isSelected == true {
            cell.backgroundColor = UIColor.init(hexString: "#1E4199")
            cell.bgView.backgroundColor = UIColor.init(hexString: "#edf1fa")
        }else{
            cell.backgroundColor = UIColor.clear
            cell.bgView.backgroundColor = UIColor.white
        }
        let getVendor : VendorsList = self.vendorList[indexPath.row]

        self.getSelectedVendorIDSet.remove(getVendor.vouchers[0].vendor_id)

    }
}
extension UICollectionView {
    func deselectAllItems(animated: Bool = false) {
        for indexPath in self.indexPathsForSelectedItems ?? [] {
            self.deselectItem(at: indexPath, animated: animated)
        }
    }
}
