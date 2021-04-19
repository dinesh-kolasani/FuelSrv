//
//  SendPromptGoCell.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 02/05/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

class SendPromptGoCell: UITableViewCell {
    
    @IBOutlet weak var sendPromptBtn: UIButton!
    @IBOutlet weak var startOrdrBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var vehicleDetailsLbl: UILabel!
    @IBOutlet weak var licensePlateLbl: UILabel!
    @IBOutlet weak var fuelNameLbl: UILabel!
    @IBOutlet weak var requestedTimeLbl: UILabel!
    @IBOutlet weak var servicesLbl: UILabel!
    @IBOutlet weak var vehicleDetailsTitleLbl: UILabel!
    @IBOutlet weak var licensePlateTitleLbl: UILabel!
    @IBOutlet weak var physicalReceiptTitleLbl: UILabel!
    @IBOutlet weak var physicalReceiptLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePic.layer.borderWidth = 1.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        profilePic.layer.borderColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
        profilePic.layer.backgroundColor = UIColor.clear.cgColor
        profilePic.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
