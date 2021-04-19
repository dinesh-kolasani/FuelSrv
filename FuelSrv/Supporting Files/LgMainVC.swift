//
//  LgMainVC.swift
//  FuelSrv
//
//  Created by PBS9 on 26/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit
import LGSideMenuController

class LgMainVC: LGSideMenuController {

    private var type: UInt?

   
    func setupWithPresentationStyle(style: LGSideMenuPresentationStyle, type: Int) {
        
        rightViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC
    }
    
    override func rightViewWillLayoutSubviews(with size: CGSize) {
        super.rightViewWillLayoutSubviews(with: size)
    }

}
