//
//  MembershipVcCell.swift
//  FuelSrv
//
//  Created by PBS9 on 21/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class MembershipVcCell: UITableViewCell {

    @IBOutlet weak var membershipTypeLbl: UILabel!
    @IBOutlet weak var membershipPriceLbl: UILabel!
    
    @IBOutlet weak var selectedBtn: RoundButton!
    
    @IBOutlet weak var separatorLineLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
