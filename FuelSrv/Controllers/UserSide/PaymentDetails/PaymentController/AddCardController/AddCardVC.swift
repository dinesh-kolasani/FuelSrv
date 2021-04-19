//
//  AddCardVC.swift
//  FuelSrv
//
//  Created by PBS9 on 20/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import Stripe
import SkyFloatingLabelTextField


class AddCardVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var cardHolderNameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var cardNumberTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var expiryDateTxt: SkyFloatingLabelTextField!
    //@IBOutlet weak var cvvTxt: SkyFloatingLabelTextField!

    @IBOutlet weak var rememberMeBtn: UIButton!
    

    @IBOutlet weak var nextBtn: RoundButton!
    var monthAndYearPicker = MonthYearPickerView()
    var longDate = Int()
    
    var cardName: String?
    var cardLastFourDigit: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardNumberTxt.maxLength = 19
        capitalizedString()
        navigation()
        expiryDatePicker()
        rememberMeBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .reloadVC, object: nil)
        
    }
    func capitalizedString(){
        cardHolderNameTxt.titleFormatter = { $0 }
        cardNumberTxt.titleFormatter = { $0 }
        expiryDateTxt.titleFormatter = { $0 }
        cardNumberTxt.delegate = self
        expiryDateTxt.delegate = self
    }
    
    //MARK:- Navigation setup
    func navigation (){
        nextBtn.dropShadow(view: nextBtn, opacity: 0.4)
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationItem.title = "ADD CARD"
    }
    
    //MARK:- Button Actions
    
    
    @IBAction func btnAction(_ sender: Any) {
        
    
    }
   
    @IBAction func rememberMeBtnAction(_ sender: Any) {
       
        if rememberMeBtn.isSelected{
            
                rememberMeBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
            
        }else {
            rememberMeBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
            
        }
        rememberMeBtn.isSelected = !rememberMeBtn.isSelected
    }
    @IBAction func nextBtnAction(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MembershipVC") as! MembershipVC
//        self.navigationController?.pushViewController(vc, animated: true)
        //NotificationCenter.default.post(name: .reloadVC, object: nil)
        nextBtn.isUserInteractionEnabled = false
        validation()
        
    }
    func validation(){
        
        if (Helper.shared.isFieldEmpty(field: cardHolderNameTxt.text!)){
            nextBtn.isUserInteractionEnabled = true
            Helper.Alertmessage(title: "Info:", message: "Please Enter Card Holder Name", vc: self)
        }else if (Helper.shared.isFieldEmpty(field: cardNumberTxt.text!)){
            nextBtn.isUserInteractionEnabled = true
            Helper.Alertmessage(title: "Info:", message: "Please Enter Card Number", vc: self)
        }else if (Helper.shared.isFieldEmpty(field: expiryDateTxt.text!)){
            nextBtn.isUserInteractionEnabled = true
            Helper.Alertmessage(title: "Info:", message: "Please Enter Card Expiry Date", vc: self)
        }
        else{
            cardvalidity()
        }
        
    }
    func cardvalidity(){
        // Initiate the card
        let stripCard = STPCardParams()
        
        // Split the expiration date to extract Month & Year
        if self.expiryDateTxt.text!.isEmpty == false {
            let expirationDate = self.expiryDateTxt.text!.components(separatedBy: "/")
            let expMonth = UInt(expirationDate[0])
            let expYear = UInt(expirationDate[1])
            
            // Send the card info to Strip to get the token
            stripCard.number = self.cardNumberTxt.text
            
            stripCard.expMonth = expMonth!
            stripCard.expYear = expYear!
            
            STPAPIClient.shared().createToken(withCard: stripCard) { (token: STPToken?, error: Error?) in
                
                guard let token = token, error == nil else {
                    self.nextBtn.isUserInteractionEnabled = true
                    // Present error to user...
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                    
                    return
                }
                print(token)
//                print(token.card?.last4)
                print(STPCard.string(from: token.card!.brand))
                
                self.cardLastFourDigit = token.card?.last4
                self.cardName = STPCard.string(from: token.card!.brand)
                //self.nextBtn.isUserInteractionEnabled = false
                self.addCardAPI()
              
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == cardNumberTxt{

            let sender = textField
            if sender.text!.count > 0 && sender.text!.count % 5 == 0 && sender.text!.last! != " " {
                sender.text!.insert(" ", at:sender.text!.index(sender.text!.startIndex, offsetBy: sender.text!.count-1) )
            }
        }
        return true
    }
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//        if textField == expiryDateTxt{
//            self.expiryDateTxt.text = monthAndYearPicker.pickerView(monthAndYearPicker, titleForRow: monthAndYearPicker.selectedRow(inComponent: 0), forComponent: 0)
//    
//        }
//    }
    
    //MARK:- Expiry Date Picker
    func expiryDatePicker (){
        //monthAndYearPicker.isHidden = false
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action:#selector(AddCardVC
            .donetimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action:#selector(AddCardVC.cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        expiryDateTxt.inputAccessoryView = toolbar
        expiryDateTxt.inputView = monthAndYearPicker
    }
    @objc func donetimePicker(){
       
//        let sele = monthAndYearPicker.pickerView(monthAndYearPicker, titleForRow: monthAndYearPicker.selectedRow(inComponent: 0), forComponent: 0)
        
    //    monthAndYearPicker.onDateSelected = { (month: Int, year: Int) in
        let month = monthAndYearPicker.month
        let year = monthAndYearPicker.year
        
            let selectedDate = String(format: "%02d/%d", month, year)
            self.expiryDateTxt.text = selectedDate
            
            
            let isoDate = selectedDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yyyy"

            let date = dateFormatter.date(from:isoDate)!
            
            let curerntdate = date
            let selectdateinlong = curerntdate.timeIntervalSince1970
            let longDateObj1 = selectdateinlong*1000
            self.longDate = Int(longDateObj1)
           
       // }
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    

    //MARK:- Add Card API
    func addCardAPI(){
        let cardNumber = cardNumberTxt.text
        let number = cardNumber?.replacingOccurrences(of: " ", with: "")
    
        print(number!)

        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!,
                                   "cardNumber": number!,
                                   "cardHolderName": cardHolderNameTxt.text!,
                                   "LastFourDigit": cardLastFourDigit!,
                                   "expiryDate": longDate,
                                   "cardBrand": cardName!]
        
        WebService.shared.apiDataPostMethod(url: addCardURL, parameters: params) { (responce, error) in
            
            if error == nil {
                self.nextBtn.isUserInteractionEnabled = true
                NotificationCenter.default.post(name: .reloadVC, object: nil)
                self.navigationController?.popViewController(animated: true)
                
                
            }else{
                self.nextBtn.isUserInteractionEnabled = true
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}

