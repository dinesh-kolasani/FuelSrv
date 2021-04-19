//
//  EmailRegisterModel.swift
//  FuelSrv
//
//  Created by PBS9 on 05/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class EmailRegisterModel : Mappable{
    
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
//class User : Mappable {
//
//    var v : Int?
//    var id : String?
//    var accountType : Int?
//    var avatar : String?
//    var buisnessType : String?
//    var createdAt : String?
//    var deviceId : String?
//    var email : String?
//    var isBlocked : Int?
//    var isDeleted : Int?
//    var isFullUrl : Int?
//    var isProfilecompleted : Int?
//    var isVerified : Int?
//    var name : String?
//    var password : String?
//    var phoneNumber : String?
//    var referralCode : String?
//    var socialId : String?
//    var updatedAt : String?
//    var userLat : String?
//    var userLong : String?
//    var userType : Int?
//
//    required init?(map: Map) {}
//
//    func mapping(map: Map) {
//        v  <- map["__v"]
//        id  <- map["_id"]
//        accountType  <- map["accountType"]
//        avatar  <- map["avatar"]
//        buisnessType  <- map["buisnessType"]
//        createdAt  <- map["createdAt"]
//        deviceId  <- map["deviceId"]
//        email  <- map["email"]
//        isBlocked  <- map["isBlocked"]
//        isDeleted  <- map["isDeleted"]
//        isFullUrl  <- map["isFullUrl"]
//        isProfilecompleted  <- map["isProfilecompleted"]
//        isVerified  <- map["isVerified"]
//        name  <- map["name"]
//        password  <- map["password"]
//        phoneNumber  <- map["phoneNumber"]
//        referralCode  <- map["referralCode"]
//        socialId  <- map["socialId"]
//        updatedAt  <- map["updatedAt"]
//        userLat  <- map["user_lat"]
//        userLong  <- map["user_long"]
//        userType  <- map["userType"]
//
//    }
//}
