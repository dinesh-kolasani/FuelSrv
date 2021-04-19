//
//  YourBusinessVC.swift
//  FuelSrv
//
//  Created by PBS9 on 01/04/19.
//  Copyright © 2019 Dinesh Raja. All rights reserved.
//

import UIKit
import ObjectMapper
import SkyFloatingLabelTextField

class YourBusinessVC: UIViewController,UITextFieldDelegate{
    var bussinessTypeModelData: BussinessTypeModel!
    var bussinessType:[Buisnes]?
    var helper = Helper()
    var myPickerView = UIPickerView()
    var bussinessTypePicker = UIPickerView()
    //var approxNoOfVehicles = ["1 - 10","11 - 25","26 - 50","51 - 100","100+"]
    var emailRegisterModelData: EmailRegisterModel!
    
    
    @IBOutlet weak var businessName: SkyFloatingLabelTextField!
    @IBOutlet weak var businessType: SkyFloatingLabelTextField!
    @IBOutlet weak var numberOfVehicles: SkyFloatingLabelTextField!
    @IBOutlet weak var businessEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var password: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var showPasswordBtn: UIButton!
    
    @IBOutlet weak var vcHeight: NSLayoutConstraint!
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //vcHeight.constant = UIScreen.main.bounds.height
        capitalizedString()
        businesstype()
        picker()
        
        
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
    
    @IBAction func showPasswordBrn(_ sender: Any) {
        
        if password.isSecureTextEntry == true{
            showPasswordBtn.setImage(#imageLiteral(resourceName: "show-passwordactivate"), for: .normal)
            password.isSecureTextEntry = false
        }else{
            showPasswordBtn.setImage(#imageLiteral(resourceName: "show-password"), for: .normal)
            password.isSecureTextEntry = true
        }
        
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        validation()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishRegVC") as! FinishRegVC
//        vc.accontType = 1
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func loginBtn(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == numberOfVehicles{
            self.pickerView(myPickerView, didSelectRow: 0, inComponent: 0)
        }
    }
    
    // MARK: - Custom Methods
    
    func capitalizedString(){
        businessName.titleFormatter = { $0 }
        businessType.titleFormatter = { $0 }
        numberOfVehicles.titleFormatter = { $0 }
        businessEmail.titleFormatter = { $0 }
        password.titleFormatter = { $0 }
        phoneNumber.titleFormatter = { $0 }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == businessName {
            businessType.becomeFirstResponder()
        }else if textField == businessType{
            numberOfVehicles.becomeFirstResponder()
        }else if textField == numberOfVehicles{
            businessEmail.becomeFirstResponder()
        }else if textField == businessEmail{
            password.becomeFirstResponder()
        }else if textField == password{
            phoneNumber.becomeFirstResponder()
        }else{
            validation()
        }
        return true
    }
    
    func validation(){
        
        if (helper.isFieldEmpty(field: businessName.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Your Business Name", vc: self)
        }else if (helper.isFieldEmpty(field: businessEmail.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Business Email Address", vc: self)
        }else if (helper.isValidEmail(candidate: businessEmail.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter a valid Email address", vc: self)
        }else if (helper.isFieldEmpty(field: password.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Password", vc: self)
        }else if (helper.isFieldEmpty(field: phoneNumber.text!)){
            self.showAlert("Info:", "Please enter phone number", "Ok")
        }else if self.isValidPhone(phone: phoneNumber.text!){
            emailRegisterAPI()
        }else{
            self.showAlert("Info:", "Enter valid phonenumber", "Ok")
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == businessType{
            self.businessType.text = self.pickerView(self.bussinessTypePicker, titleForRow: self.bussinessTypePicker.selectedRow(inComponent: 0), forComponent: 0)
        }else if textField == numberOfVehicles{
            self.numberOfVehicles.text = self.pickerView(self.myPickerView, titleForRow: self.myPickerView.selectedRow(inComponent: 0), forComponent: 0)
        }
    }
    
    
    func picker(){
        self.numberOfVehicles.delegate = self
        self.businessType.delegate = self
        
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.bussinessTypePicker.delegate = self
        self.bussinessTypePicker.dataSource = self
        self.numberOfVehicles.inputView = myPickerView
        self.businessType.inputView = bussinessTypePicker
        self.myPickerView.reloadAllComponents()
        self.bussinessTypePicker.reloadAllComponents()
    }
    
    // MARK: - API
    
    func emailRegisterAPI(){
        
        let params:[String:Any] = ["deviceId" : defaultValues.string(forKey: "DeviceID")!,
                                   "name": businessName.text!,
                                   "email": businessEmail.text!,
                                   "password": password.text!,
                                   "phoneNumber": phoneNumber.text!,
                                   "accountType": "1",
                                   "vehicleCount": numberOfVehicles.text!,
                                   "buisnessType": businessType.text!]
        
        WebService.shared.apiDataPostMethod(url: emailRegisterURL, parameters: params) { (response, error) in
            if error == nil{
                self.emailRegisterModelData = Mapper<EmailRegisterModel>().map(JSONObject: response)
                
                if self.emailRegisterModelData.success == true{
                    
                    if let str = self.emailRegisterModelData.user?.id
                    {
                        defaultValues.set(str, forKey: "UserID")
                        defaultValues.set(self.emailRegisterModelData.user?.buisnessType, forKey: "AccountType")
                        defaultValues.set(self.emailRegisterModelData.user?.name, forKey: "UserName")
                        defaultValues.set(self.emailRegisterModelData.user?.address, forKey: "address")
                        defaultValues.set(self.emailRegisterModelData.user?.avatar, forKey: "avatar")
                        defaultValues.set(self.emailRegisterModelData.user?.inviteCode, forKey: "InviteCodeText")
                        defaultValues.set(self.emailRegisterModelData.user?.isMembershipTaken, forKey: "MembershipTaken")
                        defaultValues.set(self.emailRegisterModelData.user?.isPhysicalRecieptYes, forKey: "PhysicalReciept")
                        defaultValues.synchronize()
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishRegVC") as! FinishRegVC
                        vc.value = 1
                        //vc.accontType = 1
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else
                    {
                        return
                    }

                    
                }else if self.emailRegisterModelData.success == false{
                    Helper.Alertmessage(title: "Notification", message: self.emailRegisterModelData.message ?? "", vc: self)
                    
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    func businesstype(){
        let params:[String:Any] = [:]
        WebService.shared.apiGet(url: businessTypeURL, parameters: params) { (responce, error) in
            if error == nil {
                self.bussinessTypeModelData = Mapper<BussinessTypeModel>().map(JSONObject: responce)
                
                if self.bussinessTypeModelData.success == true {
                    if let home = self.bussinessTypeModelData?.buisness
                    {
                        self.bussinessType = home
                        print(home) 
                    }
                    
                }
            }
        }
        
    }
}
extension YourBusinessVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == myPickerView{
            return approxNoOfVehicles.count
        }else if pickerView == bussinessTypePicker{
            return bussinessType?.count ?? 0
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == myPickerView{
            return approxNoOfVehicles[row]
        }else if pickerView == bussinessTypePicker {
            return bussinessType?[row].name
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == myPickerView{
            self.numberOfVehicles.text = approxNoOfVehicles[row]
        }else if pickerView == bussinessTypePicker{
            self.businessType.text = bussinessType?[row].name
        }
    }
    
    
}
