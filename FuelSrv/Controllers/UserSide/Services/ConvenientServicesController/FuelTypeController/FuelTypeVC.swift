//
//  FuelTypeVC.swift
//  FuelSrv
//
//  Created by PBS9 on 11/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps
import GooglePlaces

class FuelTypeVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet var mapView: MapView!
    
    @IBOutlet weak var nextBtn: RoundButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var userLocation = appDelegate.orderDataDict["UserLocation"] as? [String : String] ?? [:]
    var fuelDetails: [String:Any] = [:]
    var FuelTypeModelData: FuelTypeModel!
    var FuelData: [Fuel]!
    var tappedButtonsTag: Int!
    
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar()
        selectedLocation()
        fuelTypeAPI()
        
        let nib = UINib.init(nibName: "ServicesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ServicesCell")
        tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    //MARK:- Button Action
    
    @IBAction func nextBtn(_ sender: Any) {
        
        if tappedButtonsTag == nil{
            self.showAlert("Info:", "Please select Fuel type", "OK")
        }else{
            self.navigationController?.popViewController(animated: true)
        }
//        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ConvenientServicesVC") as! ConvenientServicesVC
//        self.navigationController?.pushViewController(vc, animated: true)
       // backTwo()
        
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    //MARK:- Navigation Bar Setup
    func navigationBar(){
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "FUEL TYPE"
        nextBtn.dropShadow(view: nextBtn, opacity: 0.3)
    }

    //MARK:- Map setup for perticular location
    
    func selectedLocation()  {
        
        let mapLat = Double(userLocation["Maplat"] ?? "")
        let mapLong = Double(userLocation["MapLong"] ?? "")
        let getname = userLocation["SelectedAddress"]
        
        let camera = GMSCameraPosition.camera(withLatitude: mapLat!, longitude: mapLong!, zoom: 17.0)
        mapView.animate(to: camera)
        
//        let MapView = GMSMapView.map(withFrame: .init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.mapView.bounds.size.height + 35), camera: camera)
//        view.addSubview(MapView)
        
        
        // Creates a marker in the center of the map.
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
    
    //MARK:- FUEL API
    func fuelTypeAPI(){
        let params:[String:Any] = ["accounttype": defaultValues.integer(forKey: "AccountType")]
        WebService.shared.apiGet(url: fuelTypeURL, parameters: params) { (responce, error) in
            if error == nil {
                self.FuelTypeModelData = Mapper<FuelTypeModel>().map(JSONObject: responce)
                
                if self.FuelTypeModelData.success == true {
                    if let home = self.FuelTypeModelData?.fuel
                    {
                        self.FuelData = home
                        self.tableViewHeight.constant = CGFloat( home.count * 60 )
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
extension FuelTypeVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 51.5//48.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FuelData != nil{
            return FuelData?.count ?? 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
        if let data = FuelData, data.count > indexPath.row{
            cell.cellLabel.text = data[indexPath.row].fuelName
            let price = data[indexPath.row].fuelCost
            //cell.cellPriceLabel.text = "$" + "\(String(describing: price!))" + "/L"
            cell.cellPriceLabel.text = currencyFormat(String(describing: price!)) + "/L"
            cell.cellBtn.tag = indexPath.row
//            if (data.count == indexPath.last){
//                cell.cellBtn.isHidden = true
//            }else{
//                 cell.cellBtn.isHidden = false
//            }
            
            let totalRow = tableView.numberOfRows(inSection: indexPath.section)
            if(indexPath.row == totalRow - 1){
                cell.cellBtn.isHidden = true
            }
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
    @objc func addSomething(button: UIButton)
    {
        tappedButtonsTag = button.tag
        
        if (FuelData.count > button.tag)
        {
          let fuelModel = FuelData[button.tag]
            fuelDetails[FuelTypeEnum.Fuel.rawValue] = fuelModel.fuelName ?? ""
            fuelDetails[FuelTypeEnum.Price.rawValue] = String(describing: fuelModel.fuelCost!)
            fuelDetails[FuelTypeEnum.Fueltype.rawValue] = "\(fuelModel.fuelType ?? 0)"
            
            appDelegate.orderDataDict[OrderDataEnum.FuelType.rawValue] = fuelDetails
        }
        tableView.reloadData()
    }
}
enum FuelTypeEnum:String {
    case Fueltype
    case Fuel
    case Price
}
