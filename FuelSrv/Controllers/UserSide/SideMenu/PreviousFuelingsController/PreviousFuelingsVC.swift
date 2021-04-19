//
//  PreviousFuelingsVC.swift
//  FuelSrv
//
//  Created by PBS9 on 06/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper

class PreviousFuelingsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLbl: UILabel!
    
    var AllPreviousOrdersModelData: AllPreviousOrdersModel!
    var CompletedOrderData: [CompletedOrder]?
    var driName: String?
    var driAvatar: String?
    var started: String?
    var fuelings: Int?
    var bioGraphy: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationRightItem()
        allcompletedOrdersAPI()
        
        let nib = UINib.init(nibName: "PreviousFuelingsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PreviousFuelingsCell")
        self.tableView.estimatedRowHeight = 149.5
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func navigationRightItem(){
        
        self.navigationItem.title = "PREVIOUS FUELINGS"
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
    
    //MARK:- All Pending Orders API
    func allcompletedOrdersAPI(){
        
        let params:[String:Any] = [
            "userId":defaultValues.string(forKey: "UserID")!,
            "skip":"",
            "limit":""
        ]
        
        WebService.shared.apiDataPostMethod(url: allcompletedOrdersURL, parameters: params) { (responce, error) in
            if error == nil{
                self.AllPreviousOrdersModelData = Mapper<AllPreviousOrdersModel>().map(JSONObject: responce)
                if self.AllPreviousOrdersModelData.success == true {
                    
                    if let data = self.AllPreviousOrdersModelData?.completedOrders
                    {
                        self.CompletedOrderData = data
                        
                        self.tableView.reloadData()
                        
                        
                    }else{
                        Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                    }
                    
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                    
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
extension PreviousFuelingsVC: UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       //return 200
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let data = CompletedOrderData, data.count > 0{
            errorLbl.isHidden = true
            return CompletedOrderData?.count ?? 0
        }else{
            errorLbl.isHidden = false
            errorLbl.text = "No Previous Orders"
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousFuelingsCell", for: indexPath) as! PreviousFuelingsCell
        if let data = CompletedOrderData, data.count > indexPath.row{
            cell.addressLbl.text = data[indexPath.row].userId.name
            cell.subAddressLbl.text = data[indexPath.row].address
            
            if let fuelname = data[indexPath.row].fuelType {
                
                if fuelname == 0 {
                    if let amount = data[indexPath.row].fuelAmount, amount != 0 {
                        
                        cell.fuelTypeLbl.text = "Gasoline" + "," + currencyFormat(String(describing: data[indexPath.row].fuelAmount!))
                    }else{
                        cell.fuelTypeLbl.text = "Gasoline, Fill it"
                    }
                    
                }else if fuelname == 1 {
                    if let amount = data[indexPath.row].fuelAmount, amount != 0 {
                        
                        cell.fuelTypeLbl.text = "Premium Gasoline" + "," + currencyFormat(String(describing: data[indexPath.row].fuelAmount!))
                        
                    }else{
                        cell.fuelTypeLbl.text = "Premium Gasoline, Fill it"
                    }
            
                }else if fuelname == 2{
                    if let amount = data[indexPath.row].fuelAmount, amount != 0 {
                        
                        cell.fuelTypeLbl.text = "Diesel" + "," + currencyFormat(String(describing: data[indexPath.row].fuelAmount!))
                    }else{
                        cell.fuelTypeLbl.text = "Diesel, Fill it"
                    }
                    
                }
            }
            
            if let services = data[indexPath.row].serviceId, services.isEmpty == false{
                
                let serviceStr = services.map{($0.serviceName!)}
                cell.additionalServicesLbl.text = serviceStr.joined(separator: ", ") //serviceStr.reduce("", + )
            }else{
                cell.additionalServicesLbl.text = "FuelSrv"
            }
            
            
            if let deleverDate = data[indexPath.row].updatedAt, deleverDate != "" {
                
                //mark:- converting longdate into Date format
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "EEE, MMM dd, yyyy"
                let datee = dateFormatterGet.date(from: deleverDate)
                let dateObj =  dateFormatterPrint.string(from: datee ?? Date())
                cell.completedTimeLbl.text = dateObj
            
            }else{
                cell.completedTimeLbl.text = "FurlSrv"
            }
            if let driverName = data[indexPath.row].driverId{
               
                let name = driverName.name
                cell.driverNameLbl.setTitle(name, for: .normal)
                cell.driverNameLbl.setTitleColor(#colorLiteral(red: 0.1960784314, green: 0.2235294118, blue: 0.2509803922, alpha: 1), for: .normal)
                cell.driverNameLbl.underline()
                
            }
            cell.driverNameLbl.tag = indexPath.row
            cell.driverNameLbl.addTarget(self, action: #selector(addSomething(button:)), for: .touchUpInside)
        }
        return cell
    }
    @objc func addSomething(button: UIButton) {
    
        if let data = CompletedOrderData, data.count > button.tag {
            let driverModel = data[button.tag]
            
            driName = driverModel.driverId?.name
            driAvatar = driverModel.driverId?.avatar
            fuelings = driverModel.driverId?.totalFuelings
            bioGraphy = driverModel.driverId?.bio
            started = driverModel.driverId?.createdAt
            let vc = storyboard?.instantiateViewController(withIdentifier: "DriverProfileVC") as! DriverProfileVC
            vc.profileName = driName
            vc.profileStarted = started
            vc.noOfFuelings = fuelings
            vc.biographie = bioGraphy
            vc.profileImg = driAvatar
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
