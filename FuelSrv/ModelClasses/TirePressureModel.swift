//
//  TirePressureModel.swift
//  FuelSrv
//
//  Created by PBS9 on 22/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class TirePressureModel : Mappable{
    
    var message : String?
    var success : Bool?
    var tyre : [Tyre]?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        tyre  <- map["Tyre"]
        success  <- map["success"]
    }
}
class Tyre : Mappable{
    
    var v : Int?
    var id : String?
    var createdAt : String?
    var isDeleted : Int?
    var name : String?
    var price : Int?
    var updatedAt : String?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        createdAt  <- map["createdAt"]
        isDeleted  <- map["isDeleted"]
        name  <- map["name"]
        price  <- map["price"]
        updatedAt  <- map["updatedAt"]
    }
}
