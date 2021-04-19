//
//  CompensationViewController.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 09/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit
import ObjectMapper
import Stripe

class CompensationViewController: UIViewController {
    
    @IBOutlet weak var compensationTV: UITableView!
    @IBOutlet weak var errorLbl: UILabel!
    
    var GetCardsModelData: GetCardsModel!
    var CardData: [Card]?
    
    var tappedButtonsTag :Int!
    var cardID  = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getCardAPI()
        
        let nibSec = UINib.init(nibName: "OrderReviewSecCell", bundle: nil)
        compensationTV.register(nibSec, forCellReuseIdentifier: "OrderReviewSecCell")
        
        let nib = UINib.init(nibName: "PaymentVcCell", bundle: nil)
        compensationTV.register(nib, forCellReuseIdentifier: "PaymentVcCell")
        
        compensationTV.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVc), name:.reloadVC, object: nil)
    }
    @objc func reloadVc()
    {
        getCardAPI()
    }
@IBAction func backButton(_ sender: UIButton) {
       setRoot()
    }
    //MARK:- Get Cards API
    func getCardAPI(){
        
        let parms:[String:Any] = [ "userId": defaultValues.string(forKey: "UserID")!]
        WebService.shared.apiDataPostMethod(url: getCardURL, parameters: parms) { (responce, error) in
            
            if error == nil {
                self.GetCardsModelData = Mapper<GetCardsModel>().map(JSONObject: responce)
                
                if self.GetCardsModelData.success == true {
                    if let home = self.GetCardsModelData?.cards
                    {
                        self.CardData = home
                        print(home)
                        //self.tableViewHeight.constant = CGFloat(self.GetAllVehicleData?.count ?? 1 * 60)
                        self.compensationTV.reloadData()
                        //                        if home.count == 1{
                        //                            self.tappedButtonsTag = 0
                        //                        }
                    }
                    
                }else {
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    
    //MARK:- Delete card API
    func deleteCardAPI(params: [String:Any]){
        
        WebService.shared.apiDataPostMethod(url: deleteCardURL, parameters: params) { (responce, error) in
            if error == nil {
                if let dic = responce {
                    print(dic)
                    
                    let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Notification", message: dic["message"] as? String ?? "", cancelButton: false) {
                        
                        self.getCardAPI()
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    self.present(alertWithCompletionAndCancel, animated: true)
                    
                }
                
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }

}

//MARK:- Table View
extension CompensationViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "OrderReviewSecCell") as! OrderReviewSecCell
        headerView.ORTitleLabel.text = "Payment Cards"
        headerView.btn.setTitle("+ Payment Method", for: .normal)
        headerView.btn.addTarget(self, action: #selector(paymentMethod), for: .touchUpInside)
        
        return headerView
    }
    @objc func paymentMethod(){
        
//        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
//       self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CardData != nil{
            errorLbl.isHidden = true
            return CardData?.count ?? 0

        }else{
            errorLbl.isHidden = false
            errorLbl.text = "No Cards are found. Add your card"
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentVcCell", for: indexPath) as! PaymentVcCell
        
        if let data = CardData, data.count > indexPath.row{
            let cardBrand = STPCardValidator.brand(forNumber: data[indexPath.row].cardNumber!)
            let cardImage = STPImageLibrary.brandImage(for: cardBrand)
            
            cell.cardImageView.image = cardImage

            cell.cvvView.isHidden = true
            cell.cvvLbl.isHidden = true
            cell.cellBtnRoundView.isHidden = false

            cell.cardHolderNameLbl.text = data[indexPath.row].cardHolderName
            cell.cardHolderNameLbl.textColor = #colorLiteral(red: 0.9993466735, green: 0.2575700283, blue: 0.1836260259, alpha: 1)
            cell.cardLastFourDigitsLbl.text = data[indexPath.row].lastFourDigit
            cell.cellBtn.tag = indexPath.row

                cell.cellBtnRoundView.isHidden = true
                cell.cancelBtn.isHidden = false
                cell.cancelBtn.tag = indexPath.row
                self.cardID = data[indexPath.row].id!

            //mark:- converting longdate into Date format
            let milisecond = Int(data[indexPath.row].expiryDate ?? "") ?? 0
            let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yyyy"

            cell.expiryDateLbl.text = "\(dateFormatter.string(from: dateVar))"
            cell.expiryDateLbl.textColor = #colorLiteral(red: 0.9993466735, green: 0.2575700283, blue: 0.1836260259, alpha: 1)

            // here is the check:
            if let row =  tappedButtonsTag, row == indexPath.row {
                
                cell.cancelBtn.isSelected = true


            } else {
                cell.cancelBtn.addTarget(self, action: #selector(cancelBtnAction(button:)), for: .touchUpInside)
                cell.cellBtn.isSelected = false
               
            }

        }
        return cell
    }
    @objc func cancelBtnAction(button: UIButton) {
        tappedButtonsTag = button.tag
        deleteCardAPI(params: ["cardId" : cardID])

    }
}
