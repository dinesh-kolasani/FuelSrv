//
//  PromoCodeVC.swift
//  FuelSrv
//
//  Created by PBS9 on 29/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
protocol PromoDataDelegate {
    func sendPromoData(cardData : [String: Any])
}

class PromoCodeVC: UIViewController {
    
    var PromoCodeModelData: PromoCodeModel!
    var PromoData: Promo?

    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var promoCodeTxt: UITextField!
    
    var discount: [String:Any] = [:]
    var delegate : PromoDataDelegate?
    
    //MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBtn.dropShadow(view: applyBtn, opacity: 0.4)

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Actions
    @IBAction func closeBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func applyBtnAction(_ sender: Any) {
        
        promocodeValidAPI()
        
    }
    
    //MARK:- Promo code API
    func promocodeValidAPI(){
        let string = promoCodeTxt.text ?? ""
        let promo = string.trimmingCharacters(in: .whitespaces)
        
        let params:[String:Any] = [
            "userId": defaultValues.string(forKey: "UserID")!,
            "promocode": promo]
        
        WebService.shared.apiDataPostMethod(url: promocodeURL, parameters: params) { (responce, error) in
            if error == nil {
                self.PromoCodeModelData = Mapper<PromoCodeModel>().map(JSONObject: responce)
                
                if self.PromoCodeModelData.success == true {
                    if let data = self.PromoCodeModelData.promoResult {
                        if data.isValid == 1 {
                            
                            self.PromoData = data.promo
                            
                            self.discount[PromoCodeEnum.DiscountAmount.rawValue] = self.PromoData?.discountAmount!
                            self.discount[PromoCodeEnum.PromoCode.rawValue] = self.PromoData?.promocode!
                            self.discount[PromoCodeEnum.DeactivePromo.rawValue] = self.PromoData?.deactivePromo!
                            appDelegate.orderDataDict[OrderDataEnum.Promocode.rawValue] = self.discount
                            
                            let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Notification", message: self.PromoCodeModelData.message ?? "", cancelButton: false) {
                                
                                self.dismiss(animated: true, completion: nil)
                                self.delegate?.sendPromoData(cardData: self.discount)
                            }
                            self.present(alertWithCompletionAndCancel, animated: true)
                        }else{
                            self.promoCodeTxt.shake()
                            self.promoCodeTxt.text = ""
                        }
                        
                    }
                    
//                    let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Notification", message: self.PromoCodeModelData.message ?? "", cancelButton: false) {
//                        
////                        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
////                        let nav = NavigationController.init(rootViewController: vc)
////                        self.sideMenuController?.rootViewController = nav
//                        
//                        self.dismiss(animated: true, completion: nil)
//                        self.delegate?.sendPromoData(cardData: self.discount)
//                    }
//                    
//                    self.present(alertWithCompletionAndCancel, animated: true)
                    
                }else{
                    
                    Helper.Alertmessage(title: "Info:", message: self.PromoCodeModelData.message ?? "", vc: self)
                    
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
enum PromoCodeEnum:String {
    case PromoCode
    case DiscountAmount
    case DeactivePromo
}
