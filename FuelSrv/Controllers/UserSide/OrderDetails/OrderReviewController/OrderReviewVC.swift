//
//  OrderReviewVC.swift
//  FuelSrv
//
//  Created by PBS9 on 19/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps
import GooglePlaces
import Stripe

class OrderReviewVC: UIViewController,UIPopoverPresentationControllerDelegate,PromoDataDelegate,CardDataDelegate {
    
    @IBOutlet weak var myView: MapView!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var promoCodeBtn: UIButton!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var confirmBtn: RoundButton!
    @IBOutlet weak var vcHeight: NSLayoutConstraint!
    
    @IBOutlet weak var paymentBtnBGView: UIView!
    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var selectedCardNumberLbl: UILabel!
    
    @IBOutlet weak var promoCodeBtnBGView: UIView!
    @IBOutlet weak var promoCodeLbl: UILabel!
    @IBOutlet weak var discountAmountLbl: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    var name = appDelegate.orderDataDict["ServicesType"] as? [String] ?? []
    var headerTitles = ["Address","Convenient Service","Schedule","Vehicle"] //,"Fuel Type"
    var headerTitle = ["Address","Convenient Service","Vehicle"] //,"Fuel Type"
    var userLocation = appDelegate.orderDataDict["UserLocation"] as? [String : String] ?? [:]
    var schedule = appDelegate.orderDataDict["Schedule"] as? [String:Any] ?? [:]

    var vehicle = appDelegate.orderDataDict["Vehicle"] as? [String : String] ?? [:]
    var fuelDetails = appDelegate.orderDataDict["FuelType"] as? [String : String] ?? [:]
    var fuelAmount = appDelegate.orderDataDict["FuelAmount"] as? [String : String] ?? [:]
    var oilDetails = appDelegate.orderDataDict["Oil"] as? [String : String] ?? [:]
    var FillMyTiresDetails = appDelegate.orderDataDict["FillMyTires"] as? [String : String] ?? [:]
    var WindShieldWasherFluidDetails = appDelegate.orderDataDict["WindShieldWasherFluid"] as? [String : String] ?? [:]
    var PlowMyDrivewayDetails = appDelegate.orderDataDict["PlowMyDriveway"] as? [String : String] ?? [:]
    
    var PaymentDetails = appDelegate.orderDataDict["Payment"] as? [String : String] ?? [:]
    
    var vehicleCount = "1 - 10"
    
