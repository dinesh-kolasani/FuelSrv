//
//  DriverOrdersUrgentModel.swift
//  FuelSrv
//
//  Created by PBS9 on 05/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class DriverOrdersUrgentModel : Mappable {
    
    var message : String?
    var order : [DriverOrder]?
    var success : Bool?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
       
        message <- map["message"]
        order <- map["order"]
        success <- map["success"]
    }
}
class DriverOrder : Mappable {
    
    var v : Int?
    var id : String?
    var createdAt : String?
    var driverId : String?
    var isDeleted : Int?
    var orderAccepted : Int?
    var orderId : DriverOrderId?
    var status : Int?
    var updatedAt : String?
    required init?(map: Map) { }
    
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
class DriverOrderId : Mappable{
   
    var v : Int?
    var id : String?
    var address : String?
    var allServicesCost : Int!
    var createdAt : String?
    var deleveringDate : Int?
    var discountAmount : Int?
    var discountLeft : Int!
    var distance : Int?
    var driverId : String?
    var fillType : Int?
    var fuelAmount : Int?
    var fuelQuantity : Int?
    var fuelType : Int?
    var gageImage : String?
    var isFulltank : Int?
    var isPhysicalRecieptYes : Int?
    var issueDescription : String?
    var issueImage : String?
    var isUrgent : Int?
    var orderStatus : Int?
    var orderTotalAmount : Float?
    var paymentStatus : Int?
    var promocode : String?
    var reccuring : Int?
    var recurringDate : String!
    var recurringOrderStatus : Int!
    var serviceId : [ServiceId]!
    var stripeChargeId : String!
    var taxAmount : Float?
    var timing : String?
    var updatedAt : String?
    var userLat : Double?
    var userLong : Double?
    var userId : DriverUserId?
    var vehicleCount : String?
    var vehicleId : DriverVehicleId?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        address  <- map["address"]
        createdAt  <- map["createdAt"]
        deleveringDate  <- map["deleveringDate"]
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
        updatedAt  <- map["updatedAt"]
        userLat  <- map["user_lat"]
        userLong  <- map["user_long"]
        userId  <- map["userId"]
        vehicleCount  <- map["vehicleCount"]
        vehicleId  <- map["vehicleId"]
        
        discountAmount  <- map["discountAmount"]
        distance  <- map["distance"]
        driverId  <- map["driverId"]
        fillType  <- map["fillType"]
        fuelQuantity  <- map["fuelQuantity"]
        isPhysicalRecieptYes  <- map["isPhysicalRecieptYes"]
        orderTotalAmount  <- map["orderTotalAmount"]
        taxAmount  <- map["taxAmount"]
        
        allServicesCost  <- map["allServicesCost"]
        discountLeft  <- map["discountLeft"]
        recurringDate  <- map["recurringDate"]
        recurringOrderStatus  <- map["recurringOrderStatus"]
        stripeChargeId  <- map["recurringOrderStatus"]
    }
}
class DriverVehicleId : Mappable{
    
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
class DriverUserId : Mappable{
    
    var v : Int?
    var id : String?
    var accountType : Int?
    var address : String?
    var avatar : String?
    var bio : String?
    var buisnessType : String?
    var createdAt : String?
    var deviceId : String?
    var driverAppliedDate : String?
    var email : String?
    
    var inviteCode : String?
    var isBlocked : Int?
    var isDeleted : Int?
    var isFirstTimeOrder : Int?
    var isFreeTrialTaken : Int?
    var isFullUrl : Int?
    var isMembershipTaken : Int?
    var isNotificationTrue : Int?
    var isPaid : Int?
    var isPhysicalRecieptYes : Int?
    var isProfilecompleted : Int?
    var isVerified : Int?
    var membershipAmount : Int?
    var membershipEndDate : AnyObject?
    var membershipKey : Int?
    var membershipStartDate : String?
    var membershipType : AnyObject?
    var name : String?
    var password : String?
    var phoneNumber : String?
    var promocodesUsed : [AnyObject]?
    var referralCode : String?
    var reviews : AnyObject?
    var socialId : String?
    var totalFuelings : Int?
    var updatedAt : String?
    var userLat : String?
    var userLong : String?
    var userAddress : AnyObject?
    var userType : Int?
    var vehicleCount : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        address  <- map["address"]
        accountType  <- map["accountType"]
        avatar  <- map["avatar"]
        bio  <- map["bio"]
        buisnessType  <- map["buisnessType"]
        createdAt  <- map["createdAt"]
        deviceId  <- map["deviceId"]
        email  <- map["email"]
        inviteCode  <- map["inviteCode"]
        isBlocked  <- map["isBlocked"]
        isDeleted  <- map["isDeleted"]
        isFullUrl  <- map["isFullUrl"]
        isMembershipTaken  <- map["isMembershipTaken"]
        isProfilecompleted  <- map["isProfilecompleted"]
        isVerified  <- map["isVerified"]
        membershipEndDate  <- map["membershipEndDate"]
        membershipStartDate  <- map["membershipStartDate"]
        name  <- map["name"]
        password  <- map["password"]
        phoneNumber  <- map["phoneNumber"]
        referralCode  <- map["referralCode"]
        reviews  <- map["reviews"]
        socialId  <- map["socialId"]
        totalFuelings  <- map["totalFuelings"]
        updatedAt  <- map["updatedAt"]
        userLat  <- map["user_lat"]
        userLong  <- map["user_long"]
        userType  <- map["userType"]
        vehicleCount  <- map["vehicleCount"]
        
        
        driverAppliedDate  <- map["driverAppliedDate"]
        isFirstTimeOrder  <- map["isFirstTimeOrder"]
        isFreeTrialTaken  <- map["isFreeTrialTaken"]
        isNotificationTrue  <- map["isNotificationTrue"]
        isPhysicalRecieptYes  <- map["isPhysicalRecieptYes"]
        membershipAmount  <- map["membershipAmount"]
        membershipType  <- map["membershipType"]
        membershipKey  <- map["membershipKey"]
        isPaid  <- map["isPaid"]
        promocodesUsed  <- map["promocodesUsed"]
        userAddress  <- map["userAddress"]
    }
}
