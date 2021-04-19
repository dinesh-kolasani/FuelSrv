//
//  HelpVC.swift
//  FuelSrv
//
//  Created by PBS9 on 06/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMaps
import GooglePlaces

class HelpVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastFuelingMap: NSLayoutConstraint!
    @IBOutlet weak var mapView: MapView!
    
    @IBOutlet weak var lastFuelingLbl: UILabel!
    @IBOutlet weak var lastFuelingHeight: NSLayoutConstraint!
    var LastOrderDetailModelData: LastOrderDetailModel!
    var LastOrderData: LastOrder?
    
    var images = [#imageLiteral(resourceName: "help"),#imageLiteral(resourceName: "payment"),#imageLiteral(resourceName: "fuel-type")]
    var names = ["Report an Issue","Account and Payments","User's Guide to FuelSrv"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastOrderDetailAPI()
        navigationRightItem()
        tableView.tableFooterView = UIView()
    }
    func navigationRightItem(){
        self.navigationItem.title = "HELP"
        
//        let imgMenu = UIImage(named: "menu-button")
//        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: imgMenu, style: .plain, target: self, action: #selector(Action))
        
       let imgBack = UIImage(named: "back")
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(backAction))
    }
    @objc func Action(){
        
        showMenu()
    }
    @objc func backAction(){
        
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
    }
    
    //MARK:- Last Order Detail API
    func lastOrderDetailAPI(){
        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        
        WebService.shared.apiDataPostMethod(url: lastOrderDetailURL, parameters: params) { (responce, error) in
        
            if error == nil {
                self.LastOrderDetailModelData = Mapper<LastOrderDetailModel>().map(JSONObject: responce)
                
                if self.LastOrderDetailModelData.success == true {
                    if firstTimeOrder == 1 {
                        if let home = self.LastOrderDetailModelData?.lastOrder
                        {
                            self.LastOrderData = home
                            if self.LastOrderData?.userLong == nil  {
                                self.lastFuelingMap.constant = 0
                                self.lastFuelingLbl.text = ""
                            }
                            self.selectedLocation()
                        }else{
                            self.lastFuelingMap.constant = 0
                            self.lastFuelingLbl.text = ""
                        }
                    }else{
                        self.lastFuelingMap.constant = 0
                        self.lastFuelingLbl.text = ""
                    }
                }else{
                    Helper.Alertmessage(title: "Info:", message: self.LastOrderDetailModelData.message ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
        
    }
    
    //MARK:- Map setup for perticular location
    
    func selectedLocation()  {
        
        let mapLat = Double(LastOrderData?.userLat ?? 0.0)
        let mapLong = Double(LastOrderData?.userLong ?? 0.0)
        let getname = LastOrderData?.address
        
        let camera = GMSCameraPosition.camera(withLatitude: mapLat , longitude: mapLong , zoom: 17.0)
        mapView.animate(to: camera)
        
        let marker = GMSMarker()
        marker.icon = self.imageWithImage(image: UIImage(named: "Location-icon")!, scaledToSize: CGSize(width: 35.0, height: 35.0))
        marker.position = CLLocationCoordinate2D(latitude: mapLat , longitude: mapLong )
        marker.title = getname
        marker.map = mapView
        
    }
    func imageWithImage(image: UIImage,scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}
extension HelpVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpVCCell") as! HelpVCCell
        cell.cellLbl.text = names[indexPath.row]
        cell.cellImg.image = images[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "AccountAndPaymentsVC") as! AccountAndPaymentsVC
            vc.vcCount = 1
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
        case 1:
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "AccountAndPaymentsVC") as! AccountAndPaymentsVC
            vc.vcCount = 2
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
            
        case 2:
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
            vc.vcCount = 2
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
        
        default:
            break
        }
    }
}
