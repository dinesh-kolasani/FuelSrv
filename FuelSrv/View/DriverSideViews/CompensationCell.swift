//
//  CompensationCell.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 15/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

class CompensationCell: UITableViewCell {

    @IBOutlet weak var cardTypeImg: UIImageView!
    
    @IBOutlet weak var cardHoldersName: UILabel!
    
    @IBOutlet weak var expireyDate: UILabel!
    
    @IBOutlet weak var detailsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        detailsView.layer.cornerRadius = 5
        detailsView.layer.shadowColor = UIColor.darkGray.cgColor
        detailsView.layer.shadowOpacity = 0.7
        detailsView.layer.shadowOffset = CGSize(width: 3, height: 3)
        detailsView.layer.shadowRadius = 6
        
        // Configure the view for the selected state
    }

}
