//
//  CheckOutVC.swift
//  FuelSrv
//
//  Created by PBS9 on 24/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import Stripe

class CheckOutVC: UIViewController {

    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var lastFourDigitsLbl: UILabel!
    @IBOutlet weak var cardHolderNameLbl: UILabel!
    @IBOutlet weak var expiryDateLbl: UILabel!
    @IBOutlet weak var cvvNumberTextFeild: UITextField!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var membershipFeeLbl: UILabel!
    @IBOutlet weak var taxPriceLbl: UILabel!
    @IBOutlet weak var grandTotalPriceLbl: UILabel!
    
    @IBOutlet weak var paymentBtn: RoundButton!
    
    @IBOutlet weak var vcHeight: NSLayoutConstraint!
    var paymentDetails = appDelegate.orderDataDict["Payment"] as? [String : String] ?? [:]
    var membershipDetails = appDelegate.orderDataDict["Membership"] as? [String : String] ?? [:]
    var expiryDate: String!
    var cvv = String()
    var paymentToken: String?
    var taxAmount: Double = 0.0
    var totalAmount = Int()
    var grandTotalAmount: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        print(paymentDetails)
        print(membershipDetails)
        vcHeight.constant = UIScreen.main.bounds.height
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .userAccountVC, object: nil)
        
    }

    @IBAction func paymentBtnAction(_ sender: Any) {
       // backTwo()
        if Helper.shared.isFieldEmpty(field:cvvNumberTextFeild.text!) {
            showAlert("Notification", "Please Enter CVV number", "OK")
        }else if cvvNumberTextFeild.text?.count == 3{
            cardValidity()
        }
     }
    
    //MARK:- Navigation setup
    func navigation (){
        cardView.dropShadow(view: cardView, opacity: 0.5)
        paymentBtn.dropShadow(view: paymentBtn, opacity: 0.4)
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "CHECKOUT"
        
        cardDetails()
        
    }
    //MARK:- Card Details
    func cardDetails(){
        
        let cardBrand = STPCardValidator.brand(forNumber: paymentDetails["CardNumber"] ?? "")
        let cardImage = STPImageLibrary.brandImage(for: cardBrand)
        cardImg.image = cardImage
        
        cardHolderNameLbl.text = paymentDetails["CardHolderName"]
        lastFourDigitsLbl.text = paymentDetails["CardLastFourDigits"]
        
        //mark:- converting longdate into Date format
        let milisecond = Int(paymentDetails["ExpiryDate"] ?? "") ?? 0
        let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        
        expiryDateLbl.text = "\(dateFormatter.string(from: dateVar))"
        self.expiryDate = "\(dateFormatter.string(from: dateVar))"
        
        membershipFeeLbl.text = currencyFormat(membershipDetails["Amount"])
        totalAmount = Int(truncating:numberFormat(membershipDetails["Amount"]))
        taxAmount = (Double(totalAmount) * 0.12)
        taxPriceLbl.text = currencyFormat(String(describing: taxAmount))
        grandTotalAmount = Double(truncating: numberFormat(String(describing: totalAmount))) + Double(truncating: numberFormat(String(describing: taxAmount)))
        grandTotalPriceLbl.text = currencyFormat(String(describing: grandTotalAmount))
        
    }
    //MARK:- Getting Payment Token
    func cardValidity(){
        // Initiate the card
        let stripCard = STPCardParams()
        
        // Split the expiration date to extract Month & Year
        if self.expiryDate.isEmpty == false  {
            let expirationDate = self.expiryDate.components(separatedBy: "/")
            let expMonth = UInt(expirationDate[0])
            let expYear = UInt(expirationDate[1])
            
            // Send the card info to Strip to get the token
            stripCard.number = paymentDetails["CardNumber"]
            stripCard.cvc = cvv
            stripCard.expMonth = expMonth!
            stripCard.expYear = expYear!
            
            STPAPIClient.shared().createToken(withCard: stripCard) { (token: STPToken?, error: Error?) in
                
                guard let token = token, error == nil else {
                    
                    // Present error to user...
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                    
                    return
                }
                print(token)
                self.paymentToken = String(describing: token)
                
                self.buyMemberShipAPI()
            }
        }
    }
    func backTwo() {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }

    //MARK:- Buy Membership API
    func buyMemberShipAPI(){
        let params:[String:Any] = ["memberShipType": Int(truncating: numberFormat(membershipDetails["MembershipKey"] ?? "0")),
                                   "totalAmount": grandTotalAmount,
                                   "userId": defaultValues.string(forKey: "UserID")!,
                                   "taxAmount": taxAmount,
                                   "token": paymentToken ?? ""]
        WebService.shared.apiDataPostMethod(url: buyMemberShipURL, parameters: params) { (responce, error) in
            if error == nil{
                if let dict = responce {
                    Helper.Alertmessage(title: "Info:", message: dict["message"] as! String, vc: self)
                    
                    NotificationCenter.default.post(name: .userAccountVC, object: nil)
                    //self.backTwo()
                    let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "UserAccountVC") as! UserAccountVC
                    vc.value = true
                    let nav = NavigationController.init(rootViewController: vc)
                    self.sideMenuController?.rootViewController = nav
                    
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
