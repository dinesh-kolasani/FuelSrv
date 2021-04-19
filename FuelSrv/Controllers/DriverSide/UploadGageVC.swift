//
//  UploadGageVC.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 12/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class UploadGageVC: BaseImageController {
    
    
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var checkButton1: UIButton!
    @IBOutlet weak var checkButton2: UIButton!
    @IBOutlet weak var checkButton3: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var uploadImg: UIImageView!
    
    var orderNum: String?
    var amount: String?
    var tappedBtns: [Int]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uploadView.layer.borderWidth = 1
        self.uploadView.layer.borderColor = #colorLiteral(red: 0.5445346236, green: 0.5897030234, blue: 0.6273978353, alpha: 1)
        self.uploadView.layer.cornerRadius = 5
        print(orderNum)
        print(amount)
    
    }
    
    //MARK:- Button Actions
    @IBAction func backBtn(_ sender: UIButton) {
        
      self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func galleryBtnAction(_ sender: Any) {
        openOptions()
    }
    override func selectedImage(choosenImage: UIImage) {
        uploadImg.image = choosenImage
    }
    
    @IBAction func completeBtnAction(_ sender: Any) {
        if uploadImg.image == UIImage(named: "upload"){
            Helper.Alertmessage(title: "Info:", message: "Please upload gage image", vc: self)
            
        }else if(checkButton1.isSelected == false || checkButton2.isSelected == false){
            Helper.Alertmessage(title: "Info:", message: "Please check all confirmation.", vc: self)
        }
        else{
            
            driverCompleteOrderAPI()
            SVProgressHUD.show()
            SVProgressHUD.setForegroundColor(#colorLiteral(red: 1, green: 0.257971108, blue: 0.1845636666, alpha: 1))
            SVProgressHUD.setBackgroundColor(.clear)
        }
    }
    
    @IBAction func buttonActions(_ sender: UIButton) {
        if sender.tag == 1 {
            if sender.isSelected{
                checkButton1.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
               // tappedBtns?.remove(object: sender.tag)
            }else {
                checkButton1.setImage(#imageLiteral(resourceName: "DriverCheck"), for: .normal)
                //tappedBtns?.append(sender.tag)
            }
            checkButton1.isSelected = !checkButton1.isSelected
        }
        else if sender.tag == 2 {
            if sender.isSelected{
                checkButton2.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                //tappedBtns?.remove(object: sender.tag)
            }else {
                checkButton2.setImage(#imageLiteral(resourceName: "DriverCheck"), for: .normal)
                //tappedBtns?.append(sender.tag)
            }
            checkButton2.isSelected = !checkButton2.isSelected
        }
        else if sender.tag == 3 {
            if sender.isSelected{
                checkButton3.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                //tappedBtns?.remove(object: sender.tag)
            }else {
                checkButton3.setImage(#imageLiteral(resourceName: "DriverCheck"), for: .normal)
               // tappedBtns?.append(sender.tag)
            }
            checkButton3.isSelected = !checkButton3.isSelected
        }
    }
    
    //MARK:- Complete Order
    func driverCompleteOrderAPI(){
        let parameters: [String:Any] = ["driverId": defaultValues.string(forKey: "UserID")!,
                                        "orderId": orderNum!,
                                        "orderTotalAmount": amount!]
        print(parameters)
        
        guard let image1 = self.uploadImg.image else{return}
        guard let imgData1 = UIImageJPEGRepresentation(image1, 0.1) else{return}
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imgData1, withName: "gageImage",fileName: "file.jpg", mimeType: "jpg/png/jpeg")
            for (key, value) in parameters {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                
            }
            
        }, usingThreshold: UInt64.init(),to: driverCompleteOrderURL, method: .post) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    let value = Float(progress.fractionCompleted)*100
                    print(progress.fractionCompleted)
                    print(value)
                    
                })
                upload.responseJSON { response in
                    print("Succesfully uploaded = \(response)")
                    
                    SVProgressHUD.setDefaultMaskType(.clear)
                    SVProgressHUD.dismiss()
                   
                    if let dic = response.result.value as? Dictionary<String, Any>{
                        
                        print(dic)
                        let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Info:", message: dic["message"] as? String, cancelButton: false) {
                            setRoot()
//                            let vc = DriverStoryBoard.instantiateViewController(withIdentifier: "DriverHomeVC") as! DriverHomeVC
//                            self.navigationController?.popToViewController(vc, animated: true)
                            
                        }
                        self.present(alertWithCompletionAndCancel, animated: true)
                        
                    }
                    
                }
                
            case .failure(let encodingError):
                print("Error in upload: \(encodingError.localizedDescription)")
                
            }
            
        }
    }
  

}
