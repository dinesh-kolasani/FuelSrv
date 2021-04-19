//
//  FontSizes.swift
//  FuelSrv
//
//  Created by PBS9 on 18/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import UIKit
/*

class ViewController: UIViewController {
    var tappedButtonsTags = [Int]()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ExploreCell
        
        // Configure the cell...
        myCell.configureCell(teams[indexPath.row])
        
        myCell.addSomethingButton.tag = indexPath.row
        
        // here is the check:
        if tappedButtonsTags.contains(indexPath.row) {
            myCell.addSomethingButton.enabled = false
        } else {
            myCell.addSomethingButton.addTarget(self, action: #selector(self.addSomething), forControlEvents: .TouchUpInside)
            myCell.addSomethingButton.enabled = true
        }
        
        //disable cell clicking
        myCell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return myCell
    }
    
    // I just Implemented this for demonstration purposes, you can merge this one with yours :)
    func addSomething(button: UIButton) {
        tappedButtonsTags.append(button.tag)
        tableView.reloadData()
        // ...
    }
}  */

extension UIDevice {
    
    
    enum DeviceType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown = "iPadOrUnknown"
    }
    
    var deviceType: DeviceType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}
/*

// Get device type (with help of above extension) and assign font size accordingly.
let label = UILabel()

let deviceType = UIDevice.current.deviceType

switch deviceType {
    
case .iPhone4_4S:
    label.font = UIFont.systemFont(ofSize: 10)
    
case .iPhones_5_5s_5c_SE:
    label.font = UIFont.systemFont(ofSize: 12)
    
case .iPhones_6_6s_7_8:
    label.font = UIFont.systemFont(ofSize: 14)
    
case .iPhones_6Plus_6sPlus_7Plus_8Plus:
    label.font = UIFont.systemFont(ofSize: 16)
    
case .iPhoneX:
    label.font = UIFont.systemFont(ofSize: 18)
    
default:
    print("iPad or Unkown device")
    label.font = UIFont.systemFont(ofSize: 20)
    
} */
/*

func setCardView(view : UIView){
    
    view.layer.cornerRadius = 5.0
    view.layer.borderColor  =  UIColor.clear.cgColor
    view.layer.borderWidth = 5.0
    view.layer.shadowOpacity = 0.5
    view.layer.shadowColor =  UIColor.lightGray.cgColor
    view.layer.shadowRadius = 5.0
    view.layer.shadowOffset = CGSize(width:5, height: 5)
    view.layer.masksToBounds = true
    
}
 */
/*
 
 //
 //  FuelAmountVC.swift
 //  FuelSrv
 //
 //  Created by PBS9 on 29/04/19.
 //  Copyright © 2019 Dinesh. All rights reserved.
 //
 
 import UIKit
 
 class FuelAmountVC: UIViewController {
 
 @IBOutlet weak var fillItBtn: UIButton!
 @IBOutlet weak var amountBtn: UIButton!
 @IBOutlet weak var littersBtn: UIButton!
 
 @IBOutlet weak var amountTxt: UITextField!
 @IBOutlet weak var quantityTxt: UITextField!
 
 @IBOutlet weak var littersView: UIView!
 @IBOutlet weak var amountView: UIView!
 
 @IBOutlet weak var nextBtn: RoundButton!
 var FuelAmountDetails: [String:Any] = [:]
 var tappedFilIt: Int!
 var amountButton: Int!
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 navigationSetUp()
 
 }
 
 @IBAction func fillItBtn(_ sender: Any) {
 if fillItBtn.isSelected{
 fillItBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
 amountBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
 amountTxt.isEnabled = true
 amountButton = 0
 
 }else {
 fillItBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
 amountTxt.isEnabled = false
 amountTxt.text = nil
 quantityTxt.text = nil
 amountBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
 littersBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
 tappedFilIt = 1
 amountButton = nil
 
 
 }
 fillItBtn.isSelected = !fillItBtn.isSelected
 }
 
 @IBAction func nextBtn(_ sender: Any) {
 
 if (amountButton == nil && tappedFilIt == nil){
 
 self.showAlert("Info:", "Please select Fuel amount type", "OK")
 }else{
 
 if (tappedFilIt == nil) || (amountTxt.text?.count == 0 && quantityTxt.text?.count == 0){
 self.showAlert("Info:", "Please enter Fuel amount or quantity", "OK")
 
 }else{
 
 FuelAmountDetails[FuelAmountEnum.FillIt.rawValue] = String(describing: (tappedFilIt) ?? 0)
 FuelAmountDetails[FuelAmountEnum.AmountButton.rawValue] = String(describing: (amountButton) ?? 0)
 FuelAmountDetails[FuelAmountEnum.Amount.rawValue] = amountTxt.text ?? "0"
 FuelAmountDetails[FuelAmountEnum.Quantity.rawValue] = quantityTxt.text ?? "0"
 appDelegate.orderDataDict[OrderDataEnum.FuelAmount.rawValue] = FuelAmountDetails
 
 print(appDelegate.orderDataDict)
 let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderReviewVC") as! OrderReviewVC
 self.navigationController?.pushViewController(vc, animated: true)
 
 }
 }
 
 }
 @IBAction func fuelAmountBtns(_ sender: UIButton) {
 if sender.tag == 1 {
 if sender.isSelected == true{
 amountBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
 }else {
 tappedFilIt = 0
 amountButton = 0
 amountTxt.isEnabled = true
 fillItBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
 amountBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
 littersView.isHidden = true
 quantityTxt.text = nil
 amountTxt.placeholder = "Amount"
 amountBtn.isHidden = false
 littersBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
 amountView.isHidden = false
 }
 }
 if sender.tag == 2 {
 if sender.isSelected == true{
 littersBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
 }else{
 tappedFilIt = 0
 amountButton = 1
 amountTxt.isEnabled = true
 fillItBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
 littersBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
 amountView.isHidden = true
 amountTxt.text = nil
 littersBtn.isHidden = false
 amountBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
 littersView.isHidden = false
 }
 
 }
 }
 func navigationSetUp(){
 nextBtn.dropShadow(view: nextBtn, opacity: 0.5)
 
 navigationItem.leftItemsSupplementBackButton = true
 navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
 
 self.navigationItem.title = "FUEL AMOUNT"
 }
 }
 enum FuelAmountEnum:String {
 case FillIt
 case AmountButton
 case Amount
 case Quantity
 
 }

 
 */

