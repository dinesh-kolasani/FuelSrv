//
//  FreeGasVC.swift
//  FuelSrv
//
//  Created by PBS9 on 07/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class FreeGasVC: UIViewController,UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var inviteCodeBtnAction: UIButton!
    
    @IBOutlet weak var shareBtn: RoundButton!
    
    @IBOutlet weak var inviteBtn: RoundButton!
    var inviteCode = String()
    
    @IBOutlet weak var vcHeight: NSLayoutConstraint!
    //var inviteCode: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        //vcHeight.constant = UIScreen.main.bounds.height
        
       inviteCode = defaultValues.string(forKey: "InviteCodeText")!
        navigation()
       
    }
    //MARK:- Navigation Bar
    func navigation(){
        
        inviteCodeBtnAction.setTitle(defaultValues.string(forKey: "InviteCodeText")!, for: .normal) // inviteCodeText
        self.navigationItem.title = "FREE GAS"
       let imgBack = UIImage(named: "back")
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(Action))
    }
    @objc func Action(){
        
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let nav = NavigationController.init(rootViewController: vc)
        self.sideMenuController?.rootViewController = nav
      
    }
    
    //MARK:- Button Actions
    @IBAction func inviteCodeBtnAction(sender: UIButton!) {
       UIPasteboard.general.string = inviteCodeBtnAction.titleLabel?.text
        showAlert("Note", "Code Copied", "OK")
        
    }
    // Share Button Action
    @IBAction func shareBtnAction(_ sender: UIButton) {
        // text to share
        let text = "I'm inviting you to join FuelSrv. Use my invite code '\(String(describing: inviteCode))' while registering to get $10 off your next fueling."
        print(text)
        //let image = UIImage(named: "logo@")
        let iOSAppLink = NSURL(string: "https://apps.apple.com/us/app/fuelsrv/id1472710509?ls=1")
        let androidAppLink = NSURL(string: "https://play.google.com/store/apps/details?id=com.possibility.fuelsrv")

        // set up activity view controller
        let share = [ text, "iPhone: \(iOSAppLink!)", "Android: \(androidAppLink!)" ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: true)
    }
    
}
