//
//  MembershipVC.swift
//  FuelSrv
//
//  Created by PBS9 on 21/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper

class MembershipVC: UIViewController {
    
    @IBOutlet weak var freeTrialBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var preRequestView: UIView!
    
    @IBOutlet weak var freeTrailView: RoundedView!
    @IBOutlet weak var selectBtn: RoundButton!
    
    var MembershipModelData: MembershipModel!
    var MemberShipData: [MemberShip]?
    var membershipDetails: [String:Any] = [:]
    var tappedButtonsTag: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation()
        let nib = UINib.init(nibName: "MembershipVcCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MembershipVcCell")
        
        //NotificationCenter.default.removeObserver(self, name: .userAccountVC, object: nil)
        // NotificationCenter.default.post(name: .userAccountVC, object: nil)
    }
    
    @IBAction func freeTrialBtnAction(_ sender: Any) {
        
        membershipDetails[MembershipEnum.MembershipKey.rawValue] = "2"
        membershipDetails[MembershipEnum.MembershipTaken.rawValue] = "0"
        
        appDelegate.orderDataDict[OrderDataEnum.Membership.rawValue] = membershipDetails
        if physicalReciept == 0{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSummaryVC") as! PaymentSummaryVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    @IBAction func selectBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        membershipDetails[MembershipEnum.MembershipKey.rawValue] = String(describing: 3)
        membershipDetails[MembershipEnum.Amount.rawValue] =  String(describing: 8)
        membershipDetails[MembershipEnum.MemberShipPlanId.rawValue] = ""
        membershipDetails[MembershipEnum.MembershipTaken.rawValue] = "0"
        
        appDelegate.orderDataDict[OrderDataEnum.Membership.rawValue] = membershipDetails
        
    }
    
    func navigation(){
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationItem.title = "MEMBERSHIP"
        if freeTrialTaken == 1{
            freeTrailView.isHidden = true
            preRequestView.isHidden = false
        }
        getAllMemberShipAPI()
    }
   
   
    func getAllMemberShipAPI(){
        
        let params:[String:Any] = ["accounttype": defaultValues.integer(forKey: "AccountType")]
        WebService.shared.apiGet(url: getAllMemberShipURL, parameters: params) { (responce, error) in
            if error == nil {
                self.MembershipModelData = Mapper<MembershipModel>().map(JSONObject: responce)
                
                if self.MembershipModelData.success == true {
                    if let home = self.MembershipModelData?.memberShip
                    {
                        self.MemberShipData = home
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
extension MembershipVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (MemberShipData != nil){
            return MemberShipData?.count ?? 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipVcCell", for: indexPath) as! MembershipVcCell
        
        if let data = MemberShipData, data.count > indexPath.row{
         
            cell.membershipTypeLbl.text = data[indexPath.row].membershipType
            
            if let objData = MemberShipData?[indexPath.row].membershipKey {
                if objData == 0 {
                    
                    //cell.membershipPriceLbl.text = "$" + String(describing: data[indexPath.row].membershipPrice!) + ".00/Month"
                    cell.membershipPriceLbl.text = currencyFormat(String(describing: data[indexPath.row].membershipPrice!)) + "/Month"
                    cell.selectedBtn.setTitle("SELECT MONTHLY", for: .normal)
                }else if objData == 1 {
                    
                    cell.membershipPriceLbl.text = currencyFormat(String(describing: data[indexPath.row].membershipPrice!)) + "/Year"
                    //cell.membershipPriceLbl.text = "$" + String(describing: data[indexPath.row].membershipPrice!) + ".00/Year"
                    cell.selectedBtn.setTitle("SELECT YEARLY", for: .normal)
                    cell.separatorLineLbl.isHidden = true
                }
            }
            cell.selectedBtn.tag = indexPath.row
            cell.selectedBtn.addTarget(self, action: #selector(addSomething(button:)), for: .touchUpInside)
        }
        return cell
    }
    @objc func addSomething(button: UIButton) {
        
        tappedButtonsTag = button.tag
        if let data = MemberShipData, data.count > button.tag{
            
            let MemberShipModel = data[button.tag]
            
            membershipDetails[MembershipEnum.MembershipKey.rawValue] = String(describing: MemberShipModel.membershipKey!)
            membershipDetails[MembershipEnum.Amount.rawValue] = String(describing: MemberShipModel.membershipPrice!)
            membershipDetails[MembershipEnum.MemberShipPlanId.rawValue] = String(describing: MemberShipModel.memberShipPlanId!)
            membershipDetails[MembershipEnum.MembershipTaken.rawValue] = "1"
           
            appDelegate.orderDataDict[OrderDataEnum.Membership.rawValue] = membershipDetails
        }
        if membership == 0 {
            if defaultValues.integer(forKey: "PhysicalReciept") == 0{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptVC") as! ReceiptVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSummaryVC") as! PaymentSummaryVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}
enum MembershipEnum:String {

    case MembershipTaken
    case MembershipKey
    case Amount
    case MemberShipPlanId
}