//select Location
/*   func selectedLocation()  {
 let  mapLat = OrderData![0].userLat
 let  mapLong = OrderData![0].userLong
 print(mapLat)
 print(mapLong)
 //        let mapLat = Double(userLocation["Maplat"] ?? "")
 //        let mapLong = Double(userLocation["MapLong"] ?? "")
 //  let getname = userLocation["SelectedAddress"]
 let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(mapLat!), longitude: CLLocationDegrees(mapLong!), zoom: 5.0)
 //        let MapView = GMSMapView.map(withFrame: .init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.mapView.bounds.size.height + 104), camera: camera)
 self.mapView = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), camera: camera)
 mapView.camera =  multiplecamera
 
 mapView.addSubview(mapView)
 // Creates a marker in the center of the map.
 let marker = GMSMarker()
 marker.icon = #imageLiteral(resourceName: "location pin")
 //    marker.icon = self.imageWithImage(image: UIImage(named: "Location-icon")!, scaledToSize: CGSize(width: 30.0, height: 30.0))
 marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(mapLat ?? 0.0), longitude: CLLocationDegrees(mapLong ?? 0.0))
 //   marker.title = getname
 marker.map = mapView
 }*/

// Show Current Location
//latitude: 30.7145, longitude: 76.7149), endLocation:  CLLocation(latitude: 28.643091, longitude: 77.218280))

//    let destination : CLLocationCoordinate2D  =  CLLocationCoordinate2DMake(Double(30.7145)), Double;(76.7149)

/*  func Drawpath(startLocation: CLLocation,endLocation:CLLocation){
 
 let camera = GMSCameraPosition.camera(withLatitude: startLocation.coordinate.latitude ?? 0, longitude: endLocation.coordinate.longitude ?? 0, zoom: 10)
 gmsMap = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), camera: camera)
 self.gmsMap!.camera = camera
 self.gmsMap?.animate(to: camera)
 
 var drop_markeImage = #imageLiteral(resourceName: "Location-icon@")
 let drop_marker = GMSMarker()
 drop_marker.position = CLLocationCoordinate2DMake((CLLocationDegrees(endLocation.coordinate.latitude)), (CLLocationDegrees(endLocation.coordinate.longitude)))
 drop_marker.title = "drop"
 
 drop_marker.map = mapView
 
 var drop_markeImage2 = #imageLiteral(resourceName: "fuel-type")
 let drop_marker2 = GMSMarker()
 drop_marker2.position = CLLocationCoordinate2DMake((CLLocationDegrees(endLocation.coordinate.latitude)), (CLLocationDegrees(endLocation.coordinate.longitude)))
 drop_marker2.title = "drop"
 
 drop_marker2.map = mapView
 
 let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
 let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
 
 
 let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyA0pibFZlrdFeEcR7oz7jekFKMbjgJFWzU"
 
 Alamofire.request(url).responseJSON { response in
 // original URL request
 print(response.response!) // HTTP URL response
 // result of response serialization
 do{
 
 let json = try JSON(data: response.data!)
 let routes = json["routes"].arrayValue
 print(routes)
 DispatchQueue.main.async {
 
 for route in routes
 {
 let routeOverviewPolyline = route["overview_polyline"].dictionary
 let points = routeOverviewPolyline?["points"]?.stringValue
 var path = GMSPath()
 var polyline = GMSPolyline()
 
 path = GMSPath.init(fromEncodedPath: points!)!
 polyline = GMSPolyline.init(path: path)
 polyline.strokeWidth = 2.5
 polyline.strokeColor = UIColor.orange
 polyline.map = self.gmsMap
 
 }
 }
 }
 catch{
 
 print(error)
 
 }
 
 }
 
 }*/
