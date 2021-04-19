//
//  ReimbursmentModel.swift
//  FuelSrv
//
//  Created by PBS9 on 28/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper


class ReimbursmentModel : Mappable{
    
    var message : String?
    var success : Bool?
    var userReimbursement : UserReimbursement?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        userReimbursement  <- map["userReimbursement"]
        message  <- map["message"]
        success  <- map["success"]
    }
}
class UserReimbursement : Mappable{
    
    var customerFuelAmount : Int?
    var distanceDriven : Int?
    var fromDateTime : String?
    var fuelPumped : Int?
    var myFuelAmount : Int?
    var toDateTime : String?
    var upcomingReimbursementDate : String?
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        customerFuelAmount  <- map["customerFuelAmount"]
        distanceDriven  <- map["distanceDriven"]
        fromDateTime  <- map["fromDateTime"]
        fuelPumped  <- map["fuelPumped"]
        myFuelAmount  <- map["myFuelAmount"]
        toDateTime  <- map["toDateTime"]
        upcomingReimbursementDate  <- map["upcomingReimbursementDate"]
    }
}
