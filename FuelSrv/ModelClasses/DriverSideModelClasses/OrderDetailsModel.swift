//
//  OrderDetailsModel.swift
//  FuelSrv
//
//  Created by PBS9 on 12/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderDetailsModel : Mappable{
    
    var message : String?
    var order : OrderDetails?
    var success : Bool?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message <- map["message"]
        order <- map["order"]
        success <- map["success"]
    }
}
class OrderDetails : Mappable{
    
    var v : Int!
    var id : String!
    var address : String!
    var allServicesCost : Int!
    var completedOrderFuel : Int!
    var createdAt : String!
    var deleveringDate : Int!
    var discountAmount : Int!
    var discountLeft : Float!
    var distance : Int!
    var driverId : String!
    var fillType : Int!
    var fuelAmount : Int!
    var fuelQuantity : Int!
    var fuelType : Int!
    var gageImage : String!
    var isFulltank : Int!
    var isPhysicalRecieptYes : Int!
    var issueDescription : String!
    var issueImage : String!
    var isUrgent : Int!
    var orderStatus : Int!
    var orderTotalAmount : Float!
    var paymentStatus : Int!
    var preAuthorisationAmount : Int!
    var promocode : String!
    var reccuring : Int!
    var recurringDate : String!
    var recurringOrderStatus : Int!
    var serviceId : [ServiceId]!
    var stripeChargeId : String!
    var taxAmount : Float!
    var timing : String!
    var updatedAt : String!
    var userLat : Float!
    var userLong : Float!
    var userId : UserId!
    var vehicleCount : String!
    var vehicleId : VehicleId!
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        v <- map["__v"]
        id <- map["_id"]
        address <- map["address"]
        allServicesCost <- map["allServicesCost"]
        completedOrderFuel <- map["completedOrderFuel"]
        createdAt <- map["createdAt"]
        deleveringDate <- map["deleveringDate"]
        discountAmount <- map["discountAmount"]
        discountLeft <- map["discountLeft"]
       // discountLeft <- map["message"]
        driverId <- map["driverId"]
        fillType <- map["fillType"]
        fuelAmount <- map["fuelAmount"]
        fuelQuantity <- map["fuelQuantity"]
        fuelType <- map["fuelType"]
        gageImage <- map["gageImage"]
        isFulltank <- map["isFulltank"]
        isPhysicalRecieptYes <- map["isPhysicalRecieptYes"]
        issueDescription <- map["issueDescription"]
        issueImage <- map["issueImage"]
        isUrgent <- map["isUrgent"]
        orderStatus <- map["orderStatus"]
        orderTotalAmount <- map["orderTotalAmount"]
        orderStatus <- map["orderStatus"]
        preAuthorisationAmount <- map["preAuthorisationAmount"]
        promocode <- map["promocode"]
        reccuring <- map["reccuring"]
        recurringDate <- map["recurringDate"]
        recurringOrderStatus <- map["recurringOrderStatus"]
        serviceId <- map["serviceId"]
        stripeChargeId <- map["stripeChargeId"]
        taxAmount <- map["taxAmount"]
        timing <- map["timing"]
        updatedAt <- map["updatedAt"]
        userLat <- map["user_lat"]
        userLong <- map["user_long"]
        userId <- map["userId"]
        vehicleCount <- map["vehicleCount"]
        vehicleId <- map["vehicleId"]

    }
}
