//
//  VehiclesModel.swift
//  FuelSrv
//
//  Created by PBS9 on 25/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class VehiclesModel : Mappable{
    
    var message : String?
    var success : Bool?
    var vehicles : [Vehicle]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        vehicles  <- map["vehicles"]
    }
}
