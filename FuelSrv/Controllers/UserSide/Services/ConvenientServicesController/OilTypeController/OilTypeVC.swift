//
//  OilTypeVC.swift
//  FuelSrv
//
//  Created by PBS9 on 11/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import SkyFloatingLabelTextField
import GoogleMaps
import GooglePlaces

class OilTypeVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MapView!
    
    @IBOutlet weak var nextBtn: RoundButton!
    @IBOutlet weak var quantity: SkyFloatingLabelTextField!
    var oilDetails: [String:Any] = [:]
    var OilTypeModelData: OilTypeModel!
    var OilData: [Oil]!
    var tappedButtonsTag :Int!
    let tableViewMaxHeight: CGFloat = 200
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var userLocation = appDelegate.orderDataDict["UserLocation"] as? [String : String] ?? [:]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        getOilTypeAPI()
        
        selectedLocation()
        quantity.text = "1"
        quantity.titleFormatter = { $0 }
        let nib = UINib.init(nibName: "ServicesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ServicesCell")
        tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    
    
    @IBAction func nextBtn(_ sender: UIButton) {
        if tappedButtonsTag == nil{
            self.showAlert("Info:", "Please select Oil type", "OK")
        }else if (Helper.shared.isFieldEmpty(field: quantity.text!) || quantity.text == "0") {
             self.showAlert("Info:", "Please specify oil quantity", "OK")
        }
        else{
            oilDetails[OilTypeEnum.Quantity.rawValue] = quantity.text!
            appDelegate.orderDataDict[OrderDataEnum.Oil.rawValue] = oilDetails

                let oilModel = OilData[tappedButtonsTag]
                oilDetails[OilTypeEnum.Oil.rawValue] = oilModel.name ?? ""
                oilDetails[OilTypeEnum.Price.rawValue] = String(describing: oilModel.price ?? 0)
                
                appDelegate.orderDataDict[OrderDataEnum.Oil.rawValue] = oilDetails
                print(appDelegate.orderDataDict)

            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func navigationBar(){
        nextBtn.dropShadow(view: nextBtn, opacity: 0.3)
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationItem.title = "OIL TYPE"
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
    
    //MARK:- Dynamically change UITextView height
    //    let textViewMaxHeight: CGFloat = 400
//        func textViewDidChangeSelection(_ textView: UITextView) {
//            if textView.contentSize.height >= self.textViewMaxHeight {
//                textView.isScrollEnabled = true
//
//            }else{
//                textView.frame.size.height = textView.contentSize.height
//                textView.isScrollEnabled = false
//            }
//        }
    func imageWithImage(image: UIImage,scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    //MARK:- Oil API
    func getOilTypeAPI(){
        let params:[String:Any] = ["accounttype": defaultValues.integer(forKey: "AccountType")]
        WebService.shared.apiGet(url: getOilURL, parameters: params) { (responce, error) in
            if error == nil {
                self.OilTypeModelData = Mapper<OilTypeModel>().map(JSONObject: responce)
                
                if self.OilTypeModelData.success == true {
                    if let home = self.OilTypeModelData?.oil
                    {
                        self.OilData = home
                        //self.tableViewHeight.constant = CGFloat( home.count * 48 ) + 40
                        let tableHeight = CGFloat( home.count * 48 ) + 40
                        
                        if tableHeight >= self.tableViewMaxHeight {
                            self.tableView.isScrollEnabled = true
                            
                        }else{
                            self.tableViewHeight.constant = CGFloat( home.count * 48 ) + 40
                            self.tableView.isScrollEnabled = false
                        }
                        
                        self.tableView.reloadData()
                        self.tappedButtonsTag = 0
                        
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
extension OilTypeVC: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 51.5//48.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (OilData != nil){
            return OilData.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesCell", for: indexPath) as!ServicesCell
        
        if let data = OilData, data.count > indexPath.row{
            cell.cellLabel.text = data[indexPath.row].name
            let price = data[indexPath.row].price
            cell.cellPriceLabel.text = currencyFormat(String(describing: price!)) + "/L" //"$" + "\(String(describing: price!))" + ".00/L"
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
//        if (OilData.count > button.tag)
//        {
//            let oilModel = OilData[button.tag]
//            oilDetails[OilTypeEnum.Oil.rawValue] = oilModel.name ?? ""
//            oilDetails[OilTypeEnum.Price.rawValue] = String(describing: oilModel.price ?? 0)
//
//            appDelegate.orderDataDict[OrderDataEnum.Oil.rawValue] = oilDetails
//            print(appDelegate.orderDataDict)
//        }
        tableView.reloadData()
    }
    
    
}
enum OilTypeEnum:String {
    case Oil
    case Price
    case Quantity
}

