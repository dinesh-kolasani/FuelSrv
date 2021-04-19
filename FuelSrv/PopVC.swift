//
//  PopVC.swift
//  FuelSrv
//
//  Created by PBS9 on 20/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class PopVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var menuNames = ["EDIT","DELETE"]
    var orderId: String?
    var vehicleId: String?
    var VC: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .ScheduledFuelingsVC, object: nil)
        NotificationCenter.default.removeObserver(self, name: .userAccountVC, object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if defaultValues.integer(forKey: "AccountType") == 0 {
            return menuNames.count
        }else{
            return approxNoOfVehicles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopVcCell") as! PopVcCell
        
        if defaultValues.integer(forKey: "AccountType") == 0 {
            
            cell.cellLbl.text = menuNames[indexPath.row]
        }else{
            
            cell.cellLbl.text = approxNoOfVehicles[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if defaultValues.integer(forKey: "AccountType") == 0 {
           
            if indexPath.row == 0 {
                
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
//            self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 1{
                
                if self.VC == 1{
                    
                    deleteAPI(url: deleteVehicleURL, params: ["vehicleId": vehicleId!])
                }
                else if self.VC == 2{
                    deleteAPI(url: cancelReccuringOrderURL, params: ["orderId": orderId!])
                    deleteAPI(url: cancelOrderURL, params: ["orderId": orderId!])
                }
                
                dismiss(animated: true, completion: nil)
            }
        }else{
            
        }
    }
    

    func deleteAPI(url: String, params:[String:Any]){
        
        //let params:[String:Any] = ["vehicleId": "5ce05bfc49fb1626b260da17"]
        
        WebService.shared.apiDataPostMethod(url: url, parameters: params) { (responce, error) in
            if error == nil {
                if let dic = responce {
                    print(dic)
                    
//                    let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Notification", message: dic["message"] as? String ?? "", cancelButton: false) {
//
//                    NotificationCenter.default.post(name: .userAccountVC, object: nil)
//                       self.dismiss(animated: true, completion: nil)
//
//                    }
//
//                    self.present(alertWithCompletionAndCancel, animated: true)
                    NotificationCenter.default.post(name: .userAccountVC, object: nil)
                    NotificationCenter.default.post(name: .ScheduledFuelingsVC, object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
                
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
