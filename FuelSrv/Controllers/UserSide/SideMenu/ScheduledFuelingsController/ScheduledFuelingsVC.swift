//
//  ScheduledFuelingsVC.swift
//  FuelSrv
//
//  Created by PBS9 on 30/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper

class ScheduledFuelingsVC: UIViewController,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var topViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var upComingBtn: UIButton!
    @IBOutlet weak var reCurringBtn: UIButton!
    
    @IBOutlet weak var upComingLbl: UILabel! 
    @IBOutlet weak var reCurringLbl: UILabel!
    
    @IBOutlet weak var scheduledBtn: UIButton!
    @IBOutlet weak var onDemandBtn: UIButton!
   
    @IBOutlet weak var buttonsBGView: RoundedView!
    
    var allPendingOrdersScheduledModelData: allPendingOrdersScheduledModel!
    var ScheduleOrderData: [ScheduleOrder]?
    var AllRecurringOrdersModelData : AllRecurringOrdersModel!
    
    var tappedButtonsTag: Int!
    var orderNum: String?
    var orderType = 0
    
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationRightItem()
        buttonsBGView.dropShadow(view: buttonsBGView, opacity: 0.4)
        tableView.isHidden = false
        allPendingOrdersAPI(params: ["userId": defaultValues.string(forKey: "UserID")!,
                                     "isUrgent": 1,
                                     "skip": "",
                                     "limit":""])
        
        
        let nib = UINib.init(nibName: "ScheduledFuelingsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ScheduledFuelingsCell")
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVc), name: .ScheduledFuelingsVC, object: nil)
        self.tableView.estimatedRowHeight = 142.5
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    @objc func reloadVc()
    {
        allPendingOrdersAPI(params: ["userId": defaultValues.string(forKey: "UserID")!,
                                     "isUrgent": 1,
                                     "skip": "",
                                     "limit":""])
        
        onDemandBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        onDemandBtn.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
        scheduledBtn.setTitleColor(#colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.6235294118, alpha: 1), for: .normal)
        scheduledBtn.backgroundColor = UIColor.clear
    }
    
    //MARK:- Button Actions
    @IBAction func fuelingBtns(_ sender: UIButton) {
        if sender.tag == 1 {
            if sender.isSelected == true{
                
            }else {
                buttonsBGView.isHidden = false
                tableView.isHidden = false
                
                allPendingOrdersAPI(params: ["userId": defaultValues.string(forKey: "UserID")!,
                                             "isUrgent": 1,
                                             "skip": "",
                                             "limit":""])
                orderType = 0
                upComingBtn.setTitleColor(#colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1), for: .normal)
                upComingLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
                reCurringBtn.setTitleColor(#colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.6235294118, alpha: 1), for: .normal)
                reCurringLbl.backgroundColor = UIColor.clear
                topViewHeightLayout.constant = 35
                
                onDemandBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                onDemandBtn.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
                scheduledBtn.setTitleColor(#colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.6235294118, alpha: 1), for: .normal)
                scheduledBtn.backgroundColor = UIColor.clear

            }
        }
        if sender.tag == 2 {
            if sender.isSelected == true{
                
            }else{
                buttonsBGView.isHidden = true
                tableView.isHidden = false
                allrecurringOrdersAPI(params: ["userId": defaultValues.string(forKey: "UserID")!])
                orderType = 1
                reCurringBtn.setTitleColor(#colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1), for: .normal)
                reCurringLbl.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
                upComingBtn.setTitleColor(#colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.6235294118, alpha: 1), for: .normal)
                upComingLbl.backgroundColor = UIColor.clear
                topViewHeightLayout.constant = 0
            }
            
        }
        
    }
    @IBAction func scheduledBtns(_ sender: UIButton) {
        if sender.tag == 1 {
            if sender.isSelected == true{
                
            }else {
                tableView.isHidden = false
                allPendingOrdersAPI(params: ["userId": defaultValues.string(forKey: "UserID")!,
                                             "isUrgent": 1,
                                             "skip": "",
                                             "limit":""])
                onDemandBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                onDemandBtn.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
                scheduledBtn.setTitleColor(#colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.6235294118, alpha: 1), for: .normal)
                scheduledBtn.backgroundColor = UIColor.clear
            }
        }
        if sender.tag == 2 {
            if sender.isSelected == true{
                
            }else{
                tableView.isHidden = false
                allPendingOrdersAPI(params: ["userId": defaultValues.string(forKey: "UserID")!,
                                             "isUrgent": 0,
                                             "skip": "",
                                             "limit":""])
                scheduledBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                scheduledBtn.backgroundColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
                onDemandBtn.setTitleColor(#colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.6235294118, alpha: 1), for: .normal)
                onDemandBtn.backgroundColor = UIColor.clear
                
            }
        }
    }
    func navigationRightItem(){
        
        self.navigationItem.title = "SCHEDULED FUELINGS"
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
    @objc func cancelAction(sender: UIButton) {
        let alert = UIAlertController(title: "Cancel Order", message: "Do you want to cancel your order?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",style: UIAlertActionStyle.destructive,handler: {(_: UIAlertAction!) in
            //Okay action
            if (self.ScheduleOrderData!.count > sender.tag){
                let scheduleModel = self.ScheduleOrderData![sender.tag]
                self.orderNum = scheduleModel.id
            }
            if self.orderType == 1 {
                self.deleteOrderAPI(url: cancelReccuringOrderURL, params: ["orderId": self.orderNum ?? ""])
            }else{
                self.deleteOrderAPI(url: cancelOrderURL, params: ["orderId": self.orderNum ?? ""])
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

    //MARK:- All Pending Orders API
    func allPendingOrdersAPI(params:[String:Any]){

        WebService.shared.apiDataPostMethod(url: allPendingOrdersURL, parameters: params) { (responce, error) in
            if error == nil{
                self.allPendingOrdersScheduledModelData = Mapper<allPendingOrdersScheduledModel>().map(JSONObject: responce)
                if self.allPendingOrdersScheduledModelData.success == true {
                    if let home = self.allPendingOrdersScheduledModelData?.order
                    {
                        self.ScheduleOrderData = home
                        self.tableView.reloadData()
                        print(home)
                        
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
    //MARK:- All Recurring Orders API
    func allrecurringOrdersAPI(params:[String:Any]){
        
        WebService.shared.apiDataPostMethod(url: allrecurringOrdersURL, parameters: params) { (responce, error) in
            if error == nil{
                self.AllRecurringOrdersModelData = Mapper<AllRecurringOrdersModel>().map(JSONObject: responce)
                if self.AllRecurringOrdersModelData.success == true {
                    if let home = self.AllRecurringOrdersModelData?.orders
                    {
                        self.ScheduleOrderData = home
                        self.tableView.reloadData()
                        print(home)
                        
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
    func deleteOrderAPI(url: String, params:[String:Any]){
        
        //let params:[String:Any] = ["vehicleId": "5ce05bfc49fb1626b260da17"]
        
        WebService.shared.apiDataPostMethod(url: url, parameters: params) { (responce, error) in
            if error == nil {
                if let dic = responce {
                    print(dic)
                    
                    let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Notification", message: dic["message"] as? String ?? "", cancelButton: false) {
                        NotificationCenter.default.post(name: .userAccountVC, object: nil)
                       self.dismiss(animated: true, completion: nil)
                        }
                    self.present(alertWithCompletionAndCancel, animated: true)
                    
                    NotificationCenter.default.post(name: .userAccountVC, object: nil)
                    NotificationCenter.default.post(name: .ScheduledFuelingsVC, object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    
    //MARK:- Creating DropDown
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    @objc func menuDots(base: UIView) {
        tappedButtonsTag = base.tag
        
        if (ScheduleOrderData!.count > base.tag){
            let scheduleModel = ScheduleOrderData![base.tag]
           self.orderNum = scheduleModel.id
        }
        
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "PopVC") as! PopVC
        popoverContent.VC = 2
        popoverContent.orderId = orderNum
            popoverContent.modalPresentationStyle = .popover
            popoverContent.preferredContentSize = CGSize(width: 110, height: 90)
            
            if let pctrl = popoverContent.popoverPresentationController {
                pctrl.delegate = self
                pctrl.sourceView = base
                //pctrl.sourceRect = base.bounds
                pctrl.sourceRect = CGRect(x: 30, y: 16, width: 0, height: 0)
                
                self.present(popoverContent, animated: true, completion: nil)
                
            }
    }
}


//MARK:- Creating tableview
extension ScheduledFuelingsVC: UITableViewDelegate,UITableViewDataSource{
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            //return 180
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = ScheduleOrderData, data.count > 0{
             errorLabel.isHidden = true
            return ScheduleOrderData?.count ?? 0
        }else{
            errorLabel.isHidden = false
            errorLabel.text = "No Scheduled Orders"
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduledFuelingsCell", for: indexPath) as! ScheduledFuelingsCell
        
        if let data = ScheduleOrderData, data.count > indexPath.row{
            
            cell.cellMenuBtn.tag = indexPath.row
            //cell.cellMenuBtn.addTarget(self, action: #selector(menuDots(base:)), for: .touchUpInside)
            cell.addressNameLbl.text = data[indexPath.row].userId?.name
            cell.subAddressNameLbl.text = data[indexPath.row].address
            cell.cellMenuBtn.tag = indexPath.row
            cell.cellMenuBtn.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
            
            if let fuelname = data[indexPath.row].fuelType {
                if fuelname == 0 {
                    if let amount = data[indexPath.row].fuelAmount, amount != 0 {
                        
                        cell.fuelTypeLbl.text = "Gasoline" + ", " + currencyFormat(String(describing: amount))
                        //cell.fuelTypeLbl.text = "Gasoline" + "," + "$" + String(describing: amount)
                    }else{
                        cell.fuelTypeLbl.text = "Fill it with Gasoline"
                    }
                    
                }else if fuelname == 1 {
                    if let amount = data[indexPath.row].fuelAmount, amount != 0{
                
                        cell.fuelTypeLbl.text = "Premium Gasoline" + ", " + currencyFormat(String(describing: amount))
                    }else{
                        cell.fuelTypeLbl.text = "Fill it with Premium Gasoline"
                    }
                   
                }else if fuelname == 2{
                    
                    if let amount = data[indexPath.row].fuelAmount, amount != 0{
                        //cell.fuelTypeLbl.text = "Diesel" + "," + "$" + String(describing: data[indexPath.row].fuelAmount!)
                        cell.fuelTypeLbl.text = "Diesel" + ", " + currencyFormat(String(describing: amount))
                    }else{
                        cell.fuelTypeLbl.text = "Fill it with Diesel"
                    }
                    
                }
            }
            
            if let services = data[indexPath.row].serviceId, services.isEmpty == false{
                
                let serviceStr = services.map{($0.serviceName!)}
                print(serviceStr)
                cell.additionalServicesLbl.text = serviceStr.joined(separator: ", ") //serviceStr.reduce("", + )
            }else{
                cell.additionalServicesLbl.text = ""
            }
            
            //mark:- converting longdate into Date format
            let milisecond = data[indexPath.row].deleveringDate ?? 0
            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, MMM dd, yyyy"
            
            
            if let deleverDate = data[indexPath.row].timing, deleverDate != "" {
                cell.requestLbl.text = "Requested On: "
                cell.RequestTimeLbl.text = deleverDate + ", \(dateFormatter.string(from: dateVar))"
                //cell.RequestTimeLbl.text = " \(String(describing: data[indexPath.row].timing ?? ""))" + ", \(dateFormatter.string(from: dateVar))"
            }else{
                
                cell.RequestTimeLbl.text = " "
                cell.requestLbl.text = " "
            }
        }
        return cell
    }
}
