//
//  HelpVCCell.swift
//  FuelSrv
//
//  Created by PBS9 on 06/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class HelpVCCell: UITableViewCell {

    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var cellImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
