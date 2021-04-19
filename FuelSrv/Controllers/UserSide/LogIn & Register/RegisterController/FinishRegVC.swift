//
//  FinishRegVC.swift
//  FuelSrv
//
//  Created by PBS9 on 12/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import ObjectMapper

class FinishRegVC: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate{
    
    
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet var myView: MapView!
    @IBOutlet weak var pickupLocation: UITextField!
    @IBOutlet weak var searchTbl: UITableView!
    @IBOutlet var locationMarker: UIImageView!
    @IBOutlet weak var saveBtnAction: RoundButton!
    @IBOutlet weak var currentLocationBtnAction: UIButton!
    @IBOutlet weak var addressTitletxt: UITextField!
    
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    var updateLocationData: UpdateLocationModel!
    
    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    
    var locationData: Location!
    var userLocation = appDelegate.orderDataDict["UserLocation"] as? [String : String] ?? [:]
    var locationManager = CLLocationManager()
    var placeArray = [[String:Any]]()
    var placeID = ""
    var mapLat: Double?
    var mapLong: Double?
    var getname = ""
    var postalCode = String()
    var isValid = Bool()
    var placesClient: GMSPlacesClient!
    var geoCoder = GMSGeocoder()
    var originalPullUpControllerViewSize: CGSize = .zero
    //var accontType: Int!
    var value: Int?
    var SelectedAddress:String?
    
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userLocation)
        searchTbl.dropShadow(view: searchTbl, opacity: 0.5)
        searchTbl.layer.cornerRadius = 5
        
