//
//  ServicesCell.swift
//  FuelSrv
//
//  Created by PBS9 on 22/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class ServicesCell: UITableViewCell {

    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellPriceLabel: UILabel!
    
    @IBOutlet weak var vehiclesCountView: UIView!
    @IBOutlet weak var vechicleCountLbl: UILabel!
    @IBOutlet weak var vehicleCountBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
