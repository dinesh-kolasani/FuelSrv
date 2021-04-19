//
//  SideMenuVC.swift
//  FuelSrv
//
//  Created by PBS9 on 02/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage
import FBSDKLoginKit
import GoogleSignIn

class SideMenuVC: UIViewController {
    //var IMGArray = ["clock","previous-fueling","help","payment","fuel-type","Settings","user-shape"]
    var IMGArray = [#imageLiteral(resourceName: "clock"),#imageLiteral(resourceName: "previous-fueling"),#imageLiteral(resourceName: "help"),#imageLiteral(resourceName: "payment"),#imageLiteral(resourceName: "fuel-type"),#imageLiteral(resourceName: "Settings")] //#imageLiteral(resourceName: "user-shape")
    var menuNames = ["Scheduled Fuelings","Previous Fuelings","Help","Payment","Free Gas","Settings"] //,"Become a Driver"
    var driverImgArray = [#imageLiteral(resourceName: "DriverFuel-type"),#imageLiteral(resourceName: "DriverPrevious-fueling"),#imageLiteral(resourceName: "DriverHelp"),#imageLiteral(resourceName: "DriverCompensation"),#imageLiteral(resourceName: "DriverReimbursement"),#imageLiteral(resourceName: "DriverSettings")]
    var driverMenuNames = ["Fuelings To-Do","Completed Fuelings","Help","Compensation","Reimbursement","Settings"]
    
    @IBOutlet weak var profileIMG: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileAddress: UILabel!
    
    @IBOutlet weak var menuBG: UIImageView!
    
    @IBOutlet weak var driverSectionBtn: RoundButton!
    @IBOutlet weak var userSectionBtn: RoundButton!
    
    @IBOutlet var menuTbl: UITableView!
    
    @IBOutlet weak var hideView: UIView!
    
    @IBOutlet weak var driverMenu: UITableView!
    var profileImageURL = String()
    
     var GetHomeDataModelData: GetHomeDataModel!
    //let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
       // profileDetails()
        
        driverSectionBtn.titleLabel?.numberOfLines = 0
        driverSectionBtn.titleLabel?.lineBreakMode = .byWordWrapping
        driverSectionBtn.titleLabel?.textAlignment = .center
        
        getSideMenuDataAPI()
        
        hideView.isHidden = true
        userSectionBtn.isHidden = true
        

        menuTbl.tableFooterView = UIView()
        driverMenu.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //profileDetails()
        getSideMenuDataAPI()
    }
    @objc func reloadVc()
    {
       // profileDetails()
        getSideMenuDataAPI()
    }
    //MARK:- Button Actions
    @IBAction func userProfileViewBtnAction(_ sender: Any) {
        self.sideMenuController?.hideRightViewAnimated()
        if  hideView.isHidden == true {
            
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "UserAccountVC") as! UserAccountVC
            vc.value = true
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
        }else{
            let vc = DriverStoryBoard.instantiateViewController(withIdentifier: "DriverAccountVC") as! DriverAccountVC
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
        }
    }
    
    @IBAction func driverSectionBtn(_ sender: UIButton) {
        self.sideMenuController?.hideRightViewAnimated()

        if defaultValues.integer(forKey: "IsVerified") == 1{
                driverSectionAPI()
            }else{
                checkUserVerification()
//                let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "BecomeADriverVC")as! BecomeADriverVC
//                let nav = NavigationController.init(rootViewController: vc)
//                self.sideMenuController?.rootViewController = nav
            }
    }
    
