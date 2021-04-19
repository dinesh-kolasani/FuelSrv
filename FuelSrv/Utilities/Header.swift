//
//  Header.swift
//  FuelSrv
//
//  Created by PBS9 on 03/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//
import Foundation
import UIKit

let KMainStoryBoard = UIStoryboard.init(name:"Main", bundle: nil)
let DriverStoryBoard = StoryBoard.DriverMain.get
var appDelegate = UIApplication.shared.delegate as! AppDelegate
//var returnValue = UserDefaults.standard.object(forKey: "UserID")


let DEVICE_SIZE = UIScreen.main.bounds
let DEVICE_HEIGHT = DEVICE_SIZE.height
let DEVICE_WIDTH = DEVICE_SIZE.width
let APPDELEGATE = (UIApplication.shared.delegate as! AppDelegate)

// MARK: Methods
func setCenterViewController(controller: UIViewController) {
    let navigationController = APPDELEGATE.sideMenuController?.rootViewController as? UINavigationController
    navigationController?.viewControllers = [controller]
    APPDELEGATE.sideMenuController?.rootViewController = navigationController
    
    APPDELEGATE.sideMenuController?.hideRightViewAnimated()
}

func showMenu() {
    guard let sideMenu = APPDELEGATE.sideMenuController else {
        return
    }
    sideMenu.showRightViewAnimated()
}

func setRoot() {
    let controller = DriverStoryBoard.instantiateViewController(withIdentifier: "DriverHomeVC") as! DriverHomeVC
    let navigationController = APPDELEGATE.sideMenuController?.rootViewController as? UINavigationController
    navigationController?.viewControllers = [controller]
    APPDELEGATE.sideMenuController?.rootViewController = navigationController
    
    APPDELEGATE.sideMenuController?.hideRightViewAnimated()
}


enum StoryBoard :String
{
    case Main
    case DriverMain
    var get:UIStoryboard
    {
        let sb  = UIStoryboard.init(name: self.rawValue, bundle: nil)
        return  sb
    }
}

