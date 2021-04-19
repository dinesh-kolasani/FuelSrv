//
//  ConvenientServicesVc.swift
//  FuelSrv
//
//  Created by PBS9 on 10/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps
import GooglePlaces

class ConvenientServicesVC: UIViewController,CLLocationManagerDelegate {
    
    var AllServicesModelDaata: AllServicesModel!
    var ServiceData: [Service]?
    
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var fuelMyVehicleBtn: UIButton!
    @IBOutlet weak var fillMyTiresBtn: UIButton!
    @IBOutlet weak var topUpMyOilBtn: UIButton!
    @IBOutlet weak var plowMyDrivewayBtn: UIButton!
    @IBOutlet weak var windShieldWasherFluid: UIButton!
    
    @IBOutlet weak var nextBtn: RoundButton!
    var userLocation = appDelegate.orderDataDict["UserLocation"] as? [String : String] ?? [:]
   
    var tappedButtons = [String]()
    
    var value: Bool!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentStatus = 0
        appDelegate.orderDataDict[OrderDataEnum.Payment.rawValue] = [:]
        
        //servicestype()
        print(userLocation)
        selectedLocation()
       navigation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        appDelegate.orderDataDict[OrderDataEnum.Payment.rawValue] = [:]
        appDelegate.orderDataDict[OrderDataEnum.Promocode.rawValue] = [:]
    }
    //MARK:- Button Actions
    
    @IBAction func buttonActions(_ sender: UIButton) {
        if sender.tag == 1 {
            if sender.isSelected{
                fuelMyVehicleBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                let objectToRemove = sender.currentTitle ?? ""
                tappedButtons.remove(object: objectToRemove)
                //tappedButtons.removeLast()
                appDelegate.orderDataDict[OrderDataEnum.FuelType.rawValue] = [:]
            }else {
                fuelMyVehicleBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
                tappedButtons.append(sender.titleLabel?.text ?? "")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FuelTypeVC") as! FuelTypeVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            print(tappedButtons)
            fuelMyVehicleBtn.isSelected = !fuelMyVehicleBtn.isSelected
        }
        else if sender.tag == 2 {
            
            if sender.isSelected{
                fillMyTiresBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                let objectToRemove = sender.currentTitle ?? ""
                tappedButtons.remove(object: objectToRemove)
                //tappedButtons.removeLast()
                appDelegate.orderDataDict[OrderDataEnum.FillMyTires.rawValue] = [:]
            }else {
                fillMyTiresBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
                tappedButtons.append(sender.titleLabel?.text ?? "")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TirePressureVC") as! TirePressureVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            print(tappedButtons)
            fillMyTiresBtn.isSelected = !fillMyTiresBtn.isSelected
        }
        else if sender.tag == 3 {
            
            if sender.isSelected{
                //tappedButtons.remove(at: sender.tag)
                let objectToRemove = sender.currentTitle ?? ""
                tappedButtons.remove(object: objectToRemove)
                //tappedButtons.removeLast()
                appDelegate.orderDataDict[OrderDataEnum.Oil.rawValue] = [:]
                topUpMyOilBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                
            }else {
                
                topUpMyOilBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
                tappedButtons.append(sender.titleLabel?.text ?? "")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OilTypeVC") as! OilTypeVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            print(tappedButtons)
            topUpMyOilBtn.isSelected = !topUpMyOilBtn.isSelected
            
        }else if sender.tag == 4{
            if sender.isSelected{
                //tappedButtons.removeLast()
                let objectToRemove = sender.currentTitle ?? ""
                tappedButtons.remove(object: objectToRemove)
                appDelegate.orderDataDict[OrderDataEnum.PlowMyDriveway.rawValue] = [:]
                plowMyDrivewayBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                
            }else {
            plowMyDrivewayBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
                tappedButtons.append(sender.currentTitle ?? "")
                //tappedButtons.append(sender.titleLabel?.text ?? "")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlowMyDrivewayVC") as! PlowMyDrivewayVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            print(tappedButtons)
            plowMyDrivewayBtn.isSelected = !plowMyDrivewayBtn.isSelected
            
        }else if sender.tag == 5{
            if sender.isSelected{
                //tappedButtons.removeLast()
                let objectToRemove = sender.currentTitle ?? ""
                tappedButtons.remove(object: objectToRemove)
                appDelegate.orderDataDict[OrderDataEnum.WindShieldWasherFluid.rawValue] = [:]
                windShieldWasherFluid.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                
            }else {
                windShieldWasherFluid.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
                tappedButtons.append(sender.titleLabel?.text ?? "")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WindShieldWasherFluidVC") as! WindShieldWasherFluidVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            print(tappedButtons)
            windShieldWasherFluid.isSelected = !windShieldWasherFluid.isSelected
        }
    }

    
    @IBAction func nextBtn(_ sender: Any) {
        if (tappedButtons.isEmpty == true || fuelMyVehicleBtn.isSelected == false){
            if tappedButtons.isEmpty == false{
                self.showAlert("Info:", "Please select fuel type.", "OK")
                return
                
            }
            self.showAlert("Info:", "Please select a service option.", "OK")
            
        }else{
            appDelegate.orderDataDict[OrderDataEnum.ServicesType.rawValue] = tappedButtons
            if value == true {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderReviewVC") as! OrderReviewVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyVehicleVC") as! MyVehicleVC
                self.navigationController?.pushViewController(vc, animated: true)
                //self.navigationController?.popViewController(animated: true)
                
            }
        }
        
////        if fuelMyVehicleBtn.isSelected == true{
////
////            appDelegate.orderDataDict[OrderDataEnum.ServicesType.rawValue] = tappedButtons
////
////            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyVehicleVC") as! MyVehicleVC
////            self.navigationController?.pushViewController(vc, animated: true)
////        }else{
////            self.showAlert("Info:", "Please select a service option.", "OK")
////        }
//        if (tappedButtons.isEmpty == true || fuelMyVehicleBtn.isSelected == false){
//            if tappedButtons.isEmpty == false{
//                self.showAlert("Info:", "Please select fuel type.", "OK")
//                return
//            }
//            self.showAlert("Info:", "Please select a service option.", "OK")
//        }else{
////            if popTwoBack == false {
////
////                if urgentOrder == 1{
////                    tappedButtons.append("On-demand service fee")
////                }
////            }
//
//            appDelegate.orderDataDict[OrderDataEnum.ServicesType.rawValue] = tappedButtons
//
////            if value == true {
////                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderReviewVC") as! OrderReviewVC
////                self.navigationController?.pushViewController(vc, animated: true)
////            }else{
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyVehicleVC") as! MyVehicleVC
//                self.navigationController?.pushViewController(vc, animated: true)
//                //self.navigationController?.popViewController(animated: true)
////            }
//
//        }
    }
    
    func navigation(){
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "CONVENIENT SERVICES"
//        if value == true{
//
//            let imgBack = UIImage(named: "back")
//            navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(Action))
//        }
        
    }
//    @objc func Action(){
//        self.dismiss(animated: true, completion: nil)
//        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")as! HomeVC
//        //        self.navigationController?.pushViewController(vc, animated: true)
//    }
    //MARK:- Map setup for perticular location

    func selectedLocation()  {
        
        let mapLat = Double(userLocation["Maplat"] ?? "")
        let mapLong = Double(userLocation["MapLong"] ?? "")
        //let getname = userLocation["SelectedAddress"]
        
        let camera = GMSCameraPosition.camera(withLatitude: mapLat ?? 0, longitude: mapLong ?? 0, zoom: 17.0)
        mapView.animate(to: camera)
        
//        let marker = GMSMarker()
//        marker.icon = self.imageWithImage(image: UIImage(named: "Location-icon")!, scaledToSize: CGSize(width: 35.0, height: 35.0))
//        marker.position = CLLocationCoordinate2D(latitude: mapLat ?? 0.0, longitude: mapLong ?? 0.0)
//        marker.title = getname
//    marker.infoWindowAnchor = CGPoint(x: 10, y: 10)
//        
//        marker.map = mapView
       
        
    }
    func imageWithImage(image: UIImage,scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //MARK:- Services API
    func servicestypeAPI(){
        let params:[String:Any] = ["accounttype": defaultValues.integer(forKey: "AccountType")]
        WebService.shared.apiGet(url: allServicesURL, parameters: params) { (responce, error) in
            if error == nil {
                self.AllServicesModelDaata = Mapper<AllServicesModel>().map(JSONObject: responce)
                
                if self.AllServicesModelDaata.success == true {
                    if let home = self.AllServicesModelDaata?.services
                    {
                        self.ServiceData = home
                        
                        
                    }else{
                        Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                    }
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }
        }
        
    }
}
extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = index(of: object) else {return}
        remove(at: index)
    }
    
}
//enum ServicesType:String {
//   
//    case FuelMyVehicle
//    case FillMyTires
//    case TopUpMyOil
//    case PlowMyDriveWay
//    case WindShieldWasherFluid
//}
