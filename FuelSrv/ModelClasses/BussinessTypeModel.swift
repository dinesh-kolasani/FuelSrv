//
//  BussinessTypeModel.swift
//  FuelSrv
//
//  Created by PBS9 on 08/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class BussinessTypeModel : Mappable{
    
    var buisness : [Buisnes]?
    var message : String?
    var success : Bool?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        buisness  <- map["buisness"]
        message  <- map["message"]
        success  <- map["success"]
    }
}
class Buisnes : Mappable{
    
    var v : Int?
    var id : String?
    var createdAt : String?
    var isDeleted : Int?
    var name : String?
    var updatedAt : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        createdAt  <- map["createdAt"]
        isDeleted  <- map["isDeleted"]
        name  <- map["name"]
        updatedAt  <- map["updatedAt"]
    }
}
