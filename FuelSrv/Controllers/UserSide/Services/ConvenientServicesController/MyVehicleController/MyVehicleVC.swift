//
//  MyVehicleVC.swift
//  FuelSrv
//
//  Created by PBS9 on 22/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps
import GooglePlaces

class MyVehicleVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vehiclesLbl: UILabel!
    @IBOutlet weak var addVehiclesBtn: UIButton!
    @IBOutlet weak var nextBtn: RoundButton!
    
    var picker  = UIPickerView()
    var toolBar = UIToolbar()
    
    var userLocation = appDelegate.orderDataDict["UserLocation"] as? [String : String] ?? [:]
    var locationManger = CLLocationManager()
    var geoCoder = GMSGeocoder()
    var vehicleDetails: [String:Any] = [:]
    var GetAllVehiclesModelData: GetAllVehiclesModel!
    var GetAllVehicleData: [GetAllVehicle]!
    var tappedButtonsTag: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLocation()
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        navigation()
        getAllvehiclesAPI()
        //self.tableViewHeight.constant = CGFloat( 1 * 48 )
        let nibSec = UINib.init(nibName: "OrderReviewSecCell", bundle: nil)
        tableView.register(nibSec, forCellReuseIdentifier: "OrderReviewSecCell")
        
        let nib = UINib.init(nibName: "ServicesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ServicesCell")
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVc), name:.reloadVc, object: nil)
        

    }
    
    @objc func reloadVc()
    {
      getAllvehiclesAPI()
    }
    //MARK:- Button Action
    @IBAction func nextBtn(_ sender: Any) {
        if defaultValues.integer(forKey: "AccountType") == 0{
            if tappedButtonsTag == nil {
                self.showAlert("Info:", "Please select vehicle", "OK")
                
            }else {
                
                let vehicleModel = GetAllVehicleData[tappedButtonsTag]
                
                vehicleDetails[MyVehicleEnum.vehicleID.rawValue] = vehicleModel.id
                vehicleDetails[MyVehicleEnum.Year.rawValue] = vehicleModel.year
                vehicleDetails[MyVehicleEnum.Make.rawValue] = vehicleModel.make
                vehicleDetails[MyVehicleEnum.Model.rawValue] = vehicleModel.model
                vehicleDetails[MyVehicleEnum.Color.rawValue] = vehicleModel.color
                vehicleDetails[MyVehicleEnum.LicensePlate.rawValue] = vehicleModel.licencePlate
                appDelegate.orderDataDict[OrderDataEnum.Vehicle.rawValue] = vehicleDetails
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FuelAmountVC") as! FuelAmountVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }else{
            vehicleDetails[MyVehicleEnum.vehiclesCount.rawValue] = noOfVehicle
            appDelegate.orderDataDict[OrderDataEnum.Vehicle.rawValue] = vehicleDetails
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FuelAmountVC") as! FuelAmountVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addVehiclesBtnAction(_ sender: Any) {
        //if defaultValues.integer(forKey: "AccountType") == 0 {
            
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
            vc.value = 2
            let nav  = UINavigationController.init(rootViewController: vc)
            self.navigationController?.present(nav, animated: true, completion: nil)
//        }else{
//
//             addVehiclesBtn.addTarget(self, action: #selector(Vehicles), for: .touchUpInside)
//        }
    }
    
    
/*    func mapSetup(){
        mapView.mapIdleAt = {
            (location) in
            self.getAddressFromCoordinates(location: location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0]
        mapView.updateMapCamera(location: currentLocation)
        getAddressFromCoordinates(location: currentLocation.coordinate)
    }
    func getAddressFromCoordinates(location: CLLocationCoordinate2D){
        
        geoCoder.reverseGeocodeCoordinate(location){
            (response,error) in
            
            if let address = response?.firstResult(){
                //self.pickUpLocation.text = address.lines?.joined(separator: " ")
                print(String(describing: address.lines?.joined(separator: " ")))
            }
        }
    }
 
 */
    //MARK:- Navigation bar
    func navigation(){
        nextBtn.dropShadow(view: nextBtn, opacity: 0.4)
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        if defaultValues.integer(forKey: "AccountType") == 0 {
            navigationItem.title = "MY VEHICLE"
            //getAllvehiclesAPI()
            
        }else{
            picker.dropShadow(view: picker, opacity: 0.5)
            picker.layer.cornerRadius = 5
            picker.clipsToBounds = true
            navigationItem.title = "VEHICLES"
            vehiclesLbl.text = "No. of vehicles:"
            addVehiclesBtn.isHidden = true
        }
        
    }
    
    //MARK:- Map setup for perticular location
    func selectedLocation()  {
        
        let mapLat = Double(userLocation["Maplat"] ?? "")
        let mapLong = Double(userLocation["MapLong"] ?? "")
        let getname = userLocation["SelectedAddress"]
        
        let camera = GMSCameraPosition.camera(withLatitude: mapLat ?? 0, longitude: mapLong ?? 0, zoom: 17.0)
        mapView.animate(to: camera)
        
//        let marker = GMSMarker()
//        marker.icon = self.imageWithImage(image: UIImage(named: "Location-icon")!, scaledToSize: CGSize(width: 35.0, height: 35.0))
//        marker.position = CLLocationCoordinate2D(latitude: mapLat ?? 0.0, longitude: mapLong ?? 0.0)
//        marker.title = getname
//        marker.map = mapView
        
    }
    func imageWithImage(image: UIImage,scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    //MARK:- Get All Vehicles API
    func getAllvehiclesAPI(){
        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        WebService.shared.apiDataPostMethod(url: getAllvehiclesURL, parameters: params) { (responce, error) in
        
            if error == nil {
                self.GetAllVehiclesModelData = Mapper<GetAllVehiclesModel>().map(JSONObject: responce)
                
        if self.GetAllVehiclesModelData.success == true {
            if let home = self.GetAllVehiclesModelData?.vehicles
                    {
                        self.GetAllVehicleData = home
                        print(home)
                        if home.count == 1{
                            self.tappedButtonsTag = 0
                        }
                        if home.count == 0 {
                            self.tableViewHeight.constant = CGFloat( 1 * 60 )
                        }else{
                            self.tableViewHeight.constant = CGFloat( home.count * 60 )
                        }
                        
                        self.tableView.reloadData()
                        
                    }
                    
                }else {
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
        
    }
}
//MARK:- Creating A Tableview
extension MyVehicleVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51.5//48.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if defaultValues.integer(forKey: "AccountType") == 0 {
            
            if let data = GetAllVehicleData, data.count > 0{
                errorLbl.isHidden = true
                return GetAllVehicleData?.count ?? 0
            }else{
                errorLbl.isHidden = false
                errorLbl.text = "No vehicles found"
                return 0
            }
        }else{
            return 1
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
        
        if let data = GetAllVehicleData, data.count > indexPath.row{
            cell.vehiclesCountView.isHidden = true
            cell.cellLabel.text = "\(String(describing: data[indexPath.row].year!))" + " \(String(describing: data[indexPath.row].model!))" + ","
            cell.cellPriceLabel.text = " \(String(describing: data[indexPath.row].color!))" + " \(String(describing: data[indexPath.row].licencePlate!))" //+ " \(String(describing: data[indexPath.row].make!))" 
            cell.cellBtn.tag = indexPath.row
            
            
            // here is the check:
            if let row =  tappedButtonsTag, row == indexPath.row {
                cell.cellBtn.isSelected = true
            } else {
                
                cell.cellBtn.addTarget(self, action: #selector(addSomething(button:)), for: .touchUpInside)
                cell.cellBtn.isSelected = false
            }
            
        }
        else if defaultValues.integer(forKey: "AccountType") == 1{
            cell.vehiclesCountView.isHidden = false
            cell.vechicleCountLbl.text = noOfVehicle
            cell.vehicleCountBtn.addTarget(self, action: #selector(Vehicles), for: .touchUpInside)
        }

        return cell
    }
    @objc func addSomething(button: UIButton) {
        tappedButtonsTag = button.tag
//        if let data = GetAllVehicleData, data.count > button.tag
//        {
//
//        }
        tableView.reloadData()
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableCell(withIdentifier: "OrderReviewSecCell") as! OrderReviewSecCell
//        if defaultValues.integer(forKey: "AccountType") == 0 {
//        headerView.btn.setTitle("+ Add Vehicle", for: .normal)
//        headerView.btn.addTarget(self, action: #selector(addVehicle), for: .touchUpInside)
//        headerView.ORTitleLabel.text = ""
//
//        }else{
//            headerView.ORTitleLabel.text = "No. of vehicles: "
//            headerView.ORTitleLabel.textColor = #colorLiteral(red: 0.1960784314, green: 0.2235294118, blue: 0.2509803922, alpha: 1)
//            headerView.btn.setTitle("Change here", for: .normal)
//            headerView.btn.addTarget(self, action: #selector(Vehicles), for: .touchUpInside)
//        }
//        return headerView
//    }
    @objc func addVehicle(){
        
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
        vc.value = 2
        let nav  = UINavigationController.init(rootViewController: vc)
        self.navigationController?.present(nav, animated: true, completion: nil)
       
        }

    @objc func Vehicles(){
        picker = UIPickerView.init()
        self.picker.delegate = self
        self.picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(#colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1), forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 20, y: UIScreen.main.bounds.size.height - 380, width: UIScreen.main.bounds.size.width - 40, height: 170)
        Helper.viewCornerRadius(viewoutlet: picker)
        self.view.addSubview(picker)
        
        
//        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
//        toolBar.barStyle = .blackTranslucent
//        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
//        self.view.addSubview(toolBar)
       
        //picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        //self.picker.reloadAllComponents()
    }
    @objc func onDoneButtonTapped() {
        //toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
}

extension  Notification.Name
{
    static let reloadVc = Notification.Name("reload")
}
//MARK:- Picker view
extension MyVehicleVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return approxNoOfVehicles.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return approxNoOfVehicles[row]
       
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
            noOfVehicle = approxNoOfVehicles[row]
        self.tableView.reloadData()
        picker.removeFromSuperview()
    }
}

enum MyVehicleEnum:String {
    case vehiclesCount
    case vehicleID
    case Make
    case Model
    case Year
    case Color
    case Fuel
    case LicensePlate
}
