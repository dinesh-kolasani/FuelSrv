//
//  ReimbursmentViewController.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 09/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit
import ObjectMapper

class ReimbursmentViewController: UIViewController {

    @IBOutlet weak var reimbursementTV: UITableView!
    @IBOutlet weak var myFuelDetailsLbl: UILabel!
    @IBOutlet weak var customerFuelDetailsLbl: UILabel!
    @IBOutlet weak var upcomingReimbursementDateLbl: UILabel!
    
    var ReimbursmentModelData: ReimbursmentModel!
    var UserReimbursementData: UserReimbursement!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userReimbursementAPI()
        // Do any additional setup after loading the view.
        //reimbursementTV.tableFooterView = UIView()
    }


    @IBAction func backBtn(_ sender: UIButton) {
        setRoot()
    }
    func userReimbursementAPI(){
        
        let params = ["userId":defaultValues.string(forKey: "UserID")!]
        WebService.shared.apiDataPostMethod(url: userReimbursementURL, parameters: params) { (response, error) in
            if error == nil{
                
                self.ReimbursmentModelData = Mapper<ReimbursmentModel>().map(JSONObject: response)
                
                if self.ReimbursmentModelData.success == true{
                    if let data = self.ReimbursmentModelData.userReimbursement{
                        self.UserReimbursementData = data
                        self.myFuelDetailsLbl.text = self.currencyFormat(String(describing: data.myFuelAmount)) + " based on " + String(describing: data.distanceDriven!) + " driven fueling between " + String(describing: data.fromDateTime!) + " and " + String(describing: data.toDateTime!)
                        self.customerFuelDetailsLbl.text = self.currencyFormat(String(describing: data.customerFuelAmount)) + " based on " + String(describing: data.fuelPumped!) + " pumped between " + String(describing: data.fromDateTime!) + " and " + String(describing: data.toDateTime!)
                        self.upcomingReimbursementDateLbl.text = data.upcomingReimbursementDate
                    }
                    
                }else{
                    
                    Helper.Alertmessage(title: "Info:", message: self.ReimbursmentModelData.message ?? "", vc: self)
                }
                
            } else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
            
        }
    }
}
//extension ReimbursmentViewController: UITableViewDelegate,UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let nibName = UINib(nibName: "ReimbursementCell", bundle:nil)
//
//        self.reimbursementTV.register(nibName, forCellReuseIdentifier: "ReimbursementCell")
//
//        let cell = reimbursementTV.dequeueReusableCell(withIdentifier: "ReimbursementCell", for: indexPath) as! ReimbursementCell
//            return cell
//}
//}
