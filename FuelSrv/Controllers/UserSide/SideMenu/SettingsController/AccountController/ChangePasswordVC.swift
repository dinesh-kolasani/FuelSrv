//
//  ChangePasswordVC.swift
//  FuelSrv
//
//  Created by PBS9 on 16/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import SkyFloatingLabelTextField

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var oldPasswordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTxt: SkyFloatingLabelTextField!
    
    @IBOutlet weak var oldPasswordBtn: UIButton!
    
    @IBOutlet weak var newPasswordBtn: UIButton!
    
    @IBOutlet weak var confirmPasswordBtn: UIButton!
    
    @IBOutlet weak var changePasswordBtn: RoundButton!
    
    @IBOutlet weak var changePasswordLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var vcBGView: UIImageView!
    
    var account: Int?
    
    var ChangePasswordModelData: ChangePasswordModel!
    var ResultData: Result!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        //setRoot()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func showPasswordBtn(_ sender: UIButton) {
        if sender.tag == 1 {
            if sender.isSelected{
                oldPasswordBtn.setImage(#imageLiteral(resourceName: "show-password"), for: .normal)
                oldPasswordTxt.isSecureTextEntry = true
                
            }else {
                oldPasswordBtn.setImage(#imageLiteral(resourceName: "show-passwordactivate"), for: .normal)
                oldPasswordTxt.isSecureTextEntry = false
            }
            
            oldPasswordBtn.isSelected = !oldPasswordBtn.isSelected
        }
        else if sender.tag == 2 {
            if sender.isSelected{
                newPasswordBtn.setImage(#imageLiteral(resourceName: "show-password"), for: .normal)
                newPasswordTxt.isSecureTextEntry = true
            }else {
                
                newPasswordBtn.setImage(#imageLiteral(resourceName: "show-passwordactivate"), for: .normal)
                newPasswordTxt.isSecureTextEntry = false
            }
            
            newPasswordBtn.isSelected = !newPasswordBtn.isSelected
        }
        else if sender.tag == 3 {
                if sender.isSelected{
                    confirmPasswordBtn.setImage(#imageLiteral(resourceName: "show-password"), for: .normal)
                    confirmPasswordTxt.isSecureTextEntry = true
                }else {
                    confirmPasswordBtn.setImage(#imageLiteral(resourceName: "show-passwordactivate"), for: .normal)
                    confirmPasswordTxt.isSecureTextEntry = false
                    
                }
                
                confirmPasswordBtn.isSelected = !confirmPasswordBtn.isSelected
        }
    }

    @IBAction func changePasswordBtnAction(_ sender: Any) {
        validation()
    }
    func capitalizedString(){
        oldPasswordTxt.titleFormatter = { $0 }
        newPasswordTxt.titleFormatter = { $0 }
        confirmPasswordTxt.titleFormatter = { $0 }

    }
    
    func navigation(){
        capitalizedString()
        if account == 1{
            navigationView.isHidden = false
            vcBGView.image = #imageLiteral(resourceName: "Driverbg")
            changePasswordLbl.textColor = #colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1)
            changePasswordBtn.backgroundColor = #colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1)
            //changePasswordBtn.setTitleColor(#colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1), for: .normal)
        }else{
            navigationItem.leftItemsSupplementBackButton = true
            navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            self.navigationItem.title = "CHANGE PASSWORD"
            vcBGView.image = #imageLiteral(resourceName: "BG-Shapes")
        }
        
    }
    func validation(){
        
        if Helper.shared.isFieldEmpty(field: oldPasswordTxt.text!){
            
            Helper.Alertmessage(title: "Info:", message: "Please Enter Old Password", vc: self)
            
        }else if Helper.shared.isFieldEmpty(field: newPasswordTxt.text!){
            
            Helper.Alertmessage(title: "Info:", message: "Please Enter New Password", vc: self)
            
        }else if Helper.shared.isFieldEmpty(field: confirmPasswordTxt.text!){
            
            Helper.Alertmessage(title: "Info:", message: "Please Enter Confirm Password", vc: self)
        }
        else {
            changePasswordAPI()
        }
 
    }
    func changePasswordAPI(){
        let params:[String:Any] = [
            "userId": defaultValues.string(forKey: "UserID")!,
            "oldPassword": oldPasswordTxt.text!,
            "newPassword": newPasswordTxt.text!
        ]
        
        WebService.shared.apiDataPostMethod(url: changePasswordURL, parameters: params) { (responce, error) in
            if error == nil {
                self.ChangePasswordModelData = Mapper<ChangePasswordModel>().map(JSONObject: responce)
                
                if self.ChangePasswordModelData.success == true {
                    if let data = self.ChangePasswordModelData.result{
                        
                        self.ResultData = data
                        
                        let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Notification", message: self.ChangePasswordModelData.message ?? "", cancelButton: false) {
                            
                            _ = self.navigationController?.popViewController(animated: true)
                            
                        }
                        
                        self.present(alertWithCompletionAndCancel, animated: true)

                    }
                }else{
                    Helper.Alertmessage(title: "Info:", message: self.ChangePasswordModelData.message ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
