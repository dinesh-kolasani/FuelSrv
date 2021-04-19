//
//  ScheduledFuelingsCell.swift
//  FuelSrv
//
//  Created by PBS9 on 30/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class ScheduledFuelingsCell: UITableViewCell {

    @IBOutlet weak var cellView: RoundedView!
    @IBOutlet weak var addressNameLbl: UILabel!
    
    @IBOutlet weak var subAddressNameLbl: UILabel!
    
    @IBOutlet weak var fuelTypeLbl: UILabel!
    
    @IBOutlet weak var additionalServicesLbl: UILabel!
    
    @IBOutlet weak var RequestTimeLbl: UILabel!
    
    @IBOutlet weak var requestLbl: UILabel!
    
    
    @IBOutlet weak var cellMenuBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cellView.dropShadow(view: cellView, opacity: 0.7)

        // Configure the view for the selected state
    }
    
}
