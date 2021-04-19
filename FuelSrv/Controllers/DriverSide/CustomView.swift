//
//  CustomView.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 09/05/19.
//  Copyright © 2019 PBS12. All rights reserved.
//

import UIKit

class CustomView: UIView {

    var img : UIImage!
    
    init(frame: CGRect,image: UIImage,tag: Int) {
        super.init(frame:frame)
        self.img = image
        self.tag = tag
        setUpViews()
    }
    func setUpViews(){
       let imgView = UIImageView(image: img)
        imgView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
         let lbl = UILabel(frame: CGRect(x: 0, y: 15, width: 20, height: 20))
        lbl.text = "hello"
        lbl.textAlignment = .center
        self.addSubview(imgView)
        self.addSubview(lbl)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
