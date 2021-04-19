//
//  PaymentVC.swift
//  FuelSrv
//
//  Created by PBS9 on 20/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import Stripe

protocol CardDataDelegate {
    func sendCardData(cardData : [String: Any])
}

class PaymentVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var doneBtn: RoundButton!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var doneBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    var GetCardsModelData: GetCardsModel!
    var CardData: [Card]?
    
    var PaymentDetails: [String:Any] = [:]
    var tappedButtonsTag :Int!
    var deleteCardTag: Int!
    var value: Bool!
    var cardID  = String()
    var delegate : CardDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigation()
        getCardAPI()
        
        let nib = UINib.init(nibName: "PaymentVcCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PaymentVcCell")
        
        let nibSec = UINib.init(nibName: "OrderReviewSecCell", bundle: nil)
        tableView.register(nibSec, forCellReuseIdentifier: "OrderReviewSecCell")
        
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVc), name:.reloadVC, object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func reloadVc()
    {
        getCardAPI()
        
    }
    
    //MARK:- Navigation setup
    func navigation (){
        
        doneBtn.dropShadow(view: doneBtn, opacity: 0.4)
        
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"stripe")
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 40, height: 20)

        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "Your Credit Card details are handled safely and securing using ")
        completeText.append(attachmentString)
        let  textAfterIcon = NSMutableAttributedString(string: ", and not stored anywhere by FuelSrv.")
        completeText.append(textAfterIcon)
        //self.descriptionLbl.textAlignment = .center;
        self.descriptionLbl.attributedText = completeText;
        

        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "PAYMENT"
        //self.tappedButtonsTag = 0
        
        
        if value == true{
            self.tappedButtonsTag = nil
            doneBtn.isHidden = true
            doneBtnHeight.constant = 0
            let imgBack = UIImage(named: "back")
            navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(Action))
        }
    }
    @objc func Action(){
        
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
        
    }
    
    //MARK:- Button action
    @IBAction func doneBtnAction(_ sender: Any) {
        if tappedButtonsTag == nil {
            self.showAlert("Info:", "Please select payment card", "OK")
        }else{
            
            let cardModel = CardData?[tappedButtonsTag]
            PaymentDetails[PaymentEnum.CardName.rawValue] = cardModel?.cardBrand
            PaymentDetails[PaymentEnum.CardNumber.rawValue] = cardModel?.cardNumber
            PaymentDetails[PaymentEnum.CardHolderName.rawValue] = cardModel?.cardHolderName
            PaymentDetails[PaymentEnum.CardLastFourDigits.rawValue] = cardModel?.lastFourDigit
            PaymentDetails[PaymentEnum.ExpiryDate.rawValue] = cardModel?.expiryDate
            appDelegate.orderDataDict[OrderDataEnum.Payment.rawValue] = PaymentDetails
            paymentStatus = 1
            
            delegate?.sendCardData(cardData:self.PaymentDetails)
        //self.navigationController?.popViewController(animated: true)
            if membership == 1
                //if defaultValues.integer(forKey: "MembershipTaken") == 1
            {
                
                let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            else{
                self.navigationController?.popViewController(animated: true)
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutVC")as! CheckOutVC
//                self.navigationController?.pushViewController(vc, animated: false)
            }
            
            
            if value == true {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")as! HomeVC
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }

    @IBAction func paymentBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.navigationController?.pushViewController(vc, animated: true)
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
                        self.tableView.reloadData()
                        
                        if self.value == true {
                            self.tappedButtonsTag = nil
                        }else{
                            if home.count != 0{
                                self.tappedButtonsTag = 0
                            }
                        }
                        
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
                    
                    let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Info:", message: dic["message"] as? String ?? "", cancelButton: false) {
                        
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

extension  Notification.Name
{
    static let reloadVC = Notification.Name("reload")
}
//MARK:- Table View
extension PaymentVC: UITableViewDelegate,UITableViewDataSource{
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableCell(withIdentifier: "OrderReviewSecCell") as! OrderReviewSecCell
//        headerView.ORTitleLabel.text = "Choose Card"
//        headerView.btn.setTitle("+ Payment Method", for: .normal)
//        headerView.btn.addTarget(self, action: #selector(paymentMethod), for: .touchUpInside)
//
//        return headerView
//    }
    @objc func paymentMethod(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = CardData, data.count > 0{
            errorLbl.isHidden = true
            return CardData?.count ?? 0
        }else{
            errorLbl.isHidden = false
            errorLbl.text = "No Cards Found"
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentVcCell", for: indexPath) as! PaymentVcCell
        
        if let data = CardData, data.count > indexPath.row{

//            if data[indexPath.row].cardBrand == "Visa" {
//                cell.cardImageView.image = #imageLiteral(resourceName: "Visa")
//            }else if data[indexPath.row].cardBrand == "Visa"{
//                cell.cardImageView.image = #imageLiteral(resourceName: "AmericanExpress")
//            }else if data[indexPath.row].cardBrand == "Maestro"{
//                cell.cardImageView.image = #imageLiteral(resourceName: "Master")
//            }else if data[indexPath.row].cardBrand == "Discover"{
//                cell.cardImageView.image = #imageLiteral(resourceName: "DiscoverCard")
//            }
            let cardBrand = STPCardValidator.brand(forNumber: data[indexPath.row].cardNumber!)
            let cardImage = STPImageLibrary.brandImage(for: cardBrand)
            
            cell.cardImageView.image = cardImage
            
            cell.cvvView.isHidden = true
            cell.cvvLbl.isHidden = true
            cell.cellBtnRoundView.isHidden = false
            
            cell.cardHolderNameLbl.text = data[indexPath.row].cardHolderName
            cell.cardLastFourDigitsLbl.text = data[indexPath.row].lastFourDigit
            cell.cellBtn.tag = indexPath.row
            
            
            if value == true {
                
                cell.cellBtnRoundView.isHidden = true
                cell.cancelBtn.isHidden = false
                cell.cancelBtn.tag = indexPath.row
                self.cardID = data[indexPath.row].id!
                
            }

                //mark:- converting longdate into Date format
                let milisecond = Int(data[indexPath.row].expiryDate ?? "") ?? 0
                let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/yyyy"
                
                cell.expiryDateLbl.text = "\(dateFormatter.string(from: dateVar))"
            
            // here is the check:
            if let row =  tappedButtonsTag, row == indexPath.row {
                cell.cellBtn.isSelected = true
                cell.cancelBtn.isSelected = true

                
            } else {
                
                cell.cellBtn.addTarget(self, action: #selector(addSomething(button:)), for: .touchUpInside)
                cell.cellBtn.isSelected = false
                
               // if value == true {
                    
                   deleteCardTag = indexPath.row
                    cell.cancelBtn.addTarget(self, action: #selector(cancelBtnAction(button:)), for: .touchUpInside)
                
                  //  cell.cellBtn.isSelected = false
                //}
            }
            
        }
        return cell
    }
    
    @objc func cancelBtnAction(button: UIButton) {
        deleteCardTag = button.tag
        if (self.CardData!.count > button.tag){
            let cardModel = self.CardData![button.tag]
            self.cardID = cardModel.id ?? ""
        }
        deleteCardAPI(params: ["cardId" : cardID])
        
        
    }
    
    @objc func addSomething(button: UIButton) {
        tappedButtonsTag = button.tag
        if (CardData!.count > button.tag)
        {
            let cardModel = CardData?[button.tag]
            
                PaymentDetails[PaymentEnum.CardName.rawValue] = cardModel?.cardBrand
                PaymentDetails[PaymentEnum.CardNumber.rawValue] = cardModel?.cardNumber
                PaymentDetails[PaymentEnum.CardHolderName.rawValue] = cardModel?.cardHolderName
                PaymentDetails[PaymentEnum.CardLastFourDigits.rawValue] = cardModel?.lastFourDigit
                PaymentDetails[PaymentEnum.ExpiryDate.rawValue] = cardModel?.expiryDate
                appDelegate.orderDataDict[OrderDataEnum.Payment.rawValue] = PaymentDetails
            paymentStatus = 1
            
            print(appDelegate.orderDataDict)
        }
      tableView.reloadData()
    }
}
enum PaymentEnum:String {
    case CardNumber
    case CardName
    case CardHolderName
    case ExpiryDate
    case CardLastFourDigits
}
