//
//  AllRecurringOrdersModel.swift
//  FuelSrv
//
//  Created by PBS9 on 08/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class AllRecurringOrdersModel : Mappable{
    
    var message : String!
    var orders : [ScheduleOrder]!
    var success : Bool!
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message  <- map["message"]
        success  <- map["success"]
        orders  <- map["orders"]
    }
}
