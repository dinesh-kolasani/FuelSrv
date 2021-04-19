//
//  VehicleDetailsVC.swift
//  FuelSrv
//
//  Created by PBS9 on 01/04/19.
//  Copyright © 2019 Dinesh Raja. All rights reserved.
//

import UIKit
import ObjectMapper
import SkyFloatingLabelTextField

class VehicleDetailsVC: UIViewController,UITextFieldDelegate {
   
    
    var helper = Helper()
    var VehicleModelData: VehicleModel!
    var FuelTypeModelData: FuelTypeModel!
    var FuelData: [Fuel]?
    var brandData: [Brand]?
    var allBrandsModelData: AllBrandsModel!
    var AllColorsModelData: AllColorsModel!
    var ColorData: [Color]?
    var AllVehicleModelData: AllVehicleModel!
    var VehiclemodelData: [Vehiclemodel]?
    var fuelTypePicker = UIPickerView()
    var brandPicker = UIPickerView()
    var modelPicker = UIPickerView()
    var colorPicker = UIPickerView()
    var yearsPicker = UIPickerView()
    
    var brandID: String?
    var FuelType: Int?
    var value: Int?
    var years = [String]()
    var vehicle = appDelegate.orderDataDict["Vehicle"] as? [String : Any] ?? [:]
    
    @IBOutlet weak var makeTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var modelTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var yearTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var colorTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var fuelTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var lienseTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var nextBtn: RoundButton!
    
