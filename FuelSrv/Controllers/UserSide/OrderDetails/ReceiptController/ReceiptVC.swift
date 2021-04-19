//
//  ReceiptVC.swift
//  FuelSrv
//
//  Created by PBS9 on 21/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class ReceiptVC: UIViewController {

    @IBOutlet weak var physicalReceiptBtn: UIButton!
    @IBOutlet weak var rememberBtn: UIButton!
    @IBOutlet weak var btnBGImg: UIImageView!
    
    var physicalReceiptValue: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetUp()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Actions
    @IBAction func physicalReceiptBtnAction(_ sender: UIButton) {
        if sender.isSelected{
            physicalRecieptYes = 0
            //physicalReceiptBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
            btnBGImg.image = #imageLiteral(resourceName: "Rounded Rectangle")
            
        }else {
            
            //physicalReceiptBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
            btnBGImg.image = #imageLiteral(resourceName: "checkbox-activated@")
            physicalRecieptYes = 1
        }
        
        physicalReceiptBtn.isSelected = !physicalReceiptBtn.isSelected
    }
    
    @IBAction func rememberBtnAction(_ sender: UIButton) {
        if sender.isSelected{
            
            rememberBtn.setImage(#imageLiteral(resourceName: "Rounded Rectangle"), for: .normal)
        }else {
            
            rememberBtn.setImage(#imageLiteral(resourceName: "checkbox-activated@"), for: .normal)
            
        }
        
        rememberBtn.isSelected = !rememberBtn.isSelected
    }
    @IBAction func nextBtnAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSummaryVC") as! PaymentSummaryVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        //self.navigationController?.popViewController(animated: true)
    }
    func navigationSetUp(){
        if physicalRecieptYes == 1{
            
            btnBGImg.image = #imageLiteral(resourceName: "checkbox-activated@")
        }
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.title = "RECEIPT"
    }
}
