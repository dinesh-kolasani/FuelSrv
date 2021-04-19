//
//  OrderReviewSecCell.swift
//  FuelSrv
//
//  Created by PBS9 on 24/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class OrderReviewSecCell: UITableViewCell {

    @IBOutlet weak var ORTitleLabel: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var headerLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
