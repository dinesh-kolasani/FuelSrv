//
//  OrderSummuryVC.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 17/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderSummuryVC: UIViewController {
    
    @IBOutlet weak var orderSummuryTV: UITableView!
    @IBOutlet weak var vcHeight: NSLayoutConstraint!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var proceedBtn: RoundButton!
    @IBOutlet weak var promoDiscountViewHeight: NSLayoutConstraint!
    @IBOutlet weak var discointlbl: UILabel!
    @IBOutlet weak var promoDiscountLbl: UILabel!
    @IBOutlet weak var promoDiscountImg: UIImageView!
    @IBOutlet weak var discountViewSeparatorLbl: UILabel!
    
    var orderSummury: OrderDetails!
    //var money: [ServiceId]!
    var orderid: String?
    var headerTitles = ["Convenient Service","Fuel Type","Vehicle","Delivery Address"] // Applied promocode discount
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileDetails()
   
        vcHeight.constant = UIScreen.main.bounds.height
    
        print(orderSummury)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let nib = UINib.init(nibName: "OrderReviewCell", bundle: nil)
        orderSummuryTV.register(nib, forCellReuseIdentifier: "OrderReviewCell")
        
        let nibSec = UINib.init(nibName: "OrderReviewSecCell", bundle: nil)
        orderSummuryTV.register(nibSec, forCellReuseIdentifier: "OrderReviewSecCell")
        
        //orderSummuryTV.tableFooterView = UIView()
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func proceedBtnAction(_ sender: Any) {
        if amountTxt.text == "" {
            self.showAlert("Info:", "Please enter amount", "OK")
        }else{
            
            let vc = DriverStoryBoard.instantiateViewController(withIdentifier:"UploadGageVC") as! UploadGageVC
            vc.orderNum = orderid
            vc.amount = amountTxt.text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func profileDetails(){
        
        var profileImageURL = ""
        if orderSummury.userId.isFullUrl == 0 {
             profileImageURL = baseImageURL + (orderSummury.userId?.avatar)!
        }else{
             profileImageURL = (orderSummury.userId?.avatar)!
        }
        
        
            nameLbl.text =  orderSummury.userId?.name
            addressLbl.text = orderSummury.address
            if let imageURL = URL(string: profileImageURL) {
            
                profilePic.layer.borderWidth = 1.0
                profilePic.layer.masksToBounds = false
                profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
                profilePic.layer.borderColor = UIColor.red.cgColor
                profilePic.layer.backgroundColor = UIColor.clear.cgColor
                profilePic.clipsToBounds = true
                profilePic.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userBlack"))
            }
        if let discount = orderSummury.discountLeft, discount == 0{
            promoDiscountViewHeight.constant = 0
            promoDiscountImg.image = nil
            promoDiscountLbl.text = ""
            discointlbl.text = ""
            discountViewSeparatorLbl.backgroundColor = UIColor.clear
        
        }else{
            //promoDiscountViewHeight.constant = 70
            let discount = currencyFormat("\(orderSummury.discountLeft!.magnitude)")
            discointlbl.text = "- \(discount)"
        }
    }
    
}
extension OrderSummuryVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "OrderReviewSecCell") as! OrderReviewSecCell
       
        headerView.ORTitleLabel.text = headerTitles[section]
       
        return headerView
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
       return headerTitles.count
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            var serviceStr = [String]()
            if let services = orderSummury.serviceId, services.isEmpty == false{
                serviceStr = services.map{($0.serviceName!)}
            }
            return serviceStr.count
        }else{
            return 1
          }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderReviewCell", for: indexPath) as! OrderReviewCell
        
        if indexPath.section == 0{
            cell.img.image = #imageLiteral(resourceName: "DriverServices")
            if let services = orderSummury.serviceId, services.isEmpty == false{

                var serviceStr = services.map{($0.serviceName!)}
                print(serviceStr)
                
//                var serviceid = orderSummury.serviceId
//                let objectToRemove = "Fuel my Vehicle"
//                serviceId?[indexPath.row].serviceName.remove(object: objectToRemove)
                
                cell.serviceNameLbl.text = services[indexPath.row].serviceName //serviceStr.joined(separator: ", ") //serviceStr.reduce("", + )
                cell.serviceTypeLbl.text = services[indexPath.row].subServiceName
                cell.priceLbl.text = currencyFormat(services[indexPath.row].subServicePrice)
                //cell.preAuthorizedLbl.text = "x" + " \(services[indexPath.row].subServiceQuantity!)"
                
            }else{
                cell.serviceNameLbl.text = ""
            }

        }else if indexPath.section == 1 {
            cell.img.image = #imageLiteral(resourceName: "DriverFuel-type")
            if let fuelname = orderSummury.fuelType {
                if let fullTank = orderSummury?.isFulltank, fullTank == 1 {
                    cell.priceLbl.text = "Fill it"
                }else{
                    if orderSummury.fuelAmount != 0{
                        cell.priceLbl.text = currencyFormat("\(orderSummury.fuelAmount!)") //currencyFormat(String(describing: orderSummury?.fuelAmount))
                    }else{
                        cell.priceLbl.text = "\(orderSummury.fuelQuantity!) L" //currencyFormat(String(describing: orderSummury?.fuelAmount))
                    }
                }
                
                let price = orderSummury.serviceId[0].subServicePrice ?? "0"
                print(price)
                cell.serviceTypeLbl.text = currencyFormat(String(describing: price))
                
                if fuelname == 0 {
                    
                    cell.serviceNameLbl.text = "Gasoline"
                }else if fuelname == 1 {
                    
                    cell.serviceNameLbl.text = "Premium Gasoline"
                }else if fuelname == 2{
                    
                    cell.serviceNameLbl.text = "Diesel"
                }
            }
            
        }else if indexPath.section == 2 {
            cell.img.image = #imageLiteral(resourceName: "Drivercar")
            
            if let accont = orderSummury.userId?.accountType, accont == 0 {
                if let vehicleDetails = orderSummury.vehicleId {
                    cell.serviceNameLbl.text = vehicleDetails.year! + ", " + vehicleDetails.make! + ", " + vehicleDetails.model! + ", " + vehicleDetails.color! + ", " + vehicleDetails.licencePlate!
                }
            }else{
                cell.serviceNameLbl.text = orderSummury.vehicleCount //orderData?.orderId?.vehicleCount
            }
            
        }
        else if indexPath.section == 3 {
            cell.img.image = #imageLiteral(resourceName: "DriverLocation pin")
            
            cell.serviceNameLbl.text = orderSummury.address //"userLocation"
        }
        return cell
    }
}
    
    
    
    
    

