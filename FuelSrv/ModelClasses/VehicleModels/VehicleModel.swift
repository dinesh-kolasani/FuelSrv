//
//  VehicleModel.swift
//  FuelSrv
//
//  Created by PBS9 on 04/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class VehicleModel : Mappable{
    
    var message : String?
    var success : Bool?
    var vehicle : Vehicle?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        vehicle  <- map["vehicle"]
    }
    
}
class Vehicle : Mappable{
    
    var v : Int?
    var id : String?
    var color : String?
    var createdAt : String?
    var fuel : Int?
    var isDeleted : Int?
    var licencePlate : String?
    var make : String?
    var model : String?
    var updatedAt : String?
    var userId : String?
    var year : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        color  <- map["color"]
        createdAt  <- map["createdAt"]
        fuel  <- map["fuel"]
        isDeleted  <- map["isDeleted"]
        licencePlate  <- map["licencePlate"]
        make  <- map["make"]
        model  <- map["model"]
        updatedAt  <- map["updatedAt"]
        userId  <- map["userId"]
        year  <- map["year"]
    }
}
