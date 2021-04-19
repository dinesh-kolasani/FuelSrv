//
//  OrderReviewModel.swift
//  FuelSrv
//
//  Created by PBS9 on 25/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderReviewModel : Mappable{
    
    var message : String?
    var order : Order!
    var success : Bool?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        order  <- map["order"]
    }
}
class Order : Mappable{
    
    var v : Int?
    var id : String?
    var createdAt : String?
    var deleveringDate : Int?
    var driverId : String?
    var fuelAmount : Float?
    var fuelType : Int?
    var gageImage : String?
    var isFulltank : Int?
    var issueDescription : String?
    var issueImage : String?
    var isUrgent : Int?
    var orderStatus : Int?
    var paymentStatus : Int?
    var promocode : String?
    var reccuring : Int?
    var serviceId : [ServiceId]!
    var timing : String?
    var totalAmount : Float?
    var updatedAt : String?
    var userLat : Float?
    var userLong : Float?
    var userId : String?
    var vehicleCount : String?
    var vehicleId : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        createdAt  <- map["createdAt"]
        deleveringDate  <- map["deleveringDate"]
        driverId  <- map["driverId"]
        fuelAmount  <- map["fuelAmount"]
        fuelType  <- map["fuelType"]
        gageImage  <- map["gageImage"]
        isFulltank  <- map["isFulltank"]
        issueDescription  <- map["issueDescription"]
        issueImage  <- map["issueImage"]
        isUrgent  <- map["isUrgent"]
        orderStatus  <- map["orderStatus"]
        paymentStatus  <- map["paymentStatus"]
        promocode  <- map["promocode"]
        reccuring  <- map["reccuring"]
        serviceId  <- map["serviceId"]
        timing  <- map["timing"]
        totalAmount  <- map["totalAmount"]
        updatedAt  <- map["updatedAt"]
        userLat  <- map["user_lat"]
        userLong  <- map["user_long"]
        userId  <- map["userId"]
        vehicleCount  <- map["vehicleCount"]
        vehicleId  <- map["vehicleId"]
    }
}
class ServiceId : Mappable{
    
    var serviceName : String?
    var subServiceName : String?
    var subServicePrice : String?
    var subServiceQuantity : Int?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        serviceName  <- map["serviceName"]
        subServiceName  <- map["subServiceName"]
        subServicePrice  <- map["subServicePrice"]
        subServiceQuantity  <- map["subServiceQuantity"]
    }
}
