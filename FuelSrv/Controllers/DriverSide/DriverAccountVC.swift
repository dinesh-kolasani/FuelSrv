//
//  DriverAccountVC.swift
//  FuelSrv
//
//  Created by PBS9 on 06/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SDWebImage
import SVProgressHUD

class DriverAccountVC: BaseImageController {

    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var driverNameLbl: UITextField!
    @IBOutlet weak var driverMailLbl: UITextField!
    @IBOutlet weak var driverPhoneNumberLbl: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var changeImgBtn: UIButton!
    @IBOutlet weak var changePasswordBtn: UIButton!
    @IBOutlet weak var deleteAccountBtn: UIButton!
    
    @IBOutlet weak var homeTitleLbl: UILabel!
    @IBOutlet weak var workTitleLbl: UILabel!
    
    @IBOutlet weak var workAddressLbl: UILabel!
    @IBOutlet weak var homeAddressLbl: UILabel!
    @IBOutlet weak var homeAddressBtn: UIButton!
    @IBOutlet weak var workAddressBtn: UIButton!
    
    var GetProfileModelData: GetProfileModel!
    var userData: UserProfile?
    var DeleteAccountModelData: DeleteAccountModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileAPI()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK:- Button Actions
    @IBAction func backBtnAction(_ sender: Any) {
        setRoot()
    }
    @IBAction func editBtnAction(_ sender: UIButton) {
        
        if sender.isSelected {
            editBtn.setTitle("EDIT", for: .normal)
            changeImgBtn.isHidden = true
            driverNameLbl.isEnabled = false
            driverMailLbl.isEnabled = false
            driverPhoneNumberLbl.isEnabled = false
//            homeAddressBtn.isEnabled = false
//            workAddressBtn.isEnabled = false
            updateProfileAPI()
        }else {
            
            editBtn.setTitle("DONE", for: .normal)
            editBtn.setTitleColor(#colorLiteral(red: 0, green: 0.6078431373, blue: 1, alpha: 1), for: .normal)
            editBtn.backgroundColor = UIColor.clear
            changeImgBtn.isHidden = false
            driverNameLbl.isEnabled = true
            driverMailLbl.isEnabled = true
            driverPhoneNumberLbl.isEnabled = true
//            homeAddressBtn.isEnabled = true
//            workAddressBtn.isEnabled = true
            
        }
        editBtn.isSelected = !editBtn.isSelected
    }
    
    @IBAction func changeImgBtnAction(_ sender: Any) {
        openOptions()
    }
    override func selectedImage(choosenImage: UIImage) {
        driverImage.image = choosenImage
    }
    
    @IBAction func homeAddressBtnAction(_ sender: Any) {
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "FinishRegVC") as! FinishRegVC
        vc.value = 2
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func workAddressBtnAction(_ sender: Any) {
        print("work address")
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "FinishRegVC") as! FinishRegVC
        vc.value = 2
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        vc.account = 1
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteAccountBtnAction(_ sender: Any) {
        
        let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Info:", message: "Do you want DELETE your account", cancelButton: true) {
            self.deleteAccountAPI()
            
        }
        
        self.present(alertWithCompletionAndCancel, animated: true)
        
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
                        
                        self.driverNameLbl.text = data.name
                        self.driverMailLbl.text = data.email
                        self.driverPhoneNumberLbl.text = data.phoneNumber
                        
                        let profileImageURL = baseImageURL + data.avatar!
                        if let imageURL = URL(string: profileImageURL)
                        {
                            
                            self.driverImage.layer.borderWidth = 1.0
                            self.driverImage.layer.masksToBounds = false
                            self.driverImage.layer.cornerRadius = self.driverImage.frame.size.width/2
                            self.driverImage.layer.borderColor = #colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1)
                            self.driverImage.layer.backgroundColor = UIColor.clear.cgColor
                            self.driverImage.clipsToBounds = true
                            self.driverImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userBlack"))
                            
                            
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
                    }else{
                        self.homeAddressBtn.isEnabled = true
                        self.homeAddressLbl.text = "Add New"
                        self.workAddressBtn.isEnabled = true
                        self.workAddressLbl.text = "Add New"
                    }
                    
                }else {
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
                
            }else {
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    
    //MARK:- Update Profile API
    func updateProfileAPI(){
        let parameters: [String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        print(parameters)
        
        SVProgressHUD.show()
        
        guard let image1 = self.driverImage.image else{return}
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
                                    
                                    if let imageURL = URL(string: myUrl)
                                    {
                                        print(imageURL)
                                        
                                        //                                                        self.backgroundImage.sd_setShowActivityIndicatorView(true)
                                        //                                                        self.backgroundImage.sd_setIndicatorStyle(.white)
                                        self.driverImage.sd_setImage(with: imageURL, completed: { (img, error, SDImageCacheType, url) in
                                            
                                        })
                                        
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
}
