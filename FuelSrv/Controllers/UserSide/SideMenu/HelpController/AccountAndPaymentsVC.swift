//
//  AccountAndPaymentsVC.swift
//  FuelSrv
//
//  Created by PBS9 on 26/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AccountAndPaymentsVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var doneBtn: UIButton!
    var vcCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        if (Helper.shared.isFieldEmpty(field: textView.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Text", vc: self)
        }else{
            contactMeAPI()
        }
        
    }
    
    func navigation(){
        
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.6235294118, alpha: 1)
        textView.layer.borderWidth = 3
        textView.dropShadow(view: textView, opacity: 0.5)
        textView.clipsToBounds = true
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let imgBack = UIImage(named: "back")
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(backAction))
        if vcCount == 1{
            self.navigationItem.title = "REPORT AN ISSUE"
            titleLbl.text = "Please let us know what's wrong, we'll be in touch by e-mail to reply:"
        }else if vcCount == 2{
            self.navigationItem.title = "ACCOUNT AND PAYMENTS"
            titleLbl.text = "Let us know how we can help with your account or payments, please describe your issue or inquiry and we'll be in touch by e-mail to reply:"
        }
        
    }
    @objc func backAction(){
       
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
        
    }
    func contactMeAPI(){
       let params:[String:Any] = ["phoneNumber": defaultValues.string(forKey: "Phone")!,
                                  "name": defaultValues.string(forKey: "UserName")!,
                                  "email": defaultValues.string(forKey: "UserEmail")!,
                                  "message": textView.text!]
        WebService.shared.apiDataPostMethod(url: contactMeURL, parameters: params) { (responce, error) in
            if error == nil{
                if let dict = responce{
                   self.showAlert("Info:", dict["message"] as! String , "OK")
                }
            }else{
                self.showAlert("Info:", error?.localizedDescription ?? "", "OK")
            }
        }
    }
}
