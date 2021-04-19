//
//  AboutVC.swift
//  FuelSrv
//
//  Created by PBS9 on 26/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import WebKit


class AboutVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var vcCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation()
       
    }
    func navigation(){
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        let imgBack = UIImage(named: "back")
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(backAction))
        
        webData()
        
    }
    @objc func backAction(){
        if vcCount == 1{
            
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
            //self.navigationController?.popToViewController(vc, animated: true)
        }else if vcCount == 2{
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
            let nav = NavigationController.init(rootViewController: vc)
            self.sideMenuController?.rootViewController = nav
            //self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    func webData(){
        if vcCount == 1{
            
            self.navigationItem.title = "ABOUT"
            let url = URL (string: aboutURL)
            let requestObj = URLRequest(url: url!)
            webView.load(requestObj)
        }else if vcCount == 2{
            
            self.navigationItem.title = "USER'S GUIDE TO FUELSRV"
            let url = URL (string: userGuideURL)
            let requestObj = URLRequest(url: url!)
            webView.load(requestObj)
        }
        
    }

}
