//
//  AddressViewController.swift
//  BFA
//
//  Created by Mohammed Aslam on 2022/9/4.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import GooglePlaces
import SwiftyJSON
class AddressViewController: AutocompleteBaseViewController,CLLocationManagerDelegate,MKLocalSearchCompleterDelegate {
    private let padding: CGFloat = 20

    private var searchField : UITextField = UITextField()
    private var aptSuiteTF : UITextField = UITextField()
    private var landMarkTF : UITextField = UITextField()
    private var cityTF : UITextField = UITextField()
    private var zipCodeTF : UITextField = UITextField()
    private var countryTF : UITextField = UITextField()
    private var streetAddr: String = ""
    private var aptSuite: String = ""
    private var city: String = ""
    private var zipCode: String = ""
    private var country: String = ""
    private var countryCode: String = ""
    private var home_latitude: Double = 0.0
    private var home_longitude: Double = 0.0
    weak var delegate: GetDataDelegte?
    private var getHomeWorkType : Int = 0
    private var getLatitude : Double = 0
    private var getLongtitude : Double = 0
    private var locationManager = CLLocationManager()
    private var searchTableViewBGView: UIView = UIView()
    private var searchResultsTable: UITableView!
    private lazy var tableDataSource: GMSAutocompleteTableDataSource = {
      let tableDataSource = GMSAutocompleteTableDataSource()
      tableDataSource.tableCellBackgroundColor = .white
      return tableDataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "Add Address"
        
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
        streetAddrTF.placeholder = "Street address"
        streetAddrTF.autocorrectionType = .no
        streetAddrTF.keyboardType = .default
        streetAddrTF.returnKeyType = .done
        streetAddrTF.clearButtonMode = .whileEditing
        streetAddrTF.contentVerticalAlignment = .center
        streetAddrTF.delegate = self
        streetAddrTF.textColor = UIColor(hexString: "#2B395C")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "search")
        imageView.image = image
        streetAddrTF.leftView = imageView
        streetAddrTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        streetAddrTF.text = streetAddr
//        searchCompleter.delegate = self
        streetAddrBGView.addSubview(streetAddrTF)
        self.searchField = streetAddrTF
        streetAddrTF.snp.makeConstraints { (make) in
            make.left.equalTo(streetAddrBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(streetAddrBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(streetAddrBGView)
        }
        
        let aptSuiteBGView: UIView = UIView()
        aptSuiteBGView.backgroundColor = .white
        aptSuiteBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        aptSuiteBGView.layer.shadowColor = UIColor.black.cgColor
        aptSuiteBGView.layer.shadowOffset = CGSize.zero
        aptSuiteBGView.layer.shadowOpacity = 0.12
        aptSuiteBGView.layer.shadowRadius = 3
        self.view.addSubview(aptSuiteBGView)
        aptSuiteBGView.snp.makeConstraints { (make) in
            make.top.equalTo(streetAddrBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let aptSuiteTF: UITextField = UITextField()
        aptSuiteTF.clearButtonMode = UITextField.ViewMode.always
        aptSuiteTF.placeholder = "Apt, suite, etc (optional)"
        aptSuiteTF.delegate = self
        aptSuiteTF.clearButtonMode = .whileEditing
        aptSuiteTF.text = self.aptSuite
        aptSuiteTF.textColor = UIColor(hexString: "#2B395C")
        aptSuiteBGView.addSubview(aptSuiteTF)
        self.aptSuiteTF = aptSuiteTF
        aptSuiteTF.snp.makeConstraints { (make) in
            make.left.equalTo(aptSuiteBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(aptSuiteBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(aptSuiteBGView)
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
            make.top.equalTo(aptSuiteTF.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let cityTF: UITextField = UITextField()
        cityTF.clearButtonMode = UITextField.ViewMode.always
        cityTF.placeholder = "City"
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
        
        let zipCodeBGView: UIView = UIView()
        zipCodeBGView.backgroundColor = .white
        zipCodeBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        zipCodeBGView.layer.shadowColor = UIColor.black.cgColor
        zipCodeBGView.layer.shadowOffset = CGSize.zero
        zipCodeBGView.layer.shadowOpacity = 0.12
        zipCodeBGView.layer.shadowRadius = 3
        self.view.addSubview(zipCodeBGView)
        zipCodeBGView.snp.makeConstraints { (make) in
            make.top.equalTo(cityBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let zipCodeTF: UITextField = UITextField()
        zipCodeTF.clearButtonMode = UITextField.ViewMode.always
        zipCodeTF.placeholder = "ZIP / Postcode"
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
        
        let countryBGView: UIView = UIView()
        countryBGView.backgroundColor = .white
        countryBGView.layer.cornerRadius = 2 * AutoSizeScaleX
        countryBGView.layer.shadowColor = UIColor.black.cgColor
        countryBGView.layer.shadowOffset = CGSize.zero
        countryBGView.layer.shadowOpacity = 0.12
        countryBGView.layer.shadowRadius = 3
        self.view.addSubview(countryBGView)
        countryBGView.snp.makeConstraints { (make) in
            make.top.equalTo(zipCodeBGView.snp_bottom).offset(20 * AutoSizeScaleX)
            make.height.equalTo(60 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }

        let countryTF: UITextField = UITextField()
        countryTF.clearButtonMode = UITextField.ViewMode.always
        countryTF.placeholder = "Country"
        countryTF.text = self.country
        countryTF.clearButtonMode = .whileEditing
        countryTF.delegate = self
        countryTF.textColor = UIColor(hexString: "#2B395C")
        countryBGView.addSubview(countryTF)
        self.countryTF = countryTF
        countryTF.snp.makeConstraints { (make) in
            make.left.equalTo(countryBGView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(countryBGView).offset(-20 * AutoSizeScaleX)
            make.top.bottom.equalTo(countryBGView)
        }
        
        let useMyCurrentLocationBtn: UIButton = UIButton(type: .custom)
        useMyCurrentLocationBtn.setTitleColor(UIColor(hexString: "#3868F6"), for: .normal)
        useMyCurrentLocationBtn.setTitle( "Use my current location", for: .normal)
        useMyCurrentLocationBtn.layer.cornerRadius = 7 * AutoSizeScaleX
        useMyCurrentLocationBtn.layer.borderWidth = 1 * AutoSizeScaleX
        useMyCurrentLocationBtn.layer.borderColor = UIColor(hexString: "#3868F6").cgColor
        useMyCurrentLocationBtn.layer.shadowColor = UIColor.black.cgColor
        useMyCurrentLocationBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        useMyCurrentLocationBtn.layer.shadowOpacity = 0.12
        useMyCurrentLocationBtn.layer.shadowRadius = 3
        useMyCurrentLocationBtn.addTarget(self, action: #selector(useMyCurrentLocationBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(useMyCurrentLocationBtn)
        useMyCurrentLocationBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.top.equalTo(countryBGView.snp_bottom).offset(20 * AutoSizeScaleX)
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
//        //
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
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        self.searchTableViewBGView.addSubview(tableView)
        self.searchResultsTable = tableView
        self.searchResultsTable.delegate = tableDataSource
        self.searchResultsTable.dataSource = tableDataSource
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(streetAddrBGView.snp_bottom).offset(10 * AutoSizeScaleX)
            make.bottom.equalTo(self.searchTableViewBGView)
            make.left.equalTo(self.searchTableViewBGView).offset(10 * AutoSizeScaleX)
            make.right.equalTo(self.searchTableViewBGView).offset(-10 * AutoSizeScaleX)
        }
        configDefault()
    }
    //
    func configDefault(){
        searchField.delegate = self
        tableDataSource.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func backBtnAction(sender: UIButton) {
        self.view.endEditing(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func useMyCurrentLocationBtnAction(sender:UIButton){
        self.view.endEditing(true)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
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
            let alert = UIAlertController(title: "Please select proper address", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in
                }))
                self.present(alert, animated: true, completion: {
                })
        }else{
            self.view.endEditing(false)
            self.navigationController?.popViewController(animated: true)
            delegate?.getData(streetAddr: self.searchField.text!, houseNoStr: "",aptSuite: self.aptSuiteTF.text!, city: self.cityTF.text!, zipCode: self.zipCodeTF.text!, country: self.countryTF.text!, countryCode: self.countryCode, latitude: self.getLatitude, longitude: self.getLongtitude, homeAddressType: self.getHomeWorkType)
        }
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
                    
                    
                    self.searchField.text = "\(name)"
                    self.aptSuiteTF.text = " \(thoroughfare) \(subThoroughfare)"
                    self.cityTF.text = "\(administrativeArea) \(subAdministrativeArea)"
                    self.zipCodeTF.text = "\(postalCode)"
                    self.countryTF.text = country

                    if let location = locations.last {
                        print("Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)")
                        self.getLatitude = (location.coordinate.latitude)
                        self.getLongtitude = (location.coordinate.longitude)
                        }

                }   // end else no error
              }       // end CLGeocoder reverseGeocodeLocation
            )       // end CLGeocoder
        }   // end

    @objc func textFieldChanged(sender: UIControl) {
        self.searchTableViewBGView.isHidden = false
      guard let textField = sender as? UITextField else { return }
      tableDataSource.sourceTextHasChanged(textField.text)
    }

    func dismissResultView() {

    }
    
}

extension AddressViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {

  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    dismissResultView()
    textField.resignFirstResponder()
    textField.text = ""
    tableDataSource.clearResults()
    return false
  }
}

extension AddressViewController: GMSAutocompleteTableDataSourceDelegate {
  func tableDataSource(
    _ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace
  ) {
    dismissResultView()
    searchField.resignFirstResponder()
    searchField.isHidden = false
    self.searchTableViewBGView.isHidden = true

      if place.name?.description != nil {

      }

      // Show latitude
      if place.coordinate.latitude.description.count != 0 {
          let latitude = place.coordinate.latitude
          self.getLatitude = latitude
      }
      // Show longitude
      if place.coordinate.longitude.description.count != 0 {
          let selectedLongitude = place.coordinate.longitude
          self.getLongtitude = selectedLongitude
      }

      // Show AddressComponents
      if place.addressComponents != nil {

          for addressComponent in (place.addressComponents)! {
             for type in (addressComponent.types){
                 switch(type){
                 case "sublocality_level_2":
                     self.searchField.text = addressComponent.name
                case "sublocality_level_1":
                     self.aptSuiteTF.text = addressComponent.name
                 case "administrative_area_level_2":
                     self.city = addressComponent.name
                     self.cityTF.text = self.city
                 case "country":
                     self.countryTF.text = addressComponent.name
                case "postal_code":
                     self.zipCodeTF.text = addressComponent.name
                 default:
                     break
                 }
             }
         }
      }
      dismiss(animated: true, completion: nil)
  }

  func tableDataSource(
    _ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error
  ) {
    dismissResultView()
    searchField.resignFirstResponder()
    searchField.isHidden = true
    autocompleteDidFail(error)
  }

  func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
      self.searchResultsTable.reloadData()

  }
  func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
      self.searchResultsTable.reloadData()
  }
}
