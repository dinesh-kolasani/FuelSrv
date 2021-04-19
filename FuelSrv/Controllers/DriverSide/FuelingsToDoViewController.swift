//
//  FuelingsToDoViewController.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 09/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//
import UIKit
import ObjectMapper

class FuelingsToDoViewController: UIViewController{
    
    @IBOutlet weak var fuelingsToDoTV: UITableView!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var urgentButton: UIButton!
    @IBOutlet weak var scheduledBtn: UIButton!
    @IBOutlet weak var urgentLbl: UILabel!
    @IBOutlet weak var scheduledLbl: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    var DriverOrdersUrgentModelData: DriverOrdersUrgentModel!
    var DriverOrderData: [DriverOrder]!
    var DriverOrderIdData: DriverOrderId!
    var DriverVehicleIdData: DriverVehicleId!
    var DriverUserIdData: DriverUserId!
    var ServiceIdData: [ServiceId]?
    
    var orderDetails: [String:Any] = [:]
    var tappedButtonsTag: Int!
    var countNo = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        driverOrdersUrgentAPI(URL: driverOrdersUrgentURL)
        
        let nib = UINib.init(nibName: "FuelingsToDoCel", bundle: nil)
        fuelingsToDoTV.register(nib, forCellReuseIdentifier: "FuelingsToDoCel")
        self.fuelingsToDoTV.estimatedRowHeight = 143.5
        self.fuelingsToDoTV.rowHeight = UITableViewAutomaticDimension
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // fuelingsToDoTV.reloadData()
        
    }
    
    @IBAction func sideMenuButton(_ sender: UIButton) {
        showMenu()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        setRoot()
    }
    @IBAction func urgentBtn(_ sender: UIButton) {
            if sender.tag == 1 {
             countNo = 0
            print("\(countNo)")
            print("urgent")
                driverOrdersUrgentAPI(URL: driverOrdersUrgentURL)
        
            if sender.isSelected == true{
                
            }else {
                urgentButton.setTitleColor(#colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1), for: .normal)
                urgentLbl.backgroundColor = #colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1)
                scheduledBtn.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
                scheduledLbl.backgroundColor = UIColor.clear
            }
        }
        if sender.tag == 2 {
             countNo = 1
            print("\(countNo)")
            print("scheduled")
            driverOrdersUrgentAPI(URL: driverOrdersScheduledURL)
            if sender.isSelected == true{
                
            }else{
                scheduledBtn.setTitleColor(#colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1), for: .normal)
                scheduledLbl.backgroundColor = #colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1)
                urgentButton.setTitleColor(#colorLiteral(red: 0.6206937432, green: 0.6540969014, blue: 0.6854332089, alpha: 1), for: .normal)
                urgentLbl.backgroundColor = UIColor.clear
            }
            
        }
    }
    
    //MARK:- Driver Urgent Orders API
    func driverOrdersUrgentAPI(URL: String){
        let params = ["driverId": defaultValues.string(forKey: "UserID")!]
        
        WebService.shared.apiDataPostMethod(url: URL, parameters: params) { (response, error) in
            if error == nil {
                self.DriverOrdersUrgentModelData = Mapper<DriverOrdersUrgentModel>().map(JSONObject: response)
                
                if self.DriverOrdersUrgentModelData.success == true {
                    if let data = self.DriverOrdersUrgentModelData.order
                    {
                        self.DriverOrderData = data
                        
                        
//                        if let data = self.DriverOrdersUrgentModelData.userdata?.uservehicle, data.count > 0 {
//
//                            self.uservehicleData = self.GetProfileModelData.userdata?.uservehicle
//                        }
                        
                    self.fuelingsToDoTV.reloadData()
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
extension FuelingsToDoViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 170
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = DriverOrderData, data.count > 0{
            errorLabel.isHidden = true
            return DriverOrderData?.count ?? 0
        }else{
            errorLabel.isHidden = false
            errorLabel.text = "No Orders Found"
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FuelingsToDoCel", for: indexPath) as! FuelingsToDoCel
        if let data = DriverOrderData, data.count > indexPath.row{
            
            cell.nameLbl.text = data[indexPath.row].orderId?.userId?.name
            cell.addressLbl.text = data[indexPath.row].orderId?.address
            

            if let fuelname = data[indexPath.row].orderId?.fuelType {
                //let fill = data[indexPath.row].isFulltank
                if fuelname == 0 {
                    if let amount = data[indexPath.row].orderId?.fuelAmount, amount != 0 {
                        
                        cell.fuelTypeLbl.text = "Gasoline" + "," + currencyFormat(String(describing: (data[indexPath.row].orderId?.fuelAmount)!))
                    }else{
                        cell.fuelTypeLbl.text = "Fill it with Gasoline"
                    }
                    
                }else if fuelname == 1 {
                    if let amount = data[indexPath.row].orderId?.fuelAmount, amount != 0 {
                        
                        cell.fuelTypeLbl.text = "Premium Gasoline" + ", " + currencyFormat(String(describing: (data[indexPath.row].orderId?.fuelAmount)!))
                    }else{
                        cell.fuelTypeLbl.text = "Fill it with Premium Gasoline"
                    }
                    
                }else if fuelname == 2{
                    if let amount = data[indexPath.row].orderId?.fuelAmount, amount != 0 {
                        
                        cell.fuelTypeLbl.text = "Diesel" + ", " + currencyFormat(String(describing: (data[indexPath.row].orderId?.fuelAmount)!))
                    }else{
                        cell.fuelTypeLbl.text = "Fill it with Diesel"
                    }
                    
                }
            }

            if let services = data[indexPath.row].orderId?.serviceId, services.isEmpty == false{

                let serviceStr = services.map{($0.serviceName!)}
                print(serviceStr)
                cell.additionalServicesLbl.text = serviceStr.joined(separator: ", ") //serviceStr.reduce("", + )
            }else{
                cell.additionalServicesLbl.text = ""
            }
            //mark:- converting longdate into Date format
            let milisecond = data[indexPath.row].orderId?.deleveringDate ?? 0
            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
            
            if let deleverDate = data[indexPath.row].orderId?.timing, deleverDate != "" {
                cell.orderTypeLbl.text = "SCHEDULED"
                cell.orderTypeLbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.orderTypeLbl.layer.cornerRadius = 10
                cell.orderTypeLblHeight.constant = 20
                cell.requestedLbl.text = deleverDate + ", " + dateFormatter.string(from: dateVar)
                
            }else{
                cell.orderTypeLbl.text = "URGENT"
                cell.orderTypeLbl.backgroundColor = #colorLiteral(red: 1, green: 0.2588235294, blue: 0.1843137255, alpha: 1)
                cell.orderTypeLblHeight.constant = 15
                cell.orderTypeLbl.layer.cornerRadius = 8
                cell.requestedTitleLbl.text = ""
                cell.requestedLbl.text = ""
            }
            cell.cellBtn.tag = indexPath.row
            cell.cellBtn.addTarget(self, action: #selector(addSomething(button:)), for: .touchUpInside)
        }
        return cell
    }
    @objc func addSomething(button: UIButton) {
        tappedButtonsTag = button.tag
        if (DriverOrderData.count > button.tag){
            
             let orderModel = DriverOrderData[button.tag]
            
            orderDetails[FuelingsToDoEnum.Name.rawValue] = orderModel.orderId?.userId?.name
            orderDetails[FuelingsToDoEnum.Address.rawValue] = orderModel.orderId?.address
            orderDetails[FuelingsToDoEnum.VehicleDetails.rawValue] = orderModel.orderId?.vehicleId
            orderDetails[FuelingsToDoEnum.LicensePlate.rawValue] = orderModel.orderId?.vehicleId?.licencePlate
            orderDetails[FuelingsToDoEnum.Fuel.rawValue] = orderModel.orderId?.fuelType
            
            orderDetails[FuelingsToDoEnum.ServiceDetails.rawValue] = orderModel.orderId?.serviceId.map{($0.serviceName!)}
            
            let vc = DriverStoryBoard.instantiateViewController(withIdentifier: "DriverOrderVC") as! DriverOrderVC
            vc.orderNum = (orderModel.orderId?.id)!
            vc.orderData = orderModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
enum FuelingsToDoEnum:String {
    case Name
    case Address
    case VehicleDetails
    case LicensePlate
    case Fuel
    case Requested
    case ServiceDetails
}
