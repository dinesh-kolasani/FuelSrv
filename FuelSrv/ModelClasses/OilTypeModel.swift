//
//  OilTypeModel.swift
//  FuelSrv
//
//  Created by PBS9 on 19/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class OilTypeModel : Mappable{
    
    var message : String?
    var oil : [Oil]!
    var success : Bool?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        oil  <- map["Oil"]
        success  <- map["success"]
    }
}
class Oil : Mappable{
    
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
