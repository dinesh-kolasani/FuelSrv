//
//  HelpViewController.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 08/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    var helpImagesArr = [UIImage]()
    var helpLableArr = [String]()
    @IBOutlet weak var helpTV: UITableView!
    @IBOutlet weak var helpSideBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        helpImagesArr = [#imageLiteral(resourceName: "DriverHelp"),#imageLiteral(resourceName: "DriverPayment"),#imageLiteral(resourceName: "DriverFuel-type"),#imageLiteral(resourceName: "DriverTechnical support")]
        helpLableArr = ["Report an issue","Accounts And Payments","Driver's Guide To FuelSrv","Technical Support"]
        
        helpTV.tableFooterView = UIView()

    }
  
    @IBAction func helpSideButn(_ sender: UIButton) {
        
        showMenu()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideViewController")as! SideViewController
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        setRoot()
    }
    
    
  

}
extension HelpViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpLableArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpTableViewCell", for:indexPath) as!HelpTableViewCell
        cell.helpImages.image = helpImagesArr[indexPath.row]
        cell.helpLable.text = helpLableArr[indexPath.row]
        return cell
    }
    
    
}
