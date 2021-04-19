//
//  AcceptOrderDriver.swift
//  FuelSrvDriver
//
//  Created by PBS12 on 01/05/19.
//  Copyright © 2019 PBS12. All rights reserved.
//
import Foundation
import ObjectMapper

class AcceptOrderDriver : Mappable{
    
    var acceptedOrder : AcceptedOrder?
    var message : String?
    var success : Bool?
    var orderID : [OrderId]?
    
    required init?(map: Map) { }
    func mapping(map: Map) {
        message <- map["message"]
        acceptedOrder <- map["acceptedOrder"]
        success <- map["success"]
    }
}
class AcceptedOrder : Mappable{
  
    var v : Int?
    var id : String?
    var createdAt : String?
    var driverId : String?
    var isDeleted : Int?
    var orderAccepted : Int?
    var orderId : [OrderId]?
    var status : Int?
    var updatedAt : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        v <- map["__v"]
        id <- map["_id"]
        createdAt <- map["createdAt"]
        driverId <- map["driverId"]
        isDeleted <- map["isDeleted"]
        orderAccepted <- map["orderAccepted"]
        orderId <- map["orderId"]
        status <- map["status"]
        updatedAt <- map["updatedAt"]
    
    }
}
class OrderId : Mappable{

    var v : Int?
    var id : String?
    var createdAt : String?
    var deleveringDate : Int?
    var fuelAmount : Int?
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
    var totalAmount : Float?
    var updatedAt : String?
    var userLat : Float?
    var userLong : Float?
    var userId : UserId?
    var vehicleCount : String?
    var vehicleId : VehicleId?
    
    var address : String?
    var discountAmount : Int?
    var distance : Int?
    var fillType : Int?
    var fuelQuantity : Int?
    var isPhysicalRecieptYes : Int?
    var orderTotalAmount : Float?
    var stripeChargeId : String?
    var taxAmount : Float?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        v <- map["__v"]
        id <- map["_id"]
        createdAt <- map["createdAt"]
        deleveringDate <- map["deleveringDate"]
        fuelAmount <- map["fuelAmount"]
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
        
        
        fuelType <- map["fuelType"]
        address <- map["address"]
        discountAmount <- map["discountAmount"]
        distance <- map["distance"]
        fillType <- map["fillType"]
        fuelQuantity <- map["fuelQuantity"]
        isPhysicalRecieptYes <- map["isPhysicalRecieptYes"]
        orderTotalAmount <- map["orderTotalAmount"]
        stripeChargeId <- map["stripeChargeId"]
        taxAmount <- map["taxAmount"]
    }
}


