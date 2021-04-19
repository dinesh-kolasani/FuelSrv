//
//  FuelingsToDoCel.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 15/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

class FuelingsToDoCel: UITableViewCell {

    @IBOutlet weak var cellBGView: RoundedView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var fuelTypeLbl: UILabel!
    @IBOutlet weak var additionalServicesLbl: UILabel!
    
    @IBOutlet weak var orderTypeLblHeight: NSLayoutConstraint!
    @IBOutlet weak var orderTypeLbl: UILabel!
    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var requestedTitleLbl: UILabel!
    @IBOutlet weak var requestedLbl: UILabel!
    
    override func awakeFromNib(){
            super.awakeFromNib()
        // Initialization code
    }
    
        override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
           cellBGView.dropShadow(view: cellBGView, opacity: 0.5)
            
        // Configure the view for the selected state
    }
    
}
