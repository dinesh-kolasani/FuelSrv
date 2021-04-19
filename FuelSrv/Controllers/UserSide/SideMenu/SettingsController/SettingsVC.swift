//
//  SettingsVC.swift
//  FuelSrv
//
//  Created by PBS9 on 12/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class SettingsVC: UIViewController {
    
    @IBOutlet weak var settingTbl: UITableView!
    var images = [#imageLiteral(resourceName: "user-shape"),#imageLiteral(resourceName: "home-button"),#imageLiteral(resourceName: "car"),#imageLiteral(resourceName: "payment"),#imageLiteral(resourceName: "notifications"),#imageLiteral(resourceName: "location pin"),#imageLiteral(resourceName: "invoice"),#imageLiteral(resourceName: "about"),#imageLiteral(resourceName: "logout")]
    
    var names = ["Account","Addresses","Vehicles","Payment","Notifications","Location","Physical Receipts","About","Logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationRightItem()
        
        settingTbl.tableFooterView = UIView()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    func navigationRightItem(){
        
        self.navigationItem.title = "SETTINGS"
//        let imgMenu = UIImage(named: "menu-button")
//        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: imgMenu, style: .plain, target: self, action: #selector(Action))
        let imgBack = UIImage(named: "back")
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(backAction))
    }
    
    @objc func Action(){
        
        showMenu()
    }
    @objc func backAction(){
        
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
    }
    
    func logOutAction() {
        let alert = UIAlertController(title: "Sign out?", message: "You can always access your content by signing back in", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Sign out",style: UIAlertActionStyle.destructive,handler: {(_: UIAlertAction!) in
            //Sign out action
            GIDSignIn.sharedInstance().signOut()
            
            LoginManager().logOut()
           // AccessToken.current = nil
        
            
            defaultValues.set(nil, forKey: "UserID")
            //defaultValues.set(nil, forKey: "DeviceID")
            defaultValues.set(nil, forKey: "UserName")
            defaultValues.set(nil, forKey: "avatar")
            defaultValues.set(nil, forKey: "address")
            defaultValues.set(nil, forKey: "AccountType")
            defaultValues.set(nil, forKey: "PhysicalReciept")
            defaultValues.set(nil, forKey: "MembershipTaken")
            defaultValues.set(nil, forKey: "InviteCodeText")
            defaultValues.set(0, forKey: "UserType")
            defaultValues.set(nil, forKey: "IsVerified")
            
            defaultValues.synchronize()
            
            appDelegate.orderDataDict = [:]
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: true)
            print(appDelegate.orderDataDict)
            print("somthing===========\(String(describing: defaultValues.string(forKey: "UserID")))")
            if let window = UIApplication.shared.windows.first
            {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- Physical Receipts API
    func physicalReceiptsAPI(on: Int){
        let params:[String:Any] = ["isPhysicalRecieptYes": on,
                                   "userId": defaultValues.string(forKey: "UserID")!]
        WebService.shared.apiDataPostMethod(url: physicalRecieptURL, parameters: params) { (responce, error) in
            if error == nil {
                if let dict = responce {
                    physicalRecieptYes = dict["isPhysicalRecieptYes"] as! Int
                    Helper.Alertmessage(title: "Info:", message: dict["message"] as! String, vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:!", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
    //MARK:- Notification On/Off PI
    func notificationOnOffAPI(on: Int){
        let params:[String:Any] = ["isNotificationTrue": on,
                                   "userId": defaultValues.string(forKey: "UserID")!]
        WebService.shared.apiDataPostMethod(url: notificationOnOffURL, parameters: params) { (responce, error) in
            if error == nil {
                if let dict = responce {
                    Helper.Alertmessage(title: "Info:", message: dict["message"] as! String, vc: self)
                }
            }else{
                Helper.Alertmessage(title: "Info:", message: error?.localizedDescription ?? "", vc: self)
            }
        }
    }
}
//MARK:- Table View
extension SettingsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = settingTbl.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        let cell = settingTbl.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
        cell.settingLBL.text = names[indexPath.row]
        cell.settingIMG.image = images[indexPath.row]
        cell.settingSwitch.tag = indexPath.row
        if (indexPath.row == 4) || (indexPath.row == 5) || (indexPath.row == 6){
          cell.settingSwitch.isHidden = false
            cell.settingBTN.isHidden = true
            if indexPath.row == 4 {
                if notificationTrue == 0{
                    cell.settingSwitch.isOn = false
                }
            }else if indexPath.row == 6 {
                if physicalRecieptYes == 0{
                    cell.settingSwitch.isOn = false
                }
            }
        }
        else{

            cell.settingSwitch.isHidden = true
            cell.settingBTN.isHidden = false
        }
        cell.settingSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    @objc func switchAction (sender: UISwitch){
        print(sender.tag)
        if sender.tag == 6{
            if sender.isOn {
                physicalReceiptsAPI(on: 1)
            }else{
                physicalReceiptsAPI(on: 0)
            }
        }else if sender.tag == 4{
            if sender.isOn {
                notificationOnOffAPI(on: 1)
            }else{
                notificationOnOffAPI(on: 0)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAccountVC") as! UserAccountVC
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "AddressesVC") as! AddressesVC
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
            
        case 2:
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "VehiclesVC") as! VehiclesVC
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
        case 3:
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            vc.value = true
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
            
        case 7:
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
            vc.vcCount = 1
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
    
        case 8:
           
            print("somthing wrong\(userID)")
            self.logOutAction()

        default:
            break
        }
    }
}
