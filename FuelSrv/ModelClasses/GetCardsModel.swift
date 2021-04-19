//
//  GetCardsModel.swift
//  FuelSrv
//
//  Created by PBS9 on 21/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class GetCardsModel: Mappable{
    
    var cards : [Card]?
    var message : String?
    var success : Bool?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        cards  <- map["cards"]
        success  <- map["success"]
    }
}
class Card : Mappable{
   
    var v : Int?
    var id : String?
    var cardBrand : String?
    var cardHolderName : String?
    var cardNumber : String?
    var createdAt : String?
    var expiryDate : String?
    var isDeleted : Int?
    var lastFourDigit : String?
    var updatedAt : String?
    var userId : String?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        cardBrand  <- map["cardBrand"]
        cardHolderName  <- map["cardHolderName"]
        cardNumber  <- map["cardNumber"]
        createdAt  <- map["createdAt"]
        expiryDate  <- map["expiryDate"]
        isDeleted  <- map["isDeleted"]
        lastFourDigit  <- map["LastFourDigit"]
        updatedAt  <- map["updatedAt"]
        userId  <- map["userId"]
    }
}
