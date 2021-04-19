//
//  OrderReviewCell.swift
//  FuelSrv
//
//  Created by PBS9 on 24/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class OrderReviewCell: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var serviceNameLbl: UILabel!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var preAuthorizedLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
