//
//  HelpTableViewCell.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 08/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

class HelpTableViewCell: UITableViewCell {

    @IBOutlet weak var helpImages: UIImageView!
    
    @IBOutlet weak var leftArrowImg: UIImageView!
    
    @IBOutlet weak var helpLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
