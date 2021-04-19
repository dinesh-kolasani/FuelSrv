//
//  HomeVC.swift
//  FuelSrv
//
//  Created by PBS9 on 02/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import IQKeyboardManagerSwift



class HomeVC: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate{
    @IBOutlet var myView: MapView!
    @IBOutlet var mainbuttonview: UIView!
    @IBOutlet weak var pickupLocation: UITextField!
    @IBOutlet weak var searchTbl: UITableView!
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var locationMarker: UIImageView!
    
    @IBOutlet weak var urgentOrderBtn: UIButton!
    @IBOutlet weak var scheduledFuelingBtn: UIButton!
    @IBOutlet weak var myLocationBtn: UIButton!
    @IBOutlet weak var fuelSrvPriceLbl: UILabel!
    @IBOutlet weak var priceTitleLbl: UILabel!
    @IBOutlet weak var localPriceTitleLbl: UILabel!
    
    @IBOutlet weak var localPriceLbl: UILabel!
    @IBOutlet weak var searchTblHeight: NSLayoutConstraint!
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var geoCoder = GMSGeocoder()
    var placeArray = [[String:Any]]()
    var userAddress = [String:String]()
    
    var GetHomeDataModelData: GetHomeDataModel!
    var LocationData: [Location]?
    var fuelData: [FuelData]?
    var tableViewNum = Int()
    
