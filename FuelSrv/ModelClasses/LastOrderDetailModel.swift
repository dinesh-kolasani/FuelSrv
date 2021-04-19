//
//  LastOrderDetailModel.swift
//  FuelSrv
//
//  Created by PBS9 on 10/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class LastOrderDetailModel : Mappable{
    
    var lastOrder : LastOrder?
    var message : String?
    var success : Bool?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        lastOrder  <- map["lastOrder"]
        message  <- map["message"]
        success  <- map["success"]
    }
    
}
class LastOrder : Mappable{
    
    var v : Int?
    var id : String?
    var address : String?
    var createdAt : String?
    var deleveringDate : Int?
    var discountAmount : Int?
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
    var serviceId : [ServiceId]!
    var stripeChargeId : String?
    var taxAmount : Float?
    var timing : String?
    var updatedAt : String?
    var userLat : Float?
    var userLong : Float?
    var userId : String?
    var vehicleCount : String?
    var vehicleId : String?
   
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        userLat  <- map["user_lat"]
        userLong  <- map["user_long"]
        address  <- map["address"]
    }
    
}
