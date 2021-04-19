//
//  YouViewController.swift
//  FuelSrv
//
//  Created by PBS9 on 08/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import UIKit


class YouViewController: PullUpController {
    
    @IBOutlet weak var searchBoxContainerView: UIView!
    @IBOutlet weak var firstView: UIView!
   
    @IBOutlet weak var viewBtn: UIButton!
    
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var nextBtn: RoundButton!
    var value : Int!
    enum InitialState {
        case contracted
        case expanded
    }
    var initialState: InitialState = .contracted
    
    var initialPointOffset: CGFloat {
        switch initialState {
        case .contracted:
            return searchBoxContainerView?.frame.height ?? 0
        case .expanded:
            return pullUpControllerPreferredSize.height
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    func cardText(){
        if value == 1{
            textLbl.text = "Move the PIN to show us where you Business vehicles are typically park. This can be changed later!"
        }
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        switch initialState {
        case .contracted:
            return [firstView.frame.maxY]
        case .expanded:
            return [searchBoxContainerView.frame.maxX, firstView.frame.maxY]
        }
    }
    
    @IBAction func btnAction(_ sender: Any) {
        
        
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReferralCodeVC") as! ReferralCodeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
