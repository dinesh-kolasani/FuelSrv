//
//  DriverProfileVC.swift
//  FuelSrv
//
//  Created by PBS9 on 15/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import SDWebImage

class DriverProfileVC: UIViewController {
    @IBOutlet weak var driverProfileIMG: UIImageView!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var startedLbl: UILabel!
    @IBOutlet weak var noOfFuelingsLbl: UILabel!
    @IBOutlet weak var bioGraphyText: UITextView!
    
    var profileName: String?
    var profileStarted: String?
    var biographie: String?
    var noOfFuelings: Int?
    var profileImg: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        profileDetails()

        // Do any additional setup after loading the view.
    }
    
    func navigation(){
    
    navigationItem.leftItemsSupplementBackButton = true
    navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    self.navigationItem.title = "DRIVER PROFILE"
    }
    func profileDetails(){
        
        driverNameLbl.text = profileName
        if let deleverDate = profileStarted, deleverDate != "" {
            
            //mark:- converting longdate into Date format
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "EEE, MMM dd, yyyy"
            let datee = dateFormatterGet.date(from: deleverDate)
            let dateObj =  dateFormatterPrint.string(from: datee ?? Date())
            startedLbl.text = dateObj
            
        }else{
            startedLbl.text = "FurlSrv"
        }

        noOfFuelingsLbl.text = String(describing: noOfFuelings!)
        if biographie == "" {
            bioGraphyText.text = "FuelSrv"
        }else{
            bioGraphyText.text = biographie
        }
        
        
        
        //        profileIMG.sd_setImage(with: URL(string: userphoto), placeholderImage: UIImage(named: "placeholder"))
        
        
        
        let profileImageURL = baseImageURL + profileImg!
        
        if let imageURL = URL(string: profileImageURL)
        {
            
            self.driverProfileIMG.layer.borderWidth = 1.0
            self.driverProfileIMG.layer.masksToBounds = false
            self.driverProfileIMG.layer.cornerRadius = self.driverProfileIMG.frame.size.width/2
            self.driverProfileIMG.layer.borderColor = UIColor.green.cgColor
            self.driverProfileIMG.clipsToBounds = true
            
            //                self.profileIMG.sdsetShowActivityIndicatorView(true)
            //                self.profileIMG.sdsetIndicatorStyle(.gray)
            
            driverProfileIMG.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
            
        }
    }
}
