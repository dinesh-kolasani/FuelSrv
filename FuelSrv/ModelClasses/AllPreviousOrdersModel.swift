//
//  AllPreviousOrdersModel.swift
//  FuelSrv
//
//  Created by PBS9 on 07/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class AllPreviousOrdersModel : Mappable{
   
    var completedOrders : [CompletedOrder]!
    var message : String?
    var success : Bool?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        completedOrders  <- map["completedOrders"]
    }
}
class CompletedOrder : Mappable{
   
    var v : Int?
    var id : String?
    var address : String?
    var createdAt : String?
    var deleveringDate : Int?
    var discountAmount : Int?
    var distance : Int?
    var driverId : DriverId?
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
    var serviceId : [ServiceId]!
    var stripeChargeId : String?
    var taxAmount : Float?
    var timing : String?
//    var totalAmount : Int?
    var updatedAt : String?
    var userLat : Float?
    var userLong : Float?
    var userId : UserId!
    var vehicleCount : String?
    var vehicleId : VehicleId!
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        address  <- map["address"]
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
        updatedAt  <- map["updatedAt"]
        userLat  <- map["user_lat"]
        userLong  <- map["user_long"]
        userId  <- map["userId"]
        vehicleCount  <- map["vehicleCount"]
        vehicleId  <- map["vehicleId"]
        
        discountAmount  <- map["discountAmount"]
        distance  <- map["distance"]
        fillType  <- map["fillType"]
        fuelQuantity  <- map["fuelQuantity"]
        isPhysicalRecieptYes  <- map["isPhysicalRecieptYes"]
        orderTotalAmount  <- map["orderTotalAmount"]
        stripeChargeId  <- map["stripeChargeId"]
        taxAmount  <- map["taxAmount"]
        
    }
}
class DriverId : Mappable{
  
    var v : Int?
    var id : String?
    var accountType : Int?
    var address : String?
    var avatar : String?
    var bio : String?
    var buisnessType : String?
    var createdAt : String?
    var deviceId : AnyObject?
    var email : String?
    var inviteCode : String?
    var isBlocked : Int?
    var isDeleted : Int?
    var isFullUrl : Int?
    var isMembershipTaken : Int?
    var isProfilecompleted : Int?
    var isVerified : Int?
    var membershipEndDate : String?
    var membershipStartDate : String?
    var name : String?
    var password : String?
    var phoneNumber : String?
    var referralCode : String?
    var reviews : [AnyObject]?
    var socialId : String?
    var totalFuelings : Int?
    var updatedAt : String?
    var userLat : String?
    var userLong : String?
    var userType : Int?
    var vehicleCount : String?
    
    var discountForReferral : Int?
    var driverAppliedDate : String?
    var isFirstTimeOrder : Int?
    var isFreeTrialTaken : Int?
    var isNotificationTrue : Int?
    var isPaid : Int?
    var isPhysicalRecieptYes : Int?
    var membershipAmount : Int?
    var membershipKey : Int?
    var membershipType : String?
    var promocodesUsed : [AnyObject]!
    var stripeChargeId : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        accountType  <- map["accountType"]
        address  <- map["address"]
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
