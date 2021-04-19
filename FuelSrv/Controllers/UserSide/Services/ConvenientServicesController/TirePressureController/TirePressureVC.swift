//
//  TirePressureVC.swift
//  FuelSrv
//
//  Created by PBS9 on 11/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import ObjectMapper
import SkyFloatingLabelTextField

class TirePressureVC: UIViewController, UITextFieldDelegate {
    
    var TirePressureModelData: TirePressureModel!
    var TyreData: [Tyre]!
    var tappedButtonsTag: Int!
    var fillMyTiresDetails: [String:Any] = [:]
    var tirePrice = Int()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quantityTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var nextBtn: RoundButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tirePressurePriceLbl: UILabel!
    let tableViewMaxHeight: CGFloat = 125

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       navigation()
        let nib = UINib.init(nibName: "ServicesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ServicesCell")
        tableView.tableFooterView = UIView()

        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK:- Button Action
    @IBAction func nextBtnAction(_ sender: Any) {
        if tappedButtonsTag == nil && quantityTxt.text?.count == 0 {
            self.showAlert("Info:", "Please Specify a Tire pressure", "OK")
        }
        else{
        
                fillMyTiresDetails[TirePressureEnum.Quantity.rawValue] = quantityTxt.text!
                fillMyTiresDetails[TirePressureEnum.Price.rawValue] = String(describing: tirePrice)
                appDelegate.orderDataDict[OrderDataEnum.FillMyTires.rawValue] = fillMyTiresDetails
            if tappedButtonsTag != nil{
                let pressureModel = TyreData[tappedButtonsTag]
                fillMyTiresDetails[TirePressureEnum.Quantity.rawValue] = quantityTxt.text
                fillMyTiresDetails[TirePressureEnum.Price.rawValue] = String(describing: pressureModel.price ?? 0)
                fillMyTiresDetails[TirePressureEnum.PressureType.rawValue] = pressureModel.name ?? ""
                appDelegate.orderDataDict[OrderDataEnum.FillMyTires.rawValue] = fillMyTiresDetails
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        //self.navigationController?.popViewController(animated: true)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == quantityTxt{
            tappedButtonsTag = nil
            tableView.reloadData()
            appDelegate.orderDataDict[OrderDataEnum.FillMyTires.rawValue] = [:]
            fillMyTiresDetails = [:]
            
        }
        return true
    }
    
    //MARK:- navigation
    func navigation(){
        quantityTxt.titleFormatter = { $0 }
        quantityTxt.delegate = self
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationItem.title = "TIRE PRESSURE"
        nextBtn.dropShadow(view: nextBtn, opacity: 0.3)
        getFilltyreAPI()
        
    }
    
    //MARK:- Get Fill my tires API
    
    func getFilltyreAPI(){
        let params:[String:Any] = ["accounttype": defaultValues.integer(forKey: "AccountType")]
       
        WebService.shared.apiGet(url: getFilltyreURL, parameters: params) { (responce, error) in
            
            if error == nil {
                self.TirePressureModelData = Mapper<TirePressureModel>().map(JSONObject: responce)
                
                if self.TirePressureModelData.success == true {
                    if let home = self.TirePressureModelData?.tyre
                    {
                        self.TyreData = home
                        print(home)
                        if self.TyreData.count != 0 {
                            self.tirePrice = home[0].price ?? 0
                            self.tirePressurePriceLbl.text = self.currencyFormat(String(describing: self.tirePrice)) //String(describing: self.tirePrice)
                            self.tappedButtonsTag = 0
                        }else{
                            self.tirePrice = 3
                            self.tirePressurePriceLbl.text = self.currencyFormat(String(describing: self.tirePrice))
                        }
            
                        //self.tableViewHeight.constant = CGFloat(self.GetAllVehicleData?.count ?? 1 * 60)
                        //self.tableViewHeight.constant = CGFloat(home.count * 50)
                        
                        let tableHeight = CGFloat( home.count * 40 )
                        
                        if tableHeight >= self.tableViewMaxHeight {
                            self.tableViewHeight.constant = self.tableViewMaxHeight
                            self.tableView.isScrollEnabled = true
                            
                        }else{
                            self.tableViewHeight.constant = CGFloat( home.count * 40 )
                            self.tableView.isScrollEnabled = false
                        }
                        self.tableView.reloadData()
                        
                    }
                    
                }else {
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
        
    }
    
}

//MARK:- Table View

extension TirePressureVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40//48.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if TyreData != nil{
            return TyreData?.count ?? 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesCell", for: indexPath) as! ServicesCell
        cell.backgroundColor = UIColor.clear
        
        if let data = TyreData, data.count > indexPath.row{
            
            
            cell.cellLabel.text = data[indexPath.row].name
            //cell.cellPriceLabel.text = "$" + String(describing: data[indexPath.row].price!) + "/L"
        
            cell.cellBtn.tag = indexPath.row
            
            // here is the check:
            if let row =  tappedButtonsTag, row == indexPath.row {
                cell.cellBtn.isSelected = true
                //cell.cellBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
            } else {
                cell.cellBtn.isSelected = false
                //cell.cellBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
            }
            cell.cellBtn.addTarget(self, action: #selector(addSomething(button:)), for: .touchUpInside)
        }
        return cell
    }
    @objc func addSomething(button: UIButton) {
        if button.isSelected {
            tappedButtonsTag = nil
            //uncheck the butoon
//            button.isSelected = false
            //quantityTxt.isEnabled = true
            quantityTxt.text = ""
            appDelegate.orderDataDict[OrderDataEnum.FillMyTires.rawValue] = [:]
            fillMyTiresDetails = [:]
            quantityTxt.becomeFirstResponder()
           // print(appDelegate.orderDataDict["FillMyTires"])
            
         } else {
            tappedButtonsTag = button.tag
            // checkmark it
//            button.isSelected = true
           // quantityTxt.isEnabled = false
            quantityTxt.text = ""
           quantityTxt.resignFirstResponder()
            //working things----------------------
//            let pressureModel = TyreData[button.tag]
//            fillMyTiresDetails[TirePressureEnum.Quantity.rawValue] = quantityTxt.text
//            fillMyTiresDetails[TirePressureEnum.Price.rawValue] = String(describing: pressureModel.price ?? 0)
//            fillMyTiresDetails[TirePressureEnum.PressureType.rawValue] = pressureModel.name ?? ""
//            appDelegate.orderDataDict[OrderDataEnum.FillMyTires.rawValue] = fillMyTiresDetails
//            print(fillMyTiresDetails)
            //working things----------------------
        }
    
        tableView.reloadData()
        
            //tappedButtonsTag = button.tag

//            quantityTxt.isEnabled = false
//        quantityTxt.text = ""
//
//            if (TyreData.count > button.tag)
//            {
//                let pressureModel = TyreData[button.tag]
//
//
//                //fillMyTiresDetails[TirePressureEnum.Quantity.rawValue] = quantityTxt.text!
//                fillMyTiresDetails[TirePressureEnum.Price.rawValue] = String(describing: pressureModel.price ?? 0)
//                fillMyTiresDetails[TirePressureEnum.PressureType.rawValue] = pressureModel.name ?? ""
//                appDelegate.orderDataDict[OrderDataEnum.FillMyTires.rawValue] = fillMyTiresDetails
//
//            }
//
//            tableView.reloadData()
    }

}

enum TirePressureEnum:String {
    case PressureType
    case Price
    case Quantity
}
