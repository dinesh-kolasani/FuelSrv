//
//  ConfirmVC.swift
//  FuelSrv
//
//  Created by PBS9 on 17/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class ConfirmVC: UIViewController {
    
    @IBOutlet weak var applyBtn: RoundButton!
    var drivingLicenceImg: UIImage!
    var vehicleRegistrationImg: UIImage!
    var vehicleInsuranceImg: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func nextBtn(_ sender: Any) {
        uploaddriverDocumentsAPI()
    }
    func navigation(){
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "CONFIRM"
    }
    func uploaddriverDocumentsAPI()
    {
        SVProgressHUD.show()
        let parameters: [String:Any] = ["userId":defaultValues.string(forKey: "UserID")!]
        print(parameters)
        
                guard let image1 = self.drivingLicenceImg else{return}
                guard let image2 = self.vehicleRegistrationImg else{return}
                guard let image3 = self.vehicleInsuranceImg else{return}
        
//        let image1 = #imageLiteral(resourceName: "Google@")
//        let image2 = #imageLiteral(resourceName: "picture")
//        let image3 = #imageLiteral(resourceName: "checkbox-activated@")
        
        guard let imgData1 = UIImageJPEGRepresentation(image1, 0.1) else{return}
        guard let imgData2 = UIImageJPEGRepresentation(image2, 0.1) else{return}
        guard let imgData3 = UIImageJPEGRepresentation(image3, 0.1) else{return}
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imgData1, withName: "drivingLicence",fileName: "file.jpg", mimeType: "jpg/png/jpeg")
            multipartFormData.append(imgData2, withName: "vehicleRegistration",fileName: "file.jpg", mimeType: "jpg/png/jpeg")
            multipartFormData.append(imgData3, withName: "vehicleInsurance",fileName: "file.jpg", mimeType: "jpg/png/jpeg")
            
            for (key, value) in parameters
            {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
        }, usingThreshold: UInt64.init(), to: uploaddriverDocumentsURL, method: .post, headers: nil) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("proses", progress.fractionCompleted)
                    
                })
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let dic = response.result.value as? Dictionary<String, Any>{
                        SVProgressHUD.dismiss()
                        print(dic)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
                        self.navigationController?.pushViewController(vc, animated:true)
                        
                    }
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                
            }
        }
    }
}