    @IBOutlet weak var vcHeight: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backBtnHeight: NSLayoutConstraint!
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //vcHeight.constant = UIScreen.main.bounds.height
        fuelTypeAPI()
        getbrandsAPI()
        getcolorsAPI()
        picker()
        capitalizedString()
        navigation()
        gettingYears()
print(vehicle)
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .reloadVc, object: nil)
        NotificationCenter.default.removeObserver(self, name: .userAccountVC, object: nil)
    
    }
    
    
    // MARK: - ButtonAction
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextBtn(_ sender: Any) {
       
            validation()
    }
    
    // MARK: - Custom Methods
    func navigation(){
    backBtn.isHidden = true
        // yearsPicker.selectRow(row, inComponent: 0, animated: true)
        if value == 3 {
            makeTxt.text = vehicle["Make"] as? String
            modelTxt.text = vehicle["Model"] as? String
            yearTxt.text = vehicle["Year"] as? String
            colorTxt.text = vehicle["Color"] as? String
            lienseTxt.text = vehicle["LicensePlate"] as? String
            
            if let fuelname = vehicle["Fuel"] as? Int {
                if fuelname == 0 {
                    fuelTxt.text = "Gasoline"
                }else if fuelname == 1 {
                    fuelTxt.text = "Premium Gasoline"
                }else if fuelname == 2{
                    fuelTxt.text = "Diesel"
                }
            }
        }
        
        
        if self.value == 1{
        
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else {
            backBtn.isHidden = true
            backBtnHeight.constant = 0
            navigationItem.title = "VEHICLES"
            let imgBack = UIImage(named: "back")
            navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(Action))
        }
    }
    @objc func Action(){
        self.dismiss(animated: true, completion: nil)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")as! HomeVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == modelTxt{
            //self.brandID = brandData?[row].id
            getModelAPI()
            modelPicker.reloadAllComponents()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("something")
       //modelTxt.text = modelPicker.selectRow(0, inComponent: 0, animated: true)
    }

    func capitalizedString(){
        makeTxt.titleFormatter = { $0 }
        modelTxt.titleFormatter = { $0 }
        yearTxt.titleFormatter = { $0 }
        colorTxt.titleFormatter = { $0 }
        fuelTxt.titleFormatter = { $0 }
        lienseTxt.titleFormatter = { $0 }
        self.modelTxt.delegate = self
    }
    
    func validation(){
        
        if (helper.isFieldEmpty(field: makeTxt.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Vehicle Make", vc: self)
        }else if (helper.isFieldEmpty(field: modelTxt.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Vehicle Model", vc: self)
        }else if (helper.isFieldEmpty(field: yearTxt.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Vehicle Year", vc: self)
        }else if (helper.isFieldEmpty(field: colorTxt.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Vechicle Color", vc: self)
        }else if (helper.isFieldEmpty(field: lienseTxt.text!)){
            Helper.Alertmessage(title: "Info:", message: "Please Enter Liense", vc: self)
        }else if lienseTxt.text?.count ?? 0 < 3 {
            Helper.Alertmessage(title: "Info:", message: "Liense plate must three digits", vc: self)
        }
        else{
            if value == 3{
                updateVehicleAPI()
            }else{
                vehicleAPI()
            }
        }
    }
    func picker(){
        self.fuelTxt.delegate = self
        self.fuelTypePicker.delegate = self
        self.fuelTypePicker.dataSource = self
        self.fuelTxt.inputView = fuelTypePicker
        self.fuelTypePicker.reloadAllComponents()
        
        self.makeTxt.delegate = self
        self.brandPicker.delegate = self
        self.brandPicker.dataSource = self
        self.makeTxt.inputView = brandPicker
        self.brandPicker.reloadAllComponents()
        
        self.modelTxt.delegate = self
        self.modelPicker.delegate = self
        self.modelPicker.dataSource = self
        self.modelTxt.inputView = modelPicker
        self.modelPicker.reloadAllComponents()
        
        self.colorTxt.delegate = self
        self.colorPicker.delegate = self
        self.colorPicker.dataSource = self
        self.colorTxt.inputView = colorPicker
        self.colorPicker.reloadAllComponents()
        
        self.yearTxt.delegate = self
        self.yearsPicker.delegate = self
        self.yearsPicker.dataSource = self
        self.yearTxt.inputView = yearsPicker
        
        self.yearsPicker.reloadAllComponents()

    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == makeTxt{
            self.makeTxt.text = self.pickerView(self.brandPicker, titleForRow: self.brandPicker.selectedRow(inComponent: 0), forComponent: 0)
            //self.brandID = brandData?[0].id
        }else if textField == modelTxt{
            self.modelTxt.text = self.pickerView(self.modelPicker, titleForRow: self.modelPicker.selectedRow(inComponent: 0), forComponent: 0)
        }else if textField == yearTxt{
            self.yearTxt.text = self.pickerView(self.yearsPicker, titleForRow: self.yearsPicker.selectedRow(inComponent: 0), forComponent: 0)
        }else if textField == colorTxt{
            self.colorTxt.text = self.pickerView(self.colorPicker, titleForRow: self.colorPicker.selectedRow(inComponent: 0), forComponent: 0)
        }else if textField == fuelTxt{
            self.fuelTxt.text = self.pickerView(self.fuelTypePicker, titleForRow: self.fuelTypePicker.selectedRow(inComponent: 0), forComponent: 0)
        }
    }
    func gettingYears(){
        
        //Get Current Year into i2
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let objStr = formatter.string(from: Date())
        let i2 = Int(objStr) ?? 0
        
        //Create Years Array from 1950 to This year
        years = [String]()
        for i in 1950...i2+1 {
            years.append("\(i)")
        }
        
        self.yearsPicker.selectRow(50, inComponent: 0, animated: true)
    }
    //MARK:- Update Vehicle API
    func updateVehicleAPI(){
        
        let params:[String:Any] = [
            
            "userId":defaultValues.string(forKey: "UserID")!,
            "vehicleId": vehicle["vehicleID"] ?? "",
            "make":makeTxt.text!,
            "model":modelTxt.text!,
            "year":yearTxt.text!,
            "color":colorTxt.text!,
            "Fuel":FuelType ?? 0,
            "licencePlate":lienseTxt.text!]
        
        WebService.shared.apiDataPostMethod(url: updateVehicleURL, parameters: params) { (response, error) in
            if error == nil{
                self.VehicleModelData = Mapper<VehicleModel>().map(JSONObject: response)
                
                
                if self.VehicleModelData.success == true{
                    
                        NotificationCenter.default.post(name: .userAccountVC, object: nil)
                        NotificationCenter.default.post(name: .reloadVc, object: nil)
                        self.dismiss(animated: true, completion: nil)
                   
                }else if self.VehicleModelData.success == false{
                    Helper.Alertmessage(title: "Info:", message: self.VehicleModelData.message ?? "", vc: self)
                    
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    
    // MARK: - Vehicle API
    
    func vehicleAPI(){
        
        let params:[String:Any] = [
            "userId":defaultValues.string(forKey: "UserID")!,
            "make":makeTxt.text!,
            "model":modelTxt.text!,
            "year":yearTxt.text!,
            "color":colorTxt.text!,
            "Fuel":FuelType ?? 0,
            "licencePlate":lienseTxt.text!]
        
        WebService.shared.apiDataPostMethod(url: vehicleURL, parameters: params) { (response, error) in
            if error == nil{
                self.VehicleModelData = Mapper<VehicleModel>().map(JSONObject: response)
                
                
                if self.VehicleModelData.success == true{
                    
                    if self.value == 1{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FinishRegVC") as! FinishRegVC
                        vc.value = 1
                    self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else if self.value == 2{
                        
                        NotificationCenter.default.post(name: .userAccountVC, object: nil)
                        NotificationCenter.default.post(name: .reloadVc, object: nil)
                        self.dismiss(animated: true, completion: nil)
                        
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyVehicleVC") as! MyVehicleVC
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
//                    let navVC = UINavigationController.init(rootViewController: vc)
//                    navVC.setNavigationBarHidden(true, animated: true)
//                    if let window = UIApplication.shared.windows.first
//                    {
//                        window.rootViewController = navVC
//                        window.makeKeyAndVisible()
//                    }
                }else if self.VehicleModelData.success == false{
                    Helper.Alertmessage(title: "Info:", message: self.VehicleModelData.message ?? "", vc: self)
                    
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    //MARK:- FUEL Type API
    func fuelTypeAPI(){
        let params:[String:Any] = ["accounttype": defaultValues.integer(forKey: "AccountType")]
        WebService.shared.apiGet(url: fuelTypeURL, parameters: params) { (responce, error) in
            if error == nil {
                self.FuelTypeModelData = Mapper<FuelTypeModel>().map(JSONObject: responce)
                
                if self.FuelTypeModelData.success == true {
                    if let home = self.FuelTypeModelData?.fuel
                    {
                        self.FuelData = home
                        self.FuelData?.removeLast() //Your Credit Card details are handled safely and securing using stripe, and not stored anywhere by FuelSrv.
                    }
                    
                }else {
                    Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
        
    }
    //MARK:- All Vehicle Make API
    func getbrandsAPI(){
        let params:[String:Any] = [:]
        WebService.shared.apiGet(url: getbrandsURL, parameters: params) { (responce, error) in
            if error == nil {
                self.allBrandsModelData = Mapper<AllBrandsModel>().map(JSONObject: responce)
                
                if self.allBrandsModelData.success == true {
                    if let home = self.allBrandsModelData?.brands
                    {
                        self.brandData = home
                        self.brandID = self.brandData?[0].id
                        print(home)
                    }
                    
                }
            }
        }
        
    }
    //MARK:- All Vehicle Model API
    func getModelAPI(){
        let params:[String:Any] = ["brandId": brandID ?? ""]
        WebService.shared.apiDataPostMethod(url: getModelsURL, parameters: params) { (responce, error) in
            if error == nil {
                self.AllVehicleModelData = Mapper<AllVehicleModel>().map(JSONObject: responce)
                
                if self.AllVehicleModelData.success == true {
                    if let home = self.AllVehicleModelData.vehiclemodels
                    {
                        self.VehiclemodelData = home
                        print(home)
                        self.modelPicker.reloadAllComponents()
                    }
                    
                }
            }
        }
        
    }
    //MARK:- All Vehicle Color API
    func getcolorsAPI(){
        let params:[String:Any] = [:]
        WebService.shared.apiGet(url: getcolorsURL, parameters: params) { (responce, error) in
            if error == nil {
                self.AllColorsModelData = Mapper<AllColorsModel>().map(JSONObject: responce)
                
                if self.AllColorsModelData.success == true {
                    if let home = self.AllColorsModelData?.color
                    {
                        self.ColorData = home
                        print(home)
                    }
                    
                }
            }
        }
        
    }
}
extension VehicleDetailsVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == fuelTypePicker{
           return FuelData?.count ?? 0
        }else if pickerView == brandPicker{
            return brandData?.count ?? 0
        }else if pickerView == colorPicker{
            return ColorData?.count ?? 0
        }else if pickerView == modelPicker{
            return VehiclemodelData?.count ?? 0
        }else if pickerView == yearsPicker{
            return years.count
        }
        return 0
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == fuelTypePicker{
            
            return FuelData?[row].fuelName
        
        } else if pickerView == brandPicker{
           
            return brandData?[row].brandName
        
        } else if pickerView == colorPicker{
           
            return ColorData?[row].colorName
        
        } else if pickerView == modelPicker{
           
            return VehiclemodelData?[row].vehiclemodelName
            
        } else if pickerView == yearsPicker{
            
            return years[row]
        }
        return ""
    
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == fuelTypePicker{
           
            self.fuelTxt.text = FuelData?[row].fuelName
            self.FuelType = FuelData?[row].fuelType
        
        }else if pickerView == brandPicker{
            
            self.makeTxt.text = brandData?[row].brandName
            self.brandID = brandData?[row].id
            self.modelTxt.text = ""
            //getModelAPI()
            
        }else if pickerView == colorPicker{
            
            self.colorTxt.text = ColorData?[row].colorName
        }else if pickerView == modelPicker{
            
            self.modelTxt.text = VehiclemodelData?[row].vehiclemodelName
        }else if pickerView == yearsPicker{
            
            self.yearTxt.text = years[row]
        }
    }
}
