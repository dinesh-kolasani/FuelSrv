//
//  LoginModel.swift
//  FuelSrv
//
//  Created by PBS9 on 03/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginModel : Mappable {
    
    var message : String?
    var success : Bool?
    var user : User?
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        message  <- map["message"]
        success  <- map["success"]
        user  <- map["user"]
    }
}
class User : Mappable {
    
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
    var isPhysicalRecieptYes : Int?
    var isProfilecompleted : Int?
    var isVerified : Int?
    var membershipAmount : Int?
    var membershipEndDate : String?
    var membershipStartDate : String?
    var membershipType : String?
    var name : String?
    var password : String?
    var phoneNumber : String?
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
        address  <- map["address"]
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
        userAddress  <- map["userAddress"]
        vehicleCount  <- map["vehicleCount"]
        userAddress  <- map["userAddress"]

    }
}

class SocialLoginModel : Mappable{
    
    var message : String?
    var success : Bool?
    var user : User?
    var newUser : Int!
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        user  <- map["user"]
        newUser  <- map["newUser"]
    }
}

