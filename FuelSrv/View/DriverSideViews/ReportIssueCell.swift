//
//  ReportIssueCell.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 17/04/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

protocol cellDelegate  {
    func didPressButton(_ tag: Int)
}

class ReportIssueCell: UITableViewCell {
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var covienientView: UIView!
    
    @IBOutlet weak var fuelView: UIView!
    
    @IBOutlet weak var vehicleView: UIView!
    
    @IBOutlet weak var issueText: UITextView!
    
    @IBOutlet weak var reportNxtBtn: UIButton!
    
    

    
    var delegate:cellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
       
        self.issueText.layer.borderWidth = 1
        self.issueText.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.issueText.layer.cornerRadius = 5
        
     
        
        self.covienientView.layer.borderWidth = 1
        self.covienientView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        
        self.vehicleView.layer.borderWidth = 1
        self.vehicleView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.covienientView.layer.borderWidth = 1
        self.covienientView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
       // sideMenuButton.layer.maskedCorners = .layerMinXMaxYCorner
    }
   
    @IBAction func nextbtn(_ sender: UIButton) {
        
      delegate?.didPressButton(1)
      
    }
    
}

