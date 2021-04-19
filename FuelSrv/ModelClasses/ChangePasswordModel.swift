//
//  ChangePasswordModel.swift
//  FuelSrv
//
//  Created by PBS9 on 16/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class ChangePasswordModel : Mappable{
    
    var message : String?
    var result : Result?
    var success : Bool?
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        result  <- map["result"]
    }
}
class Result : Mappable{
    
    var v : Int?
    var id : String?
    var accountType : Int?
    var address : String?
    var avatar : String?
    var bio : String?
    var buisnessType : String?
    var createdAt : String?
    var deviceId : String?
    var email : String?
    //var id : String!
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
        inviteCode  <- map["inviteCode"]
        isMembershipTaken  <- map["isMembershipTaken"]
        membershipEndDate  <- map["membershipEndDate"]
        membershipStartDate  <- map["membershipStartDate"]
        reviews  <- map["reviews"]
        totalFuelings  <- map["totalFuelings"]
        vehicleCount  <- map["vehicleCount"]
    }
}
