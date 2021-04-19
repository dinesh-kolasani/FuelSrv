//
//  LogInVC.swift
//  FuelSrv
//
//  Created by PBS9 on 01/04/19.
//  Copyright © 2019 Dinesh Raja. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SkyFloatingLabelTextField
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LogInVC: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,UITextFieldDelegate {
    
    
    var helper  = Helper()
    
    var socialEmail:String = ""
    var socialName:String = ""
    var socialId:String = ""
    var avatar:String = ""
//    var deviceId:String = ""
    var userPhoto:URL?
    var remmerme = ""
    
    @IBOutlet weak var emailTXT: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTXT: SkyFloatingLabelTextField!
    @IBOutlet weak var rememberBtn: UIButton!
    @IBOutlet weak var showPasswordBtn: UIButton!
    
    @IBOutlet weak var loginBtn: RoundButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    var loginModelData:LoginModel!
    var loginModelDataDetails:User!
    var gmailModelData:SocialLoginModel!
    var facebookModelData:SocialLoginModel!
    
    
    //var defaults = UserDefaults.standard
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        capitalizedString()
        RemenberValue = "Yes"
        

        UIApplication.shared.statusBarView?.isHidden = true
        loginBtn.dropShadow(view: loginBtn, opacity: 0.5)
        moreBtn.dropShadow(view: moreBtn, opacity: 0.5)
        googleBtn.dropShadow(view: googleBtn, opacity: 0.5)
        facebookBtn.dropShadow(view: facebookBtn, opacity: 0.5)

        
    }
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.isHidden = true
        
        if RemenberValue == "Yes"
        {
            rememberBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
            self.emailTXT.text = USEREMAIL
            self.passwordTXT.text = USERPASSWORD

        }else{
            rememberBtn.setImage(#imageLiteral(resourceName: "box"), for: .normal)
        }
        
    }
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.statusBarView?.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    // MARK: - ButtonActions
    
    @IBAction func showPasswordBtn(_ sender: Any) {
        
        if passwordTXT.isSecureTextEntry == true{
            showPasswordBtn.setImage(#imageLiteral(resourceName: "show-passwordactivate"), for: .normal)
            passwordTXT.isSecureTextEntry = false
        }else{
            showPasswordBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            passwordTXT.isSecureTextEntry = true
        }
    }
    
    @IBAction func rememberBtn(_ sender: UIButton) {
        if rememberBtn.isSelected {
            self.remmerme = "Yes"
            //UserDefaults.standard.set(remmerme, forKey: "Rememberme")
            defaultValues.set(remmerme, forKey: "Rememberme")
            rememberBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
        }else{
            
            self.remmerme = "No"
            //UserDefaults.standard.set(remmerme, forKey: "Rememberme")
            defaultValues.set(remmerme, forKey: "Rememberme")
            rememberBtn.setImage(#imageLiteral(resourceName: "box"), for: .normal)
            
        }
        defaultValues.synchronize()
        rememberBtn.isSelected = !rememberBtn.isSelected
    }
    
    @IBAction func forgotPasswordBtn(_ sender: UIButton) {
        
        let NVC = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as!ForgotPasswordVC
        navigationController?.pushViewController(NVC, animated: true)
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        validation()
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        let NVC = storyboard?.instantiateViewController(withIdentifier: "AccountTypeVC") as! AccountTypeVC
        navigationController?.pushViewController(NVC, animated: true)
        
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    @IBAction func facebookLogin(_ sender: UIButton){
        
        let fbLoginManager:LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            
            if error == nil{
                
                let fbLoginresult:LoginManagerLoginResult = result!
                if fbLoginresult.grantedPermissions != nil {
                    
                    if (fbLoginresult.grantedPermissions.contains("email")) {
                        
                        self.GetFBUserData()
                        
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    // MARK: - Custom Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTXT{
            emailTXT.errorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            emailTXT.errorMessage = "E-mail"
            
        }else{
            passwordTXT.errorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            passwordTXT.errorMessage = "Password"
        }
        return true
      }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTXT {
            passwordTXT.becomeFirstResponder()
        }else{
            validation()
        }
        return true
    }
    
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
    
    func capitalizedString(){
        emailTXT.titleFormatter = { $0 }
        passwordTXT.titleFormatter = { $0 }
        emailTXT.delegate = self
        passwordTXT.delegate = self
       
        emailTXT.placeholderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        passwordTXT.placeholderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        emailTXT.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        passwordTXT.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func validation(){
        
        if (helper.isFieldEmpty(field: emailTXT.text!)){
            Helper.Alertmessage(title: "Notification", message: "Please Enter Email Address", vc: self)
        }else if (helper.isValidEmail(candidate: emailTXT.text!)){
            Helper.Alertmessage(title: "Notification", message: "Please Enter a valid email address", vc: self)
        }else if (helper.isFieldEmpty(field: passwordTXT.text!)){
            Helper.Alertmessage(title: "Notification", message: "Please Enter Password", vc: self)
        }else{
            
            loginAPI()
            
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
            
            print("\(error.localizedDescription)")
            
        }else{
            
            print(user.profile)
            
            self.socialId = user.userID
            self.socialName = user.profile.name
            self.socialEmail = user.profile.email
            self.userPhoto = user.profile.imageURL(withDimension: 400)
            self.avatar = String(describing: userPhoto!)
            gmailAPI()
        }
    }
    func GetFBUserData(){
        if ((AccessToken.current)) != nil{
            
            GraphRequest(graphPath: "me", parameters: ["fields":"id,name,first_name,last_name, picture.width(400).height(400),email"]).start(completionHandler:{(connection,result,error ) -> Void in
                if error == nil{
                    let facebookDict = result as! [String:Any]
                   
                    self.socialEmail = facebookDict["email"] as? String ?? ""
                    
                    self.socialName = facebookDict["name"] as? String ?? ""
                    
                    self.socialId = facebookDict["id"] as? String ?? ""
                    
                    let picture:[String:Any] = facebookDict["picture"] as? [String : Any] ?? [:]
                    let userPic = picture["data"] as! [String: Any]
                    self.avatar = userPic["url"] as? String ?? ""
                    
                   
                    self.facebookAPI()
                    
                    
                }
            })
        }
    }
    
    // MARK: - Login Api.
    
    func loginAPI(){
        
        let params:[String:Any] = [
            "email" : emailTXT.text!,
            "password" : passwordTXT.text!,
            "deviceId" : defaultValues.string(forKey: "DeviceID")!]
        
        defaultValues.set(emailTXT.text!, forKey: "UserEmail")
        defaultValues.set(passwordTXT.text!, forKey: "UserPassword")
        
        
        WebService.shared.apiDataPostMethod(url: userLoginURL, parameters: params) { (response, error) in
            if error == nil{
                self.loginModelData = Mapper<LoginModel>().map(JSONObject: response)
                
                if self.loginModelData.success == true {
                    if let str = self.loginModelData.user?.id
                {
                    
                    defaultValues.set(str, forKey: "UserID")
                    defaultValues.set(self.loginModelData.user?.email, forKey: "UserEmail")
                    defaultValues.set(self.loginModelData.user?.name, forKey: "UserName")
                    defaultValues.set(self.loginModelData.user?.userAddress, forKey: "address")
                    defaultValues.set(self.loginModelData.user?.avatar, forKey: "avatar")
                    //defaultValues.set(self.loginModelData.user?.deviceId, forKey: "DeviceID")
                    defaultValues.set(self.loginModelData.user?.accountType, forKey: "AccountType")
                    defaultValues.set(self.loginModelData.user?.isPhysicalRecieptYes, forKey: "PhysicalReciept")
                    defaultValues.set(self.loginModelData.user?.isMembershipTaken, forKey: "MembershipTaken")
                    defaultValues.set(self.loginModelData.user?.inviteCode, forKey: "InviteCodeText")
                    defaultValues.synchronize()
                    appDelegate.configureSideMenu()
                }
                else{
                    return
                    }
                }
                else if self.loginModelData?.success == false
                {
                    if self.loginModelData?.message == "Password incorrect"{
                        self.passwordTXT.errorMessage = "Password incorrect"
                        self.passwordTXT.errorColor = #colorLiteral(red: 1, green: 0.2588235294, blue: 0.1843137255, alpha: 1)
                        self.passwordTXT.shake()
                        self.passwordTXT.text = ""
                    }else if self.loginModelData?.message == "Email not found"{
                        self.emailTXT.errorMessage = "E-mail not found"
                        self.emailTXT.errorColor = #colorLiteral(red: 1, green: 0.2588235294, blue: 0.1843137255, alpha: 1)
                        self.emailTXT.shake()
                        self.emailTXT.text = ""
                        self.passwordTXT.text = ""
                    }
                    
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    
    //MARK:- Facebook Api.
    func facebookAPI(){
        
        let params:[String:Any] = [
            "email" : socialEmail,
            "socialId" : socialId,
            "name" : socialName,
            "avatar" : avatar,
            "deviceId" : defaultValues.string(forKey: "DeviceID")!]
        
        WebService.shared.apiDataPostMethod(url: facebookURL, parameters: params) { (response, error) in
            
            
            if error == nil{
                self.facebookModelData = Mapper<SocialLoginModel>().map(JSONObject: response)
                
                if self.facebookModelData.success == true{
                    if let str = self.facebookModelData.user?.id
                    {
                        defaultValues.set(str, forKey: "UserID")
                        defaultValues.set(self.facebookModelData.user?.email, forKey: "UserEmail")
                        defaultValues.set(self.facebookModelData.user?.name, forKey: "UserName")
                        defaultValues.set(self.facebookModelData.user?.userAddress, forKey: "address")
                        defaultValues.set(self.facebookModelData.user?.avatar, forKey: "avatar")
                        //defaultValues.set(self.facebookModelData.user?.deviceId, forKey: "DeviceID")
                        defaultValues.set(self.facebookModelData.user?.accountType, forKey: "AccountType")
                        defaultValues.set(self.facebookModelData.user?.isPhysicalRecieptYes, forKey: "PhysicalReciept")
                        defaultValues.set(self.facebookModelData.user?.isMembershipTaken, forKey: "MembershipTaken")
                        defaultValues.set(self.facebookModelData.user?.inviteCode, forKey: "InviteCodeText")
                        defaultValues.synchronize()
                        
                        if let newUser = self.facebookModelData.newUser, newUser == 0{
                            appDelegate.configureSideMenu()
                            
                        }else{
                            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "ReferralCodeVC") as! ReferralCodeVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            //appDelegate.configureSideMenu()
                        }
                       
                    }
                    else
                    {
                        return
                    }
                    
                }else if self.facebookModelData?.success == false{
                    
                    Helper.Alertmessage(title: "Info:", message: self.facebookModelData.message ?? "", vc: self)
                    
                } else{
                     Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            } else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }

    
    //MARK:- Gmail Api.
    // deJGBP58DvU:APA91bHFkYgJZTwv4RL398RcCT2-xdJF4Id9foHV7nDc1biuGO33pkQpGl1wL9tlH4X6NZgDXfDMJXLKnboNVsRgoQ4Ls7iafhBcHkb8eFQ-MLES1JmDLybbuKZABJxQ2uNBeuPVPUPV
    //cXRigrteRzI:APA91bE8mhESpRZgDm4j9rt6hz0KA-DRFFrEf8NroWgu_lbdRZgsV6c5TAe6vi0DX4Tlz0N1Y60vnXIQi2fczjLMaSo3ZjbXUkCH5ogLJZIOk4tpHipUTFCJadnOjGUdt24fKuqU3003
    func gmailAPI(){
        
        let params:[String:Any] = [
            "email" : socialEmail,
            "socialId" : socialId,
            "name" : socialName,
            "avatar" : avatar,
            "deviceId" : defaultValues.string(forKey: "DeviceID")!]
        
        WebService.shared.apiDataPostMethod(url: googleURL, parameters: params) { (response, error) in
            
            if error == nil{
                self.gmailModelData = Mapper<SocialLoginModel>().map(JSONObject: response)
                
                if self.gmailModelData.success == true{
                    
                    if let str = self.gmailModelData.user?.id
                    {
                    
                        defaultValues.set(str, forKey: "UserID")
                        defaultValues.set(self.gmailModelData.user?.email, forKey: "UserEmail")
                        defaultValues.set(self.gmailModelData.user?.name, forKey: "UserName")
                        defaultValues.set(self.gmailModelData.user?.userAddress, forKey: "address")
                        defaultValues.set(self.gmailModelData.user?.avatar, forKey: "avatar")
                       // defaultValues.set(self.gmailModelData.user?.deviceId, forKey: "DeviceID")
                        defaultValues.set(self.gmailModelData.user?.accountType, forKey: "AccountType")
                        defaultValues.set(self.gmailModelData.user?.isPhysicalRecieptYes, forKey: "PhysicalReciept")
                        defaultValues.set(self.gmailModelData.user?.isMembershipTaken, forKey: "MembershipTaken")
                        defaultValues.set(self.gmailModelData.user?.inviteCode, forKey: "InviteCodeText")
                        defaultValues.synchronize()
                        
                        if let newUser = self.gmailModelData.newUser, newUser == 0{
                            appDelegate.configureSideMenu()
                        }else{
                            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "ReferralCodeVC") as! ReferralCodeVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            //appDelegate.configureSideMenu()
                        }
                    }
                    else
                    {
                        return
                    }
                }
                else if self.gmailModelData?.success == false{
                    
                    Helper.Alertmessage(title: "Info:", message: self.gmailModelData.message ?? "", vc: self)
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            } else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
public extension UIView {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = 4) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation), y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
}
