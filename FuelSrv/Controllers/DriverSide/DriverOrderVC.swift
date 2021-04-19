//
//  DriverOrderVC.swift
//  FuelSrv
//
//  Created by PBS9 on 07/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage
import GoogleMaps
import GooglePlaces
import SVProgressHUD

class DriverOrderVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dragButtonView: UIView!
    @IBOutlet weak var dragBtn: UIButton!
    
    @IBOutlet weak var currentLocationBtn: UIButton!
    
    var OrderDetailsModelData: OrderDetailsModel!
    var OrderDetailsData: OrderDetails!
    
    var orderDetailsModelData: OrderDetailsModel!
    var OrderData: OrderId!
    
    var orderData: DriverOrder?
    
    var acceptOrderData : DriverAllOrders!
    
    var orderNum: String?
    var cellCountNo = Int() //1
    var orderUserId = ""
    
    var demoPolyline = GMSPolyline()
    var demoPolylineOLD = GMSPolyline()
    var destinationLocation = CLLocationCoordinate2D()
    
    
    var destination = CLLocationCoordinate2D()
    var source = CLLocationCoordinate2D()
    
    var locationManager = CLLocationManager()
    var imgPP = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(orderData)
        showCurrentLocationOnMap()
        print(acceptOrderData)
        //acceptOrdersApi()
       
        
        Helper.TopedgeviewCorner(viewoutlet: tableView, radius: 25)
        
        let nib = UINib.init(nibName: "HomeOrdersCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeOrdersCell")
        
        let nib1 = UINib.init(nibName: "SendPromptGoCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "SendPromptGoCell")
        
        let nib2 = UINib.init(nibName: "SendPromptCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "SendPromptCell")
        
        let nib3 = UINib.init(nibName: "ReportCompleteCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "ReportCompleteCell")
        
        self.tableView.estimatedRowHeight = 293.5
        self.tableView.rowHeight = UITableViewAutomaticDimension
       
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    @IBAction func backBtnAction(_ sender: Any) {
        
        setRoot()
    }
    
    @IBAction func currentLocationBtnAction(_ sender: Any) {
    }
    
    @IBAction func dragBtnAction(_ sender: UIButton) {
        //viewBottom.constant = 0
        if sender.isSelected{
            
            dragBtn.setImage(#imageLiteral(resourceName: "driverDoubleUp"), for: .normal)
            var bgPath: UIBezierPath?
            bgPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
            let bgLayer = CAShapeLayer()
            bgLayer.frame = view.bounds
            bgLayer.path = bgPath?.cgPath
            tableView.layer.mask = bgLayer
            UIView.transition(with: tableView, duration: 0.3, options: .curveEaseIn, animations: {
                self.tableViewHeight.constant = 85 //self.tableView.frame.size.height - self.view.frame.size.height + 130
                self.view.layoutIfNeeded()
            }) { finished in
                self.tableView.isHidden = false
            }
            
        }else {
            //dragBtn.backgroundColor = UIColor.clear

            dragBtn.setImage(#imageLiteral(resourceName: "driverDoubleDown"), for: .normal)
        
            
            var bgPath: UIBezierPath?
            bgPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
            let bgLayer = CAShapeLayer()
            bgLayer.frame = view.bounds
            bgLayer.path = bgPath?.cgPath
            tableView.layer.mask = bgLayer
            UIView.transition(with: tableView, duration: 0.3, options: .curveEaseIn, animations: {
                self.tableViewHeight.constant = 350
                self.view.layoutIfNeeded()
            }) { finished in
                self.tableView.isHidden = false
            }
            
        }
        sender.isSelected = !sender.isSelected
    }
    
    func swipedown(_ gestureRecognizer: UISwipeGestureRecognizer?) {
        
        var bgPath: UIBezierPath?
        bgPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        let bgLayer = CAShapeLayer()
        bgLayer.frame = view.bounds
        bgLayer.path = bgPath?.cgPath
        tableView.layer.mask = bgLayer
        UIView.transition(with: tableView, duration: 0.8, options: .curveEaseIn, animations: {
            self.tableViewHeight.constant = self.tableView.frame.size.height - self.view.frame.size.height + 130
            self.view.layoutIfNeeded()
        }) { finished in
            self.tableView.isHidden = true
        }
        
    }
    func swipeup(_ gestureRecognizer: UISwipeGestureRecognizer?) {
        
        var bgPath: UIBezierPath?
        bgPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        let bgLayer = CAShapeLayer()
        bgLayer.frame = view.bounds
        bgLayer.path = bgPath?.cgPath
        tableView.layer.mask = bgLayer
        UIView.transition(with: tableView, duration: 0.8, options: .curveEaseIn, animations: {
            self.tableViewHeight.constant = 350
            self.view.layoutIfNeeded()
        }) { finished in
            self.tableView.isHidden = false
        }
        
    }
    
    
//    // MARK: - acceptOrdersApi
//    func acceptOrdersApi(){
//
//        let params = ["orderId":orderNum!,
//                      "driverId":returnValue!]
//
//        WebService.shared.apiDataPostMethod(url: acceptOredrsDriverURL, parameters: params) { (response, error) in
//            if error == nil{
//
//                self.AcceptOrderDriverModel = Mapper<AcceptOrderDriver>().map(JSONObject: response)
//
//                if self.AcceptOrderDriverModel.success == true{
//
//                    if let data = self.AcceptOrderDriverModel.acceptedOrder{
//                        self.AcceptedOrderData = data
//                        self.OrderIdData = data.orderId
//
//                        self.tableView.reloadData()
//                    }
//                    else{
//                        Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
//                    }
//                }else{
//                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
//                }
//
//            }else{
//                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
//            }
//
//        }
//    }
    
   // MARK:- Order Details Api.
    func orderDetailsAPI(){

        let params:[String:Any] = ["orderId":orderNum!]

        WebService.shared.apiDataPostMethod(url: orderDetailsURL, parameters: params) { (response, error) in
            if error == nil{
                self.OrderDetailsModelData = Mapper<OrderDetailsModel>().map(JSONObject: response)

                if self.OrderDetailsModelData.success == true{
                    if let data = self.OrderDetailsModelData.order {
                        self.OrderDetailsData = data
                        self.destination.latitude = Double(data.userLat)
                        self.destination.longitude = Double(data.userLong)
                        self.cellCountNo = 3
                        self.tableView.reloadData()
                        self.orderUserId = self.OrderDetailsModelData.order?.userId.id ?? ""
                        print("sendpromt userid\(self.orderUserId)")
                        
                        
                            let dmarker = GMSMarker()
                            let img = UIImage(named: "redMarker")
                            
                            let profileImageURL = baseImageURL + (self.OrderDetailsData.userId.avatar)!
                            if let imageURL = URL(string: profileImageURL) {
                                self.imgPP.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))
                            }
                            
                            dmarker.icon = self.imageWithImage(image: self.drawImageWithProfilePic(pp: self.imgPP.image ?? #imageLiteral(resourceName: "userwhite"), image: img!), scaledToSize: CGSize(width: 53.0, height: 70.0))
                            dmarker.position = CLLocationCoordinate2D(latitude: self.destination.latitude, longitude: self.destination.longitude)
                            dmarker.map = self.mapView
                        
                       
                    }


                }else if self.orderDetailsModelData?.success == false{

                    Helper.Alertmessage(title: "Info:", message: self.orderDetailsModelData.message ?? "", vc: self)

                } else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            } else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    //MARK:- For Getting User Current Location
    func showCurrentLocationOnMap(){
        
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0, zoom: 10)
        mapView.animate(to: camera)
        
        mapView.isMyLocationEnabled = true
        
        self.source.longitude = locationManager.location?.coordinate.longitude ?? 0
        self.source.latitude = locationManager.location?.coordinate.latitude ?? 0
        
        orderDetailsAPI()
        tableViewHeight.constant = 310
        
        
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location: CLLocation = locations.last!
//
//        let originalLoc: String = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
//        let destiantionLoc: String = "\(destinationLocation.latitude),\(destinationLocation.longitude)"
//
//        let latitudeDiff: Double = Double(location.coordinate.latitude) - Double(destinationLocation.latitude)
//        let longitudeDiff: Double = Double(location.coordinate.longitude) - Double(destinationLocation.longitude)
//
//        let waypointLatitude: Double = location.coordinate.latitude - latitudeDiff
//        let waypointLongitude: Double = location.coordinate.longitude - longitudeDiff
//
//        getDirectionsChangedPolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointLongitude)"], travelMode: nil, completionHandler: nil)
//    }
    
//    func getDirectionsChangedPolyLine(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
//    {
//
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//
//            if let originLocation = origin {
//                if let destinationLocation = destination {
//                    var directionsURLString = "https://maps.googleapis.com/maps/api/directions/json?" + "origin=" + originLocation + "&destination=" + destinationLocation
//                    if let routeWaypoints = waypoints {
//                        directionsURLString += "&waypoints=optimize:true"
//
//                        for waypoint in routeWaypoints {
//                            directionsURLString += "|" + waypoint
//                        }
//                    }
//
//                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//
//                    let directionsURL = NSURL(string: directionsURLString)
//                    DispatchQueue.main.async( execute: { () -> Void in
//                        let directionsData = NSData(contentsOf: directionsURL! as URL)
//                        do{
//                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
//
//                            let status = dictionary["status"] as! String
//                            if status == "OK" {
//
//                                let selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
//                                let overviewPolyline = selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
//
//                                let route = overviewPolyline["points"] as! String
//                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
//
//                                self.demoPolylineOLD = self.demoPolyline
//                                self.demoPolylineOLD.strokeColor = UIColor.blue
//                                self.demoPolylineOLD.strokeWidth = 3.0
//                                self.demoPolylineOLD.map = self.mapView
//                                self.demoPolyline.map = nil
//
//                                self.demoPolyline = GMSPolyline(path: path)
//                                self.demoPolyline.map = self.mapView
//                                self.demoPolyline.strokeColor = UIColor.blue
//                                self.demoPolyline.strokeWidth = 3.0
//                                self.demoPolylineOLD.map = nil
//
//
//                            } else {
//
//                                self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
//                            }
//                        } catch {
//
//                            self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
//                        }
//                    })
//                } else {
//
//                    print("Destination Location Not Found")
//                }
//            } else {
//
//                print("Origin Location Not Found")
//            }
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let mostRecentLocation: CLLocation? = locations.last
//        self.source.longitude = mostRecentLocation?.coordinate.longitude ?? 0
//        self.source.latitude = mostRecentLocation?.coordinate.latitude ?? 0
//        print(mostRecentLocation)
//        print(source)
//
//
//        let time = Timer(timeInterval: 5, repeats: true) { _ in
//            print(self.source)
//            //print(time)
//            self.draw(src: self.source, dst: self.destination)
//        }
//
//    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [Any]) {
//        let mostRecentLocation: CLLocation? = locations.last as? CLLocation
//        self.source.longitude = mostRecentLocation?.coordinate.longitude ?? 0
//        self.source.latitude = mostRecentLocation?.coordinate.latitude ?? 0
//
//        print(mostRecentLocation)
////        var now = Date()
//        _ = Timer(timeInterval: 0.5, repeats: true) { _ in
//            print(self.source)
//            self.draw(src: self.source, dst: self.destination)
//        }
////        var interval: TimeInterval = lastTimestamp ? now.timeIntervalSince(lastTimestamp) : 0
////        if !lastTimestamp || interval >= 5 * 60 {
////            lastTimestamp = now
////            print("Sending current location to web service.")
////        }
//    }
    
     //MARK:- Draw Path b/w source and destination  WORKING ONE
    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D){

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=driving&key=AIzaSyA0pibFZlrdFeEcR7oz7jekFKMbjgJFWzU")!

        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {

                        let preRoutes = json["routes"] as! NSArray
                        if preRoutes.count == 0 {
                            Helper.Alertmessage(title: "Info:", message: "Something went wrong!", vc: self)
                            return
                        }
                        let routes = preRoutes[0] as! NSDictionary
                        let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                        let polyString = routeOverviewPolyline.object(forKey: "points") as! String

                        DispatchQueue.main.async(execute: {
                            let path = GMSPath(fromEncodedPath: polyString)
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeWidth = 3.0
                            polyline.strokeColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
                            polyline.map = self.mapView

                            let bounds = GMSCoordinateBounds(path:path! )
                            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))

//                            let smarker = GMSMarker()
//                            smarker.position = CLLocationCoordinate2D(latitude: self.source.latitude, longitude: self.source.longitude)
//                            smarker.map = self.mapView

                            let dmarker = GMSMarker()
                            let img = UIImage(named: "redMarker")
                            
                            let profileImageURL = baseImageURL + (self.OrderDetailsData.userId.avatar)!
                            if let imageURL = URL(string: profileImageURL) {
                                self.imgPP.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))
                            }
                            
                            dmarker.icon = self.imageWithImage(image: self.drawImageWithProfilePic(pp: self.imgPP.image ?? #imageLiteral(resourceName: "userwhite"), image: img!), scaledToSize: CGSize(width: 53.0, height: 70.0))
                            dmarker.position = CLLocationCoordinate2D(latitude: self.destination.latitude, longitude: self.destination.longitude)
                            dmarker.map = self.mapView



                        })

                    }

                } catch {
                    print("parsing error")
                }
            }
        })
        task.resume()
    }
