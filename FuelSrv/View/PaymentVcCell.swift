//
//  PaymentVcCell.swift
//  FuelSrv
//
//  Created by PBS9 on 21/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit

class PaymentVcCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var cardHolderNameLbl: UILabel!
    @IBOutlet weak var expiryDateLbl: UILabel!
    
    @IBOutlet weak var cardLastFourDigitsLbl: UILabel!
    @IBOutlet weak var cellBGView: RoundedView!
    @IBOutlet weak var cellBtnImageView: UIImageView!
    
    @IBOutlet weak var cvvLbl: UILabel!    
    @IBOutlet weak var cvvView: RoundedView!
    @IBOutlet weak var cvvTxt: UITextField!
   
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var cellBtnRoundView: RoundedView!
    
    var cvvValue: ((_ value: String)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellBtnImageView.layer.borderWidth = 1.0
        self.cellBtnImageView.layer.masksToBounds = false
        self.cellBtnImageView.layer.cornerRadius = self.cellBtnImageView.frame.size.width/2
        self.cellBtnImageView.layer.borderColor = #colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.6235294118, alpha: 1)
        self.cellBtnImageView.clipsToBounds = true
        
        cellBGView.dropShadow(view: cellBGView, opacity: 0.7)
        cvvTxt.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cvvTxt.maxLength = 3

        // Configure the view for the selected state
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        cvvValue?(cvvTxt.text ?? "")
    }
    
}
