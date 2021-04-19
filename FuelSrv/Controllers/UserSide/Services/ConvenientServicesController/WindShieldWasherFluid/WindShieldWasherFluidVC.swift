//
//  WindShieldWasherFluidVC.swift
//  FuelSrv
//
//  Created by PBS9 on 22/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps
import GooglePlaces

class WindShieldWasherFluidVC: UIViewController,CLLocationManagerDelegate{
    
    @IBOutlet var mapView: MapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var nextBtn: RoundButton!
    var userLocation = appDelegate.orderDataDict["UserLocation"] as? [String : String] ?? [:]
    var PlowMyDrivewayModelData: PlowMyDrivewayModel!
    var PlowmyDrivewayData: [PlowmyDriveway]!
    var WindShieldWasherFluidDetails: [String:Any] = [:]
    var tappedButtonsTag: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation()
        selectedLocation()
        let nib = UINib.init(nibName: "ServicesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ServicesCell")
        tableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    //MARK:- Navigation Setup
    
    func navigation(){
        nextBtn.dropShadow(view: nextBtn, opacity: 0.3)
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "WINDSHIELD WASHER FLUID"
        
        getWindshieldAPI()
        
    }
    
    //MARK:- Button Action
    @IBAction func nextBtnAction(_ sender: Any) {
      
        if tappedButtonsTag == nil{
            self.showAlert("Info:", "Please select windshield washer fluid option ", "OK")
        }else{
            let pressureModel = PlowmyDrivewayData[tappedButtonsTag]
            WindShieldWasherFluidDetails[WindShieldWasherFluidEnum.PlowMyDrivewayName.rawValue] = pressureModel.name ?? ""
            WindShieldWasherFluidDetails[WindShieldWasherFluidEnum.Price.rawValue] = String(describing: pressureModel.price ?? 0)
            appDelegate.orderDataDict[OrderDataEnum.WindShieldWasherFluid.rawValue] = WindShieldWasherFluidDetails
            self.navigationController?.popViewController(animated: true)
        }
    }
    //MARK:- Get Wind shield API
    func getWindshieldAPI(){
        let params:[String:Any] = ["accounttype": defaultValues.integer(forKey: "AccountType")]
        WebService.shared.apiGet(url: getWindshieldURL, parameters: params) { (responce, error) in
            if error == nil {
                self.PlowMyDrivewayModelData = Mapper<PlowMyDrivewayModel>().map(JSONObject: responce)
                
                if self.PlowMyDrivewayModelData.success == true {
                    if let home = self.PlowMyDrivewayModelData?.plowmyDriveway
                    {
                        self.PlowmyDrivewayData = home
                        self.tableViewHeight.constant = CGFloat( home.count * 60 )
                        self.tableView.reloadData()
                        
                        if home.count == 1{
                            self.tappedButtonsTag = 0
                        }
                        
                    }
                    
                }else {
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
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
}

//MARK:- Table View

extension WindShieldWasherFluidVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 51.5//48.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if PlowmyDrivewayData != nil{
            return PlowmyDrivewayData?.count ?? 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
        
        if let data = PlowmyDrivewayData, data.count > indexPath.row{

            
            cell.cellLabel.text = data[indexPath.row].name
            cell.cellPriceLabel.text = currencyFormat(String(describing: data[indexPath.row].price!))
            
            
            cell.cellBtn.tag = indexPath.row
        
            // here is the check:
            if let row =  tappedButtonsTag, row == indexPath.row {
                cell.cellBtn.isSelected = true
            } else {
                
                cell.cellBtn.addTarget(self, action: #selector(addSomething(button:)), for: .touchUpInside)
                cell.cellBtn.isSelected = false
            }
        }
        
        return cell
    }
    @objc func addSomething(button: UIButton) {
        tappedButtonsTag = button.tag
        
//        if (PlowmyDrivewayData.count > button.tag)
//        {
//            let pressureModel = PlowmyDrivewayData[button.tag]
//            WindShieldWasherFluidDetails[WindShieldWasherFluidEnum.PlowMyDrivewayName.rawValue] = pressureModel.name ?? ""
//            WindShieldWasherFluidDetails[WindShieldWasherFluidEnum.Price.rawValue] = String(describing: pressureModel.price ?? 0)
//            appDelegate.orderDataDict[OrderDataEnum.WindShieldWasherFluid.rawValue] = WindShieldWasherFluidDetails
//            
//        }
        tableView.reloadData()
    }
}
enum WindShieldWasherFluidEnum:String {
    case PlowMyDrivewayName
    case Price
}

