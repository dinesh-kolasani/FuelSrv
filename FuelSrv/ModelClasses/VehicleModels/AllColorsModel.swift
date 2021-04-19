//
//  AllColorsModel.swift
//  FuelSrv
//
//  Created by PBS9 on 15/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class AllColorsModel : Mappable{
    
    var color : [Color]!
    var message : String?
    var success : Bool?
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        color  <- map["color"]
        message  <- map["message"]
        success  <- map["success"]
    }
}
class Color : Mappable{
    
    var v : Int?
    var id : String?
    var colorName : String?
    var createdAt : String?
    var isDeleted : Int?
    var updatedAt : String?
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        colorName  <- map["colorName"]
        createdAt  <- map["createdAt"]
        isDeleted  <- map["isDeleted"]
        updatedAt  <- map["updatedAt"]
    }
}
