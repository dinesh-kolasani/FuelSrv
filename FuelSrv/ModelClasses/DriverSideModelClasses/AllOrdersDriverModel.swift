//
//  AllOrdersDriverModel.swift
//  FuelSrv
//
//  Created by PBS9 on 05/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class AllOrdersDriverModel : Mappable{
    
    var message : String?
    var orders : [DriverAllOrders]?
    var success : Bool?
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
        orders <- map["orders"]
        success <- map["success"]
    }
}
class DriverAllOrders : Mappable{
    var v : Int?
    var id : String?
    var address : String?
    var createdAt : String?
    var deleveringDate : Int?
    var driverId : String?
    var fuelAmount : Int?
    var fuelQuantity : Int?
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
    var serviceId : [ServiceId]?
    var timing : String?
    var totalAmount : Int?
    var updatedAt : String?
    var userLat : Double?
    var userLong : Double?
    var userId : UserId?
    var vehicleCount : String?
    var vehicleId : VehicleId?
    var userAddress: String?
    var isPhysicalRecieptYes: Int?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        v <- map["__v"]
        id <- map["_id"]
        createdAt <- map["createdAt"]
        deleveringDate <- map["deleveringDate"]
        driverId <- map["driverId"]
        fuelAmount <- map["fuelAmount"]
        fuelQuantity <- map["fuelQuantity"]
        gageImage <- map["gageImage"]
        isFulltank <- map["isFulltank"]
        issueDescription <- map["issueDescription"]
        issueImage <- map["issueImage"]
        orderStatus <- map["orderStatus"]
        paymentStatus <- map["paymentStatus"]
        promocode <- map["promocode"]
        reccuring <- map["reccuring"]
        serviceId <- map["serviceId"]
        timing <- map["timing"]
        totalAmount <- map["totalAmount"]
        updatedAt <- map["updatedAt"]
        userLat <- map["user_lat"]
        userLong <- map["user_long"]
        userId <- map["userId"]
        vehicleCount <- map["vehicleCount"]
        vehicleId <- map["vehicleId"]
        address <- map["address"]
        userAddress <- map["userAddress"]
        isPhysicalRecieptYes <- map["isPhysicalRecieptYes"]
        fuelType <- map["fuelType"]
        
    }
}
