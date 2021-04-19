//
//  UserAccountVC.swift
//  FuelSrv
//
//  Created by PBS9 on 16/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SDWebImage
import SVProgressHUD

class UserAccountVC: BaseImageController,UIPopoverPresentationControllerDelegate {
    
    var GetProfileModelData: GetProfileModel!
    var userData: UserProfile?
    var uservehicleData: [GetAllVehicle]?
    var DeleteAccountModelData: DeleteAccountModel!
    var vehicleDetails: [String:Any] = [:]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var userImageView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UITextField!
    @IBOutlet weak var userMailLbl: UITextField!
    @IBOutlet weak var userPhoneNumberLbl: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var changeImgBtn: UIButton!
    @IBOutlet weak var changePasswordBtn: UIButton!
    @IBOutlet weak var deleteAccountBtn: UIButton!
    
    
//    @IBOutlet weak var membershipView: RoundedView!
//    @IBOutlet weak var membershipTypeLbl: UILabel!
//    @IBOutlet weak var membershipPriceLbl: UILabel!
//    @IBOutlet weak var membershipMenuDotsBtn: UIButton!
//    @IBOutlet weak var addMembershipBtn: UIButton!
    
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var workAddressLbl: UILabel!
    @IBOutlet weak var homeAddressLbl: UILabel!
    @IBOutlet weak var homeAddressBtn: UIButton!
    @IBOutlet weak var workAddressBtn: UIButton!
    
    @IBOutlet weak var homeTitleLbl: UILabel!
    
    @IBOutlet weak var workTitleLbl: UILabel!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var vcHight: NSLayoutConstraint!
    //var noOfVehicle = String()
    
    var tappedButtonsTag: Int!
    var vehicle: String?
    var value: Bool!
    var vehicleId: String?
    var picker  = UIPickerView()
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //vcHight.constant = UIScreen.main.bounds.height
//        self.userImageView.layer.borderWidth = 1.0
//        self.userImageView.layer.masksToBounds = false
//        self.userImageView.layer.cornerRadius = self.userImage.frame.size.width/2
//        self.userImageView.layer.borderColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
//        self.userImageView.layer.backgroundColor = UIColor.clear.cgColor
//        self.userImageView.clipsToBounds = true
//        membershipView.dropShadow(view: membershipView, opacity: 0.7)
        
        navigation()
        getProfileAPI()
        
        
        let nibSec = UINib.init(nibName: "OrderReviewSecCell", bundle: nil)
        tableView.register(nibSec, forCellReuseIdentifier: "OrderReviewSecCell")
        
