//
//  orderSuccessVC.swift
//  FuelSrv
//
//  Created by PBS9 on 20/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class OrderSuccessVC: UIViewController {

    @IBOutlet weak var doneBtn: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        doneBtn.dropShadow(view: doneBtn, opacity: 0.3)
        appDelegate.orderDataDict = [:]
        print(appDelegate.orderDataDict)

        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    @IBAction func doneBtnAction(_ sender: Any) {
        appDelegate.configureSideMenu()
    }
    
}
