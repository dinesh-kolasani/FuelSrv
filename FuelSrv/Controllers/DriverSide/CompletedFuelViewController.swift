//
//  CompletedFuelViewController.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 09/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit
import ObjectMapper


class CompletedFuelViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var errorLbl: UILabel!
    var AllCompletedOrdersModelData: AllCompletedOrdersModel!
    var CompletedFuelingData: [DriverOrder]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousfilllingsDriversAPI()

        let nib = UINib.init(nibName: "CompletedFuelingsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CompletedFuelingsCell")
        self.tableView.estimatedRowHeight = 137.5
        self.tableView.rowHeight = UITableViewAutomaticDimension
         tableView.tableFooterView = UIView()
    }
    @IBAction func completedSidebtn(_ sender: UIButton) {
        showMenu()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        setRoot()
    }
    //MARK:- Previous Filllings Drivers API
    func previousfilllingsDriversAPI(){
        let params = ["driverId": defaultValues.string(forKey: "UserID")!]

        WebService.shared.apiDataPostMethod(url: previousfilllingsDriversURL, parameters: params) { (response, error) in
            if error == nil {
                self.AllCompletedOrdersModelData = Mapper<AllCompletedOrdersModel>().map(JSONObject: response)

                if self.AllCompletedOrdersModelData.success == true {
                    if let data = self.AllCompletedOrdersModelData.orders
                    {
                        self.CompletedFuelingData = data

                        self.tableView.reloadData()
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
//MARK:- Creating tableview
extension CompletedFuelViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 180
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = CompletedFuelingData, data.count != 0{
            errorLbl.isHidden = true
            return CompletedFuelingData?.count ?? 0
        }else{
            errorLbl.isHidden = false
            errorLbl.text = "No Completed fueling found."
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedFuelingsCell") as! CompletedFuelingsCell
        if let completedOrders = CompletedFuelingData, completedOrders.count > indexPath.row {
           
            cell.nameLbl.text = completedOrders[indexPath.row].orderId?.userId?.name
            cell.addressLbl.text = completedOrders[indexPath.row].orderId?.address
            
            if let fuelName = completedOrders[indexPath.row].orderId?.fuelType {
                if fuelName == 0 {
        
                    if let amount = completedOrders[indexPath.row].orderId?.fuelAmount, amount != 0 {
                        
                        cell.fuelTypeLbl.text = "Gasoline" + ", " + currencyFormat(String(describing: (completedOrders[indexPath.row].orderId?.fuelAmount)!))
                    }else{
                        cell.fuelTypeLbl.text = "Gasoline, Fill it"
                    }
                }
                else if fuelName == 1 {
                    
                    if let amount = completedOrders[indexPath.row].orderId?.fuelAmount, amount != 0 {
                        
                        cell.fuelTypeLbl.text = "Premium Gasoline" + ", " + currencyFormat(String(describing: (completedOrders[indexPath.row].orderId?.fuelAmount)!))
                    }else{
                        cell.fuelTypeLbl.text = "Premium Gasoline, Fill it"
                    }
                }
                else if fuelName == 2 {
                    
                    if let amount = completedOrders[indexPath.row].orderId?.fuelAmount, amount != 0 {
                        
                        cell.fuelTypeLbl.text = "Diesel" + ", " + currencyFormat(String(describing: (completedOrders[indexPath.row].orderId?.fuelAmount)!))
                    }else{
                        cell.fuelTypeLbl.text = "Diesel, Fill it"
                    }
                }
            }
            if let services = completedOrders[indexPath.row].orderId?.serviceId, services.isEmpty == false{
                let serviceStr = services.map{($0.serviceName!)}
                cell.additionalServicesLbl.text = serviceStr.joined(separator: ", ")
            }
            if let deleverDate = completedOrders[indexPath.row].updatedAt, deleverDate != "" {
                
                //mark:- converting longdate into Date format
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "EEE, MMM dd, yyyy"
                let datee = dateFormatterGet.date(from: deleverDate)
                let dateObj =  dateFormatterPrint.string(from: datee ?? Date())
                cell.completedLbl.text = dateObj
                
            }else{
                cell.completedLbl.text = "FurlSrv"
            }
            
        }
        
        return cell
    }
}
