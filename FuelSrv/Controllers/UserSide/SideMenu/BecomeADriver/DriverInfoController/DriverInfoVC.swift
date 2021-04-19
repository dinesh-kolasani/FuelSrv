//
//  DriverInfoVC.swift
//  FuelSrv
//
//  Created by PBS9 on 22/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

class DriverInfoVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userMailLbl: UILabel!
    @IBOutlet weak var userPhoneNumberLbl: UILabel!
    
    @IBOutlet weak var nextBtn: RoundButton!
    
    var GetProfileModelData: GetProfileModel!
    var userData: UserProfile!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        getProfileAPI()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAccountVC") as! UserAccountVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverLicenseVC") as! DriverLicenseVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func navigation(){
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "DRIVER INFO"
        
    }
    
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
                        self.userPhoneNumberLbl.text = data.phoneNumber
                        let profileImageURL = baseImageURL + data.avatar!
                        if let imageURL = URL(string: profileImageURL)
                        {
                            
                            self.userImage.layer.borderWidth = 1.0
                            self.userImage.layer.masksToBounds = false
                            self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2
                            self.userImage.layer.borderColor = UIColor.green.cgColor
                            self.userImage.clipsToBounds = true
                            self.userImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "user-shape"))
                            
                        }
                        
                    }
                }else {
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }

            }else {
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    

}
