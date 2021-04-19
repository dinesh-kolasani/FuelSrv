//
//  placeCell.swift
//  FuelSrv
//
//  Created by PBS9 on 10/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class placeCell: UITableViewCell {

    @IBOutlet weak var subAddressLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var placeImg: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
