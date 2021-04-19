//
//  TableViewCell.swift
//  FuelSrv
//
//  Created by PBS9 on 07/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class PreviousFuelingsCell: UITableViewCell {
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var subAddressLbl: UILabel!
    @IBOutlet weak var fuelTypeLbl: UILabel!
    @IBOutlet weak var additionalServicesLbl: UILabel!
    @IBOutlet weak var completedTimeLbl: UILabel!
    @IBOutlet weak var driverNameLbl: UIButton!
    
    @IBOutlet weak var cellView: RoundedView!
    
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
