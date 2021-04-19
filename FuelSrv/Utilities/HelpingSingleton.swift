//
//  HelpingSingleton.swift
//  FuelSrv
//
//  Created by PBS9 on 02/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import SVProgressHUD
struct Helper
{
    static var shared = Helper()
    //App delegate
    
    // Mark: - Alert Message
    // =====================================
    static func Alertmessage(title:String, message:String , vc:UIViewController?)
    {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        
        if vc != nil
        {
            vc!.present(alert, animated: true, completion: nil)
        }
        else
        {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate
            {
                appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    struct Alert {
        static func errorAlert(title: String, message: String?, cancelButton: Bool = false, completion: (() -> Void)? = nil) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .default) {
                _ in
                guard let completion = completion else { return }
                completion()
            }
            alert.addAction(actionOK)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            cancel.setValue(#colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1), forKey: "titleTextColor")
            if cancelButton { alert.addAction(cancel) }
            
            return alert
        }
        
    }
    // =========== UIview only top edges cornerradius ================
    
    static func TopedgeviewCorner(viewoutlet:UIView, radius: CGFloat)
    {
        viewoutlet.clipsToBounds = true
        viewoutlet.layer.cornerRadius = radius
        viewoutlet.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    static func BottemedgeviewCorner(viewoutlet:UIView)
    {
        viewoutlet.clipsToBounds = true
        viewoutlet.layer.cornerRadius = 15
        viewoutlet.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    static func viewCornerRadius(viewoutlet:UIView)
    {
        viewoutlet.clipsToBounds = true
        viewoutlet.layer.cornerRadius = 15
        viewoutlet.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    // ============  UITextView CornerRadius =======================
    
    static func TextviewcornerRadius(textviewoutlet:UITextView)
    {
        textviewoutlet.layer.borderWidth = 1
        textviewoutlet.layer.borderColor = UIColor.init(red: 175/255, green: 178/255, blue: 197/225, alpha: 0.2).cgColor
        textviewoutlet.layer.cornerRadius = 15
    }
    
    // Mark: - Valid Email or Not
    /*************************************************************/

    func isValidEmail(candidate: String) -> Bool {

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
        if valid {
            valid = !candidate.contains("..")
        }
        return !valid
    }

    // Mark: - Field empty or not
    /*************************************************************/

    func isFieldEmpty(field: String) -> Bool {
        return field.count == 0
    }
    
    // MARK: - Networking For API'S
    /**************************************************************/
    
    // Alamofire Data From API (POST Method)
    static func apiDataPostMethod(url:String,parameters:[String:Any] , completion: @escaping (_ data:[String:Any]? , _ error:Error?) -> Void)
    {
        if !CheckInternet.Connection()
        {
            Helper.Alertmessage(title: "Alert!", message: "Please Check Internet Connection", vc: nil)
            
        }
        
        SVProgressHUD.show()
        //        let urlRequest = URLRequest(url: URL(fileURLWithPath: url))
        //        Alamofire.request(url, method: .post, parameters: parameters, encoding: , headers: nil)
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            SVProgressHUD.dismiss()
            
            if response.result.isSuccess
            {
                print("Response Data: \(response)")
                
                if let data = response.result.value as? [String:Any]
                {
                    completion(data , nil)
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: (response.error?.localizedDescription)!, vc: nil)
                    
                    completion(nil,response.error)
                }
            }
            else
            {
                Helper.Alertmessage(title: "Info:", message: (response.error?.localizedDescription)!, vc: nil)
                completion(nil,response.error)
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    // Alamofire Data From API(GET Method)
    static func apiDataGetMethod(url:String,parameters:[String:Any], completion: @escaping (_ data:[String:Any]? , _ error:Error?) -> Void)
    {
        if !CheckInternet.Connection()
        {
            Helper.Alertmessage(title: "Alert!", message: "Please Check The InternetConnetion", vc: nil)
        }
        SVProgressHUD.show()
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            SVProgressHUD.dismiss()
            
            if response.result.isSuccess
            {
                if let data = response.result.value as? [String:Any]
                {
                    completion(data , nil)
                    
                    print("Jsondata Data:\(data)")
                }else
                {
                    completion(nil,response.error)
                    
                    print("Json having nil data")
                }
            }
            else
            {
                completion(nil,response.error)
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
}

