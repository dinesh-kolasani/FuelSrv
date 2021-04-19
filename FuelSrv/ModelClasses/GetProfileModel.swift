//
//  GetProfileModel.swift
//  FuelSrv
//
//  Created by PBS9 on 19/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class GetProfileModel : Mappable{
   
    var message : String?
    var success : Bool?
    var userdata : Userdata?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        userdata  <- map["userdata"]
    }
}
class Userdata : Mappable{
    
    var address : [Addres]?
    var user : UserProfile?
    var uservehicle : [GetAllVehicle]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        address  <- map["address"]
        user  <- map["user"]
        uservehicle  <- map["uservehicle"]
    }
}
class Addres : Mappable{
    
    var v : Int?
    var id : String?
    var addressTitle: String?
    var createdAt : String?
    var isDeleted : String?
    var updatedAt : String?
    var userLat : String?
    var userLong : String?
    var userAddress : String?
    var userId : String?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        addressTitle  <- map["addressTitle"]
        createdAt  <- map["createdAt"]
        isDeleted  <- map["isDeleted"]
        updatedAt  <- map["updatedAt"]
        userLat  <- map["user_lat"]
        userLong  <- map["user_long"]
        userAddress  <- map["userAddress"]
        userId  <- map["uservehicle"]
    }
}
class UserProfile : Mappable{
   
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
    var membershipAmount : Double?
    var membershipEndDate : String?
    var membershipStartDate : String?
    var membershipType : String?
    var name : String?
    var password : String?
    var phoneNumber : String?
    var promocodesUsed : [AnyObject]!
    var referralCode : String?
    var reviews : AnyObject?
    var socialId : String?
    var totalFuelings : Int?
    var updatedAt : String?
    var userLat : String?
    var userLong : String?
    var userAddress : String?
    var userType : Int?
    var vehicleCount : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        accountType  <- map["accountType"]
        avatar  <- map["avatar"]
        buisnessType  <- map["buisnessType"]
        createdAt  <- map["createdAt"]
        deviceId  <- map["deviceId"]
        email  <- map["email"]
        isBlocked  <- map["isBlocked"]
        isDeleted  <- map["isDeleted"]
        isFullUrl  <- map["isFullUrl"]
        isProfilecompleted  <- map["isProfilecompleted"]
        isVerified  <- map["isVerified"]
        name  <- map["name"]
        password  <- map["password"]
        phoneNumber  <- map["phoneNumber"]
        referralCode  <- map["referralCode"]
        socialId  <- map["socialId"]
        updatedAt  <- map["updatedAt"]
        userLat  <- map["user_lat"]
        userLong  <- map["user_long"]
        userType  <- map["userType"]
        vehicleCount  <- map["vehicleCount"]
        
        bio  <- map["bio"]
        driverAppliedDate  <- map["driverAppliedDate"]
        inviteCode  <- map["inviteCode"]
        isFirstTimeOrder  <- map["isFirstTimeOrder"]
        isFreeTrialTaken  <- map["isFreeTrialTaken"]
        isMembershipTaken  <- map["isMembershipTaken"]
        isNotificationTrue  <- map["isNotificationTrue"]
        isPhysicalRecieptYes  <- map["isPhysicalRecieptYes"]
        membershipAmount  <- map["membershipAmount"]
        membershipEndDate  <- map["membershipEndDate"]
        membershipStartDate  <- map["membershipStartDate"]
        membershipType  <- map["membershipType"]
        reviews  <- map["reviews"]
        totalFuelings  <- map["totalFuelings"]
        isPaid  <- map["isPaid"]
        promocodesUsed  <- map["promocodesUsed"]
        userAddress  <- map["userAddress"]
    }
}
