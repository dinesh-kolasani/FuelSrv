//
//  YouVC.swift
//  FuelSrv
//
//  Created by PBS9 on 01/04/19.
//  Copyright © 2019 Dinesh Raja. All rights reserved.
//

import UIKit
import ObjectMapper
import SkyFloatingLabelTextField

class YouVC: UIViewController, UITextFieldDelegate {
    var helper = Helper()
    
    var EmailRegisterModelData :EmailRegisterModel!
    
    @IBOutlet weak var nameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTxt: SkyFloatingLabelTextField!
    
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var nextBtn: RoundButton!
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        capitalizedString()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - ButtonActions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showPasswordBtn(_ sender: Any) {
        
        if passwordTxt.isSecureTextEntry == true{
            showPasswordBtn.setImage(#imageLiteral(resourceName: "show-passwordactivate"), for: .normal)
            passwordTxt.isSecureTextEntry = false
        }else{
            showPasswordBtn.setImage(#imageLiteral(resourceName: "show-password"), for: .normal)
            passwordTxt.isSecureTextEntry = true
        }
    }
    
    @IBAction func NextBtn(_ sender: Any) {
        
        validation()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
//        vc.value = 1
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nameTxt {
            emailTxt.becomeFirstResponder()
        }else if textField == emailTxt{
            passwordTxt.becomeFirstResponder()
        }else if textField == passwordTxt{
            phoneTxt.becomeFirstResponder()
        }else{
            validation()
        }
        return true
    }
    
    // MARK: - Custom Methods
    
    func capitalizedString(){
        nameTxt.titleFormatter = { $0 }
        emailTxt.titleFormatter = { $0 }
        passwordTxt.titleFormatter = { $0 }
         phoneTxt.titleFormatter = { $0 }
        
        self.nameTxt.delegate = self
        self.emailTxt.delegate = self
        self.passwordTxt.delegate = self
        self.phoneTxt.delegate = self
        
    }
    
    func validation(){
        
        if (helper.isFieldEmpty(field: nameTxt.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Your Name", vc: self)
        }else if (helper.isFieldEmpty(field: emailTxt.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Email Address", vc: self)
        }else if (helper.isValidEmail(candidate: emailTxt.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter a valid email address", vc: self)
        }else if (helper.isFieldEmpty(field: passwordTxt.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Password", vc: self)
        }else if (helper.isFieldEmpty(field: phoneTxt.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Phone Number", vc: self)
        }else if self.isValidPhone(phone: phoneTxt.text!){
            emailRegisterAPI()
        }else{
            self.showAlert("Info:", "Please Enter Valid Phone Number", "Ok")
        }
    }
    
    // MARK: - API
    
    func emailRegisterAPI(){
        
        let params:[String:Any] = ["name": nameTxt.text!,
                                   "email": emailTxt.text!,
                                   "password": passwordTxt.text!,
                                   "phoneNumber": phoneTxt.text!,
                                   "deviceId" : defaultValues.string(forKey: "DeviceID")!,
                                   "accountType": "0"]
        
        print(params)
        
        WebService.shared.apiDataPostMethod(url: emailRegisterURL, parameters: params) { (response, error) in
            if error == nil{
                self.EmailRegisterModelData = Mapper<EmailRegisterModel>().map(JSONObject: response)
                
                
                if self.EmailRegisterModelData.success == true{
                    
                   
                        if let str = self.EmailRegisterModelData.user?.id
                        {
                            defaultValues.set(str, forKey: "UserID")
                            defaultValues.set(self.EmailRegisterModelData.user?.buisnessType, forKey: "AccountType")
                            defaultValues.set(self.EmailRegisterModelData.user?.name, forKey: "UserName")
                            defaultValues.set(self.EmailRegisterModelData.user?.address, forKey: "address")
                            defaultValues.set(self.EmailRegisterModelData.user?.avatar, forKey: "avatar")
                            defaultValues.set(self.EmailRegisterModelData.user?.inviteCode, forKey: "InviteCodeText")
                            defaultValues.set(self.EmailRegisterModelData.user?.isMembershipTaken, forKey: "MembershipTaken")
                            defaultValues.set(self.EmailRegisterModelData.user?.isPhysicalRecieptYes, forKey: "PhysicalReciept")
                            defaultValues.synchronize()
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
                            vc.value = 1
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        else
                        {
                            return
                        }
                
                }else if self.EmailRegisterModelData.success == false{
                    Helper.Alertmessage(title: "Info:", message: self.EmailRegisterModelData.message ?? "", vc: self)
                    
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
