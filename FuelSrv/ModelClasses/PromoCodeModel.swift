//
//  PromoCodeModel.swift
//  FuelSrv
//
//  Created by PBS9 on 19/04/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class PromoCodeModel : Mappable{
    
    var message : String?
    var promoResult : PromoResult?
    var success : Bool?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        promoResult  <- map["promoResult"]
        success  <- map["success"]
    }
}
class PromoResult : Mappable{
    
    var isValid : Int?
    var promo : Promo!
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        isValid  <- map["isValid"]
        promo  <- map["promo"]
    }
}
class Promo : Mappable{
   
    var v : Int?
    var id : String?
    var createdAt : String?
    var deactivePromo : Int?
    var discountAmount : Int?
    var isDeleted : Int?
    var promocode : String?
    var updatedAt : String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        createdAt  <- map["createdAt"]
        deactivePromo  <- map["deactivePromo"]
        discountAmount  <- map["discountAmount"]
        isDeleted  <- map["isDeleted"]
        promocode  <- map["promocode"]
        updatedAt  <- map["updatedAt"]
    }
}
