//
//  MembershipModel.swift
//  FuelSrv
//
//  Created by PBS9 on 21/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class MembershipModel : Mappable{
   
    var memberShip : [MemberShip]!
    var message : String?
    var success : Bool?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        memberShip  <- map["memberShip"]
    }
}
class MemberShip : Mappable{
    
    var v : Int?
    var id : String?
    var createdAt : String?
    var isDeleted : Int?
    var memberShipPlanId: String?
    var membershipKey : Int?
    var membershipPrice : Double?
    var membershipType : String?
    var updatedAt : String?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        createdAt  <- map["createdAt"]
        isDeleted  <- map["isDeleted"]
        memberShipPlanId <- map["memberShipPlanId"]
        membershipKey  <- map["membershipKey"]
        membershipPrice  <- map["membershipPrice"]
        membershipType  <- map["membershipType"]
        updatedAt  <- map["fuelType"]
    }
}
