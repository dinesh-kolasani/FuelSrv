//
//  ReferralCodeVC.swift
//  FuelSrv
//
//  Created by PBS9 on 02/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import SkyFloatingLabelTextField

class ReferralCodeVC: UIViewController {

    @IBOutlet weak var referCodeTF: SkyFloatingLabelTextField!
    @IBOutlet weak var applyBtn: RoundButton!
    
    var referralCodeModelData: ReferralCodeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigation()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    //MARK:- Button Action
    @IBAction func applyBtn(_ sender: Any) {
        if referCodeTF.text != ""{
            referralCodeAPI()
        }else{
            showAlert("Info:", "Please enter referral code", "OK")
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func skipBtnAction(_ sender: Any) {
//        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        let nav = NavigationController.init(rootViewController: vc)
//        self.sideMenuController?.rootViewController = nav
        appDelegate.configureSideMenu()
    }
    
    
    
    //MARK:- Navigation
    func navigation(){
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
       
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipAction))
    }
    
    @objc func skipAction(){
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC")as! HomeVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
        
    }
    // MARK: - API
    func referralCodeAPI(){
        
        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!,
                                   "referralCode":referCodeTF.text!]
        
        WebService.shared.apiDataPostMethod(url: referralCodeURL, parameters: params) { (response, error) in
            if error == nil{
                self.referralCodeModelData = Mapper<ReferralCodeModel>().map(JSONObject: response)
                
                if self.referralCodeModelData.success == true{
                    
                    appDelegate.configureSideMenu()
                    
//                    let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                    let nav = NavigationController.init(rootViewController: vc)
//                    self.sideMenuController?.rootViewController = nav
                    
//                    let navVC = UINavigationController.init(rootViewController: vc)
//                    navVC.setNavigationBarHidden(true, animated: true)
//                    if let window = UIApplication.shared.windows.first
//                    {
//                        window.rootViewController = navVC
//                        window.makeKeyAndVisible()
//                    }
                }else if self.referralCodeModelData.success == false{
                    Helper.Alertmessage(title: "Notification", message: self.referralCodeModelData.message ?? "", vc: self)
                    
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
