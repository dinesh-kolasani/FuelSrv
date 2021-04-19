//
//  OrderSummuryCel.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 17/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

class OrderSummuryCel: UITableViewCell {
    
    
    
    @IBOutlet weak var convinient: UIView!
    
    @IBOutlet weak var fuelType: UIView!
    
    @IBOutlet weak var vehicle: UIView!
    
    @IBOutlet weak var address: UIView!
    
    @IBOutlet weak var amount: UIView!
    
    @IBOutlet weak var proceedBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        self.convinient.layer.borderWidth = 1
        self.convinient.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
//        self.fuelType.layer.borderWidth = 0.5
//        self.fuelType.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.vehicle.layer.borderWidth = 0.5
        self.vehicle.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
//        self.address.layer.borderWidth = 0.5
//        self.address.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//
        self.amount.layer.borderWidth = 0.5
        self.amount.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        

        // Configure the view for the selected state
    }
    
    
    
    
}
