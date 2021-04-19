//
//  ForgotPasswordModel.swift
//  FuelSrv
//
//  Created by PBS9 on 04/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class ForgotPasswordModel : Mappable{
    
    var message : String?
    var success : Bool?
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
    }
}