//    func addPolyLineWithEncodedStringInMap(encodedString: String) {
//
//
////        let camera = GMSCameraPosition.cameraWithLatitude(18.5204, longitude: 73.8567, zoom: 10.0)
////        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
////        mapView.myLocationEnabled = true
//
//        let path = GMSMutablePath(fromEncodedPath: encodedString)
//        let polyLine = GMSPolyline(path: path)
//        polyLine.strokeWidth = 5
//        polyLine.strokeColor = UIColor.red
//        polyLine.map = mapView
//
//        let bounds = GMSCoordinateBounds(path:path! )
//        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
//
//        let smarker = GMSMarker()
//        smarker.position = CLLocationCoordinate2D(latitude: source.latitude, longitude: source.longitude)
//        smarker.map = mapView
//
//        let dmarker = GMSMarker()
//        dmarker.position = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
//        dmarker.map = mapView
//
//        view = mapView
//
//    }
   
//    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
//
//        let session = URLSession.shared
//
//        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyBVR9y0dhBvTnGkHOah1xy2rOIEB1J0pRA")!
//
//            //&key=AIzaSyA0pibFZlrdFeEcR7oz7jekFKMbjgJFWzU"
//
//        let task = session.dataTask(with: url, completionHandler: {
//            (data, response, error) in
//
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//
//            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any], let jsonResponse = jsonResult else {
//                print("error in JSONSerialization")
//                return
//            }
//
//            guard let routes = jsonResponse["routes"] as? [Any] else {
//                return
//            }
//
//            guard let route = routes[0] as? [String: Any] else {
//                return
//            }
//
//            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
//                return
//            }
//
//            guard let polyLineString = overview_polyline["points"] as? String else {
//                return
//            }
//
//            //Call this method to draw path on map
//            self.drawPath(from: polyLineString)
//        })
//        task.resume()
//    }
//    func drawPath(from polyStr: String){
//        let path = GMSPath(fromEncodedPath: polyStr)
//        let polyline = GMSPolyline(path: path)
//        polyline.strokeWidth = 3.0
//        polyline.map = mapView // Google MapView
//    }
    func imageWithImage(image: UIImage,scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage {
        
        let imgView = UIImageView(image: image)
        let picImgView = UIImageView(image: pp)
        picImgView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        
        imgView.addSubview(picImgView)
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y - 30
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        imgView.setNeedsLayout()
        picImgView.setNeedsLayout()
        
        let newImage = imageWithView(view: imgView)
        return newImage
    }
    
    func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
    //MARK:- Send Prompt API
    func sendPromptAPI(){
        
        let params:[String:Any] = ["userId": orderUserId,
                                   "driverId": defaultValues.string(forKey: "UserID")!,
                                   "issue": ""]
        WebService.shared.apiDataPostMethod(url: sendPromptURL, parameters: params) { (response, error) in
            if error == nil{
                if let dict = response {
                    
                    Helper.Alertmessage(title: "Info:", message: dict["message"] as! String, vc: self)
                    
                    
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT-7") // TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
    func convertUTCToDate(_ datestring:String) -> String {
        
        let dateForm = DateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateForm.timeZone = TimeZone(abbreviation: "UTC+0")
        
        let dateFormatterPrint = DateFormatter()
        
        dateFormatterPrint.dateFormat = "hh:mm a"
        dateFormatterPrint.timeZone = TimeZone.current
        let date = dateForm.date(from: datestring)
        let date1 = dateFormatterPrint.string(from: date ?? Date())
        
        
        return date1
        
    }
}
//MARK:- Creating Table View
extension DriverOrderVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      //return 300
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellCountNo == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrdersCell", for: indexPath) as! HomeOrdersCell
            
            var profileImageURL = ""
            if orderData?.orderId?.userId?.isFullUrl == 0{
                 profileImageURL = baseImageURL + (orderData?.orderId?.userId?.avatar)!
            }else{
                 profileImageURL = (orderData?.orderId?.userId?.avatar)!
            }
           
            if let imageURL = URL(string: profileImageURL) {
                cell.profilePic.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))
            }
            
            cell.nameLbl.text = orderData?.orderId?.userId?.name
            cell.addressLbl.text = orderData?.orderId?.address
            cell.lecensePlateLbl.text = orderData?.orderId?.vehicleId?.licencePlate
            if let accont = orderData?.orderId?.userId?.accountType, accont == 0 {
                
                cell.vehicleDetailslbl.text = (orderData?.orderId?.vehicleId?.year)! + " " + (orderData?.orderId?.vehicleId?.make)! + " " + (orderData?.orderId?.vehicleId?.model)! +  "," + (orderData?.orderId?.vehicleId?.color)!
//                (acceptOrderData.vehicleId?.year)! + " " + (acceptOrderData.vehicleId?.make)! + " " + (acceptOrderData.vehicleId?.model)! + ", " + (acceptOrderData.vehicleId?.color)!
            }else{
                cell.vehicleDetailsTitleLbl.text = "No. of vehicles:"
                cell.vehicleDetailslbl.text = orderData?.orderId?.vehicleCount
                cell.licensePlateTitleLbl.text = ""
            }
            
            
            if let fuelname = orderData?.orderId?.fuelType {
                if fuelname == 0 {
                    if let fullTank = orderData?.orderId?.isFulltank, fullTank == 1 {
                        cell.fuewlLbl.text = "Gasoline (Fill it)"
                    }else{
                        if let amount = OrderDetailsData.fuelAmount, amount != 0 {
                            cell.fuewlLbl.text = "Gasoline (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuewlLbl.text = "Gasoline (\(OrderDetailsData.fuelQuantity ?? 1) L)"
                        }
                       //cell.fuewlLbl.text = "Gasoline"
                    }
                    
                }
                else if fuelname == 1{
                    if let fullTank = orderData?.orderId?.isFulltank, fullTank == 1 {
                       cell.fuewlLbl.text = "Premium Gasoline (Fill it)"
                    }else{
                        if let amount = OrderDetailsData.fuelAmount, amount != 0 {
                            cell.fuewlLbl.text = "Premium Gasoline (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuewlLbl.text = "Premium Gasoline (\(OrderDetailsData.fuelQuantity ?? 1) L)"
                        }
                        //cell.fuewlLbl.text = "Premium Gasoline"
                    }
                    
                }
                else if fuelname == 2{
                    if let fullTank = orderData?.orderId?.isFulltank, fullTank == 1 {
                        cell.fuewlLbl.text = "Diesel (Fill it)"
                    }else{
                        if let amount = OrderDetailsData.fuelAmount, amount != 0 {
                            cell.fuewlLbl.text = "Diesel (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuewlLbl.text = "Diesel (\(OrderDetailsData.fuelQuantity ?? 1) L)"
                        }
                        //cell.fuewlLbl.text = "Diesel"
                    }
                    
                }
            }
            if let services = orderData?.orderId?.serviceId, services.isEmpty == false{
                let serviceStr = services.map{($0.serviceName!)}
                print(serviceStr)
                cell.servicesLbl.text = serviceStr.joined(separator: ", ")
                }else{
                    cell.servicesLbl.text = ""
            }
            
            if let longDate = orderData?.orderId?.deleveringDate, longDate != 0{
                
                //mark:- converting longdate into Date format
                let milisecond = longDate
                let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                if let deleverDate = orderData?.orderId?.timing, deleverDate != "" {
                    cell.requstedLbl.text = deleverDate + ", " + dateFormatter.string(from: dateVar)
                }
                
                if let Receipt = orderData?.orderId?.isPhysicalRecieptYes, Receipt == 1{
                    cell.physicalReceiptLbl.text = "YES"
                }else{
                    cell.physicalReceiptLbl.text = "NO"
                    
                }
                
            }else
            {
                cell.requstedLbl.text = "Now"
//                cell.physicalReceiptTitleLbl.text = ""
//                cell.physicalReceiptLbl.text = ""
                
            }
            
            
            cell.acceptBtn.tag = indexPath.row
            cell.acceptBtn.setTitle("GO!", for: .normal)
            cell.acceptBtn.addTarget(self, action: #selector(btnPres(sender:)), for: .touchUpInside)
            return cell
        }
        else if cellCountNo == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrdersCell", for: indexPath) as! HomeOrdersCell

            var profileImageURL = ""
            if acceptOrderData.userId?.isFullUrl == 0 {
                 profileImageURL = baseImageURL + (acceptOrderData.userId?.avatar)!
            }else{
                profileImageURL = (acceptOrderData.userId?.avatar)!
            }
            
            if let imageURL = URL(string: profileImageURL) {
                cell.profilePic.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))
            }
            
            cell.nameLbl.text = acceptOrderData.userId?.name //orderData?.orderId?.userId?.name
            cell.addressLbl.text = acceptOrderData.address //orderData?.orderId?.address
            cell.lecensePlateLbl.text = acceptOrderData.vehicleId?.licencePlate //orderData?.orderId?.vehicleId?.licencePlate
            if let accont =  acceptOrderData.userId?.accountType, accont == 0 {
                
                cell.vehicleDetailslbl.text = (acceptOrderData.vehicleId?.year)! + " " + (acceptOrderData.vehicleId?.make)! + " " + (acceptOrderData.vehicleId?.model)! + ", " + (acceptOrderData.vehicleId?.color)!
            }else{
                cell.vehicleDetailsTitleLbl.text = "No. of vehicles:"
                cell.vehicleDetailslbl.text = acceptOrderData.vehicleCount //orderData?.orderId?.vehicleCount
                cell.licensePlateTitleLbl.text = ""
            }
            
            
            if let fuelname = acceptOrderData.fuelType{
                if fuelname == 0 {
                    if let fullTank = acceptOrderData.isFulltank, fullTank == 1 {
                        
                        cell.fuewlLbl.text = "Gasoline (Fill it)"
                    }else{
                        if let amount = acceptOrderData.fuelAmount, amount != 0 {
                            cell.fuewlLbl.text = "Gasoline (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuewlLbl.text = "Gasoline (\(acceptOrderData.fuelQuantity ?? 1) L)"
                        }
                        //cell.fuewlLbl.text = "Gasoline"
                    }
                    
                }
                else if fuelname == 1{
                    
                    if let fullTank = acceptOrderData.isFulltank, fullTank == 1 {
                        cell.fuewlLbl.text = "Premium Gasoline (Fill it)"
                    }else{
                        if let amount = acceptOrderData.fuelAmount, amount != 0 {
                            cell.fuewlLbl.text = "Premium Gasoline (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuewlLbl.text = "Premium Gasoline (\(acceptOrderData.fuelQuantity ?? 1) L)"
                        }
                        //cell.fuewlLbl.text = "Premium Gasoline"
                    }
                }
                else if fuelname == 2{
                    
                    if let fullTank = acceptOrderData.isFulltank, fullTank == 1 {
                        cell.fuewlLbl.text = "Diesel (Fill it)"
                    }else{
                        if let amount = acceptOrderData.fuelAmount, amount != 0 {
                            cell.fuewlLbl.text = "Diesel (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuewlLbl.text = "Diesel (\(acceptOrderData.fuelQuantity ?? 1) L)"
                        }
                        //cell.fuewlLbl.text = "Diesel"
                    }
                }
            }
            if let services = acceptOrderData.serviceId, services.isEmpty == false{
                let serviceStr = services.map{($0.serviceName!)}
                print(serviceStr)
                cell.servicesLbl.text = serviceStr.joined(separator: ", ")
            }else{
                cell.servicesLbl.text = ""
            }
            
            if let longDate = acceptOrderData.deleveringDate, longDate != 0{
                
                //mark:- converting longdate into Date format
                let milisecond = longDate
                let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                if let deleverDate = acceptOrderData.timing, deleverDate != "" {
                    cell.requstedLbl.text = deleverDate + ", " + dateFormatter.string(from: dateVar)
                }
                
                if let Receipt = acceptOrderData.userId?.isPhysicalRecieptYes, Receipt == 1{
                    cell.physicalReceiptLbl.text = "YES"
                }else{
                    cell.physicalReceiptLbl.text = "NO"
                }
                
            }else
            {
                cell.requstedLbl.text = "Now"
//                cell.physicalReceiptTitleLbl.text = ""
//                cell.physicalReceiptLbl.text = ""
                
            }
            
            cell.acceptBtn.tag = indexPath.row
            cell.acceptBtn.setTitle("GO!", for: .normal)
            cell.acceptBtn.addTarget(self, action: #selector(btnPres(sender:)), for: .touchUpInside)
            return cell
            
        }
        else if cellCountNo == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendPromptGoCell", for: indexPath) as! SendPromptGoCell
     //       if let data = orderDetailsModelData.order, data != nil {
            
            var profileImageURL = ""
            if OrderDetailsData.userId.isFullUrl == 0{
                profileImageURL = baseImageURL + (OrderDetailsData.userId.avatar)!
            }else{
                profileImageURL = (OrderDetailsData.userId.avatar)!
            }
            
            
            if let imageURL = URL(string: profileImageURL) {
                cell.profilePic.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))
            }
            cell.nameLbl.text = OrderDetailsData.userId.name //orderData?.orderId?.userId?.name
            cell.addressLbl.text = OrderDetailsData.address //orderData?.orderId?.address
            
            if let accont = OrderDetailsData.userId.accountType, accont == 0 {
                
                cell.vehicleDetailsLbl.text = (OrderDetailsData.vehicleId.year)! + " " + (OrderDetailsData.vehicleId.make)! + " " + (OrderDetailsData.vehicleId.model)! + ", " + (OrderDetailsData.vehicleId.color)!
//                (acceptOrderData.vehicleId?.year)! + " " + (acceptOrderData.vehicleId?.make)! + " " + (acceptOrderData.vehicleId?.model)! + ", " + (acceptOrderData.vehicleId?.color)!
            }else{
                cell.vehicleDetailsTitleLbl.text = "No. of vehicles:"
                cell.vehicleDetailsLbl.text = OrderDetailsData.vehicleCount //orderData?.orderId?.vehicleCount
                cell.licensePlateTitleLbl.text = ""
            }
            if OrderDetailsData.userId.accountType == 0 {
                if let licensePlate = OrderDetailsData.vehicleId.licencePlate, licensePlate != ""{
                    cell.licensePlateLbl.text = OrderDetailsData.vehicleId.licencePlate //OrderData.vehicleId?.licencePlate
                }
            }else{
                cell.licensePlateTitleLbl.text = ""
                cell.licensePlateLbl.text = ""
            }
            
            if let fuelname = OrderDetailsData.fuelType {
                //let fill = data[indexPath.row].isFulltank
                
                if fuelname == 0 {
                    if let fullTank = OrderDetailsData.isFulltank, fullTank == 1 {
                        
                        cell.fuelNameLbl.text = "Gasoline (Fill it)"
                    }else{
                        if let amount = OrderDetailsData.fuelAmount, amount != 0 {
                            cell.fuelNameLbl.text = "Gasoline (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuelNameLbl.text = "Gasoline (\(OrderDetailsData.fuelQuantity ?? 1) L)"
                        }
                       //cell.fuelNameLbl.text = "Gasoline"
                    }
                    
                }else if fuelname == 1 {
                    if let fullTank = OrderDetailsData.isFulltank, fullTank == 1 {
                        
                        cell.fuelNameLbl.text = "Premium Gasoline (Fill it)"
                    }else{
                        if let amount = OrderDetailsData.fuelAmount, amount != 0 {
                            cell.fuelNameLbl.text = "Premium Gasoline (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuelNameLbl.text = "Premium Gasoline (\(OrderDetailsData.fuelQuantity ?? 1) L)"
                        }
                        //cell.fuelNameLbl.text = "Premium Gasoline"
                    }
                    
                }else if fuelname == 2{
                    if let fullTank = OrderDetailsData.isFulltank, fullTank == 1 {
                        
                         cell.fuelNameLbl.text = "Diesel(Fill it)"
                    }else{
                        if let amount = OrderDetailsData.fuelAmount, amount != 0 {
                            cell.fuelNameLbl.text = "Diesel (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuelNameLbl.text = "Diesel (\(OrderDetailsData.fuelQuantity ?? 1) L)"
                        }
                         //cell.fuelNameLbl.text = "Diesel"
                    }
                   
                }
            }
            
            if let longDate = OrderDetailsData.deleveringDate, longDate != 0{
                
                let milisecond = longDate
                let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                if let deleverDate = OrderDetailsData.timing, deleverDate != "" {
                    cell.requestedTimeLbl.text = deleverDate + ", " + dateFormatter.string(from: dateVar)
                }
            }else
            {
                if let time = OrderDetailsData.createdAt, time != "" {
                    
//                    //mark:- converting longdate into Date format
//                    let dateFormatterGet = DateFormatter()
//                    dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//                    dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC+0")
//                    let dateFormatterPrint = DateFormatter()
//                    dateFormatterPrint.dateFormat = "hh:mm a"
//                    let datee = dateFormatterGet.date(from: time)
//                    let dateObj =  dateFormatterPrint.string(from: datee ?? Date())
                    
                    cell.requestedTimeLbl.text = "Now " + convertUTCToDate(time)
                }else{
                    cell.requestedTimeLbl.text = "Now"
                }
               // cell.requestedTimeLbl.text = "Now"
                
//                cell.physicalReceiptTitleLbl.text = ""
//                cell.physicalReceiptLbl.text = ""
            }
            if let Receipt = OrderDetailsData.isPhysicalRecieptYes, Receipt == 1{
                cell.physicalReceiptLbl.text = "YES"
            }else{
                //cell.physicalReceiptTitleLbl.text = ""
                cell.physicalReceiptLbl.text = "NO"
            }
            
            if let serviceData = OrderDetailsData.serviceId, serviceData.count > indexPath.row{
                let serviceStr = serviceData.map{($0.serviceName!)}
                cell.servicesLbl.text = serviceStr.joined(separator: ", ")
            }
            
            cell.sendPromptBtn.addTarget(self, action: #selector(btnPres(sender: )), for: .touchUpInside)
            cell.startOrdrBtn.addTarget(self, action: #selector(btnPres(sender:)), for: .touchUpInside)
            
           // }
           return cell
        }
        else if cellCountNo == 4{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendPromptCell", for: indexPath) as! SendPromptCell
        //    if let data = OrderIdData,data.count > indexPath.row{
           
            var profileImageURL = ""
            if OrderDetailsData.userId.isFullUrl == 0{
                profileImageURL = baseImageURL + (OrderDetailsData.userId.avatar)!
            }else{
                profileImageURL = (OrderDetailsData.userId.avatar)!
            }
            
            
            if let imageURL = URL(string: profileImageURL) {
                cell.profilePic.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))
            }
                cell.nameLbl.text = OrderDetailsData.userId.name //data[indexPath.row].userId?.name!
            
                cell.addressLbl.text = OrderDetailsData.address //data[indexPath.row].address!
                
                let name = OrderDetailsData.userId.name
                cell.cellTextLbl.text = "Hi \(name!)! This is your FuelSrv operator, I seem to be having the following issue: "
                
          //  }
            cell.sendBtn.addTarget(self, action: #selector(btnPres(sender:)), for: .touchUpInside)
            return cell
        }
        else if cellCountNo == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCompleteCell", for: indexPath) as! ReportCompleteCell
        //    if let data1 = OrderIdData, data1.count > indexPath.row{
            
            var profileImageURL = ""
            if OrderDetailsData.userId.isFullUrl == 0 {
                 profileImageURL = baseImageURL + (OrderDetailsData.userId.avatar)!
            }else{
                 profileImageURL = (OrderDetailsData.userId.avatar)!
            }
            
            if let imageURL = URL(string: profileImageURL) {
                cell.profilePic.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))
                //cell.profilePic.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "DriverUser-shape"))
            }
                cell.nameLbl.text = OrderDetailsData.userId.name //data1[indexPath.row].userId?.name!
                cell.addressLbl.text = OrderDetailsData.address//data1[indexPath.row].address!
            
            if let accont = OrderDetailsData.userId.accountType, accont == 0 {
                
                cell.vehicleDetailslbl.text = (OrderDetailsData.vehicleId.year)! + " " + (OrderDetailsData.vehicleId.make)! + " " + (OrderDetailsData.vehicleId.model)! + ", " + (OrderDetailsData.vehicleId.color)!
                
            }else{
                cell.vehicleDetailsTitleLbl.text = "No. of vehicles:"
                cell.vehicleDetailslbl.text = OrderDetailsData.vehicleCount
                cell.licensePlateTitleLbl.text = ""
            }
            
            if OrderDetailsData.userId.accountType == 0 {
                if let licensePlate = OrderDetailsData.vehicleId.licencePlate, licensePlate != ""{
                    cell.lecensePlateLbl.text = OrderDetailsData.vehicleId.licencePlate //OrderData.vehicleId?.licencePlate
                }
            }else{
                cell.licensePlateTitleLbl.text = ""
                cell.lecensePlateLbl.text = ""
            }
            if let fuelname = OrderDetailsData.fuelType {
                //let fill = data[indexPath.row].isFulltank
                
                if fuelname == 0 {
                    if let fullTank = OrderDetailsData.isFulltank, fullTank == 1 {
                        
                        cell.fuewlLbl.text = "Gasoline (Fill it)"
                    }else{
                        if let amount = OrderDetailsData.fuelAmount, amount != 0 {
                            cell.fuewlLbl.text = "Gasoline (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuewlLbl.text = "Gasoline (\(OrderDetailsData.fuelQuantity ?? 1) L)"
                        }
                       // cell.fuewlLbl.text = "Gasoline"
                    }
                    
                }else if fuelname == 1 {
                    if let fullTank = OrderDetailsData.isFulltank, fullTank == 1 {
                        
                        cell.fuewlLbl.text = "Premium Gasoline (Fill it)"
                    }else{
                        if let amount = OrderDetailsData.fuelAmount, amount != 0 {
                            cell.fuewlLbl.text = "Premium Gasoline (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuewlLbl.text = "Premium Gasoline (\(OrderDetailsData.fuelQuantity ?? 1) L)"
                        }
                        //cell.fuewlLbl.text = "Premium Gasoline"
                    }
                    
                }else if fuelname == 2{
                    if let fullTank = OrderDetailsData.isFulltank, fullTank == 1 {
                        
                        cell.fuewlLbl.text = "Diesel(Fill it)"
                    }else{
                        if let amount = OrderDetailsData.fuelAmount, amount != 0 {
                            cell.fuewlLbl.text = "Diesel (\(currencyFormat(String(describing: amount))))"
                        }else{
                            cell.fuewlLbl.text = "Diesel (\(OrderDetailsData.fuelQuantity ?? 1) L)"
                        }
                        //cell.fuewlLbl.text = "Diesel"
                    }
                    
                }
            }
            if let services = OrderDetailsData.serviceId, services.isEmpty == false{
                let serviceStr = services.map{($0.serviceName!)}
                
                cell.servicesLbl.text = serviceStr.joined(separator: ", ")
            }else{
                cell.servicesLbl.text = ""
            }
                    
                    if let longDate = OrderDetailsData.deleveringDate, longDate != 0{
                        
                        let milisecond = longDate
                        let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        
                        if let deleverDate = OrderDetailsData.timing, deleverDate != "" {
                            cell.requstedLbl.text = deleverDate + ", " + dateFormatter.string(from: dateVar)
                        }
                       
                    }else
                    {
                        
                        if let time = OrderDetailsData.createdAt, time != "" {
                            cell.requstedLbl.text = "Now " + convertUTCToDate(time)
                        }else{
                            cell.requstedLbl.text = "Now"
                        }
                    }
            
            
            if let Receipt = OrderDetailsData.isPhysicalRecieptYes, Receipt == 1{
                cell.physicalReceiptLbl.text = "YES"
            }else{
                cell.physicalReceiptLbl.text = "NO"
            }
               
                
           // }
            cell.reportIssueBtn.addTarget(self, action: #selector(btnPres(sender:)), for: .touchUpInside)
            cell.completeOrderBtn.addTarget(self, action: #selector(btnPres(sender:)), for: .touchUpInside)
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    @objc func btnPres(sender:UIButton ){
        
       
        
        if sender.title(for: .normal) == "ACCEPT"{
            cellCountNo = 2
            //tableView.reloadData()
        }else if sender.title(for: .normal) == "GO!"{
            
            orderDetailsAPI()
            tableViewHeight.constant = 310
//            cellCountNo = 3
            
        }
        else if sender.title(for: .normal) == "Send Prompt"{
            
            //showAlert("Info:", "Some issue is there", "OK")
            
            let vc = DriverStoryBoard.instantiateViewController(withIdentifier: "SendPromptVC") as! SendPromptVC
            vc.userId = orderUserId
            vc.sendPromtData = OrderDetailsData
           self.present(vc, animated: true, completion: nil)
//            self.present(vc, animated: true) {
//                self.tableViewHeight.constant = 0
//            }
//            cellCountNo = 4
//            tableViewHeight.constant = 395
            
        }
        else if sender.title(for: .normal) == "SEND"{
            
            sendPromptAPI()
            tableViewHeight.constant = 310
            cellCountNo = 3
        }
        else if sender.title(for: .normal) == "START ORDER"{
            

            dragButtonView.isHidden = false
            tableViewHeight.constant = 0
            SVProgressHUD.show()
            
            draw(src: source, dst: destination)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.tableViewHeight.constant = 85
                self.cellCountNo = 5
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
        else if sender.title(for: .normal) == "Report Issue"{
            
            let vc = DriverStoryBoard.instantiateViewController(withIdentifier: "ReportIssueVC") as! ReportIssueVC
            vc.orderid = OrderDetailsData.id //orderData?.orderId?.id
            vc.reportIssue = OrderDetailsData
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if sender.title(for: .normal) == "COMPLETE ORDER"{
            
            let vc = DriverStoryBoard.instantiateViewController(withIdentifier: "OrderSummuryVC") as! OrderSummuryVC
            vc.orderid = OrderDetailsData.id //orderData?.orderId?.id
            vc.orderSummury = OrderDetailsData
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.reloadData()
    }
}

