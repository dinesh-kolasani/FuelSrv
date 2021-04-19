////  HomeVC.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 08/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import SDWebImage


class DriverHomeVC: UIViewController,CLLocationManagerDelegate{
    var AllOrdersDriverModelData : AllOrdersDriverModel!
    var DriverAllOrdersData = [DriverAllOrders]()
    
    var service:[ServiceId]?
    var vehicleData:[VehicleId]?
    var ServiceIdModel: ServiceId!
    var vehicleModel: VehicleId!
    
    var AcceptOrderDriverModel : AcceptOrderDriver!
    var acceptOrderDriverData : AcceptedOrder!
    
        //var orderDetailsModelData: OrderDetailsModel!
        //var OrderIdData: OrderId!
    
    var defaultMarker = GMSMarker()

    @IBOutlet weak var acceptOrdersTV: UITableView!
    @IBOutlet weak var sideMenuButton: UIButton!
    
    @IBOutlet weak var mainButtonView: UIView!
    
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var currentLocationBtn: UIButton!
    
    var locationManager = CLLocationManager()
    var selectedMarkerIndex:Int!
    
    var userLocation = appDelegate.orderDataDict["UserLocation"] as? [String : String] ?? [:]
    var mapLat: Double?
    var mapLong: Double?
    var getname = ""
    var deleverTime: Int?
    
    var tag = Int()
    
