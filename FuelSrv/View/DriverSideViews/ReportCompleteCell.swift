//
//  ReportCompleteCell.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 02/05/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

class ReportCompleteCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var vehicleDetailslbl: UILabel!
    @IBOutlet weak var lecensePlateLbl: UILabel!
    @IBOutlet weak var fuewlLbl: UILabel!
    @IBOutlet weak var servicesLbl: UILabel!
    @IBOutlet weak var requstedLbl: UILabel!
    @IBOutlet weak var reportIssueBtn: UIButton!
    @IBOutlet weak var completeOrderBtn: UIButton!
    @IBOutlet weak var vehicleDetailsTitleLbl: UILabel!
    @IBOutlet weak var licensePlateTitleLbl: UILabel!
    @IBOutlet weak var physicalReceiptLbl: UILabel!
    @IBOutlet weak var physicalReceiptTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePic.layer.borderWidth = 1.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        profilePic.layer.borderColor = #colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1)
        profilePic.layer.backgroundColor = UIColor.clear.cgColor
        profilePic.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
