//
//  AllVehicleModel.swift
//  FuelSrv
//
//  Created by PBS9 on 15/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class AllVehicleModel : Mappable{
    
    var message : String?
    var success : Bool?
    var vehiclemodels : [Vehiclemodel]!
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        vehiclemodels  <- map["vehiclemodels"]
        message  <- map["message"]
        success  <- map["success"]
    }
}
class Vehiclemodel : Mappable{
    
    var v : Int?
    var id : String?
    var brandId : BrandId!
    var createdAt : String?
    var isDeleted : Int?
    var makeName : String?
    var updatedAt : String?
    var vehiclemodelName : String!
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        brandId  <- map["brandId"]
        createdAt  <- map["createdAt"]
        isDeleted  <- map["isDeleted"]
        makeName  <- map["makeName"]
        updatedAt  <- map["updatedAt"]
        vehiclemodelName  <- map["vehiclemodelName"]
    }
}
class BrandId : Mappable{
    
    var v : Int?
    var id : String?
    var brandName : String?
    var createdAt : String?
    var isDeleted : Int?
    var updatedAt : String?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        brandName  <- map["brandName"]
        createdAt  <- map["createdAt"]
        isDeleted  <- map["isDeleted"]
        updatedAt  <- map["updatedAt"]
    }
}
