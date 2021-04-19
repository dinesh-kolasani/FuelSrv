//
//  AllServicesModel.swift
//  FuelSrv
//
//  Created by PBS9 on 19/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class AllServicesModel : Mappable{
    
    var message : String?
    var services : [Service]!
    var success : Bool?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        services  <- map["services"]
        success  <- map["success"]
    }
}
class Service : Mappable{
    
    var v : Int?
    var id : String?
    var createdAt : String?
    var isDeleted : Int?
    var serviceCost : Int?
    var serviceName : String?
    var updatedAt : String?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        createdAt  <- map["createdAt"]
        isDeleted  <- map["isDeleted"]
        serviceCost  <- map["serviceCost"]
        serviceName  <- map["serviceName"]
        updatedAt  <- map["updatedAt"]
    }
}
