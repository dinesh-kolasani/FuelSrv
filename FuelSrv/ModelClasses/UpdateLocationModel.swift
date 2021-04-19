//
//  UpdateLocationModel.swift
//  FuelSrv
//
//  Created by PBS9 on 19/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class UpdateLocationModel : Mappable{
    
    var location : Location?
    var message : String?
    var success : Bool?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        location  <- map["location"]
        message  <- map["message"]
        success  <- map["success"]
    }
}
class Location : Mappable{
    
    var v : Int?
    var id : String?
    var addressTitle : String?
    var createdAt : String?
    var isDeleted : String?
    var updatedAt : String?
    var userLat : String?
    var userLong : String?
    var userAddress : String?
    var userId : String?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        addressTitle  <- map["addressTitle"]
        createdAt  <- map["createdAt"]
        isDeleted  <- map["isDeleted"]
        updatedAt  <- map["updatedAt"]
        userLat  <- map["user_lat"]
        userLong  <- map["user_long"]
        userAddress  <- map["userAddress"]
        userId  <- map["userId"]
        
    }
}
