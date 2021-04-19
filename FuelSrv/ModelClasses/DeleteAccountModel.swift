//
//  DeleteAccountModel.swift
//  FuelSrv
//
//  Created by PBS9 on 16/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class DeleteAccountModel : Mappable{
    
    var account : AnyObject?
    var message : String?
    var success : Bool?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        account  <- map["account"]
    }
}
