//
//  ReportIssueVC.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 17/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ObjectMapper

class ReportIssueVC: UIViewController {
    
    @IBOutlet weak var repotIssueTV: UITableView!
    @IBOutlet weak var vcHeight: NSLayoutConstraint!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var issueDescription: IQTextView!
    @IBOutlet weak var nextBtn: RoundButton!
    
    @IBOutlet weak var promocodeDiscountViewHeight: NSLayoutConstraint!
    @IBOutlet weak var discountLbl: UILabel!
    
    var reportIssue: OrderDetails!
    var orderid: String?
    
    var headerTitles = ["Convenient Service","Fuel Type","Vehicle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       profileDetails()
   //     promocodeDiscountViewHeight.constant = 0.0
        vcHeight.constant = UIScreen.main.bounds.height
        
        print(reportIssue)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let nib = UINib.init(nibName: "OrderReviewCell", bundle: nil)
        repotIssueTV.register(nib, forCellReuseIdentifier: "OrderReviewCell")
        
        let nibSec = UINib.init(nibName: "OrderReviewSecCell", bundle: nil)
        repotIssueTV.register(nibSec, forCellReuseIdentifier: "OrderReviewSecCell")
        
        
        //repotIssueTV.tableFooterView = UIView()
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        if issueDescription.text == "" {
            self.showAlert("Info:", "Please enter issue description", "ok")
        }else{
            let vc = DriverStoryBoard.instantiateViewController(withIdentifier:"UploadImageVC") as! UploadImageVC
            vc.orderNum = orderid
            vc.issue = issueDescription.text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func profileDetails(){
        
        issueDescription.layer.cornerRadius = 5
        issueDescription.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.6235294118, alpha: 1)
        issueDescription.layer.borderWidth = 2
        issueDescription.dropShadow(view: issueDescription, opacity: 0.5)
        issueDescription.clipsToBounds = true
        
        var profileImageURL = ""
        if reportIssue.userId.isFullUrl == 0{
             profileImageURL = baseImageURL + (reportIssue.userId?.avatar)!
        }else{
             profileImageURL = (reportIssue.userId?.avatar)!
        }
        
        nameLbl.text =  reportIssue.userId?.name
        addressLbl.text = reportIssue.address
        if let imageURL = URL(string: profileImageURL) {
            
            profilePic.layer.borderWidth = 1.0
            profilePic.layer.masksToBounds = false
            profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
            profilePic.layer.borderColor = #colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1)
            profilePic.layer.backgroundColor = UIColor.clear.cgColor
            profilePic.clipsToBounds = true
            profilePic.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userBlack"))
        }
//        if let discount = reportIssue.discountLeft, discount == 0{
//            promocodeDiscountViewHeight.constant = 0
//        }else{
//            promocodeDiscountViewHeight.constant = 75
//            discountLbl.text = currencyFormat("\(reportIssue.discountLeft!)")
//        }
    }
    
}

extension ReportIssueVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "OrderReviewSecCell") as! OrderReviewSecCell
        
        headerView.ORTitleLabel.text = headerTitles[section]
        headerView.focusStyle = .default
        
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
            if let services = reportIssue.serviceId, services.isEmpty == false{
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
                if let services = reportIssue.serviceId, services.isEmpty == false{

                    let serviceStr = services.map{($0.serviceName!)}
                    print(serviceStr)
                    cell.serviceNameLbl.text = services[indexPath.row].serviceName
                    cell.serviceTypeLbl.text = services[indexPath.row].subServiceName
                    cell.priceLbl.text = currencyFormat(services[indexPath.row].subServicePrice)
                    //cell.preAuthorizedLbl.text = "x" + "\(services[indexPath.row].subServiceQuantity!) "//serviceStr.joined(separator: ", ") //serviceStr.reduce("", + )
                }else{
                    cell.serviceNameLbl.text = ""
                }
            }else if indexPath.section == 1 {
                cell.img.image = #imageLiteral(resourceName: "DriverFuel-type")
                if let fuelname = reportIssue.fuelType {
                    
                    if let fullTank = reportIssue?.isFulltank, fullTank == 1 {
                        cell.priceLbl.text = "Fill it"
                    }else{
                        if reportIssue.fuelAmount != 0{
                            cell.priceLbl.text = currencyFormat("\(reportIssue.fuelAmount!)") //currencyFormat(String(describing: orderSummury?.fuelAmount))
                        }else{
                            cell.priceLbl.text = "\(reportIssue.fuelQuantity!) L" //currencyFormat(String(describing: orderSummury?.fuelAmount))
                        }
                    }
                    let price = reportIssue.serviceId[0].subServicePrice ?? "0"
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
                if let accont = reportIssue.userId?.accountType, accont == 0 {
                    if let vehicleDetails = reportIssue.vehicleId {
                        cell.serviceNameLbl.text = vehicleDetails.year! + " " + vehicleDetails.make! + ", " + vehicleDetails.model! + ", " + vehicleDetails.color! + " " + vehicleDetails.licencePlate!
                    }
                }else{
                    cell.serviceNameLbl.text = reportIssue.vehicleCount //orderData?.orderId?.vehicleCount
                }
            }
            else if indexPath.section == 3 {
                cell.img.image = #imageLiteral(resourceName: "DriverLocation pin")
                
                cell.serviceNameLbl.text = reportIssue.address //"userLocation"
            }
       
        return cell
    }
}
extension ReportIssueVC:cellDelegate{
    func didPressButton(_ tag: Int) {
        
        print("button pressed")
    }
    
    
}
