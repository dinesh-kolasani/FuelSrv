//
//  FuelTypeModel.swift
//  FuelSrv
//
//  Created by PBS9 on 08/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class FuelTypeModel : Mappable{
    
    var fuel : [Fuel]!
    var message : String?
    var success : Bool?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        fuel  <- map["fuel"]
        message  <- map["message"]
        success  <- map["success"]
    }
}

class Fuel : Mappable{
    
    var v : Int?
    var id : String?
    var createdAt : String?
    var fuelCost : Float?
    var fuelName : String?
    var fuelType : Int?
    var isDeleted : Int?
    var updatedAt : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        createdAt  <- map["createdAt"]
        fuelCost  <- map["fuelCost"]
        fuelName  <- map["fuelName"]
        fuelType  <- map["fuelType"]
        isDeleted  <- map["isDeleted"]
        updatedAt  <- map["updatedAt"]
    }
}
