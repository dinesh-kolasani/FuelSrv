//
//  VehicleRegistrationVC.swift
//  FuelSrv
//
//  Created by PBS9 on 22/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import Alamofire

class VehicleRegistrationVC: BaseImageController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraBtnBGView: RoundedView!    
    @IBOutlet weak var galleryBtnBGView: RoundedView!
    @IBOutlet weak var nextBtn: RoundButton!
    
    var img1: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextBtnAction(_ sender: Any) {
        if imageView.image == UIImage(named: "upload"){
            Helper.Alertmessage(title: "Info:", message: "Please upload Vehicle Registration", vc: self)
            
        }else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VehicleInsuranceVC") as! VehicleInsuranceVC
            vc.image1 = img1
            vc.image2 = imageView.image
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func galleryBtnAction(_ sender: Any) {
        openOptions()
    }
    
    func navigation(){
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "VEHICLE REGISTRATION"
    }
    override func selectedImage(choosenImage: UIImage) {
        imageView.image = choosenImage
    }
    

}
