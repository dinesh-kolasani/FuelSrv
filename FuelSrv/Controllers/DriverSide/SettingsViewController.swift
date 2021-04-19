//
//  SettingsViewController.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 11/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class SettingsViewController: UIViewController {
    
    var settImages = [UIImage]()
    var settArr = [String]()
   
    @IBOutlet weak var settingTableview: UITableView!
    
    @IBAction func settingsSideBtn(_ sender: Any) {
        showMenu()

    }
    
    @IBAction func setBackBtn(_ sender: UIButton) {
        setRoot()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settImages = [#imageLiteral(resourceName: "DriverUser-shape"),#imageLiteral(resourceName: "DriverPayment"),#imageLiteral(resourceName: "DriverNotifications"),#imageLiteral(resourceName: "DriverLocation pin"),#imageLiteral(resourceName: "DriverLogout")]
        settArr = ["Account","Payments","Notification","Location Services","Logout"]
        
        
        settingTableview.tableFooterView = UIView()
       
    }
    func driverLogOutAction() {
        let alert = UIAlertController(title: "Sign out?", message: "You can always access your content by signing back in", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Sign out",style: UIAlertActionStyle.destructive,handler: {(_: UIAlertAction!) in
            //Sign out action
            GIDSignIn.sharedInstance().signOut()
            LoginManager().logOut()
            
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
            
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
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
}

extension SettingsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settArr.count
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        cell.cellImage?.image = settImages[indexPath.row]
        cell.cellLabel?.text = settArr[indexPath.row]
        
        if (indexPath.row == 2) || (indexPath.row == 3){
        
            cell.cellSwitch.isHidden = false
            cell.cellButton.isHidden = true
        }
        else{
            cell.cellSwitch.isHidden = true
            cell.cellButton.isHidden = false
            
        }
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch indexPath.row {
        case 0:
            
            let vc = DriverStoryBoard.instantiateViewController(withIdentifier: "DriverAccountVC") as! DriverAccountVC
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            
            let vc = DriverStoryBoard.instantiateViewController(withIdentifier: "CompensationViewController") as! CompensationViewController
            
            navigationController?.pushViewController(vc, animated: true)
            
        case 2:
            break
            
        case 3:
            break
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
//            navigationController?.pushViewController(vc, animated: true)
            
        case 4:
            //   _ = UIApplication.shared.delegate as? AppDelegate
            
            print("somthing wrong\(userID)")
            
           self.driverLogOutAction()
            
        default:
            break
        }
    }
    
}

