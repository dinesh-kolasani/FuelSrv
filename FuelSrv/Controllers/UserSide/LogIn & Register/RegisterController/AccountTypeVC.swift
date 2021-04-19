//
//  AccountTypeVC.swift
//  FuelSrv
//
//  Created by PBS9 on 01/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit


class AccountTypeVC: UIViewController {
    

    
    //Mark: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - ButtonActions
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func MeBtn(_ sender: Any) {
        let NVC = storyboard?.instantiateViewController(withIdentifier: "YouVC") as! YouVC
        navigationController?.pushViewController(NVC, animated: true)
    }
    
    @IBAction func BusinessBtn(_ sender: Any) {
        
        let NVC = self.storyboard?.instantiateViewController(withIdentifier: "YourBusinessVC") as! YourBusinessVC
        navigationController?.pushViewController(NVC, animated: true)
    }
}