    var locationManager = CLLocationManager()
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.isUserInteractionEnabled = false
        //vcHeight.constant = UIScreen.main.bounds.height
       //tableHeight.constant = 380
        navigation()
        selectedLocation()
       print(appDelegate.orderDataDict)
        print(FillMyTiresDetails)
        let nib = UINib.init(nibName: "OrderReviewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "OrderReviewCell")
        
        let nibSec = UINib.init(nibName: "OrderReviewSecCell", bundle: nil)
        tableView.register(nibSec, forCellReuseIdentifier: "OrderReviewSecCell")
        
        tableView.tableFooterView = footerView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // self.tableViewHeight.constant = CGFloat(self.name.count * 60)
    }
    //MARK: - Button actions
    @IBAction func nextBtn(_ sender: Any) {
        if paymentStatus == 1{
            if firstTimeOrder == 0 && refCode != "" {
                if fuelAmount["FillIt"] == "0"{
                    if cancelAction == false{
                        showAlertWithButton()
                    }else{
                        check()
                    }

                }else{
                   check()
                }
            }else{
                check()
            }
            
        }else{
            
           self.showAlert("Info:", "Please select payment method", "OK")
        }
    }
    func check(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
        self.navigationController?.pushViewController(vc, animated: true)
        
//        if defaultValues.integer(forKey: "MembershipTaken") == 0{
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MembershipVC") as! MembershipVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    func showAlertWithButton() {
        let alert = UIAlertController(title: "Promo code Terms", message: "To use the \(currencyFormat("10")) free credit that's been applied to your first order, please reselect 'Fill it' while selecting fuel amount!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: { _ in
            self.promoCodeBtn.setTitle("Have Promocode?", for: .normal)
            self.promoCodeBtnBGView.isHidden = true
            cancelAction = true
        }))
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.default,
                                      handler: {(_: UIAlertAction!) in
                         self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func paymentBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        vc.delegate = self
        membership = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        cancelAction = true
        promoCodeBtn.setTitle("Have Promocode?", for: .normal)
        promoCodeBtnBGView.isHidden = true
        appDelegate.orderDataDict[OrderDataEnum.Promocode.rawValue] = [:]
    }
    
    @IBAction func promoCodeBtn(_ sender: UIButton) {
        
        showPopover(base: sender, size: CGSize(width: 300, height: 170))

    }
    func showPopover(base: UIView, size: CGSize) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PromoCodeVC") as! PromoCodeVC
        
            viewController.delegate = self
            viewController.modalPresentationStyle = .popover
            viewController.preferredContentSize = size
            
            if let pctrl = viewController.popoverPresentationController {
                pctrl.delegate = self
                pctrl.sourceView = base
                pctrl.sourceRect = base.bounds
                
                self.present(viewController, animated: true, completion: nil)
            }
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    
    func sendCardData(cardData: [String : Any]) {
        print(cardData)
        imageView.isHidden = true
        paymentBtn.setTitle("", for: .normal)
        paymentBtnBGView.isHidden = false
        
//        if cardData["CardName"] as? String == "Visa" {
//            selectedImg.image = #imageLiteral(resourceName: "Visa")
//        }else if cardData["CardName"] as? String == "Visa"{
//            selectedImg.image = #imageLiteral(resourceName: "AmericanExpress")
//        }else if cardData["CardName"] as? String == "Visa"{
//            selectedImg.image = #imageLiteral(resourceName: "Master")
//        }else if cardData["CardName"] as? String == "Visa"{
//            selectedImg.image = #imageLiteral(resourceName: "DiscoverCard")
//        }
        
        let cardBrand = STPCardValidator.brand(forNumber: cardData["CardNumber"] as? String ?? "")
        let cardImage = STPImageLibrary.brandImage(for: cardBrand)
        selectedImg.image = cardImage
        
        selectedCardNumberLbl.text = "...\(cardData["CardLastFourDigits"]!)"
        
    }
    func sendPromoData(cardData: [String : Any]) {
        print(cardData)
        if cardData["PromoCode"] != nil{
            promoCodeBtn.setTitle("", for: .normal)
            promoCodeBtnBGView.isHidden = false
            promoCodeLbl.text = String(describing: cardData["PromoCode"]!)
            discountAmountLbl.text = currencyFormat(String(describing: cardData["DiscountAmount"]!))
            cancelAction = true
        }
        
    }
    
    
    //MARK:- Navigation setup
    func navigation (){
        
        confirmBtn.dropShadow(view: confirmBtn, opacity: 0.3)
        
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationItem.title = "ORDER REVIEW"
        if urgentOrder == 1{
         name.append("On-demand service fee")
        }
        if firstTimeOrder == 0{
            if refCode != "" {
                promoCodeBtn.setTitle("", for: .normal)
                promoCodeBtnBGView.isHidden = false
                promoCodeLbl.text = refCode
                discountAmountLbl.text = currencyFormat("10")
                var discount: [String:Any] = [:]
                discount[PromoCodeEnum.DiscountAmount.rawValue] = 10
                discount[PromoCodeEnum.PromoCode.rawValue] = refCode
                discount[PromoCodeEnum.DeactivePromo.rawValue] = 1
                appDelegate.orderDataDict[OrderDataEnum.Promocode.rawValue] = discount
            }
        }
    }
    //MARK:- Map setup for perticular location
    func selectedLocation()  {
        
        let mapLat = Double(userLocation["Maplat"] ?? "")
        let mapLong = Double(userLocation["MapLong"] ?? "")
        let getname = userLocation["SelectedAddress"]
        
        let camera = GMSCameraPosition.camera(withLatitude: mapLat!, longitude: mapLong!, zoom: 17.0)
        myView.animate(to: camera)
        
//        let MapView = GMSMapView.map(withFrame: .init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.mapView.bounds.size.height + 35), camera: camera)
//        view.addSubview(MapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.icon = self.imageWithImage(image: UIImage(named: "Location-icon")!, scaledToSize: CGSize(width: 35.0, height: 35.0))
        marker.position = CLLocationCoordinate2D(latitude: mapLat ?? 0.0, longitude: mapLong ?? 0.0)
        marker.title = getname
        marker.map = myView
        
    }
    
    func imageWithImage(image: UIImage,scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
//MARK:- Creating Table View
extension OrderReviewVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "OrderReviewSecCell") as! OrderReviewSecCell
        
        if schedule["SelectedTime"] == nil{
            headerView.ORTitleLabel.text = headerTitle[section]
        }else {
            headerView.ORTitleLabel.text = headerTitles[section]
        }
        if headerView.ORTitleLabel.text == "Convenient Service"{
            headerView.btn.setTitle("+Add More", for: .normal)
            headerView.btn.setTitleColor(#colorLiteral(red: 0, green: 0.6078431373, blue: 1, alpha: 1), for: .normal)
            headerView.btn.addTarget(self, action: #selector(backTwo), for: .touchUpInside)
        }
        headerView.backgroundColor = UIColor.white
        return headerView
    }
//    @objc func addMoreBtnAction(_ sender: Any?){
//        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "ConvenientServicesVC") as! ConvenientServicesVC
//        vc.value = true            
//        let nav  = UINavigationController.init(rootViewController: vc)
//        //self.navigationController?.pushViewController(vc, animated: true)
//        self.navigationController?.present(nav, animated: true, completion: nil)
//
//    }
    @objc func backTwo() {
        popTwoBack = true
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if schedule["SelectedTime"] == nil{
            
            return 3
        }else {
             return 4
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            
            return 1
        }else if section == 1 {
            
            return name.count
        }else if section == 2 {
            
            return 1
        }else{
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderReviewCell", for: indexPath) as! OrderReviewCell
        
        if indexPath.section == 0{
            
            cell.img.image = #imageLiteral(resourceName: "location pin")
            cell.serviceNameLbl.text = userLocation["SelectedAddress"]
            
        }else if indexPath.section == 1{
            
            cell.serviceNameLbl.text = name[indexPath.row]
            if cell.serviceNameLbl.text == "Fuel my Vehicle"
            {
                cell.img.image = #imageLiteral(resourceName: "fuel-type")
                cell.serviceNameLbl.text = fuelDetails["Fuel"]
                cell.serviceTypeLbl.text = currencyFormat(fuelDetails["Price"]) + "/L"
                cell.priceLbl.text = currencyFormat(fuelDetails["Price"])
                //cell.serviceTypeLbl.text = "$" + String(describing: fuelDetails["Price"]!) + ".00"
                
                if fuelAmount["FillIt"] == "1"{
                    if defaultValues.integer(forKey: "AccountType") == 0{
                        cell.priceLbl.text = "Fill it"
                        cell.preAuthorizedLbl.text = "(Pre-authorized $100)  "
                    }else{
                        cell.priceLbl.text = "Fill"
                        cell.preAuthorizedLbl.text = "(Pre-authorized $100)  "
                    }
                    
                }else if fuelAmount["AmountButton"] == "0"{
                    
                    //cell.priceLbl.text =  "$" + String(describing: fuelAmount["Amount"]!) + ".00"
                    cell.priceLbl.text = currencyFormat(fuelAmount["Amount"])
                }else if fuelAmount["AmountButton"] == "1"{
                    
                    cell.priceLbl.text = String(describing:fuelAmount["Quantity"]!) + "L"
                }

            }
            if cell.serviceNameLbl.text == "Fill my Tires"{
                cell.img.image = #imageLiteral(resourceName: "services-c")
                if let tirePressure = FillMyTiresDetails["PressureType"], tirePressure != ""{
                    cell.serviceTypeLbl.text = tirePressure
                }else{
                    cell.serviceTypeLbl.text = FillMyTiresDetails["Quantity"]! + "PSI"
                }
                
                cell.priceLbl.text = currencyFormat(FillMyTiresDetails["Price"]) //FillMyTiresDetails["Price"]

            }
            if cell.serviceNameLbl.text == "Top up my Oil"{
                cell.img.image = #imageLiteral(resourceName: "services-c")
                cell.serviceTypeLbl.text = oilDetails["Oil"]
                
                let oilPrice = oilDetails["Price"]
                 let totalOilPrice = Int(truncating: numberFormat(oilPrice)) * Int(truncating: numberFormat(oilDetails["Quantity"]))
                
                cell.priceLbl.text = "x" + String(describing: oilDetails["Quantity"]!) + " " + currencyFormat(String(describing: totalOilPrice))
                
               //cell.priceLbl.text = "x" + String(describing: oilDetails["Quantity"]!) + " " + currencyFormat(oilDetails["Price"])

            }
            if cell.serviceNameLbl.text == "Plow my Driveway"{
                cell.img.image = #imageLiteral(resourceName: "services-c")
                cell.serviceTypeLbl.text = PlowMyDrivewayDetails["PlowMyDrivewayName"]
                //cell.priceLbl.text = "$" + String(describing: PlowMyDrivewayDetails["Price"]!) + ".00"
                cell.priceLbl.text = currencyFormat(PlowMyDrivewayDetails["Price"])

            }
            if cell.serviceNameLbl.text == "Windshield Wash"{
                cell.img.image = #imageLiteral(resourceName: "services-c")
                cell.serviceTypeLbl.text = WindShieldWasherFluidDetails["PlowMyDrivewayName"]
                //cell.priceLbl.text = "$" + String(describing: WindShieldWasherFluidDetails["Price"]!) + ".00"
                cell.priceLbl.text = currencyFormat(WindShieldWasherFluidDetails["Price"])
            }
            if cell.serviceNameLbl.text == "On-demand service fee"{
                cell.img.image = #imageLiteral(resourceName: "services-c")
                cell.priceLbl.text = "Free"//currencyFormat(String(describing: onDemandPrice))
            }
            
            
            
        }
 /*       else if indexPath.section == 2{
            
            cell.img.image = #imageLiteral(resourceName: "fuel-type")
            cell.serviceNameLbl.text = fuelDetails["Fuel"]
            cell.serviceTypeLbl.text = "$" + String(describing: fuelDetails["Price"]!)
            
            if fuelAmount["FillIt"] == "1"{
                
                cell.priceLbl.text = "Fill it"
            }else if fuelAmount["AmountButton"] == "0"{
                
                cell.priceLbl.text =  "$" + String(describing: fuelAmount["Amount"]!)
            }else if fuelAmount["AmountButton"] == "1"{
                
                cell.priceLbl.text = String(describing:fuelAmount["Amount"]!) + "L"
            }
            
            
        } */
        else if indexPath.section == 2 {
            if schedule["SelectedTime"] != nil {
                
                cell.img.image = #imageLiteral(resourceName: "clock")
                
              //  if schedule.count > indexPath.row{
                    cell.serviceNameLbl.text = schedule["SelectedDate"] as? String
                    cell.serviceTypeLbl.text = schedule["SelectedTime"] as? String
                
            } else {
                cell.img.image = #imageLiteral(resourceName: "car")
                if defaultValues.integer(forKey: "AccountType") == 0 {
                    cell.serviceTypeLbl.isHidden = true
                    cell.priceLbl.isHidden = true
                    cell.serviceNameLbl.text = "\(vehicle["Year"]!) \(vehicle["Model"]!), \(vehicle["Color"]!) \(vehicle["LicensePlate"]!)" // \(vehicle["Make"]!) 
                }else{
                    cell.serviceTypeLbl.isHidden = true
                    cell.priceLbl.isHidden = true
                    cell.serviceNameLbl.text = vehicle["vehiclesCount"]
                }
                
            }
           
        }else if indexPath.section == 3{
            
            cell.img.image = #imageLiteral(resourceName: "car")
            if defaultValues.integer(forKey: "AccountType") == 0 {
                
                cell.serviceTypeLbl.isHidden = true
                cell.priceLbl.isHidden = true
                cell.serviceNameLbl.text = "\(vehicle["Year"]!) \(vehicle["Model"]!), \(vehicle["Color"]!) \(vehicle["LicensePlate"]!)" // \(vehicle["Make"]!)
            }else{
                
                cell.serviceTypeLbl.isHidden = true
                cell.priceLbl.isHidden = true
                cell.serviceNameLbl.text = vehicle["vehiclesCount"]
            }
        }
       // cell.img.image = imgArr[indexPath.section][indexPath.row]
        return cell
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = footerView
//        return view
//    }
}