//        addressTitletxt.adjustsFontSizeToFitWidth = true
//        addressTitletxt.minimumFontSize = 10

        //mapSetup()
        //addPullUpController()
        myView.mapType = .satellite
        googleLocations()
        roundedView.dropShadow(view: roundedView, opacity: 1.0)
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let nib = UINib.init(nibName: "placeCell", bundle: nil)
        searchTbl.register(nib, forCellReuseIdentifier: "placeCell")
        NotificationCenter.default.removeObserver(self, name: .userAccountVC, object: nil)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .reloadVc, object: nil)
     }
    //MARK:- Button Actions
    
    @IBAction func viewBtnAction(_ sender: UIButton) {
        //viewBottom.constant = 0
        if sender.isSelected{
            viewBtn.setImage(#imageLiteral(resourceName: "doubleup"), for: .normal)
            viewBottom.constant = -200
        
        }else {
           
            viewBtn.setImage(#imageLiteral(resourceName: "doubledown"), for: .normal)
            viewBottom.constant = 0
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
       
        if Helper.shared.isFieldEmpty(field: addressTitletxt.text!) {
            showAlert("Notification", "Please Enter Address title", "OK")
        }else if (isValid == false){
            self.showAlert("Info:", "Choose the Prefered Address", "OK")
        }else{
            //updateLocationAPI()
            if value == 3 {
                editLocationAPI()
                
            }else {
                updateLocationAPI()
                
            }
        }
    }
    
    @IBAction func currentLocationBtnAction(_ sender: Any) {
        showCurrentLocationOnMap()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Navigation SetUp
    func navigationItem(){
       
            let imgBack = UIImage(named: "back")
            navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(backAction))
        
    }
    @objc func backAction(){
        self.dismiss(animated: true, completion: nil)
        
//        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        let nav = NavigationController.init(rootViewController: vc)
//        self.sideMenuController?.rootViewController = nav
    }
    
    
   
    
    
    //MARK:- GoogleMap Delegates
    func googleLocations(){
        
        placesClient = GMSPlacesClient.shared()
        self.pickupLocation.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if value == 1{
            showCurrentLocationOnMap()
        }
        if value == 2 {
//            saveBtnAction.isHidden = false
//            currentLocationBtnAction.isHidden = false
            //navigationItem()
            backBtn.isHidden = false
            showCurrentLocationOnMap()
        }
        else if value == 3{
            backBtn.isHidden = false
            addressTitletxt.text = userLocation["AddressTitle"]
            pickupLocation.text = userLocation["SelectedAddress"]
            mapLat = Double(userLocation["Maplat"] ?? "")
            mapLong = Double(userLocation["MapLong"] ?? "")
            
            selectedLocation()
        }
        if defaultValues.integer(forKey: "AccountType") == 1{
            let customFont = UIFont(name: "SegoeUI-Semibold", size: 20) ?? .boldSystemFont(ofSize: 20)
            let myString = "Move the PIN to show us where you Business vehicles are typically park. This can be changed later!"
    
            let myAttribute = [ NSAttributedString.Key.font : customFont ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            textLbl.attributedText  = myAttrString
        pickupLocation.placeholder = "Where are your vehicles?"
            //textLbl.text = "Move the PIN to show us where you Business vehicles are typically park. This can be changed later!"
        }else{
            textLbl.text = "Move the PIN to show us where you typically park. This can be changed later!"
             pickupLocation.placeholder = "Where's your vehicle?"
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let currentLocation = locations[0]
        myView.updateMapCamera(location: currentLocation)
        getAddressFromCoordinates(location: currentLocation.coordinate)
        
    }
    //MARK:- Show current Location on map
    func showCurrentLocationOnMap(){
    
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude ?? 0.0), longitude: (self.locationManager.location?.coordinate.longitude ?? 0.0), zoom: 15)
        myView.animate(to: camera)
        myView.isMyLocationEnabled = true
        self.mapSetup()
    }
    
    
    //MARK:- Getting loactions by using Marker
    func mapSetup(){
        
        myView.mapType = .satellite
        
        myView.mapIdleAt = {
            (location) in
            self.getAddressFromCoordinates(location: location)
        }
    }

    func getAddressFromCoordinates(location: CLLocationCoordinate2D){
        
        geoCoder.reverseGeocodeCoordinate(location){
            (response,error) in
            if let address = response?.firstResult(){
                
                self.pickupLocation.text = address.lines?.joined(separator: ",")
                //print(String(describing: address.lines?.joined(separator: " ")))
                let codeObj = address.postalCode?.components(separatedBy: " ")
                self.postalCode = (codeObj?[0]) ?? "000"
                print(self.postalCode)
                self.getCityAvailabilityAPI()
                self.mapLat = address.coordinate.latitude
                self.mapLong = address.coordinate.longitude
                self.SelectedAddress = self.pickupLocation.text
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    //MARK: - For Getting Particular Location
    func selectedLocation()  {
        myView.mapType = .satellite
        let camera = GMSCameraPosition.camera(withLatitude: mapLat!, longitude: mapLong!, zoom: 17.0)
        myView.animate(to: camera)
            self.mapSetup()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let obj = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if (obj.count) > 0{
            searchTbl.isHidden = false
            getPlaces(obj)
            searchTbl.reloadData()
        }else{
            searchTbl.isHidden = true
            pickupLocation.placeholder = "Where to?"
            placeArray.removeAll()
        }
        return true
    }
    //MARK:- GooglePlaces
    func getPlaces(_ name: String?) {
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        placesClient.autocompleteQuery(name!, bounds: nil, filter: filter) { (results, error) in
            if error != nil {
                print("Autocomplete error \(error?.localizedDescription ?? "")")
                return
            }
            self.placeArray.removeAll()
            
            for result in results ?? [] {
                //print("Result '\(result.attributedFullText.string)' with placeID \(result.placeID)")
                //var items = result.attributedFullText.string.components(separatedBy: ",")
                var dict: [String:Any] = [:]
                dict["address"] = result.attributedFullText.string
                dict["placeID"] = result.placeID
                //                items.removeLast()
                //                dict["state"] = items.last
                //                items.removeLast()
                //                dict["city"] = items.last
                self.placeArray.append(dict)
                dict.removeAll()
            }
            //self.searchTbl.isHidden = false
            self.searchTbl.reloadData()
            //print("Place array-----\(self.placeArray)")
        }
        self.searchTbl.isHidden = false
        self.searchTbl.reloadData()
        
    }
    
    //MARK:- Creating PullUp Controller
/*    private func makeSearchViewControllerIfNeeded() -> YouViewController {
        let currentPullUpController = childViewControllers
            .filter({ $0 is YouViewController })
            .first as? YouViewController
        let pullUpController: YouViewController = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "YouViewController") as! YouViewController
        
        pullUpController.value = accontType
        
        if originalPullUpControllerViewSize == .zero {
            originalPullUpControllerViewSize = pullUpController.view.bounds.size
        }
        return pullUpController
    }
    private func addPullUpController() {
        let pullUpController = makeSearchViewControllerIfNeeded()
        _ = pullUpController.view // call pullUpController.viewDidLoad()
        addPullUpController(pullUpController,
                            initialStickyPointOffset: pullUpController.initialPointOffset - 20
            ,
                            animated: true)
    }
    */
    
    //MARK:- Checking City Availability
    func getCityAvailabilityAPI(){
        
        let params:[String:Any] = ["locationProvince": postalCode]
        WebService.shared.apiGet(url: getCityAvailabilityURL, parameters: params) { (responce, error) in
            if error == nil {
                if let dict = responce {
                    if dict["isValid"] as! Int == 0 {
                        self.showAlert("Info:", dict["message"] as! String , "OK")
                        self.isValid = false
                        
//                        self.urgentOrderBtn.isEnabled = false
//                        self.scheduledFuelingBtn.isEnabled = false
                    }else{
                        self.isValid = true
//                        self.urgentOrderBtn.isEnabled = true
//                        self.scheduledFuelingBtn.isEnabled = true
                    }
                    
                }
            }
        }
    }
    
    //MARK:- Update Location API
    func updateLocationAPI(){
        let params:[String:Any] = [
            "userId": defaultValues.string(forKey: "UserID")!,
            "addressTitle": addressTitletxt.text!,
            "user_lat": String(describing: mapLat!),
            "user_long":String(describing: mapLong!),
            "userAddress": SelectedAddress!
        ]
        
        WebService.shared.apiDataPostMethod(url: updateLocationURL, parameters: params) { (response, error) in
            if error == nil{
                self.updateLocationData = Mapper<UpdateLocationModel>().map(JSONObject: response)
                if self.updateLocationData.success == true{
                    if self.value == 2{
    
                        NotificationCenter.default.post(name: .userAccountVC, object: nil)
                        NotificationCenter.default.post(name: .reloadVc, object: nil)
                        self.dismiss(animated: true, completion: nil)
   
                  }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReferralCodeVC") as! ReferralCodeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
    
                }else{
                    Helper.Alertmessage(title: "Info:", message: self.updateLocationData.message ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    //MARK:- Edit Location API
    func editLocationAPI(){
        let params:[String:Any] = [
            "userId": defaultValues.string(forKey: "UserID")!,
            "addressTitle": addressTitletxt.text!,
            "user_lat": String(describing: mapLat!),
            "user_long":String(describing: mapLong!),
            "userAddress": SelectedAddress!,
            "locationId" : userLocation["AddressId"]!
        ]
        
        WebService.shared.apiDataPostMethod(url: editAddressURL, parameters: params) { (response, error) in
            if error == nil{
                self.updateLocationData = Mapper<UpdateLocationModel>().map(JSONObject: response)
                if self.updateLocationData.success == true{
                    
                        
                        NotificationCenter.default.post(name: .userAccountVC, object: nil)
                        self.dismiss(animated: true, completion: nil)
                        
                    
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: self.updateLocationData.message ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
//MARK: - Creating TableView
extension FinishRegVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return placeArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTbl.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! placeCell
        
        let str = placeArray[indexPath.row]["address"] as! String
        let firstWord = str.components(separatedBy: ", ")[0]
        cell.subAddressLbl.text = firstWord
        
        cell.addressLbl.text = placeArray[indexPath.row]["address"] as? String
        
        cell.btn.addTarget(self, action: #selector(btnPrsd(_:)), for: .touchUpInside)
        cell.btn.tag = indexPath.row
        return cell
        
    }
    @objc func btnPrsd(_ sender: Any?) {
        self.mapSetup()
        // SVProgressHUD.show()
        
        searchTbl.isHidden = true
        pickupLocation.resignFirstResponder()
        let btn = sender as! UIButton
        placeID = (placeArray[btn.tag ])["placeID"] as! String
        let placesClient = GMSPlacesClient()
        placesClient.lookUpPlaceID(placeID, callback: { place, error in
            if error != nil {
                print("Place Details error \(error?.localizedDescription ?? "")")
                return
            }
            self.pickupLocation.text = place?.name
//            print("somthing there\(place!)")
//            print("somthing there\(place?.coordinate)")
            self.mapLat = place?.coordinate.latitude
            self.mapLong = place?.coordinate.longitude
            self.getname = place?.formattedAddress ?? ""
            self.SelectedAddress = self.pickupLocation.text
            self.selectedLocation()
        })
        
    }
}
/*
public extension UIView {
    
    func topToBottom(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = 4) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        //animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation), y: self.center.y))
        layer.add(animation, forKey: "topToBottom")
    }
}
*/