    var userlat: Double = 0.0
    var userlong: Double = 0.0
    var imgPP = UIImageView()
    
    
        //MARK:- View Did Load
        override func viewDidLoad() {
        super.viewDidLoad()
            
            let nibName = UINib(nibName: "HomeOrdersCell", bundle:nil)
            self.acceptOrdersTV.register(nibName, forCellReuseIdentifier: "HomeOrdersCell")
            
            mainButtonView.setOneSideCorner(outlet: mainButtonView)
            currentLocationBtn.dropShadow(view: currentLocationBtn, opacity: 0.5)
            Helper.TopedgeviewCorner(viewoutlet: acceptOrdersTV, radius: 40)
            
           //allOrdersDriverAPI()
            showDriverCurrentLocationOnMap()
            acceptOrdersTV.isHidden = true
            
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipedown(_:)))
            swipeDown.direction = .down
            acceptOrdersTV.addGestureRecognizer(swipeDown)
            
            
            
            scrollTableView()
            
            mapView.delegate = self
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
            self.acceptOrdersTV.estimatedRowHeight = 293.5
            self.acceptOrdersTV.rowHeight = UITableViewAutomaticDimension
            
        }
    
        //MARK:- View Will Appear
        override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            //allOrdersDriverAPI()
        }
        //MARK:- View Did Appear
        override func viewDidAppear(_ animated: Bool) {
            UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 1, green: 0.2588235294, blue: 0.1843137255, alpha: 1)
        }
    
        //MARK:- View Did Disappear
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
        
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    
    //MARK:- Swipe Gesture Down/UP
    @objc func swipedown(_ gestureRecognizer: UISwipeGestureRecognizer?) {
        
        var bgPath: UIBezierPath?
        bgPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        let bgLayer = CAShapeLayer()
        bgLayer.frame = view.bounds
        bgLayer.path = bgPath?.cgPath
        acceptOrdersTV.layer.mask = bgLayer
        UIView.transition(with: acceptOrdersTV, duration: 0.5, options: .curveEaseIn, animations: {
            self.tableViewHeight.constant = self.acceptOrdersTV.frame.size.height - self.view.frame.size.height + 130
            self.view.layoutIfNeeded()
        }) { finished in
            self.acceptOrdersTV.isHidden = true
        }
        
    }
    func swipeup(_ gestureRecognizer: UISwipeGestureRecognizer?) {
        
        var bgPath: UIBezierPath?
        bgPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        let bgLayer = CAShapeLayer()
        bgLayer.frame = view.bounds
        bgLayer.path = bgPath?.cgPath
        acceptOrdersTV.layer.mask = bgLayer
        UIView.transition(with: acceptOrdersTV, duration: 0.5, options: .curveEaseIn, animations: {
            self.tableViewHeight.constant = 350
            self.view.layoutIfNeeded()
        }) { finished in
        }
        
    }
    
    //MARK:- All Orders Locations Markers Creating
    func Markers(){
        arrayMarkers.removeAll()

        for i in 0..<DriverAllOrdersData.count {

            let userlat = DriverAllOrdersData[i].userLat!
            let userlong = DriverAllOrdersData[i].userLong!
            let orderType = DriverAllOrdersData[i].deleveringDate!
            deleverTime = orderType
            self.getname = DriverAllOrdersData[i].address!
            let imagString = DriverAllOrdersData[i].userId?.avatar ?? ""
            let photoUrlType = DriverAllOrdersData[i].userId?.isFullUrl ?? 0
            print(imagString)
            
            var profileImageURL = ""
            if photoUrlType == 0 {
                profileImageURL = baseImageURL + imagString
            }else{
                  profileImageURL = imagString
            }
 //           DispatchQueue.main.async {
            
                if let imageURL = URL(string: profileImageURL){
                self.imgPP.isUserInteractionEnabled = false
                    self.imgPP.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))

                }
       //     }
            orderLocation(userlat,userlong,i, orderType)
        }
    }
       //Marker position on map
    func orderLocation(_ lat:Double , _ long:Double , _ indexValue:Int , _ orderType: Int)  {
        
        //let camera = GMSCameraPosition.camera(withLatitude: lat , longitude: long , zoom: 14.0)
        //mapView.animate(to: camera)
        
        let marker = GMSMarker()
        marker.userData = indexValue
//        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: 50, height: 70), image: #imageLiteral(resourceName: "home-button"), borderColor: UIColor.darkGray, tag: 0)
//        marker.iconView = customMarker
        //let imgPP = UIImage(named: "userPic")
        var img = UIImage(named: "redMarker")
        
        if orderType != 0 {
            img = UIImage(named: "blackMarker")
        }else{
            img = UIImage(named: "redMarker")
        }
        
        
        //marker.icon = drawImageWithProfilePic(pp: imgPP!, image: img!)
        //marker.icon = self.imageWithImage(image: #imageLiteral(resourceName: "redMarker"), scaledToSize: CGSize(width: 53, height: 70))
        marker.icon = self.imageWithImage(image: drawImageWithProfilePic(pp: imgPP.image ?? #imageLiteral(resourceName: "userwhite"), image: img!), scaledToSize: CGSize(width: 53.0, height: 70.0))
        marker.position = CLLocationCoordinate2D(latitude: lat , longitude: long )
        //marker.title = getname
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.map = mapView
        marker.infoWindowAnchor = CGPoint(x: 1.5, y: 1.0)
        arrayMarkers.append(marker)
    
    }
    
    lazy var arrayMarkers = [GMSMarker]()
    
    //mergeing image for creating marker image
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
    
    //MARK:- Show Current Location
    func showDriverCurrentLocationOnMap(){
        //let marker = GMSMarker()
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0, zoom: 13)
        mapView.animate(to: camera)
        mapView.isMyLocationEnabled = true
        
//        //Setting the googleView
//        self.mapView?.camera = camera
//        self.mapView?.delegate = self
//        self.mapView?.isMyLocationEnabled = true
//        self.mapView?.settings.myLocationButton = true
//        self.mapView?.settings.compassButton = true
//        self.mapView?.settings.zoomGestures = true
//        self.mapView?.animate(to: camera)
        
        //self.mapView.addSubview(self.gmsMap!)
    
        self.mapLat = locationManager.location?.coordinate.latitude
        self.mapLong = locationManager.location?.coordinate.longitude
         DispatchQueue.main.async {
            
        self.allOrdersDriverAPI(self.locationManager.location?.coordinate.latitude ?? 0.0, self.locationManager.location?.coordinate.longitude ?? 0.0)
        }
    }
 
    //MARK:- Scroll of tableView Cell
    func scrollTableView(){
        
        if (acceptOrdersTV.contentSize.height < acceptOrdersTV.frame.size.height) {
            acceptOrdersTV.isScrollEnabled = false;
        }
        else {
            acceptOrdersTV.isScrollEnabled = true;
        }
    }
    
    //MARK:- Button actions
    @IBAction func sideMenuAction(_ sender: UIButton) {
        showMenu()
    }
    @IBAction func currentLocationBtn(_ sender: Any) {
        
        self.showDriverCurrentLocationOnMap()
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: - AllOrderDriverModel API
    func allOrdersDriverAPI(_ lat:Double , _ long:Double){
        
//        mapLat = 49.28473139440409 //Double(userLocation["Maplat"] ?? "")
//        mapLong = -123.12067095190287 //Double(userLocation["MapLong"] ?? "")
        
        let params = ["userLong": lat,
                      "userLat": long,
                      "userId": defaultValues.string(forKey: "UserID")!] as [String : Any]
        
        WebService.shared.apiDataPostMethod(url: allOrdersDriverURL, parameters: params) { (response, error) in
            if error == nil{

                self.AllOrdersDriverModelData = Mapper<AllOrdersDriverModel>().map(JSONObject: response)

                if self.AllOrdersDriverModelData.success == true{
                    
                    if let data = self.AllOrdersDriverModelData?.orders{
                        self.DriverAllOrdersData.removeAll()
                        self.DriverAllOrdersData.append(contentsOf: data)
                        
                        print(self.DriverAllOrdersData.count)
                        
                        print(self.DriverAllOrdersData)
    
                          self.acceptOrdersTV.reloadData()

                    }
                    
                }
                DispatchQueue.main.async {
                    self.Markers()
                    //self.acceptOrdersTV.reloadData()
                }
            }
            
        }
        
    }
    
    // MARK: - acceptOrdersApi
    func acceptOrdersApi(orderId: String){
        
        let params = ["orderId":orderId,
                      "driverId":defaultValues.string(forKey: "UserID")!]
        
        WebService.shared.apiDataPostMethod(url: acceptOredrsDriverURL, parameters: params) { (response, error) in
            if error == nil{
                
                self.AcceptOrderDriverModel = Mapper<AcceptOrderDriver>().map(JSONObject: response)
                
                if self.AcceptOrderDriverModel.success == true{
                    if let data = self.AcceptOrderDriverModel.acceptedOrder{
                        self.acceptOrderDriverData = data
                        print(self.acceptOrderDriverData!)
                        //  self.fuelingsToDoTV.reloadData()
                    }
                
                }else{
                    
                    Helper.Alertmessage(title: "Info:", message: self.AcceptOrderDriverModel.message ?? "", vc: self)
                }

            } else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
            
        }
    
    }
    func convertUTCToDate(_ datestring:String) -> String {
        
        
        //mark:- converting longdate into Date format
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC+000")
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "hh:mm a"
        dateFormatterPrint.timeZone = TimeZone.current
        let datee = dateFormatterGet.date(from: datestring)
        let dateObj =  dateFormatterPrint.string(from: datee ?? Date())
        
        return dateObj
        
    }

}
//MARK:- Marker and info Window Delegates
extension DriverHomeVC: GMSMapViewDelegate{
    /* handles Info Window tap */

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        print("didTapInfoWindowOf")
        print(marker.userData!)
        if let value = marker.userData as? Int{
            selectedMarkerIndex = value
        }
        acceptOrdersTV.isHidden = false
        
        var bgPath: UIBezierPath?
        bgPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        let bgLayer = CAShapeLayer()
        bgLayer.frame = view.bounds
        bgLayer.path = bgPath?.cgPath
        acceptOrdersTV.layer.mask = bgLayer
        UIView.transition(with: acceptOrdersTV, duration: 0.5, options: .curveEaseIn, animations: {
            self.tableViewHeight.constant = 350
            self.acceptOrdersTV.reloadData()
            self.view.layoutIfNeeded()
        }) { finished in
        }
        
        //tableViewHeight.constant = 350
        
        
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Touched map")
        var bgPath: UIBezierPath?
        bgPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        let bgLayer = CAShapeLayer()
        bgLayer.frame = view.bounds
        bgLayer.path = bgPath?.cgPath
        acceptOrdersTV.layer.mask = bgLayer
        UIView.transition(with: acceptOrdersTV, duration: 0.5, options: .curveEaseIn, animations: {
            self.tableViewHeight.constant = self.acceptOrdersTV.frame.size.height - self.view.frame.size.height + 130
            self.view.layoutIfNeeded()
        }) { finished in
            self.acceptOrdersTV.isHidden = true
        }
        //acceptOrdersTV.isHidden = true
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        print(marker.userData!)
        if let value = marker.userData as? Int{
         selectedMarkerIndex = value
        }
        return false
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

//        let view = UIView(frame: CGRect.init(x: 10, y: 0, width: 70, height: 40))
        let view = UIView(frame: CGRect.init(x: 50 , y: 50, width: 100, height: 70))
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 6
        
        let displayLbl = UILabel(frame: CGRect.init(x: 38, y: 4, width: 80, height: 15))
        let displayTLbl = UILabel(frame: CGRect.init(x: 38, y: 18, width: 80, height: 15))
        
        guard let value = selectedMarkerIndex else { return nil}
        let selectedMarkerData = DriverAllOrdersData[value]
        
        var imageName = "Polygon 1 copy"
        if selectedMarkerData.deleveringDate != 0 {
             imageName = "Polygon 1 copygray"
            
            //mark:- converting longdate into Date format
            let milisecond = selectedMarkerData.deleveringDate ?? 0
            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            //dateFormatter.string(from: dateVar) + selectedMarkerData.timing!
            let customFont = UIFont(name: "SegoeUI-Semibold", size: 10) ?? .boldSystemFont(ofSize: 10)
           
            let myString  = dateFormatter.string(from: dateVar)
        
            let myAttribute = [ NSAttributedString.Key.font : customFont ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            displayLbl.attributedText  = myAttrString
//            displayLbl.lineBreakMode = .byWordWrapping
//            displayLbl.numberOfLines = 0
            let myString1  = selectedMarkerData.timing!

            let myAttribute1 = [ NSAttributedString.Key.font : customFont ]
            let myAttrString1 = NSAttributedString(string: myString1, attributes: myAttribute1)
            displayTLbl.attributedText  = myAttrString1
            
            
            
        
        }else{
           
            imageName = "Polygon 1 copy"
            
            let customFont = UIFont(name: "SegoeUI-Semibold", size: 13) ?? .boldSystemFont(ofSize: 10)
            
            let myString  = "  Now"
            
            let myAttribute = [ NSAttributedString.Key.font : customFont ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            displayLbl.attributedText  = myAttrString
            //displayLbl.textAlignment = .center
            
            
            let time = selectedMarkerData.updatedAt ?? ""
                
              let myString1 = convertUTCToDate(time)
            
            
            
            //let myString1  = selectedMarkerData.timing!
            
            let myAttribute1 = [ NSAttributedString.Key.font : customFont ]
            let myAttrString1 = NSAttributedString(string: myString1, attributes: myAttribute1)
            displayTLbl.attributedText  = myAttrString1
        }
        
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 25, y: 0, width: 70, height: 40)
        view.addSubview(imageView)
        
//        let lbl = UILabel(frame: CGRect.init(x: 18, y: 12, width: 70, height: 15))
       

        //displayLbl.text = "NOW"
        displayLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(displayLbl)
        
        displayTLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(displayTLbl)

        return view
    }
}

//MARK:- Creating Table View
extension DriverHomeVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //return 300
        return UITableViewAutomaticDimension
     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrdersCell", for: indexPath) as! HomeOrdersCell
        
        guard let value = selectedMarkerIndex else {
            
            return UITableViewCell()
        }
        let selectedMarkerData = DriverAllOrdersData[value]
        print(selectedMarkerData)
            if DriverAllOrdersData.count > indexPath.row {
                
                var profileImageURL = ""
                
                if selectedMarkerData.userId?.isFullUrl == 0{
                    profileImageURL = baseImageURL + (selectedMarkerData.userId?.avatar)!
                }else{
                     profileImageURL = (selectedMarkerData.userId?.avatar)!
                }
                if let imageURL = URL(string: profileImageURL) {
                    cell.profilePic.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))
                }
                
                cell.nameLbl.text = selectedMarkerData.userId?.name!
                cell.addressLbl.text = selectedMarkerData.address!
                //cell.physicalReceiptLbl = data1[indexPath.row].
                
                if let accont = selectedMarkerData.userId?.accountType, accont == 0 {
                    
                    cell.vehicleDetailslbl.text = (selectedMarkerData.vehicleId?.year)! + " " + (selectedMarkerData.vehicleId?.make)! + " " + (selectedMarkerData.vehicleId?.model)! + ", " + (selectedMarkerData.vehicleId?.color)!
                    cell.lecensePlateLbl.text = selectedMarkerData.vehicleId?.licencePlate!
                }else{
                    cell.vehicleDetailsTitleLbl.text = "No. of vehicles:"
                    cell.vehicleDetailslbl.text = selectedMarkerData.vehicleCount
                    cell.licensePlateTitleLbl.text = ""
                    cell.lecensePlateLbl.text = ""
                }
                
                
              
                if let fuelname = selectedMarkerData.fuelType {
                    //let fill = data[indexPath.row].isFulltank
                    
                    if fuelname == 0 {
                        if let fullTank = selectedMarkerData.isFulltank, fullTank == 1 {
                            
                            cell.fuewlLbl.text = "Gasoline (Fill it)"
                        }else{
                            if let amount = selectedMarkerData.fuelAmount, amount != 0 {
                               cell.fuewlLbl.text = "Gasoline (\(currencyFormat(String(describing: amount))))"
                            }else{
                                cell.fuewlLbl.text = "Gasoline (\(selectedMarkerData.fuelQuantity ?? 1) L)"
                            }
                            
                        }
                        
                    }else if fuelname == 1 {
                        if let fullTank = selectedMarkerData.isFulltank, fullTank == 1 {
                            
                            cell.fuewlLbl.text = "Premium Gasoline (Fill it)"
                        }else{
                            if let amount = selectedMarkerData.fuelAmount, amount != 0 {
                                cell.fuewlLbl.text = "Premium Gasoline (\(currencyFormat(String(describing: amount))))"
                            }else{
                                cell.fuewlLbl.text = "Premium Gasoline (\(selectedMarkerData.fuelQuantity ?? 1) L)"
                            }
                            //cell.fuewlLbl.text = "Premium Gasoline"
                        }
                        
                    }else if fuelname == 2{
                        if let fullTank = selectedMarkerData.isFulltank, fullTank == 1 {
                            
                            cell.fuewlLbl.text = "Diesel(Fill it)"
                        }else{
                            if let amount = selectedMarkerData.fuelAmount, amount != 0 {
                                cell.fuewlLbl.text = "Diesel (\(currencyFormat(String(describing: amount))))"
                            }else{
                                cell.fuewlLbl.text = "Diesel (\(selectedMarkerData.fuelQuantity ?? 1) L)"
                            }
                            //cell.fuewlLbl.text = "Diesel"
                        }
                        
                    }
                }
                if let longDate = selectedMarkerData.deleveringDate, longDate != 0 {
                   
                    //mark:- converting longdate into Date format
                    let milisecond = selectedMarkerData.deleveringDate ?? 0
                    
                    let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    
                    cell.requstedLbl.text = dateFormatter.string(from: dateVar) + " " + selectedMarkerData.timing!//dateFormatter.string(from: dateVar) + selectedMarkerData.timing!
                }else{
                    
                    if let time = selectedMarkerData.createdAt, time != "" {
                        
                        cell.requstedLbl.text = "Now - " + convertUTCToDate(time)
                    }else{
                        cell.requstedLbl.text = "Now"
                    }
                    //cell.requstedLbl.text = "Now"
                }
                
                if let Receipt = selectedMarkerData.isPhysicalRecieptYes, Receipt == 1{
                    cell.physicalReceiptLbl.text = "YES"
                }else{
                    //cell.physicalReceiptTitleLbl.text = ""
                    cell.physicalReceiptLbl.text = "NO"
                }
                
                if let services = selectedMarkerData.serviceId, services.isEmpty == false{
                    let serviceStr = services.map{($0.serviceName!)}
                    
                    cell.servicesLbl.text = serviceStr.joined(separator: ", ")
                }else{
                    cell.servicesLbl.text = ""
                }
                
        }
            cell.acceptBtn.tag = indexPath.row
            cell.acceptBtn.dropShadow(view: cell.acceptBtn, opacity: 0.3)
            cell.acceptBtn.addTarget(self, action: #selector(btnPres(sender:)), for: .touchUpInside)

            return cell
    }

    @objc func btnPres(sender:UIButton ){
        let order = DriverAllOrdersData[sender.tag]
        
            acceptOrdersApi(orderId: order.id!)
        //showAlert("Info:", "Some issue is there, goto check the fueling todo screen ", "OK")
        tableViewHeight.constant = 0
        
        let vc = DriverStoryBoard.instantiateViewController(withIdentifier: "DriverOrderVC") as! DriverOrderVC
        vc.acceptOrderData = order
        vc.orderNum = order.id
        vc.cellCountNo = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