        let nib = UINib.init(nibName: "UserAccountCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserAccountCell")
        tableView.tableFooterView = footerView
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVc), name:.userAccountVC, object: nil)

        // Do any additional setup after loading the view.
    }
    @objc func reloadVc()
    {
        getProfileAPI()
    }
    
    //MARK:- View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    //MARK:- Button Actions
    @IBAction func editBtnAction(_ sender: UIButton) {
        
        if sender.isSelected {
            editBtn.setTitle("EDIT", for: .normal)
            changeImgBtn.isHidden = true
            userNameLbl.isEnabled = false
            userMailLbl.isEnabled = false
            userPhoneNumberLbl.isEnabled = false
//            homeAddressBtn.isEnabled = false
//            workAddressBtn.isEnabled = false
            updateProfileAPI(parameters: ["userId": defaultValues.string(forKey: "UserID")!,
                                          "email": userMailLbl.text ?? "",
                                          "phoneNumber": userPhoneNumberLbl.text ?? "",
                                          "name": userNameLbl.text ?? "",
                                          "isFullUrl":"0"])
        }else {

            editBtn.setTitle("Update", for: .normal)
            editBtn.setTitleColor(#colorLiteral(red: 0, green: 0.6078431373, blue: 1, alpha: 1), for: .normal)
            editBtn.backgroundColor = UIColor.clear
            changeImgBtn.isHidden = false
            userNameLbl.isEnabled = true
            userMailLbl.isEnabled = true
            userPhoneNumberLbl.isEnabled = true
//            homeAddressBtn.isEnabled = true
//            workAddressBtn.isEnabled = true
            
        }
        editBtn.isSelected = !editBtn.isSelected
    }
    
    @IBAction func changeImgBtnAction(_ sender: Any) {
        openOptions()
    }
    override func selectedImage(choosenImage: UIImage) {
        userImage.image = choosenImage
    }
    
    @IBAction func homeAddressBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishRegVC") as! FinishRegVC
        vc.value = 2
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func workAddressBtnAction(_ sender: Any) {
        print("work address")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishRegVC") as! FinishRegVC
        vc.value = 2
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteAccountBtnAction(_ sender: Any) {
        deleteAction()
//        let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Info:", message: "Do you want DELETE your account", cancelButton: true) {
//            self.deleteAccountAPI()
//        }
//         self.present(alertWithCompletionAndCancel, animated: true)
    }
    
    @IBAction func addMembershipBtnAction(_ sender: Any) {

        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "MembershipVC") as! MembershipVC
        membership = 1
        self.navigationController?.pushViewController(vc, animated: true)
//        let nav = NavigationController.init(rootViewController: vc)
//        self.sideMenuController?.rootViewController = nav
    }
    func deleteAction() {
        let alert = UIAlertController(title: "Notification", message: "Are you sure you’d like to delete your account?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "DELETE",style: UIAlertActionStyle.destructive,handler: {(_: UIAlertAction!) in
            //Sign out action
            self.deleteAccountAPI()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:- Navigation
    func navigation(){

        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "ACCOUNT"
        
        if value == true{
            let imgBack = UIImage(named: "back")
            navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(backAction))
        }
    }
    @objc func backAction(){
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")as! HomeVC
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    @objc func cancelMembershipAction() {
        let alert = UIAlertController(title: "Cancel Membership", message: "Do you want to cancel your Membership?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",style: UIAlertActionStyle.destructive,handler: {(_: UIAlertAction!) in
            //Okay action
            self.cancelMembershipAPI()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    //MARK:- Get Profile API
    func getProfileAPI(){
        
        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        
        WebService.shared.apiDataPostMethod(url: getProfileURL, parameters: params) { (responce, error) in
            if error == nil {
                self.GetProfileModelData = Mapper<GetProfileModel>().map(JSONObject: responce)
                
                if self.GetProfileModelData.success == true {
                    
                    if let data = self.GetProfileModelData.userdata?.user{
                        self.userData = data
                        
                        self.userNameLbl.text = data.name
                        self.userMailLbl.text = data.email
                        if let phone = data.phoneNumber, phone == ""{
                            self.userPhoneNumberLbl.text = "No Phone number specified yet"
                        }else{
                            self.userPhoneNumberLbl.text = data.phoneNumber  // No address specified yet
                        }
        
                        noOfVehicle = data.vehicleCount ?? "1 - 10"
                        
//                        if data.membershipAmount != 0{
//                            if data.isMembershipTaken == 1 {
//                                
//                                self.membershipTypeLbl.text = data.membershipType
//                                self.membershipPriceLbl.text = self.currencyFormat(String(describing: data.membershipAmount!)) + "/" + String(describing: data.membershipType!)
//                                self.membershipMenuDotsBtn.addTarget(self, action: #selector(self.cancelMembershipAction), for: .touchUpInside)
//                            }else{
//                                self.addMembershipBtn.isHidden = false
//                                self.addMembershipBtn.setTitle("+ Add Membership", for: .normal)
//                            }
//                            
//                        }else{
//                            //self.membershipTypeLbl.text = "No membership selected"
//                            self.addMembershipBtn.isHidden = false
//                            self.addMembershipBtn.setTitle("+ Add Membership", for: .normal)
//                        }
                       
                        
                        let profileImageURL = baseImageURL + data.avatar!
                        if let imageURL = URL(string: profileImageURL) {
                            
                            //self.userImage.layer.borderWidth = 1.0
                            self.userImage.layer.masksToBounds = false
                            self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2
                            //self.userImage.layer.borderColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
                            self.userImage.layer.backgroundColor = UIColor.clear.cgColor
                            self.userImage.clipsToBounds = true
                            
                            if self.GetProfileModelData.userdata?.user?.isFullUrl == 1 {
                                
                                self.userImage.sd_setImage(with: URL(string: data.avatar ?? ""), placeholderImage: UIImage(named: "userBlack"))
                            }else{
                                self.userImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userBlack"))
                            }
                        }
                        
                    }
                    
                    if let home = self.GetProfileModelData.userdata?.address, home.count != 0{
                        self.homeTitleLbl.text = home[0].addressTitle ?? "Address"
                        self.homeAddressLbl.text = home[0].userAddress
                        self.homeAddressBtn.isEnabled = false
                        self.workAddressBtn.isEnabled = true
                        self.workTitleLbl.text = "Address"
                        if home.count > 1{
                            self.workTitleLbl.text = home[1].addressTitle ?? "Address"
                            self.workAddressLbl.text = home[1].userAddress
                            self.workAddressBtn.isEnabled = false
                        }
//                        if home.count <= 2{
//                            self.workAddressLbl.text = home[1].userAddress
//                        }
//                        if let data = home[1].userAddress, data != "" {
//                            self.workAddressLbl.text = home[1].userAddress
//                        }else{
//                            self.workAddressLbl.text = "Tap to change your work address"
//                        }
                    }else{
                        self.homeAddressBtn.isEnabled = true
                        self.homeAddressLbl.text = "Add New"
                        self.workAddressBtn.isEnabled = true
                        self.workAddressLbl.text = "Add New"
                    }
                    
                    if let data = self.GetProfileModelData.userdata?.uservehicle, data.count > 0 {
                        
                        self.uservehicleData = self.GetProfileModelData.userdata?.uservehicle
                        //self.tableHeight.constant = CGFloat(data.count * 65)
                        //self.tableHeight.constant = CGFloat(self.uservehicleData!.count * 65) + CGFloat (40)
                        self.tableView.reloadData()
                    }
                    else if defaultValues.integer(forKey: "AccountType") == 1{
                       
                        self.userData = self.GetProfileModelData.userdata?.user
                        self.tableView.reloadData()
                    }
                    else{
                        self.uservehicleData = self.GetProfileModelData.userdata?.uservehicle
                         self.tableView.reloadData()
                    }
                    
                }else {
                    Helper.Alertmessage(title: "Info:", message: self.GetProfileModelData.message ?? "", vc: self)
                }
                
            }else {
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    //MARK:- Delete Account API
    func deleteAccountAPI(){
        
         let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        
        WebService.shared.apiDataPostMethod(url: deleteAccountURL, parameters: params) { (responce, error) in
            if error == nil {
                 self.DeleteAccountModelData = Mapper<DeleteAccountModel>().map(JSONObject: responce)
                
                if self.DeleteAccountModelData.success == true {
                    
                    
                    let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Notification", message: self.DeleteAccountModelData.message ?? "", cancelButton: false) {
                        
                        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                        let nav = NavigationController.init(rootViewController: vc)
                        self.sideMenuController?.rootViewController = nav
                        
                    }
                    
                    self.present(alertWithCompletionAndCancel, animated: true)
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: self.DeleteAccountModelData.message ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    
    //MARK:- Update Profile API
    func updateProfileAPI(parameters: [String:Any]){
        //let parameters: [String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        print(parameters)
        
        SVProgressHUD.show()
        
        guard let image1 = self.userImage.image else{return}
        guard let imgData1 = UIImageJPEGRepresentation(image1, 0.1) else{return}
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
             multipartFormData.append(imgData1, withName: "avatar",fileName: "file.jpg", mimeType: "jpg/png/jpeg")
            for (key, value) in parameters {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                
            }
   
        }, usingThreshold: UInt64.init(),to: updateProfileURL, method: .post) { (result) in
                            switch result {
                            case .success(let upload, _, _):
                                upload.uploadProgress(closure: { (progress) in
                                    let value = Float(progress.fractionCompleted)*100
                                    print(progress.fractionCompleted)
                                    print(value)

                                })
                                upload.responseJSON { response in
                                    print("Succesfully uploaded = \(response)")
                                    
                                    if let dic = response.result.value as? Dictionary<String, Any>{

                                        print(dic)

                                        DispatchQueue.main.async
                                            {
                                                SVProgressHUD.dismiss()

                                                let  imageData = dic["data"] as? [String:Any]

                                                if let backgroundImage = imageData?["avatar"] as? String
                                                {
                                                    let myUrl = baseImageURL + backgroundImage
                                                    defaultValues.set(backgroundImage, forKey: "avatar")
                                                    defaultValues.synchronize()
                                                    if let imageURL = URL(string: myUrl)
                                                    {
                                                        print(imageURL)
                                                        defaultValues.set(imageData?["avatar"], forKey: "avatar")
                                                        self.userNameLbl.text = imageData?["name"] as? String
                                                        defaultValues.synchronize()
//                                                        self.backgroundImage.sd_setShowActivityIndicatorView(true)
//                                                        self.backgroundImage.sd_setIndicatorStyle(.white)
                                                        self.userImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userBlack"))
//                                                        self.userImage.sd_setImage(with: imageURL, completed: { (img, error, SDImageCacheType, url) in
//
//                                                        })

                                                    }

                                                }
                                                let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Info:", message: dic["message"] as? String, cancelButton: false) {

                                                    //_ = self.navigationController?.popViewController(animated: true)

                                                }
                                                self.present(alertWithCompletionAndCancel, animated: true)

                                        }

                                    }
                                    
                                }
                            case .failure(let encodingError):
                                print("Error in upload: \(encodingError.localizedDescription)")
                                
                            }
                            
        }
    }
    //MARK:- Update Vehicle Count API
    func updateVehicleCountAPI(parameters: [String:Any]){
        print(parameters)
        
        SVProgressHUD.show()
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(),to: updateProfileURL, method: .post) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    let value = Float(progress.fractionCompleted)*100
                    print(progress.fractionCompleted)
                    print(value)
                    
                })
                upload.responseJSON { response in
                    print("Succesfully uploaded = \(response)")
                    
                    if let dic = response.result.value as? Dictionary<String, Any>{
                        
                        print(dic)
                        
                        DispatchQueue.main.async
                            {
                                SVProgressHUD.dismiss()
                                
                                let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Info:", message: dic["message"] as? String, cancelButton: false) {
                                    
                                    //_ = self.navigationController?.popViewController(animated: true)
                                    
                                }
                                self.present(alertWithCompletionAndCancel, animated: true)
                            }
                     }
                 }
            case .failure(let encodingError):
                print("Error in upload: \(encodingError.localizedDescription)")
            }
        }
    }
    func cancelMembershipAPI (){
        
        let parameters: [String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        
        WebService.shared.apiDataPostMethod(url: cancelMembershipURL, parameters: parameters) { (responce, error) in
            if error == nil {
                if let dict = responce {
                    Helper.Alertmessage(title: "Info:", message: dict["message"] as! String, vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    func deleteAPI(url: String, params:[String:Any]){
        
        //let params:[String:Any] = ["vehicleId": "5ce05bfc49fb1626b260da17"]
        
        WebService.shared.apiDataPostMethod(url: url, parameters: params) { (responce, error) in
            if error == nil {
                if let dic = responce {
                    print(dic)
                    Helper.Alertmessage(title: "Info:", message: dic["message"] as! String, vc: self)
                        self.getProfileAPI()
                }
                
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    //MARK:- Menu Dots Action
    @objc func memuDotsBtnAction(sender: UIButton) {
        let alert = UIAlertController(title: "Info:", message: "Choose your actions", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            print("You've pressed Cancel")
        }))
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            print("You've pressed Edit")
            if (self.uservehicleData!.count > sender.tag){
                let vehicleModel = self.uservehicleData![sender.tag]
                //self.vehicleId = scheduleModel.id
                self.vehicleDetails[MyVehicleEnum.Fuel.rawValue] = vehicleModel.fuel
                self.vehicleDetails[MyVehicleEnum.vehicleID.rawValue] = vehicleModel.id
                self.vehicleDetails[MyVehicleEnum.Year.rawValue] = vehicleModel.year
                self.vehicleDetails[MyVehicleEnum.Make.rawValue] = vehicleModel.make
                self.vehicleDetails[MyVehicleEnum.Model.rawValue] = vehicleModel.model
                self.vehicleDetails[MyVehicleEnum.Color.rawValue] = vehicleModel.color
                self.vehicleDetails[MyVehicleEnum.LicensePlate.rawValue] = vehicleModel.licencePlate
                appDelegate.orderDataDict[OrderDataEnum.Vehicle.rawValue] = self.vehicleDetails
                
            }
            
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
            print(self.vehicleDetails)
            vc.value = 3
            let nav  = UINavigationController.init(rootViewController: vc)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            
            if (self.uservehicleData!.count > sender.tag){
                let scheduleModel = self.uservehicleData![sender.tag]
                self.vehicleId = scheduleModel.id
            }
            
            self.deleteAPI(url: deleteVehicleURL, params: ["vehicleId": self.vehicleId!])
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
extension  Notification.Name
{
    static let userAccountVC = Notification.Name("reload")
    static let ScheduledFuelingsVC = Notification.Name("reload")
    
}
//MARK:- Creating TableView

extension UserAccountVC: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "OrderReviewSecCell") as! OrderReviewSecCell
        if defaultValues.integer(forKey: "AccountType") == 0{
            
            headerView.ORTitleLabel.text = "Vehicles"
            headerView.ORTitleLabel.textColor = #colorLiteral(red: 0.1960784314, green: 0.2235294118, blue: 0.2509803922, alpha: 1)
            headerView.headerLeading.constant = 16
            headerView.btn.setTitle("+Add Vehicles", for: .normal)
            headerView.btn.setTitleColor(#colorLiteral(red: 0, green: 0.6078431373, blue: 1, alpha: 1), for: .normal)
            headerView.btn.addTarget(self, action: #selector(addVehicle), for: .touchUpInside)
        }else{
            headerView.ORTitleLabel.text = "Approx. Number of vehicles: "
            headerView.ORTitleLabel.textColor = #colorLiteral(red: 0.1960784314, green: 0.2235294118, blue: 0.2509803922, alpha: 1)
            //headerView.btn.setTitle("Change here", for: .normal)
            //headerView.btn.addTarget(self, action: #selector(showPopover(base:)), for: .touchUpInside)
            headerView.btn.isHidden = true
        }
        return headerView
    }
    @objc func addVehicle(){
        
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
        vc.value = 2
        let nav  = UINavigationController.init(rootViewController: vc)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if uservehicleData != nil{
            
//                errorLbl.isHidden = true
            if uservehicleData?.count ?? 0 > 0{
                 return uservehicleData?.count ?? 0
            }else{
//                errorLbl.isHidden = false
//                errorLbl.text = "No Vehicles found"
                return 1
            }
        }else{
            if defaultValues.integer(forKey: "AccountType") == 1 {
//                errorLbl.isHidden = true
            }else{
//                errorLbl.isHidden = false
//                errorLbl.text = "No Vehicles found"
                return 1
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "UserAccountCell", for: indexPath) as! UserAccountCell
        if defaultValues.integer(forKey: "AccountType") == 0 {
            
            if let data = uservehicleData, data.count > indexPath.row{
                cell.errorLbl.text = ""
                cell.cellView.isHidden = false
                cell.vehicleDetailsLbl.text = String(describing: data[indexPath.row].year!) + " " + String(describing: data[indexPath.row].model!) + "," + " " + String(describing: data[indexPath.row].color!) + " " + String(describing: data[indexPath.row].licencePlate!) //" " + String(describing: data[indexPath.row].make!) +
                cell.vehicleBtn.isHidden = false
                cell.vehicleBtn.tag = indexPath.row
                cell.vehicleBtn.addTarget(self, action: #selector(memuDotsBtnAction), for: .touchUpInside)
                //cell.vehicleBtn.addTarget(self, action: #selector(showPopover), for: .touchUpInside)
            }else{
                cell.cellView.isHidden = true
                cell.errorLbl.text = "No Vehicles found"
            }
        }else{
            cell.vehicleBtn.isHidden = false
            cell.vehicleDetailsLbl.text = noOfVehicle
            cell.vehicleBtn.addTarget(self, action: #selector(Vehicles), for: .touchUpInside)
            //cell.vehicleBtn.addTarget(self, action: #selector(showPopover), for: .touchUpInside)
        }
        return cell
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    @objc func showPopover(base: UIView) {
        tappedButtonsTag = base.tag
        if defaultValues.integer(forKey: "AccountType") == 0 {
            if (uservehicleData!.count > base.tag){
                let vehicleModel = uservehicleData![base.tag]
                self.vehicle = vehicleModel.id
            }
        }
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PopVC") as! PopVC
        
        viewController.VC = 1
            viewController.vehicleId = vehicle
            viewController.modalPresentationStyle = .popover
            if defaultValues.integer(forKey: "AccountType") == 0 {
                
                viewController.preferredContentSize = CGSize(width: 150, height: 90)
                
            }else{
                
                viewController.preferredContentSize = CGSize(width: 200, height: 220)
            }
            if let pctrl = viewController.popoverPresentationController {
                pctrl.delegate = self
                pctrl.sourceView = base
                pctrl.sourceRect = base.bounds

                self.present(viewController, animated: true, completion: nil)
            }
        }
    @objc func Vehicles(){
        picker = UIPickerView.init()
        self.picker.delegate = self
        self.picker.dataSource = self
        picker.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        picker.setValue(#colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1), forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.showsSelectionIndicator = true
        picker.layer.cornerRadius = 5
        picker.dropShadow(view: picker, opacity: 1.0)
        picker.frame = CGRect.init(x: 50, y: UIScreen.main.bounds.size.height - 350, width: UIScreen.main.bounds.size.width - 95, height: 150)
        self.view.addSubview(picker)
        
        
    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        //footerView.isHidden = false
//        let viewfooter = footerView
//        
//        return viewfooter
//    }
}

//MARK:- Picker view
extension UserAccountVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return approxNoOfVehicles.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return approxNoOfVehicles[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        noOfVehicle = approxNoOfVehicles[row]
        self.tableView.reloadData()
        picker.removeFromSuperview()
        self.updateVehicleCountAPI(parameters: ["userId": defaultValues.string(forKey: "UserID")!,
                                           "vehicleCount": noOfVehicle])
    }
}
