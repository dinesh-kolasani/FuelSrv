//
//  FuelAmountVC.swift
//  FuelSrv
//
//  Created by PBS9 on 29/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class FuelAmountVC: UIViewController {
    
    @IBOutlet weak var fillITbtn: UIButton!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var litersBtn: UIButton!
    
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var quantityTxt: UITextField!
    
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var litersView: UIView!
    
    @IBOutlet weak var nextBtn: RoundButton!
    
    var FuelAmountDetails: [String:Any] = [:]
    
    var tappedFilIt: Int!
    var amountButton: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
       navigationSetUp()
        paymentStatus = 0
        amountButton = 0
        tappedFilIt = 1
        amountTxt.isEnabled = false
        quantityTxt.isEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        appDelegate.orderDataDict[OrderDataEnum.Promocode.rawValue] = [:]
        appDelegate.orderDataDict[OrderDataEnum.Payment.rawValue] = [:]
    }
    
    @IBAction func fillItBtnAction(_ sender: UIButton) {
        if fillITbtn.isSelected{
            fillITbtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
            priceBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
            litersBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
            amountTxt.placeholder = "Amount"
            litersView.isHidden = true
            amountTxt.isEnabled = true
            quantityTxt.isEnabled = true
            amountButton = 0
            
        }else {
            fillITbtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
            amountTxt.isEnabled = false
            quantityTxt.isEnabled = false
            amountTxt.text = nil
            quantityTxt.text = nil
            priceBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
            litersBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
            tappedFilIt = 1
            amountButton = nil
        }
        fillITbtn.isSelected = !fillITbtn.isSelected
    }
    
    @IBAction func selectedBtnAction(_ sender: UIButton) {
        if sender.tag == 1 {
            if sender.isSelected == true{
                priceBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
            }else {
                tappedFilIt = nil
                amountButton = 0
                amountTxt.isEnabled = true
                fillITbtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                priceBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
                litersView.isHidden = true
                quantityTxt.text = nil
                
                
                litersBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                amountView.isHidden = false
            }
        }
        else if sender.tag == 2 {
            if sender.isSelected == true{
                litersBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
            }else{
                tappedFilIt = nil
                amountButton = 1
                quantityTxt.isEnabled = true
                fillITbtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                litersBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
                amountView.isHidden = true
                amountTxt.text = nil
                priceBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
                litersView.isHidden = false
            }
            
        }
        
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
//        if (tappedFilIt == nil && amountButton == nil) {
//            self.showAlert("Info:", "Please select Fuel amount type", "OK")
        
            if (tappedFilIt == nil) && (amountTxt.text?.count == 0 && quantityTxt.text?.count == 0){
                self.showAlert("Info:", "Please enter Fuel amount or quantity", "OK")
                
//            }
            
            }
//            else if amountTxt.text == "0" && quantityTxt.text == "0"{
//                self.showAlert("Info:!", "Please enter valid amount or quantity", "OK")
//            }
            else{
            
            
            FuelAmountDetails[FuelAmountEnum.FillIt.rawValue] = String(describing: (tappedFilIt) ?? 0)
            FuelAmountDetails[FuelAmountEnum.AmountButton.rawValue] = String(describing: (amountButton) ?? 0)
            FuelAmountDetails[FuelAmountEnum.Amount.rawValue] = amountTxt.text ?? "0"
            FuelAmountDetails[FuelAmountEnum.Quantity.rawValue] = quantityTxt.text ?? "0"
            appDelegate.orderDataDict[OrderDataEnum.FuelAmount.rawValue] = FuelAmountDetails
            
            print(appDelegate.orderDataDict)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderReviewVC") as! OrderReviewVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func navigationSetUp(){
        nextBtn.dropShadow(view: nextBtn, opacity: 0.5)
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationItem.title = "FUEL AMOUNT"
    }
}
enum FuelAmountEnum:String {
    case FillIt
    case AmountButton
    case Amount
    case Quantity
    
}
