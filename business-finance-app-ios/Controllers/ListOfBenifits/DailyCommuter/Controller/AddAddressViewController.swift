//
//  AddAddressViewController.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/8/30.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire

class AddAddressViewController: BaseViewController,CLLocationManagerDelegate,MKLocalSearchCompleterDelegate,UISearchBarDelegate {
    var streetAddrTF : UITextField = UITextField()
    var streetAddrManuallyTF : UITextField = UITextField()
    var landMarkTF : UITextField = UITextField()
    var cityTF : UITextField = UITextField()
    var zipCodeTF : UITextField = UITextField()
    var streetAddr: String = ""
    var houseNo: String = ""
    var aptSuite: String = ""
    var city: String = ""
    var zipCode: String = ""
    var country: String = ""
    var countryCode: String = ""
    var home_latitude: Double = -2
    var home_longitude: Double = -2
    var locationManager = CLLocationManager()
    weak var delegate: GetDataDelegte?
    var getHomeWorkType : Int = 0
    var getLatitude : Double = -2
    var getLongtitude : Double = -2
    var searchResultsTable: UITableView!
    lazy var searchBar:UISearchBar = UISearchBar()
    var searchCompleter = MKLocalSearchCompleter()
    var searchTableViewBGView: UIView = UIView()
    var useMyCurrentLocationBtn : UIButton = UIButton()
    var notAbleFindAddressBGView: UIView = UIView()
    var searchAddressFromGoogleBGView : UIView = UIView()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "Adresse hinzufügen"
        
