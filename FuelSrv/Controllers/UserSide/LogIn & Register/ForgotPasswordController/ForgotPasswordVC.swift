//
//  ForgotPasswordVC.swift
//  FuelSrv
//
//  Created by PBS9 on 02/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import SkyFloatingLabelTextField

class ForgotPasswordVC: UIViewController {
    var helper = Helper()
    
    @IBOutlet weak var emailTXT: SkyFloatingLabelTextField!
    var ForgotPasswordModelData : ForgotPasswordModel!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
   
    // MARK: - ButtonAction
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func verifyBtn(_ sender: Any) {
        
        validation()
    }
    
    // MARK: - Custom Methods
    func navigation(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let imgBack = UIImage(named: "back")
        
        navigationController?.navigationBar.backIndicatorImage = imgBack
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBack
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func validation(){
        
        if (helper.isFieldEmpty(field: emailTXT.text!)){
            Helper.Alertmessage(title: "Notification", message: "Please Enter Email Address", vc: self)
        }else if (helper.isValidEmail(candidate: emailTXT.text!)){
            Helper.Alertmessage(title: "Notification", message: "Please Enter a valid email address", vc: self)
        }else{
            forgetPasswordAPI()
        }
    }
    // MARK: - API
    
    func forgetPasswordAPI(){
        
        let params:[String:Any] = ["email" : emailTXT.text!]
        WebService.shared.apiDataPostMethod(url: forgetPasswordURL, parameters: params) { (response, error) in
            if error == nil{
                
                self.ForgotPasswordModelData = Mapper<ForgotPasswordModel>().map(JSONObject: response)
                
                if self.ForgotPasswordModelData.success == true {
                    
                    let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Notification", message: self.ForgotPasswordModelData.message ?? "", cancelButton: false) {
                        
                        _ = self.navigationController?.popViewController(animated: true)

                    }
                    
                    self.present(alertWithCompletionAndCancel, animated: true)
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: self.ForgotPasswordModelData.message ?? "", vc: self)
                }
                
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
