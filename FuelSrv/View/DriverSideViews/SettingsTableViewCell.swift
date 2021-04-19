//
//  SettingsTableViewCell.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 11/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var cellSwitch: UISwitch!
    @IBOutlet weak var cellButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
