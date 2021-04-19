//
//  ThankYouVC.swift
//  FuelSrv
//
//  Created by PBS9 on 17/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class ThankYouVC: UIViewController {

    @IBOutlet weak var applicationView: RoundedView!
    
    @IBOutlet weak var finishBtn: RoundButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        applicationView.dropShadow(view: applicationView, opacity: 1.0)
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func finishBtn(_ sender: Any) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
