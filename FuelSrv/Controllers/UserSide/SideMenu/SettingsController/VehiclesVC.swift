//
//  VehiclesVC.swift
//  FuelSrv
//
//  Created by PBS9 on 24/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper

class VehiclesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addAddressBtn: RoundButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var businessVehiclesTitle: UILabel!
    var VehiclesModelData: VehiclesModel!
    var VehicleData: [Vehicle]!
    var vehicleDetails: [String:Any] = [:]
    var vehicleId: String?
    var picker  = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationRightItem()
        
        
        let nib = UINib.init(nibName: "UserAccountCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserAccountCell")
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadVc), name:.userAccountVC, object: nil)
        
    }
    @objc func reloadVc()
    {
        getAllvehiclesAPI()
    }
    
    
    @IBAction func addAddressBtnAction(_ sender: Any) {
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
        vc.value = 2
        let nav  = UINavigationController.init(rootViewController: vc)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    func navigationRightItem(){
        
        self.navigationItem.title = "VEHICLES"
        
        let imgBack = UIImage(named: "back")
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(backAction))
       if defaultValues.integer(forKey: "AccountType") == 1{
        addAddressBtn.isHidden = true
        businessVehiclesTitle.text = "Approx. Number of Vehicles"
       }else{
            getAllvehiclesAPI()
        }
    }
    
    @objc func backAction(){
        
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
    }
    func getAllvehiclesAPI(){
        let params:[String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        WebService.shared.apiDataPostMethod(url: getAllvehiclesURL, parameters: params) { (responce, error) in
            if error == nil {
                self.VehiclesModelData = Mapper<VehiclesModel>().map(JSONObject: responce)
                if self.VehiclesModelData.success == true {
                    if let data = self.VehiclesModelData.vehicles{
                        self.VehicleData = data
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    //MARK:- Menu Dots Action
    @objc func memuDotsBtnAction(sender: UIButton) {
        let alert = UIAlertController(title: "Info:", message: "Choose your actions", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            print("You've pressed Cancel")
        }))
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            print("You've pressed Edit")
            if (self.VehicleData!.count > sender.tag){
                let vehicleModel = self.VehicleData![sender.tag]
                //self.vehicleId = scheduleModel.id
                self.vehicleDetails[MyVehicleEnum.Fuel.rawValue] = vehicleModel.fuel
                self.vehicleDetails[MyVehicleEnum.vehicleID.rawValue] = vehicleModel.id
                self.vehicleDetails[MyVehicleEnum.Year.rawValue] = vehicleModel.year
                self.vehicleDetails[MyVehicleEnum.Make.rawValue] = vehicleModel.make
                self.vehicleDetails[MyVehicleEnum.Model.rawValue] = vehicleModel.model
                self.vehicleDetails[MyVehicleEnum.Color.rawValue] = vehicleModel.color
                self.vehicleDetails[MyVehicleEnum.LicensePlate.rawValue] = vehicleModel.licencePlate
                appDelegate.orderDataDict[OrderDataEnum.Vehicle.rawValue] = self.vehicleDetails
                
            }
            
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! VehicleDetailsVC
            print(self.vehicleDetails)
            vc.value = 3
            let nav  = UINavigationController.init(rootViewController: vc)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            
            if (self.VehicleData!.count > sender.tag){
                let scheduleModel = self.VehicleData![sender.tag]
                self.vehicleId = scheduleModel.id
            }
            
            self.deleteVehiclesAPI(url: deleteVehicleURL, params: ["vehicleId": self.vehicleId!])
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func deleteVehiclesAPI(url: String, params:[String:Any]){
        
        //let params:[String:Any] = ["vehicleId": "5ce05bfc49fb1626b260da17"]
        
        WebService.shared.apiDataPostMethod(url: url, parameters: params) { (responce, error) in
            if error == nil {
                if let dic = responce {
                    print(dic)
                    Helper.Alertmessage(title: "Info:", message: dic["message"] as! String, vc: self)
                    self.getAllvehiclesAPI()
                }
                
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    //MARK:- Update Vehicle Count API
    func updateVehicleCountAPI(parameters: [String:Any]){
        //let parameters: [String:Any] = ["userId": defaultValues.string(forKey: "UserID")!]
        print(parameters)
        
        SVProgressHUD.show()
        
//        guard let image1 = self.userImage.image else{return}
//        guard let imgData1 = UIImageJPEGRepresentation(image1, 0.1) else{return}
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
           // multipartFormData.append(imgData1, withName: "avatar",fileName: "file.jpg", mimeType: "jpg/png/jpeg")
            for (key, value) in parameters {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                
            }
            
        }, usingThreshold: UInt64.init(),to: updateProfileURL, method: .post) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    let value = Float(progress.fractionCompleted)*100
                    print(progress.fractionCompleted)
                    print(value)
                    
                })
                upload.responseJSON { response in
                    print("Succesfully uploaded = \(response)")
                    
                    if let dic = response.result.value as? Dictionary<String, Any>{
                        
                        print(dic)
                        
                        DispatchQueue.main.async
                            {
                                SVProgressHUD.dismiss()
                                
                               // let  imageData = dic["data"] as? [String:Any]
                                
//                                if let backgroundImage = imageData?["avatar"] as? String
//                                {
//                                    let myUrl = baseImageURL + backgroundImage
//
//                                    if let imageURL = URL(string: myUrl)
//                                    {
//                                        print(imageURL)
//
//                                        //                                                        self.backgroundImage.sd_setShowActivityIndicatorView(true)
//                                        //                                                        self.backgroundImage.sd_setIndicatorStyle(.white)
//                                        self.userImage.sd_setImage(with: imageURL, completed: { (img, error, SDImageCacheType, url) in
//
//                                        })
//
//                                    }
//
//                                }
                                let alertWithCompletionAndCancel = Helper.Alert.errorAlert(title: "Info:", message: dic["message"] as? String, cancelButton: false) {
                                    
                                    //_ = self.navigationController?.popViewController(animated: true)
                                    
                                }
                                self.present(alertWithCompletionAndCancel, animated: true)
                                
                        }
                        
                    }
                    
                }
            case .failure(let encodingError):
                print("Error in upload: \(encodingError.localizedDescription)")
                
            }
            
        }
    }

}
extension VehiclesVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if defaultValues.integer(forKey: "AccountType") == 0{
            if let data = VehicleData, data.count > 0{
                errorLabel.isHidden = true
                return VehicleData?.count ?? 0
            }else{
                errorLabel.isHidden = false
                errorLabel.text = "No Vehicles found"
                return 0
            }
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserAccountCell", for: indexPath) as! UserAccountCell
        if defaultValues.integer(forKey: "AccountType") == 0 {

            if let data = VehicleData, data.count > indexPath.row{
                cell.vehicleDetailsLbl.text = String(describing: data[indexPath.row].year!) + " " + " " + String(describing: data[indexPath.row].model!) + "," + " " + String(describing: data[indexPath.row].color!) + " " + String(describing: data[indexPath.row].licencePlate!) // String(describing: data[indexPath.row].make!) +
                cell.vehicleBtn.isHidden = false
                cell.vehicleBtn.tag = indexPath.row
                cell.vehicleBtn.addTarget(self, action: #selector(memuDotsBtnAction), for: .touchUpInside)
            
            }
        }else{
            cell.vehicleBtn.isHidden = false
            cell.vehicleDetailsLbl.text = noOfVehicle
            cell.vehicleBtn.addTarget(self, action: #selector(Vehicles), for: .touchUpInside)
        }
        return cell
    }
    @objc func Vehicles(){
        picker = UIPickerView.init()
        self.picker.delegate = self
        self.picker.dataSource = self
        picker.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        picker.setValue(#colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1), forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.showsSelectionIndicator = true
        picker.layer.cornerRadius = 5
        picker.dropShadow(view: picker, opacity: 1.0)
        picker.frame = CGRect.init(x: 50, y: 125, width: UIScreen.main.bounds.size.width - 95, height: 150)
        self.view.addSubview(picker)
        
        
    }
}
//MARK:- Picker view
extension VehiclesVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return approxNoOfVehicles.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return approxNoOfVehicles[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        noOfVehicle = approxNoOfVehicles[row]
        self.tableView.reloadData()
        picker.removeFromSuperview()
        self.updateVehicleCountAPI(parameters: ["userId": defaultValues.string(forKey: "UserID")!,
                                           "vehicleCount": noOfVehicle])
    }
}
