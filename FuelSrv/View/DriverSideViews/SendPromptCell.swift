//
//  SendPromptCell.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 02/05/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

class SendPromptCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var cellTextLbl: UILabel!
    
    @IBOutlet weak var vehicleBtn: UIButton!
    @IBOutlet weak var gasBtn: UIButton!
    @IBOutlet weak var safelyBtn: UIButton!
    
    @IBOutlet weak var sendBtn: RoundButton!
    
    
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
