//
//  AddressesVC.swift
//  FuelSrv
//
//  Created by PBS9 on 24/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps
import GooglePlaces


class AddressesVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addAddressBtn: RoundButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    var GetAllLocationsModelData: GetAllLocationsModel!
    var LocationData: [Location]?
    var orderNum: String?
    
    var userAddress = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationRightItem()
        getallLocationsAPI()
        let nib = UINib.init(nibName: "AddressesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AddressesCell")
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVc), name:.reloadVc, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func reloadVc()
    {
        getallLocationsAPI()
    }

    @IBAction func addAddressBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishRegVC") as! FinishRegVC
        vc.value = 2
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    func navigationRightItem(){
       
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "ADDRESSES"

        let imgBack = UIImage(named: "back")
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(backAction))
    }
    
    @objc func backAction(){
        
       
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
        //self.navigationController?.popToViewController(vc, animated: true)
    }
    //MARK:- Menu Dots Action
    @objc func memuDotsBtnAction(sender: UIButton) {
        let alert = UIAlertController(title: "Info:", message: "Choose your actions", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            print("You've pressed Cancel")
        }))
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            print("You've pressed Edit")
            if (self.LocationData!.count > sender.tag){
                let locationModel = self.LocationData![sender.tag]
                //self.vehicleId = scheduleModel.id
                self.userAddress[LocationEnum.AddressTitle.rawValue] = locationModel.addressTitle
                self.userAddress[LocationEnum.AddressId.rawValue] = locationModel.id
                self.userAddress[LocationEnum.Maplat.rawValue] = locationModel.userLat
                self.userAddress[LocationEnum.MapLong.rawValue] = locationModel.userLong
                self.userAddress[LocationEnum.SelectedAddress.rawValue] = locationModel.userAddress
                appDelegate.orderDataDict[OrderDataEnum.UserLocation.rawValue] = self.userAddress
                
            }
        
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishRegVC") as! FinishRegVC
            print(self.userAddress)
            vc.value = 3
            self.navigationController?.present(vc, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            
            if (self.LocationData!.count > sender.tag){
                let scheduleModel = self.LocationData![sender.tag]
                self.orderNum = scheduleModel.id
            }
            
            self.deleteAddressAPI(locationId: self.orderNum ?? "")
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- Get All Locations API
    func getallLocationsAPI(){
        let parameters: [String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        
        WebService.shared.apiDataPostMethod(url: getallLocationsURL, parameters: parameters) { (responce, error) in
            if error == nil {
               self.GetAllLocationsModelData = Mapper<GetAllLocationsModel>().map(JSONObject: responce)
                if self.GetAllLocationsModelData.success == true {
                    if let data = self.GetAllLocationsModelData.location{
                        self.LocationData = data
                        self.tableView.reloadData()
                    }
                    
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    func deleteAddressAPI(locationId: String){
        let parameters: [String:Any] = ["locationId": locationId]
        WebService.shared.apiDataPostMethod(url: deleteAddressURL, parameters: parameters) { (responce, error) in
            if error == nil {
                if let dict = responce {
                    Helper.Alertmessage(title: "Info:", message: dict["message"] as! String, vc: self)
                    self.getallLocationsAPI()
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
extension AddressesVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = LocationData, data.count > 0{
            errorLbl.isHidden = true
            return LocationData?.count ?? 0
        }else{
            errorLbl.isHidden = false
            errorLbl.text = "No Addresses found"
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressesCell", for: indexPath) as! AddressesCell
        if let data = LocationData, data.count > indexPath.row{
            cell.addressTitleLbl.text = data[indexPath.row].addressTitle
            cell.addressLbl.text = data[indexPath.row].userAddress
            cell.cellMenuBtn.tag = indexPath.row
            cell.cellMenuBtn.addTarget(self, action: #selector(memuDotsBtnAction), for: .touchUpInside)
            DispatchQueue.main.async {
                var lat:Double = 0.00
                var long:Double = 0.00
                if let val = data[indexPath.row].userLat , let lati = Double(val){
                    lat = lati
                }
                if let val = data[indexPath.row].userLong , let langi = Double(val){
                    long = langi
                }
                cell.selectedLocation(lat: lat, long: long)
                cell.mapView.isUserInteractionEnabled = false
            }
         }
        return cell
    }
}