    @IBOutlet weak var timingLbl: UILabel!
    var placeID = ""
    var mapLat: Double?
    var mapLong: Double?
    var getname = ""
    var postalCode = String()
    var isValid = Bool()
    var hoursS = ""
    var hoursE = ""
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.isHidden = false
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
        if defaultValues.integer(forKey: "AccountType") == 1 {
            self.pickupLocation.placeholder = "Where are your vehicles?"
        }else{
            self.pickupLocation.placeholder = "Where's your vehicle?"
        }
        //mapSetup()
        tableViewNum = 0
        getHomeDataAPI()
       locationMarker.isHidden = true
        showCurrentLocationOnMap()
        //navigation()
        appDelegate.orderDataDict = [:]
        roundedView.dropShadow(view: roundedView, opacity: 0.5)
        mainbuttonview.setOneSideCorner(outlet: mainbuttonview)
        urgentOrderBtn.dropShadow(view: urgentOrderBtn, opacity: 0.5)
        scheduledFuelingBtn.dropShadow(view: scheduledFuelingBtn, opacity: 0.5)
        myLocationBtn.dropShadow(view: myLocationBtn, opacity: 0.5)
        searchTbl.dropShadow(view: searchTbl, opacity: 0.5)
        placesClient = GMSPlacesClient.shared()
        self.pickupLocation.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let nib = UINib.init(nibName: "placeCell", bundle: nil)
        searchTbl.register(nib, forCellReuseIdentifier: "placeCell")
                print(appDelegate.orderDataDict)
        
//        for fontFamilyName in UIFont.familyNames {
//            print("family: \(fontFamilyName)\n")
//            
//            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName) {
//                print("font: \(fontName)")
//            }
//        }
        
    }
    

    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    //MARK:- Button Actions
    
    @IBAction func menuBtn(_ sender: UIButton) {
        userAddress[LocationEnum.Maplat.rawValue] = "\(mapLat ?? 0.0)"
        userAddress[LocationEnum.MapLong.rawValue] = "\(mapLong ?? 0.00)"
        
        appDelegate.orderDataDict[OrderDataEnum.UserLocation.rawValue] = userAddress
        
        showMenu()
    }
    
    @IBAction func urgentOrderBtn(_ sender: Any) {
        if haltedTrue == 0 {
            let timeCurrent = presentTime()
            print(timeCurrent)
            
            // Formating string to Hours
            let inFormatter = DateFormatter()
            inFormatter.dateFormat = "HH:mm"
            
            let outFormatter = DateFormatter()
            outFormatter.dateFormat = "HH:mm"
            
            // let inStr = "16:50"
            let date = inFormatter.date(from: "\(timeCurrent[0]):\(timeCurrent[1])")!
            print(date)
            let outStr = outFormatter.string(from: date)
            
            print("converted time\(outStr)")
            
            
            if isValid == false{
                self.showAlert("Info:", "Please choose an address", "ok")
            }
            else if outStr >= endTime || outStr < startTime{
                
//                showAlert("Info:", "We're sorry, we won't be fueling at that time! Please request a time within our service hours(\(startTime) to \(endTime)).", "OK")
                
                showAlert("Info:", "We’re sorry, our current service hours are \(startTime) to \(endTime), please schedule a fueling between those hours using the calendar button.:)", "OK")
                
            }else{
                
                userAddress[LocationEnum.Maplat.rawValue] = "\(mapLat ?? 0.0)"
                userAddress[LocationEnum.MapLong.rawValue] = "\(mapLong ?? 0.00)"
                userAddress[LocationEnum.isUrgent.rawValue] = "1"
                userAddress[LocationEnum.SelectedAddress.rawValue] = pickupLocation.text
                appDelegate.orderDataDict[OrderDataEnum.UserLocation.rawValue] = userAddress
                
                appDelegate.orderDataDict[OrderDataEnum.Schedule.rawValue] = [:]
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConvenientServicesVC") as! ConvenientServicesVC
                urgentOrder = 1
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            self.showAlert("Info:", haltedMessage, "ok")
        }
    }
    @IBAction func myLocationBtn(_ sender: Any) {
       self.mapSetup()
        self.showCurrentLocationOnMap()
        locationMarker.isHidden = false
        self.locationManager.stopUpdatingLocation()
    }
    
    @IBAction func scheduleFuelingBtn(_ sender: UIButton) {
        
        validations()
        
        userAddress[LocationEnum.Maplat.rawValue] = "\(mapLat ?? 0.0)"
        userAddress[LocationEnum.MapLong.rawValue] = "\(mapLong ?? 0.00)"
        userAddress[LocationEnum.isUrgent.rawValue] = "0"
        userAddress[LocationEnum.SelectedAddress.rawValue] = pickupLocation.text
        appDelegate.orderDataDict[OrderDataEnum.UserLocation.rawValue] = userAddress
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleFuelingVC") as! ScheduleFuelingVC
//        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
    //MAREK:- Validations
    
    func validations()
    {
        //if (self.pickupLocation.text?.isEmpty)! && mapLat == nil
         if isValid == false || mapLat == nil
        {
            self.showAlert("Info:", "Please choose an address", "ok")
        }else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleFuelingVC") as! ScheduleFuelingVC
            urgentOrder = 0
            vc.timeS = self.hoursS
            vc.timeE = self.hoursE
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Custom Methods
    func navigation(){
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let imgBack = UIImage(named: "back")
        
        navigationController?.navigationBar.backIndicatorImage = imgBack
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBack
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? nil)! > 1 {
            searchTbl.isHidden = true
        }else{
            searchTbl.isHidden = false
            tableViewNum = 1
            
            searchTbl.reloadData()

        }
         return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isValid = false
        placeArray.removeAll()
        searchTbl.isHidden = false
        tableViewNum = 1
//        self.searchTblHeight.constant = CGFloat( LocationData?.count ?? 0 * 65 )
        searchTbl.reloadData()

        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{

        pickupLocation.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let obj = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if (obj.count) > 0 {
            tableViewNum = 0
            //searchTbl.isHidden = false
            getLocation(obj)
            searchTblHeight.constant = CGFloat( placeArray.count * 48 )
            searchTbl.reloadData()
            
        }
        else{
            
            placeArray.removeAll()
            //searchTbl.isHidden = true
            tableViewNum = 1
            searchTblHeight.constant = CGFloat( LocationData?.count ?? 0 * 48 )
            searchTbl.reloadData()
            pickupLocation.placeholder = "Where to?" 
            
        }
        return true
    }
    
    func presentTime() -> [String]{
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: date)
        let timeCompents = time.components(separatedBy: ":")
        
        return timeCompents
    }
    //MARK:- For Getting Google Places
    func getLocation(_ name: String?) {
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
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
//            self.searchTbl.isHidden = false
            self.searchTbl.reloadData()
            //print("Place array-----\(self.placeArray)")
        }
        self.searchTbl.isHidden = false
       self.searchTbl.reloadData()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//                        self.showCurrentLocationOnMap()
//                        self.locationManager.stopUpdatingLocation()
        let currentLocation = locations[0]
        myView.updateMapCamera(location: currentLocation)
        getAddressFromCoordinates(location: currentLocation.coordinate)
    }
    
    //MARK:- For Getting User Current Location
    func showCurrentLocationOnMap(){
       
             let camera = GMSCameraPosition.camera(withLatitude: locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0, zoom: 15)
             myView.animate(to: camera)
            
            myView.isMyLocationEnabled = true
            mapLat = locationManager.location?.coordinate.latitude
            mapLong = locationManager.location?.coordinate.longitude
        
//        let marker = GMSMarker()
//        marker.icon = self.imageWithImage(image: UIImage(named: "Location-icon")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
//        marker.position = camera.target
//        marker.map = myView
        
//        marker.snippet = "Your Current location"
//        marker.map = mapView
//        myView.addSubview(mainMapView)
//        mapLat = locationManager.location?.coordinate.latitude
//        mapLong = locationManager.location?.coordinate.longitude
//        print(mapLat)
//        print(mapLong)
    }
    func imageWithImage(image: UIImage,scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    //MARK:- Getting loactions by using Marker
    func mapSetup(){
        myView.mapIdleAt = {
            (location) in
            self.getAddressFromCoordinates(location: location)
        }
    }
    func getAddressFromCoordinates(location: CLLocationCoordinate2D){
        
        
        geoCoder.reverseGeocodeCoordinate(location){
            (response,error) in
            if let address = response?.firstResult(){
            
                let addressStr = address.lines?.joined(separator: ",")
    
                self.pickupLocation.text = addressStr!
                print(addressStr!)
                print(address.locality)
                
                var place = ""
                if address.locality != nil{
                    place = address.locality ?? ""
                }else{
                    place = address.country ?? ""
                }
                
                let formattedString = NSMutableAttributedString()
                formattedString
                    .normal("Today in ")
                    .bold(place)
                    .normal(" (Regular)")
                
                
                //self.priceTitleLbl.text = "Today in " + place + " (Regular)"
                self.priceTitleLbl.attributedText = formattedString
                
                let codeObj = address.postalCode?.components(separatedBy: " ")
                self.postalCode = (codeObj?[0]) ?? "000"
                print(self.postalCode)
                self.getCityAvailabilityAPI()
                self.mapLat = address.coordinate.latitude
                self.mapLong = address.coordinate.longitude
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    //MARK: - For Getting Particular Location
    func selectedLocation()  {
        let camera = GMSCameraPosition.camera(withLatitude: mapLat!, longitude: mapLong!, zoom: 17.0)
        myView.animate(to: camera)
//        let MapView = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.myView.frame.size.width, height: self.myView.frame.size.height), camera: camera)
//        //view = MapView
//
//        myView.addSubview(MapView)
        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//       // marker.icon = #imageLiteral(resourceName: "Location-icon")
//        marker.position = CLLocationCoordinate2D(latitude: mapLat!, longitude: mapLong!)
//        marker.title = getname
//        marker.map = MapView
        
    }
    //MARK:- Checking City Availability
    func getCityAvailabilityAPI(){
        
        let params:[String:Any] = ["locationProvince": postalCode]
        WebService.shared.apiGet(url: getCityAvailabilityURL, parameters: params) { (responce, error) in
            if error == nil {
                if let dict = responce {
                    if dict["isValid"] as! Int == 0 {
                        self.showAlert("Info: ", dict["message"] as! String , "OK")
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
    //MARK:- User Home Data
    func getHomeDataAPI(){
        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        WebService.shared.apiDataPostMethod(url: getHomeDataURL, parameters: params) { (responce, error) in
            if error == nil {
                self.GetHomeDataModelData = Mapper<GetHomeDataModel>().map(JSONObject: responce)
                
                if self.GetHomeDataModelData.success == true {
                    if let home = self.GetHomeDataModelData.homeData?.locations
                    {
                        self.LocationData = home
                        haltedTrue = self.GetHomeDataModelData.homeData?.timeAvailability?.haltedTrue ?? 0
                        haltedMessage = self.GetHomeDataModelData.homeData?.timeAvailability?.haltedMessage ?? ""
                        
                        //Verified = self.GetHomeDataModelData.homeData?.userData?.isVerified ?? 0
                        firstTimeOrder = self.GetHomeDataModelData.homeData?.userData?.isFirstTimeOrder ?? 1
                        refCode = self.GetHomeDataModelData.homeData?.userData?.referralCode ?? ""
                        fullUrl = self.GetHomeDataModelData.homeData?.userData?.isFullUrl ?? 0
                        freeTrialTaken = self.GetHomeDataModelData.homeData?.userData?.isFreeTrialTaken ?? 0
                        notificationTrue = self.GetHomeDataModelData.homeData?.userData?.isNotificationTrue ?? 0
                        physicalRecieptYes = self.GetHomeDataModelData.homeData?.userData?.isPhysicalRecieptYes ?? 0
                        profileCompleted = self.GetHomeDataModelData.homeData?.userData?.isProfilecompleted ?? 0
                        noOfVehicle =  self.GetHomeDataModelData.homeData?.userData?.vehicleCount ?? "1 - 10"
                        defaultValues.set(self.GetHomeDataModelData.homeData?.userData?.isMembershipTaken, forKey: "MembershipTaken")
                        defaultValues.set(self.GetHomeDataModelData.homeData?.userData?.accountType, forKey: "AccountType")
                        defaultValues.set(self.GetHomeDataModelData.homeData?.userData?.name, forKey: "UserName")
 
                        defaultValues.set(self.GetHomeDataModelData.homeData?.userData?.email, forKey: "UserEmail")
                        defaultValues.set(self.GetHomeDataModelData.homeData?.userData?.avatar, forKey: "avatar")
                        defaultValues.set(self.GetHomeDataModelData.homeData?.userData?.phoneNumber, forKey: "Phone")
                        defaultValues.set(self.GetHomeDataModelData.homeData?.userData?.isVerified, forKey: "IsVerified")
                        defaultValues.synchronize()
                        if let userLoc = self.GetHomeDataModelData.homeData?.locations, userLoc.count != 0 {
                            defaultValues.set(self.GetHomeDataModelData.homeData?.locations[0].userAddress ?? "" , forKey: "address")
                            defaultValues.synchronize()
                        }
                        
                        
                        let etime = self.GetHomeDataModelData.homeData?.timeAvailability?.endTime ?? "00:00"
                        endTime = etime
//                        let components = etime.components(separatedBy: ":").map {(x) -> Int in return Int(String(x))!}
//                        endTime = components[0]
                    
                        let stime = self.GetHomeDataModelData.homeData?.timeAvailability?.startTime ?? "00:00"
                        startTime = stime
//                        let component = stime.components(separatedBy: ":") .map { (x) -> Int in return Int(String(x))! }
//                        startTime = component[0]
                        
                        let finalTime = self.hours24(dateAsString: etime)
                        if finalTime >= "11:55 PM" && finalTime < "11:59 PM"{
                            self.hoursS = self.hours24(dateAsString: stime)
                            self.hoursE = "Midnight"
                            self.timingLbl.text = self.hours24(dateAsString: stime) + " - " +
                            "Midnight"
                        }else{
                            self.hoursS = self.hours24(dateAsString: stime)
                            self.hoursE = self.hours24(dateAsString: etime)
                            self.timingLbl.text = self.hours24(dateAsString: stime) + " - " + self.hours24(dateAsString: etime)
                        }
                        
                        
                        self.searchTblHeight.constant = CGFloat( home.count * 65 )
                        self.tableViewNum = 1
                        self.searchTbl.reloadData()
                        
                    }
                    if let fuelDetails = self.GetHomeDataModelData.homeData?.fuelData {
                        self.fuelData = fuelDetails
                    }
                    if let account = self.GetHomeDataModelData.homeData?.userData?.accountType , account == 0{
                        onDemandPrice = Double(self.GetHomeDataModelData.homeData?.onDemandPersonal ?? 0)
    
                        let localPrice = self.fuelData?.filter{ ($0.accounttype == 0 && $0.fuelType ==  3)}
                        self.localPriceLbl.text = self.currencyFormat("\(localPrice?[0].fuelCost ?? 0)") + "/L"
                        self.localPriceTitleLbl.text = localPrice?[0].fuelName
                        
                        let fuelSrvPrice = self.fuelData?.filter{ ($0.accounttype == 0 && $0.fuelType == 0)}
                        self.fuelSrvPriceLbl.text = self.currencyFormat("\(fuelSrvPrice?[0].fuelCost ?? 0)") + "/L"
            
                    }else{
                        onDemandPrice = Double(self.GetHomeDataModelData.homeData?.onDemandBuissness ?? 0)
                        let localPrice = self.fuelData?.filter{ ($0.accounttype == 1 && $0.fuelType == 3)}
                        self.localPriceLbl.text = self.currencyFormat(String(describing: localPrice?[0].fuelCost ?? 0)) + "/L"
                        self.localPriceTitleLbl.text = localPrice?[0].fuelName
                        
                        let fuelSrvPrice = self.fuelData?.filter{ ($0.accounttype == 1 && $0.fuelType == 0)}
                        self.fuelSrvPriceLbl.text = self.currencyFormat("\(fuelSrvPrice?[0].fuelCost ?? 0)") + "/L"
                    }
                    
                }else {
                    
                Helper.Alertmessage(title: "Info:", message: self.GetHomeDataModelData.message ?? "", vc: self)
                    
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    func hours24 (dateAsString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: dateAsString)
        
        dateFormatter.dateFormat = "h:mm a"
        let date12 = dateFormatter.string(from: date!)
        return date12
    }
    
}
//MARK:- Table view
extension HomeVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewNum == 0{
            return placeArray.count
        }else{
            
            return LocationData?.count ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTbl.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! placeCell
        
        if tableViewNum == 0 {
            let str = placeArray[indexPath.row]["address"] as! String
            let firstWord = str.components(separatedBy: ",")[0]
            cell.subAddressLbl.text = firstWord
            
            cell.addressLbl.text = placeArray[indexPath.row]["address"] as? String
            
        } else {
            if let data = LocationData, data.count > indexPath.row{
                cell.subAddressLbl.text = data[indexPath.row].addressTitle
                cell.addressLbl.text = data[indexPath.row].userAddress
            }
        }
        cell.btn.addTarget(self, action: #selector(btnPrsd(_:)), for: .touchUpInside)
        cell.btn.tag = indexPath.row
        return cell
        
    }
    @objc func btnPrsd(_ sender: Any?) {
        self.mapSetup()
        
        searchTbl.isHidden = true
        
        pickupLocation.resignFirstResponder()
        let btn = sender as! UIButton
        if tableViewNum == 0 {
            placeID = (placeArray[btn.tag ])["placeID"] as! String
            let placesClient = GMSPlacesClient()
            placesClient.lookUpPlaceID(placeID, callback: { place, error in
                if error != nil {
                    print("Place Details error \(error?.localizedDescription ?? "")")
                    return
                }
                
                self.pickupLocation.text = place?.name
                self.mapLat = place?.coordinate.latitude
                self.mapLong = place?.coordinate.longitude
                self.getname = (place?.name)!
//               print(place?.addressComponents)
//                print(place)
                self.locationMarker.isHidden = false
                
                self.selectedLocation()
            })
        }else{
            
            
            locationMarker.isHidden = false
            isValid = true
            
            pickupLocation.text = LocationData?[btn.tag].userAddress ?? ""
            
            let camera = GMSCameraPosition.camera(withLatitude:Double(truncating: numberFormat(LocationData?[btn.tag].userLat)), longitude: Double(truncating: numberFormat(LocationData?[btn.tag].userLong)), zoom: 17.0)
            myView.animate(to: camera)

        }
    }
}
enum LocationEnum:String {
    case isUrgent
    case Maplat
    case MapLong
    case SelectedAddress
    case AddressTitle
    case AddressId
}
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "SegoeUI-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
