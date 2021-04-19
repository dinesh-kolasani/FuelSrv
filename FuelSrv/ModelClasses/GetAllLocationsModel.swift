//
//  GetAllLocationsModel.swift
//  FuelSrv
//
//  Created by PBS9 on 24/06/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class GetAllLocationsModel : Mappable{
    
    var location : [Location]!
    var message : String?
    var success : Bool?
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        location  <- map["location"]
        message  <- map["message"]
        success  <- map["success"]
    }
}
