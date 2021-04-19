//
//  PaymentSummaryVC.swift
//  FuelSrv
//
//  Created by PBS9 on 22/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import Stripe

class PaymentSummaryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vcHeight: NSLayoutConstraint!
    @IBOutlet weak var fillMyTiresPriceLbl: UILabel!
    @IBOutlet weak var topUpMyOilPriceLbl: UILabel!
    @IBOutlet weak var plowMyDrivewayPriceLbl: UILabel!
    @IBOutlet weak var windShieldWashPriceLbl: UILabel!
    @IBOutlet weak var fuelAmountPriceLbl: UILabel!
    @IBOutlet weak var onDemandServicePriceLbl: UILabel!
    @IBOutlet weak var taxAmountLbl: UILabel!
    @IBOutlet weak var GSTAmountLbl: UILabel!
    @IBOutlet weak var discountAmountLbl: UILabel!
    @IBOutlet weak var grandTotalAmountLbl: UILabel!
    @IBOutlet weak var proceedPaymentBtn: RoundButton!
    
    @IBOutlet weak var preRequestPriceLbl: UILabel!
    @IBOutlet weak var preRequestTitleLbl: UILabel!
    
    @IBOutlet weak var fuelAmountLbl: UILabel!
    @IBOutlet weak var fillMyTiresVH: NSLayoutConstraint!
    @IBOutlet weak var topUpMyOilVH: NSLayoutConstraint!
    @IBOutlet weak var plowMyDrivewayVH: NSLayoutConstraint!
    @IBOutlet weak var windShieldWashVH: NSLayoutConstraint!
    @IBOutlet weak var fuelAmountVH: NSLayoutConstraint!
    @IBOutlet weak var discountVH: NSLayoutConstraint!
    @IBOutlet weak var onDemandVH: NSLayoutConstraint!
    @IBOutlet weak var preRequestVH: NSLayoutConstraint!
    
    
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var lastFourDigitsLbl: UILabel!
    @IBOutlet weak var cardHolderNameLbl: UILabel!
    @IBOutlet weak var expiryDateLbl: UILabel!
    @IBOutlet weak var cvvNumberTextFeild: UITextField!
    @IBOutlet weak var cardView: UIView!
    
    
    var OrderReviewModelData: OrderReviewModel!
    var serviceNames = appDelegate.orderDataDict["ServicesType"] as? [String] ?? []
    
    var userLocationDetails = appDelegate.orderDataDict["UserLocation"] as? [String : String] ?? [:]
    var scheduleDetails = appDelegate.orderDataDict["Schedule"] as? [String:Any] ?? [:]
    
    var fuelTypeDetails = appDelegate.orderDataDict["FuelType"] as? [String : String] ?? [:]
    var fillMyTiresDetails = appDelegate.orderDataDict["FillMyTires"] as? [String : String] ?? [:]
    var oilDetails = appDelegate.orderDataDict["Oil"] as? [String : String] ?? [:]
    var plowMyDrivewayDetails = appDelegate.orderDataDict["PlowMyDriveway"] as? [String : String] ?? [:]
    var windShieldWashDetails = appDelegate.orderDataDict["WindShieldWasherFluid"] as? [String : String] ?? [:]
    
    var vehicleDetails = appDelegate.orderDataDict["Vehicle"] as? [String : String] ?? [:]
    var fuelAmountDetails = appDelegate.orderDataDict["FuelAmount"] as? [String : String] ?? [:]
    
    var paymentDetails = appDelegate.orderDataDict["Payment"] as? [String : String] ?? [:]
    var promoDetails = appDelegate.orderDataDict["Promocode"] as? [String: Any] ?? [:]
    var membershipDetails = appDelegate.orderDataDict["Membership"] as? [String : String] ?? [:]
    
    var vehicleCount = "1 - 10"
    var paymentToken: String?
    var cvv = String()
    var expiryDate: String!
    
    var serviceID = [[String : Any]]()
    var promo: String = ""
    var totalAmount = Double()
    var totalOilPrice = 0.0
    var ServicesCost = 0.0
    var totalFuelAmount = String()
    var taxAmount: Double = 0.0
    var grandTotalAmount: Double = 0.0
    var discount: Double = 0.0
    var totalTax: Double = 0.0
    var withOutMembershipPrice: Double = 0.0
    var taxWithOutMembership = Double()
    var leftDiscount: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        cvvNumberTextFeild.maxLength = 4
        
        vcHeight.constant = UIScreen.main.bounds.height
        navigation()
        paymentSummary()
        
        print(appDelegate.orderDataDict)
        
