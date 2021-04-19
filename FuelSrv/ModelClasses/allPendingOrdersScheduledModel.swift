//
//  allPendingOrdersScheduledModel.swift
//  FuelSrv
//
//  Created by PBS9 on 30/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class allPendingOrdersScheduledModel : Mappable{
   
    var message : String?
    var order : [ScheduleOrder]!
    var success : Bool?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        order  <- map["order"]
    }
}
class ScheduleOrder : Mappable{
    
    var v : Int?
    var id : String?
    var address : String?
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
    var serviceId : [ServiceId]!
    var timing : String?
    var totalAmount : Int?
    var updatedAt : String?
    var userLat : Float?
    var userLong : Float?
    var userId : UserId?
    var vehicleCount : String?
    var vehicleId : VehicleId?
    
    
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
        totalAmount  <- map["totalAmount"]
        updatedAt  <- map["updatedAt"]
        userLat  <- map["user_lat"]
        userLong  <- map["user_long"]
        userId  <- map["userId"]
        vehicleCount  <- map["vehicleCount"]
        vehicleId  <- map["vehicleId"]
    }
}
class VehicleId : Mappable{
   
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
class UserId : Mappable{
    
    var v : Int?
    var id : String?
    var accountType : Int?
    var address : String?
    var avatar : String?
    var bio : String?
    var buisnessType : String?
    var createdAt : String?
    var deviceId : String?
    var discountForReferral : Int?
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
    var membershipEndDate : String?
    var membershipKey : Int?
    var membershipStartDate : String?
    var membershipType : String?
    var name : String?
    var password : String?
    var phoneNumber : String?
    var promocodesUsed : [AnyObject]!
    var referralCode : String?
    var stripeChargeId : String?
    var reviews : AnyObject?
    var socialId : String?
    var totalFuelings : Int?
    var updatedAt : String?
    var userLat : String?
    var userLong : String?
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
        
        
        discountForReferral  <- map["discountForReferral"]
        driverAppliedDate  <- map["driverAppliedDate"]
        isFirstTimeOrder  <- map["isFirstTimeOrder"]
        isFreeTrialTaken  <- map["isFreeTrialTaken"]
        isNotificationTrue  <- map["isNotificationTrue"]
        isPaid  <- map["isPaid"]
        isPhysicalRecieptYes  <- map["isPhysicalRecieptYes"]
        membershipAmount  <- map["membershipAmount"]
        membershipKey  <- map["membershipKey"]
        membershipType  <- map["membershipType"]
        promocodesUsed  <- map["promocodesUsed"]
        stripeChargeId  <- map["stripeChargeId"]
    }
}