    @IBAction func userSectionBtnAction(_ sender: UIButton) {
        self.sideMenuController?.hideRightViewAnimated()
        if defaultValues.integer(forKey: "IsVerified") == 1{
            userSectionAPI()
        }else
        {
            return
        }
    }
    //MARK:- Profile Details
    func profileDetails(){
        let name = defaultValues.string(forKey: "UserName")!

        profileName.text = name //userName

        if defaultValues.string(forKey: "address")! == "" { //userAddres
            profileAddress.text = "No address specified yet"  //defaultValues.string(forKey: "UserEmail")! //USEREMAIL
        }else {
            profileAddress.text = defaultValues.string(forKey: "address")! //userAddres
        }

//        profileIMG.sd_setImage(with: URL(string: userphoto), placeholderImage: UIImage(named: "placeholder"))

        if let Img = defaultValues.string(forKey: "avatar"),Img != ""{
            if fullUrl == 1 {
                profileImageURL = defaultValues.string(forKey: "avatar")!
            }else{
                profileImageURL = baseImageURL + Img //userphoto
            }

            if let imageURL = URL(string: profileImageURL)
            {

                self.profileIMG.layer.borderWidth = 1.0
                self.profileIMG.layer.masksToBounds = false
                self.profileIMG.layer.cornerRadius = self.profileIMG.frame.size.width/2
                self.profileIMG.layer.borderColor = UIColor.black.cgColor
                self.profileIMG.layer.backgroundColor = UIColor.clear.cgColor
                self.profileIMG.clipsToBounds = true

//                self.profileIMG.sdsetShowActivityIndicatorView(true)
//                self.profileIMG.sdsetIndicatorStyle(.gray)

                self.profileIMG.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))
            }
        }else{
            self.profileIMG.image = UIImage(named: "userwhite")
            self.profileIMG.layer.borderWidth = 1.0
            self.profileIMG.layer.masksToBounds = false
            self.profileIMG.layer.cornerRadius = self.profileIMG.frame.size.width/2
            self.profileIMG.layer.borderColor = #colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1)
            self.profileIMG.layer.backgroundColor = UIColor.clear.cgColor
            self.profileIMG.clipsToBounds = true
        }
    }
    
    //MARK:- Logout Action
    func logOutAction() {
        
            GIDSignIn.sharedInstance().signOut()
            LoginManager().logOut()
        
            defaultValues.set(nil, forKey: "UserID")
            //defaultValues.set(nil, forKey: "DeviceID")
            defaultValues.set(nil, forKey: "UserName")
            defaultValues.set(nil, forKey: "avatar")
            defaultValues.set(nil, forKey: "address")
            defaultValues.set(nil, forKey: "AccountType")
            defaultValues.set(nil, forKey: "PhysicalReciept")
            defaultValues.set(nil, forKey: "MembershipTaken")
            defaultValues.set(nil, forKey: "InviteCodeText")
            defaultValues.set(0, forKey: "UserType")
            defaultValues.set(nil, forKey: "IsVerified")
            
            defaultValues.synchronize()
            
            appDelegate.orderDataDict = [:]
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: true)
            print(appDelegate.orderDataDict)
            print("somthing===========\(String(describing: defaultValues.string(forKey: "UserID")))")
            if let window = UIApplication.shared.windows.first
            {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
        
    }
    //MARK:- User Home Data
    func getSideMenuDataAPI(){
        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID") ?? ""]
        print(params)
        WebService.shared.apiDataPostMethod(url: getHomeDataURL, parameters: params) { (responce, error) in
            if error == nil {
                self.GetHomeDataModelData = Mapper<GetHomeDataModel>().map(JSONObject: responce)
                
                    if self.GetHomeDataModelData.success == true {
                        self.profileName.text = self.GetHomeDataModelData.homeData?.userData?.name
                        
                        if let address = self.GetHomeDataModelData.homeData?.userData?.userAddress, address == ""{
                            self.profileAddress.text = "No address specified yet"
                        }else{
                            self.profileAddress.text = self.GetHomeDataModelData.homeData?.userData?.userAddress
                        }
                        defaultValues.set(self.GetHomeDataModelData.homeData?.userData?.isVerified, forKey: "IsVerified")
                        defaultValues.synchronize()
                        
                        
                        
                    if let img = self.GetHomeDataModelData.homeData?.userData?.avatar, img != ""{

                    let profileImageURL = baseImageURL + img //defaultValues.string(forKey: "avatar")!
                        
                            self.profileIMG.layer.masksToBounds = false
                            self.profileIMG.layer.cornerRadius = self.profileIMG.frame.size.width/2
                            //self.profileIMG.layer.borderColor = UIColor.green.cgColor
                            //self.userImage.layer.backgroundColor = UIColor.black.cgColor
                            self.profileIMG.clipsToBounds = true
                        
                            if self.GetHomeDataModelData.homeData?.userData?.isFullUrl == 1 {
                                
                                self.profileIMG.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "userwhite"))

                            }else{
                                self.profileIMG.sd_setImage(with: URL(string: profileImageURL), placeholderImage: UIImage(named: "userwhite"))

                            }
                        
                    }else{
                        self.profileIMG.image = #imageLiteral(resourceName: "userwhite")
                        }
                    
                }else {
                        let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Info", message: self.GetHomeDataModelData.message ?? "", cancelButton: false) {
                            
                            self.logOutAction()
                        }
                        self.present(alertWithCompletionAndCancel, animated: true)
                    //Helper.Alertmessage(title: "Info:", message: self.GetHomeDataModelData.message ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    
    func driverSectionAPI(){

        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!,
                                   "userType": "1"]
        WebService.shared.apiDataPostMethod(url: changeuserTypeURL, parameters: params) { (response, error) in
            if error == nil{
                if let dict = response {
                    if dict["success"] as! Bool == true {
                    
                        self.showAlert("Info:", dict["message"] as! String , "OK")
                        let vc = DriverStoryBoard.instantiateViewController(withIdentifier: "DriverHomeVC") as! DriverHomeVC
                        let nav = NavigationController.init(rootViewController: vc)
                        self.sideMenuController?.rootViewController = nav
                        
                        self.hideView.isHidden = false
                        self.menuBG.image = #imageLiteral(resourceName: "Driverbg-1")
                        self.driverSectionBtn.isHidden = true
                        self.userSectionBtn.isHidden = false
                        self.profileIMG.layer.borderColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
                        
                        defaultValues.set(1, forKey: "UserType")
                        defaultValues.synchronize()
    
                    }else{
                        return
                    }
                }else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }

            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    func userSectionAPI(){
        
        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!,
                                   "userType": "0"]
        WebService.shared.apiDataPostMethod(url: changeuserTypeURL, parameters: params) { (response, error) in
            if error == nil{
                if let dict = response {
                    if dict["success"] as! Bool == true {
                        
                        
                        self.showAlert("Info:", dict["message"] as! String , "OK")
                        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        let nav = NavigationController.init(rootViewController: vc)
                        self.sideMenuController?.rootViewController = nav
                        self.hideView.isHidden = true
                        self.menuBG.image = #imageLiteral(resourceName: "menu-bg")
                        self.userSectionBtn.isHidden = true
                        self.driverSectionBtn.isHidden = false
                        self.profileIMG.layer.borderColor = #colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1)
                        
                        defaultValues.set(0, forKey: "UserType")
                        defaultValues.synchronize()
   
                    }else{
                        
                        return
                    }
                }else{
                    
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
                
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    //MARK:- Checking User Verification API
    func checkUserVerification(){
        
        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        
        WebService.shared.apiDataPostMethod(url: checkUserVerificationURL, parameters: params)  { (response, error) in
            if error == nil{
                if let dict = response {
                    if dict["isVerified"] as! Int == 0  && profileCompleted == 0{ //isProfilecompleted
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverInfoVC") as! DriverInfoVC
//                        self.navigationController?.pushViewController(vc, animated: true)
                        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "BecomeADriverVC")as! BecomeADriverVC
                        let nav = NavigationController.init(rootViewController: vc)
                        self.sideMenuController?.rootViewController = nav
                    }else if dict["isVerified"] as! Int == 1 {
                        
                        self.showAlert("Info:", "You are already a approved driver", "OK")
                        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        let nav = NavigationController.init(rootViewController: vc)
                        self.sideMenuController?.rootViewController = nav
                        
                    }else if dict["isVerified"] as! Int == 2 {
                        
                        self.showAlert("Info:", "Your documents are not accepted", "OK")
                        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        let nav = NavigationController.init(rootViewController: vc)
                        self.sideMenuController?.rootViewController = nav
                    }else{
                        self.showAlert("Info:", "Your documents are under review, we'll be in touch shortly!", "OK")
                        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        let nav = NavigationController.init(rootViewController: vc)
                        self.sideMenuController?.rootViewController = nav
                    }
                }
            }
        }
    }
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuTbl{
            return IMGArray.count
        }
        else if tableView == driverMenu{
            return driverImgArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == menuTbl{
            
            let cell = menuTbl.dequeueReusableCell(withIdentifier: "menuCell") as! menuCell
            cell.menuLabel.text = menuNames[indexPath.row]
            cell.menuSideImg.image = IMGArray[indexPath.row]
            return cell
        }
        else if tableView == driverMenu{
            let cell = driverMenu.dequeueReusableCell(withIdentifier: "menuCell") as! menuCell
            cell.menuLabel.text = driverMenuNames[indexPath.row]
            cell.menuSideImg.image = driverImgArray [indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.sideMenuController?.hideRightViewAnimated()
        if tableView == menuTbl{
            
            switch indexPath.row  {
            case 0:
                let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "ScheduledFuelingsVC") as! ScheduledFuelingsVC
                let nav = NavigationController.init(rootViewController: vc)
                self.sideMenuController?.rootViewController = nav
                
            case 1:
                let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "PreviousFuelingsVC") as! PreviousFuelingsVC
                let nav = NavigationController.init(rootViewController: vc)
                self.sideMenuController?.rootViewController = nav
                
                
            case 2:
                let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
                let nav = NavigationController.init(rootViewController: vc)
                self.sideMenuController?.rootViewController = nav
                
            case 3:
                let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
                vc.value = true
                let nav = NavigationController.init(rootViewController: vc)
                self.sideMenuController?.rootViewController = nav
                
            case 4:
                let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "FreeGasVC") as! FreeGasVC
                let nav = NavigationController.init(rootViewController: vc)
                self.sideMenuController?.rootViewController = nav
                
            case 5:
                let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                let nav  = UINavigationController.init(rootViewController: vc)
                self.sideMenuController?.rootViewController = nav
            case 6:
                let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
                let nav  = UINavigationController.init(rootViewController: vc)
                self.sideMenuController?.rootViewController = nav
                
                
            default:
                break
            }
        }
        else if tableView == driverMenu{
            
            switch indexPath.row {
            case 0:
                let fuelings = DriverStoryBoard.instantiateViewController(withIdentifier: "FuelingsToDoViewController") as! FuelingsToDoViewController
                setCenterViewController(controller: fuelings)
            case 1:
                let completedFuelings = DriverStoryBoard.instantiateViewController(withIdentifier: "CompletedFuelViewController") as! CompletedFuelViewController
                setCenterViewController(controller: completedFuelings)
            case 2:
                let help = DriverStoryBoard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                setCenterViewController(controller: help)
            case 3:
                let compensation = DriverStoryBoard.instantiateViewController(withIdentifier: "CompensationViewController") as! CompensationViewController
                setCenterViewController(controller: compensation)
            case 4:
                let rembursement = DriverStoryBoard.instantiateViewController(withIdentifier: "ReimbursmentViewController") as! ReimbursmentViewController
                setCenterViewController(controller: rembursement)
            case 5:
                let settings = DriverStoryBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                setCenterViewController(controller: settings)
            default:
                break
            }
        }


    }
    
}

