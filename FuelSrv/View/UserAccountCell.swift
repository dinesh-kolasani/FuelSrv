//
//  UserAccountCell.swift
//  FuelSrv
//
//  Created by PBS9 on 17/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class UserAccountCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var vehicleDetailsLbl: UILabel!
    @IBOutlet weak var vehicleBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.dropShadow(view: cellView, opacity: 0.7)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
