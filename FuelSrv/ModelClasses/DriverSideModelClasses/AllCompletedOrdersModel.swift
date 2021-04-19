//
//  AllCompletedOrdersModel.swift
//  FuelSrv
//
//  Created by PBS9 on 13/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class AllCompletedOrdersModel : Mappable{
    
    var message : String?
    var orders : [DriverOrder]?
    var success : Bool?
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
        orders <- map["orders"]
        success <- map["success"]
    }
}