        let backBtn =  UIButton(type: .custom)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitle("  Zurück", for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction(sender:)), for: .touchUpInside)
        backBtn.titleLabel?.font = UIFont.appFont(ofSize: 13, weight: .regular)
        backBtn.sizeToFit()
        let barBackButton = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = barBackButton
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(getLatitude == -1){
            self.streetAddrManuallyTF.isHidden = false
            self.streetAddrTF.isHidden = true
            self.notAbleFindAddressBGView.isHidden = true
            self.searchAddressFromGoogleBGView.isHidden = false
            self.useMyCurrentLocationBtn.isHidden = true
        }else{
            self.streetAddrManuallyTF.isHidden = true
            self.streetAddrTF.isHidden = false
            self.notAbleFindAddressBGView.isHidden = false
            self.searchAddressFromGoogleBGView.isHidden = true
            self.useMyCurrentLocationBtn.isHidden = false

        }
    }
    func configView(){
        let streetAddrBGView: UIView = UIView()
        streetAddrBGView.backgroundColor = .white
        streetAddrBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        streetAddrBGView.layer.shadowColor = UIColor.black.cgColor
        streetAddrBGView.layer.shadowOffset = CGSize.zero
        streetAddrBGView.layer.shadowOpacity = 0.12
        streetAddrBGView.layer.shadowRadius = 3
        self.view.addSubview(streetAddrBGView)
        streetAddrBGView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let streetAddrTF: UITextField = UITextField()
        streetAddrTF.clearButtonMode = UITextField.ViewMode.always
        streetAddrTF.translatesAutoresizingMaskIntoConstraints = false
        streetAddrTF.borderStyle = .none
        streetAddrTF.backgroundColor = .white
        streetAddrTF.placeholder = "Straße und Hausnummer"
        streetAddrTF.autocorrectionType = .no
        streetAddrTF.keyboardType = .default
        streetAddrTF.returnKeyType = .done
        streetAddrTF.clearButtonMode = .whileEditing
        streetAddrTF.contentVerticalAlignment = .center
        streetAddrTF.delegate = self
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 12, height: 12))
        let image = UIImage(named: "search")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        streetAddrTF.leftView = imageView
        streetAddrTF.leftViewMode = .always
        streetAddrTF.textColor = UIColor(hexString: "#2B395C")
        streetAddrTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        streetAddrTF.text = "\(streetAddr)\(houseNo)"
        searchCompleter.delegate = self
        streetAddrBGView.addSubview(streetAddrTF)
        self.streetAddrTF = streetAddrTF
        streetAddrTF.snp.makeConstraints { (make) in
            make.left.equalTo(streetAddrBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(streetAddrBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(streetAddrBGView)
        }
        
        let streetAddrManuallyTF: UITextField = UITextField()
        streetAddrManuallyTF.clearButtonMode = UITextField.ViewMode.always
        streetAddrManuallyTF.translatesAutoresizingMaskIntoConstraints = false
        streetAddrManuallyTF.borderStyle = .none
        streetAddrManuallyTF.backgroundColor = .white
        streetAddrManuallyTF.placeholder = "Straße und Hausnummer"
        streetAddrManuallyTF.autocorrectionType = .no
        streetAddrManuallyTF.keyboardType = .default
        streetAddrManuallyTF.returnKeyType = .done
        streetAddrManuallyTF.clearButtonMode = .whileEditing
        streetAddrManuallyTF.contentVerticalAlignment = .center
        streetAddrManuallyTF.isHidden = true
        streetAddrManuallyTF.delegate = self
        streetAddrManuallyTF.textColor = UIColor(hexString: "#2B395C")
        streetAddrManuallyTF.text = "\(streetAddr)\(houseNo)"
        streetAddrBGView.addSubview(streetAddrManuallyTF)
        self.streetAddrManuallyTF = streetAddrManuallyTF
        streetAddrManuallyTF.snp.makeConstraints { (make) in
            make.left.equalTo(streetAddrBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(streetAddrBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(streetAddrBGView)
        }

        let zipCodeBGView: UIView = UIView()
        zipCodeBGView.backgroundColor = .white
        zipCodeBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        zipCodeBGView.layer.shadowColor = UIColor.black.cgColor
        zipCodeBGView.layer.shadowOffset = CGSize.zero
        zipCodeBGView.layer.shadowOpacity = 0.12
        zipCodeBGView.layer.shadowRadius = 3
        self.view.addSubview(zipCodeBGView)
        zipCodeBGView.snp.makeConstraints { (make) in
            make.top.equalTo(streetAddrBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let zipCodeTF: UITextField = UITextField()
        zipCodeTF.clearButtonMode = UITextField.ViewMode.always
        zipCodeTF.placeholder = "Postleitzahl"
        zipCodeTF.clearButtonMode = .whileEditing
        zipCodeTF.delegate = self
        zipCodeTF.text = self.zipCode
        zipCodeTF.textColor = UIColor(hexString: "#2B395C")
        zipCodeBGView.addSubview(zipCodeTF)
        self.zipCodeTF = zipCodeTF
        zipCodeTF.snp.makeConstraints { (make) in
            make.left.equalTo(zipCodeBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(zipCodeBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(zipCodeBGView)
        }
        
        let cityBGView: UIView = UIView()
        cityBGView.backgroundColor = .white
        cityBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        cityBGView.layer.shadowColor = UIColor.black.cgColor
        cityBGView.layer.shadowOffset = CGSize.zero
        cityBGView.layer.shadowOpacity = 0.12
        cityBGView.layer.shadowRadius = 3
        self.view.addSubview(cityBGView)
        cityBGView.snp.makeConstraints { (make) in
            make.top.equalTo(zipCodeBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let cityTF: UITextField = UITextField()
        cityTF.clearButtonMode = UITextField.ViewMode.always
        cityTF.placeholder = "Ort"
        cityTF.delegate = self
        cityTF.clearButtonMode = .whileEditing
        cityTF.text = self.city
        cityTF.textColor = UIColor(hexString: "#2B395C")
        cityBGView.addSubview(cityTF)
        self.cityTF = cityTF
        cityTF.snp.makeConstraints { (make) in
            make.left.equalTo(cityBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(cityBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(cityBGView)
        }
        
        
        let useMyCurrentLocationBtn: UIButton = UIButton(type: .custom)
        useMyCurrentLocationBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        useMyCurrentLocationBtn.setTitle( "Meinen aktuellen Standort verwenden", for: .normal)
        useMyCurrentLocationBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        useMyCurrentLocationBtn.layer.borderWidth = 1 * AutoSizeScaleX
        useMyCurrentLocationBtn.layer.borderColor = UIColor(hexString: "#3868F6").cgColor
        useMyCurrentLocationBtn.layer.shadowColor = UIColor.black.cgColor
        useMyCurrentLocationBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        useMyCurrentLocationBtn.layer.shadowOpacity = 0.12
        useMyCurrentLocationBtn.layer.shadowRadius = 3
        useMyCurrentLocationBtn.addTarget(self, action: #selector(useMyCurrentLocationBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(useMyCurrentLocationBtn)
        self.useMyCurrentLocationBtn = useMyCurrentLocationBtn
        useMyCurrentLocationBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.top.equalTo(cityBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        let currentLocationImg: UIImageView = UIImageView()
        currentLocationImg.image = UIImage.init(named: "Currentlocation")
        currentLocationImg.contentMode = .scaleAspectFit
        useMyCurrentLocationBtn.addSubview(currentLocationImg)
        currentLocationImg.snp.makeConstraints { (make) in
            make.right.equalTo(useMyCurrentLocationBtn).offset(-10 * AutoSizeScaleX)
            make.centerY.equalTo(useMyCurrentLocationBtn)
            make.width.height.equalTo(18 * AutoSizeScaleX)
        }
        
        let notAbleFindAddressBGView: UIView = UIView()
        notAbleFindAddressBGView.backgroundColor = .white
        self.view.addSubview(notAbleFindAddressBGView)
        self.notAbleFindAddressBGView = notAbleFindAddressBGView
        notAbleFindAddressBGView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(50 * AutoSizeScaleX)
            make.top.equalTo(useMyCurrentLocationBtn.snp_bottom).offset(40 * AutoSizeScaleX)
        }
        let notAbleFindAddressLab: UILabel = UILabel()
        notAbleFindAddressLab.textColor = .lightGray
        notAbleFindAddressLab.font = UIFont.appFont(ofSize: 15 * AutoSizeScaleX, weight: .regular)
        notAbleFindAddressLab.text = "Wenn Du Deine Adresse nicht finden kannst"
        notAbleFindAddressLab.textColor = UIColor(hexString: "#2B395C")
        notAbleFindAddressLab.textAlignment = .center
        self.notAbleFindAddressBGView.addSubview(notAbleFindAddressLab)
        notAbleFindAddressLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.notAbleFindAddressBGView)
            make.height.equalTo(20 * AutoSizeScaleX)
            make.top.equalTo(4 * AutoSizeScaleX)
        }
        
        let clickHereBtn: UIButton = UIButton(type: .custom)
        clickHereBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        clickHereBtn.setTitle( "klicke hier", for: .normal)
        clickHereBtn.titleLabel?.font = UIFont.appFont(ofSize: 15 * AutoSizeScaleX, weight: .semibold)
        clickHereBtn.titleLabel?.textAlignment = .center
        clickHereBtn.addTarget(self, action: #selector(clickHereBtnAction(sender:)), for: .touchUpInside)
        self.notAbleFindAddressBGView.addSubview(clickHereBtn)
        clickHereBtn.snp.makeConstraints { (make) in
            make.width.equalTo(96 * AutoSizeScaleX)
            make.centerX.equalTo(self.view)
            make.top.equalTo(notAbleFindAddressLab.snp_bottom)
            make.height.equalTo(24 * AutoSizeScaleX)
        }
        
        let searchAddressFromGoogleBGView: UIView = UIView()
        searchAddressFromGoogleBGView.backgroundColor = .white
        searchAddressFromGoogleBGView.isHidden = true
        self.view.addSubview(searchAddressFromGoogleBGView)
        self.searchAddressFromGoogleBGView = searchAddressFromGoogleBGView
        searchAddressFromGoogleBGView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(50 * AutoSizeScaleX)
            make.top.equalTo(useMyCurrentLocationBtn.snp_bottom).offset(40 * AutoSizeScaleX)
        }
        let searchAddressFromGoogleLab: UILabel = UILabel()
        searchAddressFromGoogleLab.textColor = .lightGray
        searchAddressFromGoogleLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        searchAddressFromGoogleLab.text = "wenn Du die automatische Suche verwenden möchtest."
        searchAddressFromGoogleLab.numberOfLines = 0
        searchAddressFromGoogleLab.textColor = UIColor(hexString: "#2B395C")
        searchAddressFromGoogleLab.textAlignment = .center
        self.searchAddressFromGoogleBGView.addSubview(searchAddressFromGoogleLab)
        searchAddressFromGoogleLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.notAbleFindAddressBGView)
            make.height.equalTo(20 * AutoSizeScaleX)
            make.top.equalTo(4 * AutoSizeScaleX)
        }
        
        let clickHereGoogleSearchBtn: UIButton = UIButton(type: .custom)
        clickHereGoogleSearchBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        clickHereGoogleSearchBtn.setTitle( "klicke hier", for: .normal)
        clickHereGoogleSearchBtn.titleLabel?.font = UIFont.appFont(ofSize: 15 * AutoSizeScaleX, weight: .semibold)
        clickHereGoogleSearchBtn.titleLabel?.textAlignment = .center
        clickHereGoogleSearchBtn.addTarget(self, action: #selector(clickHereGoogleSearchBtnAction(sender:)), for: .touchUpInside)
        self.searchAddressFromGoogleBGView.addSubview(clickHereGoogleSearchBtn)
        clickHereGoogleSearchBtn.snp.makeConstraints { (make) in
            make.width.equalTo(96 * AutoSizeScaleX)
            make.centerX.equalTo(self.view)
            make.top.equalTo(notAbleFindAddressLab.snp_bottom)
            make.height.equalTo(24 * AutoSizeScaleX)
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
        cancleBtn.addTarget(self, action: #selector(cancelBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        
        let submitBtn: UIButton = UIButton(type: .custom)
        submitBtn.backgroundColor = UIColor(hexString: "#3868F6")
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.setTitle( "Einreichen", for: .normal)
        submitBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        submitBtn.addTarget(self, action: #selector(submitBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(cancleBtn.snp_top).offset(-20 * AutoSizeScaleX)
            make.height.equalTo(46 * AutoSizeScaleX)
        }
        //
        let searchTableViewBGView: UIView = UIView()
        searchTableViewBGView.backgroundColor = .white
        searchTableViewBGView.isHidden = true
        self.view.addSubview(searchTableViewBGView)
        self.searchTableViewBGView = searchTableViewBGView
        searchTableViewBGView.snp.makeConstraints { (make) in
            make.top.equalTo(streetAddrBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view).offset(8 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-8 * AutoSizeScaleX)
        }
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        self.searchTableViewBGView.addSubview(tableView)
        self.searchResultsTable = tableView
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(streetAddrBGView.snp_bottom).offset(10 * AutoSizeScaleX)
            make.bottom.equalTo(self.searchTableViewBGView)
            make.left.equalTo(self.searchTableViewBGView).offset(10 * AutoSizeScaleX)
            make.right.equalTo(self.searchTableViewBGView).offset(-10 * AutoSizeScaleX)
        }
    }
    
    @objc func backBtnAction(sender: UIButton) {
        self.view.endEditing(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickHereBtnAction(sender: UIButton){
        self.streetAddrManuallyTF.isHidden = false
        self.streetAddrTF.isHidden = true
        self.streetAddrManuallyTF.text = ""
        self.streetAddrTF.text = ""
        self.zipCodeTF.text =  ""
        self.cityTF.text =  ""
        self.getLatitude = -1
        self.getLongtitude = -1
        self.notAbleFindAddressBGView.isHidden = true
        self.searchAddressFromGoogleBGView.isHidden = false
        self.useMyCurrentLocationBtn.isHidden = true
    }
    
    @objc func clickHereGoogleSearchBtnAction(sender: UIButton){
        self.notAbleFindAddressBGView.isHidden = false
        self.searchAddressFromGoogleBGView.isHidden = true
        self.streetAddrManuallyTF.isHidden = true
        self.streetAddrTF.isHidden = false
        self.useMyCurrentLocationBtn.isHidden = false
        self.view.endEditing(true)
        self.streetAddrManuallyTF.text = ""
        self.streetAddrTF.text = ""
        self.zipCodeTF.text =  ""
        self.cityTF.text =  ""

    }
    
    @objc func useMyCurrentLocationBtnAction(sender:UIButton){
        self.view.endEditing(true)
        self.streetAddrManuallyTF.isHidden = true
        self.streetAddrTF.isHidden = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            //self.locationTextField.text = "Navigation Tracking Not Authorized!"
            print("Navigation Tracking Not Authorized!")
        } else {
            print("LocationManager Authorized")
        }
    }
    
    @objc func cancelBtnAction(sender: UIButton){
        self.view.endEditing(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func submitBtnAction(sender: UIButton){
        if(getLatitude == 0.0 || getLongtitude == 0.0  ){
            let alert = UIAlertController(title: "Bitte wählen Sie die richtige Adresse", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                }))
                self.present(alert, animated: true, completion: {
                })
        }else{
            if(getLatitude == -2 || getLatitude == -1){
                if(self.streetAddrManuallyTF.text!.isEmpty){
                    UIApplication.shared.showAlertWith(title: "Straße und Hausnummer sollte nicht leer sein",message: "")
                }else if(self.cityTF.text!.isEmpty){
                    UIApplication.shared.showAlertWith(title: "Stadt sollte nicht leer sein",message: "")

                }else{
                delegate?.getData(streetAddr: self.streetAddrManuallyTF.text!,houseNoStr: "", aptSuite: "", city: self.cityTF.text!, zipCode: self.zipCodeTF.text!, country: "", countryCode: self.countryCode, latitude: self.getLatitude, longitude: self.getLongtitude, homeAddressType: self.getHomeWorkType)
                    self.view.endEditing(false)
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                if(self.streetAddrTF.text! == " "){
                    UIApplication.shared.showAlertWith(title: "Straße und Hausnummer sollte nicht leer sein",message: "")
                }else if(self.cityTF.text!.isEmpty){
                    UIApplication.shared.showAlertWith(title: "Stadt sollte nicht leer sein",message: "")

                }else{
                delegate?.getData(streetAddr: self.streetAddrTF.text!,houseNoStr: self.houseNo, aptSuite: "", city: self.cityTF.text!, zipCode: self.zipCodeTF.text!, country: "", countryCode: self.countryCode, latitude: self.getLatitude, longitude: self.getLongtitude, homeAddressType: self.getHomeWorkType)
                    self.view.endEditing(false)
                    self.navigationController?.popViewController(animated: true)
                }
            }

//            }
 
        }
    }
    
    @objc func addAddressBtnAction(sender: UIButton) {
        let geocoder1 = CLGeocoder()
        let address = "\(self.streetAddrTF.text!),\(self.cityTF.text!)"
                geocoder1.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                    if((error) != nil){
                        print("Error", error ?? "")
                    }
                    if let placemark = placemarks?.first {
                        let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate

                    }
                })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let myLocation : CLLocation = locations[0]
        
            manager.stopUpdatingLocation()  // use this line only if 1 location is needed.
            
            CLGeocoder().reverseGeocodeLocation(myLocation, completionHandler:{(placemarks, error) in
                
                if ((error) != nil)  { print("Error: \(String(describing: error))") }
                else {
                    
                    let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
                    
                    var name:String = ""
                    var subThoroughfare:String = ""
                    var thoroughfare:String = ""
                    var locality:String = ""
                    var subLocality:String = ""
                    var subAdministrativeArea:String = ""
                    var postalCode:String = ""
                    var country:String = ""
                    var administrativeArea:String = ""
                        // Use a series of ifs, or nil coalescing operators ??s, as per your coding preference.
                    if ((p.subThoroughfare) != nil) {
                        subThoroughfare = (p.subThoroughfare)!
                    }
                    if ((p.thoroughfare) != nil) {
                        thoroughfare = p.thoroughfare!
                    }
                    if ((p.subLocality) != nil) {
                        subLocality = p.subLocality!
                    }
                    
                    if ((p.administrativeArea) != nil) {
                        administrativeArea = p.administrativeArea!
                    }
                    if ((p.subAdministrativeArea) != nil) {
                        subAdministrativeArea = p.subAdministrativeArea!
                    }
                    if ((p.postalCode) != nil) {
                        postalCode = p.postalCode!
                    }
                    if ((p.name) != nil) {
                        name = p.name!
                    }
                    if ((p.locality) != nil) {
                        locality = p.locality!
                    }
        
                    if ((p.country) != nil) {
                        country = p.country!
                    }

                    self.streetAddrTF.text = "\(thoroughfare) \(subThoroughfare)"
                    self.houseNo =  "\(subThoroughfare)"
                    self.cityTF.text = "\(administrativeArea) \(subAdministrativeArea)"
                    self.zipCodeTF.text = "\(postalCode)"
                    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
                    manager.stopUpdatingLocation()
                    let latdoubleStr = String(format: "%.3f", locValue.latitude)
                    let longdoubleStr = String(format: "%.3f", locValue.longitude)
                    self.getLatitude = Double(latdoubleStr) ?? 0.0
                    self.getLongtitude = Double(longdoubleStr) ?? 0.0

                }   // end else no error
              }       // end CLGeocoder reverseGeocodeLocation
            )       // end CLGeocoder
        }   // end
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func endEdit() {
        self.view.endEditing(true)
    }
    
    // This method declares that whenever the text in the searchbar is change to also update
    // the query that the searchCompleter will search based off of
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
    @objc func textFieldChanged(sender: UIControl) {
      guard let textField = sender as? UITextField else { return }
        self.searchTableViewBGView.isHidden = false
        searchCompleter.filterType = .locationsAndQueries
        searchCompleter.queryFragment = textField.text ?? ""
    
    }
    // This method declares gets called whenever the searchCompleter has new search results
    // If you wanted to do any filter of the locations that are displayed on the the table view
    // this would be the place to do it.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        // Setting our searcResults variable to the results that the searchCompleter returned
        searchResults = completer.results
        
        // Reload the tableview with our new searchResults
        searchResultsTable.reloadData()
    }
    
    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.streetAddrTF){
            self.searchTableViewBGView.isHidden = false
            self.searchBar.isHidden = false
            searchCompleter.queryFragment = textField.text!
        }
        let maxLength = 40
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            let lon: Double = Double("\(pdblLongitude)")!
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]

                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                            self.streetAddrTF.text = "\(pm.thoroughfare!) \(pm.subThoroughfare!)"
                            self.houseNo = pm.subThoroughfare!

                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                            self.cityTF.text = pm.locality!

                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                            self.zipCodeTF.text = pm.postalCode!
                        }
                  }
            })

        }
    
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
       // let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyATxf1AEc3FFa9TKQCwOpgSx-S3jShptP8"
//let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=56006&language=fr&types=geocode&key=AIzaSyATxf1AEc3FFa9TKQCwOpgSx-S3jShptP8"
       // let url = "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyATxf1AEc3FFa9TKQCwOpgSx-S3jShptP8&placeid=ChIJT7Uylnzc3IARLySp4JPG-0w"
        let url = " https://dev-api.riso-app.de/api/v1/maps/place-details?placeid=ChIJN1t_tDeuEmsRUsoyG83frY4"
print("getAddressFromLatLonggetAddressFromLatLong")
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:

                let responseJson = response.result.value! as! NSDictionary

                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
                            for component in addressComponents {
                                if let temp = component.object(forKey: "types") as? [String] {
                                    if (temp[0] == "postal_code") {
                                    }
                                    if (temp[0] == "locality") {
                                }
                                    if (temp[0] == "administrative_area_level_1") {
                                 }
                                    if (temp[0] == "country") {
                              }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - TextView Delegate Methods

// Setting up extensions for the table view
extension AddAddressViewController: UITableViewDataSource {
    // This method declares the number of sections that we want in our table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This method declares how many rows are the in the table
    // We want this to be the number of current search results that the
    // Completer has generated for us
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // This method delcares the cells that are table is going to show at a particular index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = searchResults[indexPath.row]
        
        //Create  a new UITableViewCell object
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        //Set the content of the cell to our searchResult data
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension AddAddressViewController: UITableViewDelegate {
    // This method declares the behavior of what is to happen when the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            print(name)
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            //self.aptSuiteTF.text = name
            let latdoubleStr = String(format: "%.3f", coordinate.latitude)
            let longdoubleStr = String(format: "%.3f", coordinate.longitude)
            self.getLatitude = Double(latdoubleStr) ?? 0.0
            self.getLongtitude = Double(longdoubleStr) ?? 0.0
            for item in response!.mapItems {
               // self.streetAddrTF.text = item.placemark.thoroughfare ?? ""
                self.streetAddrTF.text = "\(item.placemark.thoroughfare ?? "") \(item.placemark.subThoroughfare ?? "")"
                //self.aptSuiteTF.text = "\(item.placemark.thoroughfare ?? "")"
                //self.houseNoTF.text = item.placemark.subThoroughfare ?? ""
                self.houseNo = (item.placemark.thoroughfare ?? "")
                self.zipCodeTF.text = item.placemark.postalCode ?? ""
                self.cityTF.text =  item.placemark.locality ?? ""
                self.countryCode = item.placemark.countryCode ?? ""
                }
            for item in response!.mapItems {
                   if let name = item.name,
                       let location = item.placemark.location {
                   }
               }
            self.searchTableViewBGView.isHidden = true
          //  self.getAddressFromLatLon(pdblLatitude: String(lat), withLongitude: String(lon))
            self.view.endEditing(true)

        }
    }
}


extension UISearchBar {

    func getTextField() -> UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            // Fallback on earlier versions
            let textField = subviews.first(where: { $0 is UITextField }) as? UITextField
            return textField
        }
    }
}
// MARK: - UITextFieldDelegate
extension AddAddressViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case streetAddrTF:
            zipCodeTF.becomeFirstResponder()
            return true
//        case houseNoTF:
//            aptSuiteTF.becomeFirstResponder()
//            return true
//        case aptSuiteTF:
            zipCodeTF.becomeFirstResponder()
            return true
        case zipCodeTF:
            cityTF.becomeFirstResponder()
            return true
        case cityTF:
            cityTF.resignFirstResponder()
            return true
        default:
            textField.resignFirstResponder()
            return true
        }
    }
    
}
