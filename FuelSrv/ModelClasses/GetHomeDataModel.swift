//
//  GetHomeDataModel.swift
//  FuelSrv
//
//  Created by PBS9 on 10/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class GetHomeDataModel: Mappable{

    var homeData : HomeData?
    var message : String?
    var success : Bool?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        homeData  <- map["homeData"]
        success  <- map["success"]
    }
}
class HomeData : Mappable{
    
    var fuelData : [FuelData]!
    var locations : [Location]!
    var onDemandBuissness : Int?
    var onDemandPersonal : Int?
    var timeAvailability : TimeAvailability?
    var userData : UserData?
   
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        fuelData  <- map["fuelData"]
        locations  <- map["locations"]
        onDemandBuissness  <- map["onDemandBuissness"]
        onDemandPersonal  <- map["onDemandPersonal"]
        timeAvailability  <- map["timeAvailability"]
        userData  <- map["userData"]
    }
}
class TimeAvailability : Mappable{
    
    var v : Int?
    var id : String?
    var createdAt : String?
    var endTime : String?
    var haltedMessage : String?
    var haltedTrue : Int?
    var isDeleted : Int?
    var startTime : String?
    var updatedAt : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        createdAt  <- map["createdAt"]
        endTime  <- map["endTime"]
        haltedMessage  <- map["haltedMessage"]
        haltedTrue  <- map["haltedTrue"]
        isDeleted  <- map["isDeleted"]
        startTime  <- map["startTime"]
        updatedAt  <- map["updatedAt"]
    }
}
class UserData :Mappable{
    
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
    //var id : String!
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
    var socialId : String?
    var stripeChargeId : String?
    var totalFuelings : Int?
    var updatedAt : String?
    var userLat : String?
    var userLong : String?
    var userAddress : String?
    var userType : Int?
    var vehicleCount : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        accountType  <- map["accountType"]
        isVerified  <- map["isVerified"]
        referralCode  <- map["referralCode"]
        isFirstTimeOrder <- map["isFirstTimeOrder"]
        isProfilecompleted <- map["isProfilecompleted"]
        isMembershipTaken <- map["isMembershipTaken"]
        name  <- map["name"]
        email <- map["email"]
        isFreeTrialTaken <- map["isFreeTrialTaken"]
        isPhysicalRecieptYes <- map["isPhysicalRecieptYes"]
        isNotificationTrue <- map["isNotificationTrue"]
        phoneNumber <- map["phoneNumber"]
        vehicleCount <- map["vehicleCount"]
        userAddress  <- map["userAddress"]
        avatar  <- map["avatar"]
        isFullUrl <- map["isFullUrl"]
        isVerified <- map["isVerified"]
    }
    
}
class FuelData : Mappable{
    
    var v : Int?
    var id : String?
    var accounttype : Int?
    var createdAt : String?
    var fuelCost : Float?
    var fuelName : String?
    var fuelType : Int?
    var isDeleted : Int?
    var updatedAt : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        v <- map["__v"]
        id <- map["_id"]
        accounttype <- map["accounttype"]
        createdAt <- map["createdAt"]
        fuelCost <- map["fuelCost"]
        fuelName <- map["fuelName"]
        fuelType <- map["fuelType"]
        isDeleted <- map["isDeleted"]
        updatedAt <- map["updatedAt"]
    }
}
