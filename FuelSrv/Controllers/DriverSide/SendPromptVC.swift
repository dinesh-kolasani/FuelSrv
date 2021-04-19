//
//  SendPromptVC.swift
//  FuelSrv
//
//  Created by PBS9 on 08/07/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class SendPromptVC: UIViewController{

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var detailsTextLbl: UILabel!
    
    @IBOutlet weak var vehicleBtn: UIButton!
    @IBOutlet weak var gasBtn: UIButton!
    @IBOutlet weak var safelyBtn: UIButton!
    
    @IBOutlet weak var safetyBtnLbl: UILabel!
    @IBOutlet weak var profileBGView: UIView!
    @IBOutlet weak var sendBtn: RoundButton!
    
    @IBOutlet weak var swipeView: UIView!
    
    var userId = ""
    var sendPromtData: OrderDetails!
    var tappedButtons = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profileDetails()
        
        Helper.TopedgeviewCorner(viewoutlet: profileBGView, radius: 25)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        // Do any additional setup after loading the view.
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                
                self.dismiss(animated: true, completion: nil)
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
        if tappedButtons.isEmpty == true{

            self.showAlert("Info:", "Please select your issue to send prompt.", "OK")
        }else{
            sendPromptAPI()
        }
    }
    
    @IBAction func buttonActions(_ sender: UIButton) {
        if sender.tag == 1 {
            if sender.isSelected{
                vehicleBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                let objectToRemove = sender.currentTitle ?? ""
                tappedButtons.remove(object: objectToRemove)
            }else {
                vehicleBtn.setImage(#imageLiteral(resourceName: "DriverCheck"), for: .normal)
                tappedButtons.append(sender.titleLabel?.text ?? "")
            }
            vehicleBtn.isSelected = !vehicleBtn.isSelected
        }
        else if sender.tag == 2 {
            if sender.isSelected{
                gasBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                let objectToRemove = sender.currentTitle ?? ""
                tappedButtons.remove(object: objectToRemove)
            }else {
                gasBtn.setImage(#imageLiteral(resourceName: "DriverCheck"), for: .normal)
                tappedButtons.append(sender.titleLabel?.text ?? "")
            }
            gasBtn.isSelected = !gasBtn.isSelected
        }
        else if sender.tag == 3 {
            if sender.isSelected{
                safelyBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                //let objectToRemove = sender.currentTitle ?? ""
                let objectToRemove = safetyBtnLbl.text ?? ""
                tappedButtons.remove(object: objectToRemove)
            }else {
                safelyBtn.setImage(#imageLiteral(resourceName: "DriverCheck"), for: .normal)
                tappedButtons.append(safetyBtnLbl.text ?? "")
                //tappedButtons.append(sender.titleLabel?.text ?? "")
            }
            safelyBtn.isSelected = !safelyBtn.isSelected
        }
    }
    func profileDetails(){
        profilePic.layer.borderWidth = 1.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        profilePic.layer.borderColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
        profilePic.layer.backgroundColor = UIColor.clear.cgColor
        profilePic.clipsToBounds = true
        
        var profileImageURL = ""
        if sendPromtData.userId.isFullUrl == 0{
            profileImageURL = baseImageURL + (sendPromtData.userId.avatar)!
        }else{
            profileImageURL = (sendPromtData.userId.avatar)!
        }
        
        
        if let imageURL = URL(string: profileImageURL) {
            profilePic.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "userwhite"))
        }
        nameLbl.text = sendPromtData.userId.name //data[indexPath.row].userId?.name!
        
        addressLbl.text = sendPromtData.address //data[indexPath.row].address!
        
        let name = sendPromtData.userId.name
       detailsTextLbl.text = "Hi \(name!)! This is your FuelSrv operator, I seem to be having the following issue: "
        
        
    }
    
    //MARK:- Send Prompt API
    func sendPromptAPI(){
        let issues = tappedButtons.joined(separator: "\n")
        
        let params:[String:Any] = ["userId": userId,
                                   "driverId": defaultValues.string(forKey: "UserID")!,
                                   "issue": issues]
        WebService.shared.apiDataPostMethod(url: sendPromptURL, parameters: params) { (response, error) in
            if error == nil{
                if let dict = response {
                    
                    Helper.Alertmessage(title: "Info:", message: dict["message"] as! String, vc: self)
                    //self.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true) {
                        setRoot()
                    }
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