//        let nibCell = UINib.init(nibName: "PaymentVcCell", bundle: nil)
//        tableView.register(nibCell, forCellReuseIdentifier: "PaymentVcCell")
//
//        tableView.tableFooterView = UIView()
        
    }
    
    //MARK:- Navigation setup
    func navigation (){
        proceedPaymentBtn.dropShadow(view: proceedPaymentBtn, opacity: 0.5)
        cardView.dropShadow(view: cardView, opacity: 0.5)
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationItem.title = "CHECKOUT"
        selectedServices()
        cardDetails()
    }

    @IBAction func proceedPaymentBtnAction(_ sender: Any) {
        
        
        if Helper.shared.isFieldEmpty(field:cvvNumberTextFeild.text!) {
            showAlert("Notification", "Please Enter CVV number", "OK")
        }else if cvvNumberTextFeild.text?.count ?? 0 >= 3 {
            proceedPaymentBtn.isUserInteractionEnabled = false
             cardvalidity()
        }
    }
    
    func paymentSummary(){
       
        if firstTimeOrder == 0 {
            if cancelAction == false{
                promo = refCode
            }else{
                promo = promoDetails["PromoCode"] as? String ?? ""
            }
            
        }else{
            if let code = promoDetails["PromoCode"] {
                
                 promo = code as? String ?? ""
            }
         }
        if defaultValues.integer(forKey: "AccountType") == 1 {
            
        }
        
        if let tiresPrice = fillMyTiresDetails["Price"], tiresPrice != ""{
            
            fillMyTiresPriceLbl.text = currencyFormat(tiresPrice)
        }else {
            
            fillMyTiresVH.constant = 0
        }
        if let oilPrice = oilDetails["Price"], oilPrice != "" {
            totalOilPrice = Double(truncating: numberFormat(oilPrice)) * Double(truncating: numberFormat(oilDetails["Quantity"]))
            
            topUpMyOilPriceLbl.text = "x" + String(describing: oilDetails["Quantity"]!) + " " + currencyFormat(String(describing: totalOilPrice))
        }else {
            
            topUpMyOilVH.constant = 0
        }
        if let driveWayPrice = plowMyDrivewayDetails["Price"], driveWayPrice != "" {
            
            plowMyDrivewayPriceLbl.text = currencyFormat(driveWayPrice)
        }else{
            
            plowMyDrivewayVH.constant = 0
        }
        if let washPrice = windShieldWashDetails["Price"], washPrice != "" {
            
            windShieldWashPriceLbl.text = currencyFormat(washPrice)
        }else {
            windShieldWashVH.constant = 0
        }
        //if let ondemand =
        if freeTrialTaken == 1{
            
        if let perRequestPrice = membershipDetails["Amount"], perRequestPrice != "" {
            preRequestPriceLbl.text = currencyFormat(perRequestPrice)
            if membershipDetails["MemberShipPlanId"] != "" {
                preRequestTitleLbl.text = "Membership fee"
            }
        }else{
            preRequestVH.constant = 0
            preRequestTitleLbl.text = ""
            preRequestPriceLbl.text = ""
        }
        }else{
            preRequestVH.constant = 0
            preRequestTitleLbl.text = ""
            preRequestPriceLbl.text = ""
        }
        
        if fuelAmountDetails["FillIt"] == "1" {
            let fuelAmount = currencyFormat(fuelTypeDetails["Price"]) + "/L"
            
            fuelAmountLbl.text = fuelTypeDetails["Fuel"]! + "(\(fuelAmount))"
            if defaultValues.integer(forKey: "AccountType") == 0{
                fuelAmountPriceLbl.text = "Fill it"
            }else{
                fuelAmountPriceLbl.text = "Fill"
            }
            
            
        }else{
            
            if let fuelAmount = fuelAmountDetails["Amount"], fuelAmount != "" {
                
                fuelAmountPriceLbl.text = currencyFormat(fuelAmount)
                totalFuelAmount = fuelAmount
            }else {
                let fuelAmount = Double(truncating: numberFormat(fuelTypeDetails["Price"])) * Double(truncating: numberFormat(fuelAmountDetails["Quantity"]))
                fuelAmountPriceLbl.text = "(\(String(describing:fuelAmountDetails["Quantity"]!))" + "L) " + currencyFormat(String(describing: fuelAmount))
                //fuelAmountVH.constant = 0
                totalFuelAmount = String(describing: fuelAmount)
            }
        }
       
        if urgentOrder == 1 {
             onDemandVH.constant = 0
            onDemandServicePriceLbl.text = currencyFormat(String(describing: onDemandPrice))
            
            totalAmount = Double(truncating: numberFormat(fillMyTiresDetails["Price"])) + totalOilPrice + Double(truncating: numberFormat(plowMyDrivewayDetails["Price"])) + Double(truncating: numberFormat(windShieldWashDetails["Price"])) + onDemandPrice + Double(truncating:numberFormat(membershipDetails["Amount"]))
        }else {
            onDemandVH.constant = 0
            
            
            totalAmount = Double(truncating: numberFormat(fillMyTiresDetails["Price"])) + totalOilPrice + Double(truncating: numberFormat(plowMyDrivewayDetails["Price"])) + Double(truncating: numberFormat(windShieldWashDetails["Price"])) + Double(truncating:numberFormat(membershipDetails["Amount"]))
        }
       
        ServicesCost = Double(truncating: numberFormat(fillMyTiresDetails["Price"])) + Double(totalOilPrice) + Double(truncating: numberFormat(plowMyDrivewayDetails["Price"])) + Double(truncating: numberFormat(windShieldWashDetails["Price"]))
        
        taxAmount = (Double(totalAmount) * 0.12)
        print(taxAmount)
        if freeTrialTaken == 1{
            
            taxWithOutMembership = totalAmount
            
        }else{
            taxWithOutMembership = totalAmount - Double(truncating:numberFormat(membershipDetails["Amount"]))
            
        }
        let pstWithOut = (Double(taxWithOutMembership) * 0.07)
        let gstWithOut = (Double(taxWithOutMembership) * 0.05)
        totalTax = pstWithOut + gstWithOut
        print(totalTax)
        taxAmountLbl.text = currencyFormat(String(describing: pstWithOut))
        GSTAmountLbl.text = currencyFormat(String(describing: gstWithOut))
        
        if promoDetails["DiscountAmount"] != nil {
            
            discountAmountLbl.text =  "-" + currencyFormat(String(describing: promoDetails["DiscountAmount"] ?? 0))
            discount = Double(promoDetails["DiscountAmount"]! as! Int)
        }
        else{
            if firstTimeOrder == 0 && refCode != ""{
                if cancelAction == false {
                    discountAmountLbl.text = "-" + currencyFormat("10")
                    discount = 10
                    
                    
                }else{
                    discountVH.constant = 0
                    discount = 0.0
                }
            }else{
                discountVH.constant = 0
                discount = 0.0
            }
        }
        grandTotalAmount = Double(truncating: numberFormat(String(describing: totalAmount))) + Double(truncating: numberFormat(String(describing: taxAmount))) + Double(truncating: numberFormat(totalFuelAmount)) - discount
        
        if freeTrialTaken == 1 && discount == 0.0 {//&& firstTimeOrder == 1 && defaultValues.integer(forKey: "MembershipTaken") == 0{ //isFirstTimeOrder = 1;  isFreeTrialTaken = 1;  isMembershipTaken = 0;
            
            withOutMembershipPrice = Double(truncating: numberFormat(String(describing: totalAmount))) + Double(truncating: numberFormat(totalFuelAmount)) + totalTax - discount
           
        }else{
            
            withOutMembershipPrice = Double(truncating: numberFormat(String(describing: totalAmount))) + Double(truncating: numberFormat(totalFuelAmount)) + totalTax - Double(truncating:numberFormat(membershipDetails["Amount"])) - discount
            
        }

        if fuelAmountDetails["FillIt"] == "1" {
//            var total = Double()
//
//            if firstTimeOrder == 0{
//                total = totalAmount - Double(truncating: numberFormat((membershipDetails["Amount"])))
//
//            }else{
//                total = totalAmount + Double(truncating: numberFormat((membershipDetails["Amount"])))
//            }
            
            let total = totalAmount - Double(truncating: numberFormat((membershipDetails["Amount"])))
            
            if discount <= total {
                grandTotalAmount = Double(truncating: numberFormat(String(describing: totalAmount))) + Double(truncating: numberFormat(String(describing: taxAmount))) + Double(truncating: numberFormat(totalFuelAmount)) + Double(truncating: numberFormat("100"))  - discount
                print(grandTotalAmount)
                //grandTotalAmount = Double(truncating: numberFormat("100"))
            grandTotalAmountLbl.text = currencyFormat(String(describing: withOutMembershipPrice)) + " + " + "Fill Tank"
            }else{
                print(grandTotalAmount)
                grandTotalAmount = Double(truncating: numberFormat("100")) + Double(truncating: numberFormat(membershipDetails["Amount"]))
                leftDiscount = Double(truncating: numberFormat(String(describing: withOutMembershipPrice)))
                grandTotalAmountLbl.text = currencyFormat("0") + " + " + "(Fill Tank " + currencyFormat(String(describing: withOutMembershipPrice)) + ")"

            }
            
        }else{
            if withOutMembershipPrice > 0{
                grandTotalAmountLbl.text = currencyFormat(String(describing: withOutMembershipPrice))
            }else{
                grandTotalAmount = Double(truncating: numberFormat("0"))
                leftDiscount = Double(truncating: numberFormat(String(describing: withOutMembershipPrice)))
                grandTotalAmountLbl.text = currencyFormat("0") + " (" + currencyFormat(String(describing: withOutMembershipPrice)) + ")"
            }
            
            
//            if discount < withOutMembershipPrice {
//                grandTotalAmountLbl.text = currencyFormat(String(describing: withOutMembershipPrice))
////                grandTotalAmount = Double(truncating: numberFormat("0"))
////                grandTotalAmountLbl.text = currencyFormat("0") + currencyFormat(String(describing: withOutMembershipPrice))
//            }else{
//                //grandTotalAmountLbl.text = currencyFormat(String(describing: withOutMembershipPrice))
//                grandTotalAmount = Double(truncating: numberFormat("0"))
//                grandTotalAmountLbl.text = currencyFormat("0") + currencyFormat(String(describing: withOutMembershipPrice))
//            }
            
        }
        
    }
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
    }
    
    //MARK:- Getting Payment Token
    func cardvalidity(){
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
//            let cardSate = STPCardValidator.validationState(forCard: stripCard)
            STPAPIClient.shared().createToken(withCard: stripCard) { (token: STPToken?, error: Error?) in
                guard let token = token, error == nil else {
                    
                    // Present error to user...
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                    
                    return
                }
                print(token)
                self.paymentToken = String(describing: token)
                if defaultValues.integer(forKey: "AccountType") == 0{
                     self.placeOrderAPI()
                }else{
                    self.placeOrderBusinessAPI()
                }
               
            }
        }
    }
    
    func selectedServices(){
        
        let serviceID1: [String:Any] = [
            "serviceName":"Fuel my Vehicle",
            "subServiceName": fuelTypeDetails["Fuel"] ?? "",
            "subServicePrice": fuelTypeDetails["Price"] ?? "",
            "subServiceQuantity":1
        ]//"FuelType": ["Fuel": "Premium Gasoline", "Price": "3.0", "Fueltype": "1"]
        
        let serviceID2: [String:Any] =  [
            "serviceName":"Fill my Tires",
            "subServiceName":fillMyTiresDetails["PressureType"] ?? "",
            "subServicePrice":fillMyTiresDetails["Price"] ?? "" ,
            "subServiceQuantity":1
        ]  // "FillMyTires": ["Price": "$7", "PressureType": "   PSI"]
        
        let serviceID3: [String:Any] =  [
            "serviceName":"Top up my Oil",
            "subServiceName":oilDetails["Oil"] ?? "",
            "subServicePrice":oilDetails["Price"] ?? "",
            "subServiceQuantity": oilDetails["Quantity"] ?? 1
        ] //"Oil": ["Oil": "10W40", "Price": "$34", "Quantity": "1"]
        
        let serviceID4:[String : Any] =  [
            "serviceName":"Plow my Driveway",
            "subServiceName": plowMyDrivewayDetails["PlowMyDrivewayName"] ?? "",
            "subServicePrice": plowMyDrivewayDetails["Price"] ?? "",
            "subServiceQuantity":1
        ] // "PlowMyDriveway": ["Price": "$35", "PlowMyDrivewayName": "Driveway"]
        
        let serviceID5:[String : Any] =  [
            "serviceName":"Windshield Washer Fluid",
            "subServiceName": windShieldWashDetails["PlowMyDrivewayName"] ?? "",
            "subServicePrice": windShieldWashDetails["Price"] ?? "",
            "subServiceQuantity":1
        ] // "WindShieldWasherFluid": ["Price": "$200", "PlowMyDrivewayName": "test 2"]
        
        if serviceNames.contains("Fuel my Vehicle"){
            serviceID.append(serviceID1)
        }
        if serviceNames.contains("Fill my Tires"){
            serviceID.append(serviceID2)
        }
        if serviceNames.contains("Top up my Oil"){
            serviceID.append(serviceID3)
        }
        if serviceNames.contains("Plow my Driveway"){
            serviceID.append(serviceID4)
        }
        if serviceNames.contains("Windshield Wash"){
            serviceID.append(serviceID5)
        }
        
    }
    
    //MARK:- Place order API for personal Account
    func placeOrderAPI(){
     
    let params:[String:Any] = [
        
         "address":userLocationDetails["SelectedAddress"] ?? "",
         "deleveringDate":scheduleDetails["LongDate"] ?? 0,
         "discountAmount":discount,
         "fillType": numberFormat(fuelAmountDetails["AmountButton"] ?? "") ,
         "fuelAmount": numberFormat(fuelAmountDetails["Amount"] ?? "") ,
         "fuelQuantity": numberFormat(fuelAmountDetails["Quantity"] ?? ""),
         "fuelType": numberFormat(fuelTypeDetails["Fueltype"] ?? "") ,
         "isFulltank": numberFormat(fuelAmountDetails["FillIt"] ?? "") ,
         "isMembershipTaken": numberFormat(membershipDetails["MembershipTaken"]),
         "memberShipPlanId": membershipDetails["MemberShipPlanId"] ?? "",//memberShipPlanId
         "isPhysicalRecieptYes":physicalRecieptYes,
         "isRememberCard":1,
         "isUrgent": numberFormat(userLocationDetails["isUrgent"] ?? ""),
         "totalAmount": numberFormat(membershipDetails["Amount"]),
         "allServicesCost": ServicesCost,
         "membershipKey": numberFormat(membershipDetails["MembershipKey"]),
         "orderTotalAmount":grandTotalAmount,
         "promocode":promo,
         "reccuring":scheduleDetails["Reccuring"] ?? 0,
         "serviceId":serviceID,
         "taxAmount":taxAmount,
         "timing":scheduleDetails["SelectedTime"] ?? "",
         "token":paymentToken ?? "",
         "userId": defaultValues.string(forKey: "UserID")!,
         "user_lat":userLocationDetails["Maplat"] ?? 0.00,
         "user_long":userLocationDetails["MapLong"] ?? 0.00, 
        "vehicleCount": vehicleDetails["vehiclesCount"] ?? "",
         "vehicleId":vehicleDetails["vehicleID"] ?? "",
         "discountLeft": abs(leftDiscount),
        "placedFrom": "iOS"
         ]
        
        WebService.shared.apiPlaceOrderPost(url: placeOrderURL, parameters: params) { (responce, error) in
         
            if error == nil{
                self.OrderReviewModelData = Mapper<OrderReviewModel>().map(JSONObject: responce)
                
                if self.OrderReviewModelData.success == true {
                    
                    let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Info:", message: self.OrderReviewModelData.message ?? "", cancelButton: false) {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderSuccessVC") as! OrderSuccessVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    
                    self.present(alertWithCompletionAndCancel, animated: true)
                    
                }else {
                    Helper.Alertmessage(title: "Info:", message: self.OrderReviewModelData.message ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
        
    }
    //MARK:- Place order API for business Account
    
    func placeOrderBusinessAPI(){
        
        let params:[String:Any] = [
            
            "address":userLocationDetails["SelectedAddress"] ?? "",
            "deleveringDate":scheduleDetails["LongDate"] ?? 0,
            "discountAmount":discount,
            "fillType": numberFormat(fuelAmountDetails["AmountButton"] ?? "") ,
            "fuelAmount": numberFormat(fuelAmountDetails["Amount"] ?? "") ,
            "fuelQuantity": numberFormat(fuelAmountDetails["Quantity"] ?? ""),
            "fuelType": numberFormat(fuelTypeDetails["Fueltype"] ?? "") ,
            "isFulltank": numberFormat(fuelAmountDetails["FillIt"] ?? "") ,
            "isMembershipTaken": numberFormat(membershipDetails["MembershipTaken"]),
            "memberShipPlanId": membershipDetails["MemberShipPlanId"] ?? "",
            "isPhysicalRecieptYes":physicalReciept,
            "isRememberCard":1,
            "isUrgent": numberFormat(userLocationDetails["isUrgent"] ?? ""),
            "totalAmount": numberFormat(membershipDetails["Amount"]),
            "allServicesCost": ServicesCost,
            "membershipKey": numberFormat(membershipDetails["MembershipKey"]),
            "orderTotalAmount":grandTotalAmount,
            "promocode":promo,
            "reccuring":scheduleDetails["Reccuring"] ?? 0,
            "serviceId":serviceID,
            "taxAmount":taxAmount,
            "timing":scheduleDetails["SelectedTime"] ?? "",
            "token":paymentToken ?? "",
            "userId": defaultValues.string(forKey: "UserID")!,
            "user_lat":userLocationDetails["Maplat"] ?? 0.00,
            "user_long":userLocationDetails["MapLong"] ?? 0.00,
            "vehicleCount": vehicleDetails["vehiclesCount"] ?? "",
            "discountLeft": abs(leftDiscount),
            "placedFrom": "iOS"
        ]
        
        WebService.shared.apiPlaceOrderPost(url: placeOrderURL, parameters: params) { (responce, error) in
            
            if error == nil{
                self.OrderReviewModelData = Mapper<OrderReviewModel>().map(JSONObject: responce)
                
                if self.OrderReviewModelData.success == true {
                    
                    let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Info:", message: self.OrderReviewModelData.message ?? "", cancelButton: false) {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderSuccessVC") as! OrderSuccessVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    
                    self.present(alertWithCompletionAndCancel, animated: true)
                    
                }else {
                    Helper.Alertmessage(title: "Info:", message: self.OrderReviewModelData.message ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
        
    }
}
//extension PaymentSummaryVC: UITableViewDelegate,UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return 170
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentVcCell", for: indexPath) as! PaymentVcCell
//
//        if paymentDetails["CardName"] == "Visa" {
//            cell.imageView?.image = #imageLiteral(resourceName: "Visa")
//        }else if paymentDetails["CardName"] == "Visa"{
//            cell.imageView?.image = #imageLiteral(resourceName: "AmericanExpress")
//        }
//
//        cell.cardHolderNameLbl.text = paymentDetails["CardHolderName"]
//        cell.cardLastFourDigitsLbl.text = paymentDetails["CardLastFourDigits"]
//
//        //mark:- converting longdate into Date format
//        let milisecond = Int(paymentDetails["ExpiryDate"] ?? "") ?? 0
//        let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/yyyy"
//
//        cell.expiryDateLbl.text = "\(dateFormatter.string(from: dateVar))"
//        self.expiryDate = "\(dateFormatter.string(from: dateVar))"
//
//        cell.cvvValue = { value in
//
//            self.cvv = value
//        }
//
//        return cell
//    }
//}

