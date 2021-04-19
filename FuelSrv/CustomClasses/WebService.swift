//
//  HelpingSingleton.swift
//  FuelSrv
//
//  Created by PBS9 on 03/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class WebService: NSObject {
    static let shared:WebService = {
        
        let sharedInsatnce = WebService()
        return sharedInsatnce
    }()
    
    //********************** Api Get Method ******************
    //MARK: - GET
    func apiGet(url:String,parameters:[String:Any] , completion: @escaping (_ data:[String:Any]? , _ error:Error?) -> Void)
    {
        print(url)
        print(parameters)
        if !CheckInternet.Connection()
        {
            Helper.Alertmessage(title: "Alert!", message: "Please Check Internet Connection", vc: nil)
            
        }
        
        //SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1))
        SVProgressHUD.setBackgroundColor(.clear)
//        SVProgressHUD.setBorderColor(UIColor.white)
//        SVProgressHUD.setBackgroundColor(UIColor.black)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        manager.request(url, method:.get, parameters: parameters, encoding: URLEncoding.default, headers: headersintoApi()).responseJSON { (response:DataResponse<Any>) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.dismiss()
            
            if response.result.isSuccess
            {
                print("Response Data: \(response)")
                
                if let data = response.result.value as? [String:Any]
                {
                    if let datastr = data["success"] as? Bool
                    //if let datastr = data["status"] as? String
                    {
                        //if datastr == "200"
                          if datastr == true
                        {
                            completion(data , nil)
                        }else{
                            self.showlogoutAlert()
                        }
                    }else
                    {
                        self.showlogoutAlert()
                    }
                    
                    
                    
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
    
    //MARK:- Post API for Place order
    func apiPlaceOrderPost(url:String,parameters:[String:Any] , completion: @escaping (_ data:[String:Any]? , _ error:Error?) -> Void)
    {
        print(url)
        print(parameters)
        if !CheckInternet.Connection()
        {
            Helper.Alertmessage(title: "Alert!", message: "Please Check Internet Connection", vc: nil)
            
        }
       
        SVProgressHUD.show()
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1))
        SVProgressHUD.setBackgroundColor(.clear)
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 45
        Alamofire.request(url, method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in

       
            //            Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default)
            //                .responseJSON { response in
            //                    debugPrint(response)
            //            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            SVProgressHUD.setDefaultMaskType(.clear)
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
    
    
    //********************** Api Post Method ******************
    //MARK: - POST
    
    //webservice for POST
    func apiDataPostMethod(url:String,parameters:[String:Any] , completion: @escaping (_ data:[String:Any]? , _ error:Error?) -> Void)
    {
        print(url)
        print(parameters)
        if !CheckInternet.Connection()
        {
            Helper.Alertmessage(title: "Alert!", message: "Please Check Internet Connection", vc: nil)
            
        }
        
        SVProgressHUD.show()
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1))
        SVProgressHUD.setBackgroundColor(.clear)
        
        
        //        let user = "Ecot Admin"
        //        let hash = "9a1b93c75fec3362ad82f73fe3e3661545aa9559"//"Ecot01"
        //
        //        let credentialData = "\(user):\(hash)".data(using: String.Encoding.utf8)!
        //        let base64Credentials = credentialData.base64EncodedString()
        
        //        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //        [req setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        
//                let headers = [
////                    "Authorization": "Basic \(base64Credentials)",
//                    "Accept":"application/json, text/plain, */*",
//                    "Content-Type":"application/json;charset=utf-8,application/x-www-form-urlencoded",
//                    "Accept-Encoding":"gzip, deflate, br",
//                    "Access-Control-Allow-Origin":"*",
//                    "Access-Control-Allow-Methods":"API, CRUNCHIFYGET, GET, POST, PUT, UPDATE, OPTIONS",
//                    "Access-Control-Allow-Headers":"X-Requested-With, Content-Type, X-Codingpedia"]
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 45
        
        manager.request(url, method:.post, parameters: parameters, encoding: URLEncoding.default, headers: headersintoApi()).responseJSON { (response:DataResponse<Any>) in
            
//            Alamofire.request(postURL, method: .post, parameters: params, encoding: JSONEncoding.default)
//                .responseJSON { response in
//                    debugPrint(response)
//            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            SVProgressHUD.setDefaultMaskType(.clear)
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
    
    //MARK: - MultiPart
    
    // progressHandler: @escaping (_ progressRes:Progress<Any>) -> ()),
    func apiMultiPartPost(serviceName:String,parameters: [String:Any]?,imageData:UIImage , completionHandler: @escaping (_ response:DataResponse<Any>) -> ()) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(imageData, 0.5)!, withName: "photo_path", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                //multipartFormData.append((value as AnyObject).data(String.Encoding.utf8.rawValue), withName: key)
                
            }
        }, to:serviceName)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    //progressHandler(Progress)
                })
                
                upload.responseJSON { response in
                    
                    completionHandler(response)
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
    }
    
    
    
    func headersintoApi() -> [String:String]
    {
        let string = ""
//        if let getTokenType = UserDefaults.standard.value(forKey: tokenType) as? String , let getTokenID = UserDefaults.standard.value(forKey: accessToken) as? String {
//            string = getTokenType + " " + getTokenID
//
//        }
        print(string)

        let headers = ["Content-Type":"application/x-www-form-urlencoded",
                       "Authorization":string]
        return headers
    }
//
    func showlogoutAlert()
    {
        let alert = UIAlertController(title: "Alert!", message: "Your Session is expired", preferredStyle: UIAlertControllerStyle.alert);
        let action = UIAlertAction.init(title: "ok", style: .default) { (sction) in
          //  Helper.shared.appDelegate.loggout()
        }
        alert.addAction(action)
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
