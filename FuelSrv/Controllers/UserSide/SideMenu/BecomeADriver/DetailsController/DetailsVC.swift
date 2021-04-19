//
//  DetailsVC.swift
//  FuelSrv
//
//  Created by PBS9 on 17/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iAgreeBtn: UIButton!
    
    @IBOutlet weak var nextBtn: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button actions
    @IBAction func iAgreeBtn(_ sender: Any) {
        if iAgreeBtn.isSelected {
            iAgreeBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
        }else{
            iAgreeBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
        }
        iAgreeBtn.isSelected = !iAgreeBtn.isSelected
        
        
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if iAgreeBtn.isSelected == true{
            checkUserVerification()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverInfoVC") as! DriverInfoVC
//        self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.showAlert("Info:", "Please check I Agree to continue.", "OK")
        }
    }
    //MARK:- Navigation Bar
    func navigation(){
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "DETAILS"
        
        
        let imgBack = UIImage(named: "back")
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(backAction))
    }
    @objc func backAction(){
        
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
    }
    func checkUserVerification(){
        
        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]

        WebService.shared.apiDataPostMethod(url: checkUserVerificationURL, parameters: params)  { (response, error) in
            if error == nil{
                if let dict = response {
                    if dict["isVerified"] as! Int == 0  && profileCompleted == 0{ //isProfilecompleted
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverInfoVC") as! DriverInfoVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
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
