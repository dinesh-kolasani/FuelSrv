//
//  BecomeADriverVC.swift
//  FuelSrv
//
//  Created by PBS9 on 12/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class BecomeADriverVC: UIViewController {

    @IBOutlet weak var applyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       navigation()
        applyBtn.isHidden = true
    }
    
    @IBAction func applyBtn(_ sender: Any) {

        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
    }
    
    @IBAction func enterBtn(_ sender: Any) {
        showAlert("Info:", "If you're interested in joining the FuelSrv team as a Driver, please select apply!", "OK")
       
    }
    func navigation(){
        self.navigationItem.title = "BECOME A DRIVER"

        let imgBack = UIImage(named: "back")
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(Action))
        
    }
    @objc func Action(){
        
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
        
    }
}
