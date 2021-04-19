//
//  SettingsCell.swift
//  FuelSrv
//
//  Created by PBS9 on 12/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var settingIMG: UIImageView!
    @IBOutlet weak var settingLBL: UILabel!
    @IBOutlet weak var settingBTN: UIButton!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
