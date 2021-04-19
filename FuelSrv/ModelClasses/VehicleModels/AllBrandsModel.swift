//
//  AllBrandsModel.swift
//  FuelSrv
//
//  Created by PBS9 on 15/05/19.
//  Copyright © 2019 Dinesh. All rights reserved.
//

import Foundation
import ObjectMapper

class AllBrandsModel : Mappable{
   
    var brands : [Brand]!
    var message : String?
    var success : Bool?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        brands  <- map["brands"]
        message  <- map["message"]
        success  <- map["success"]
    }
}
class Brand : Mappable{
   
    var v : Int?
    var id : String?
    var brandName : String?
    var createdAt : String?
    var isDeleted : Int?
    var updatedAt : String?
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        v  <- map["__v"]
        id  <- map["_id"]
        brandName  <- map["brandName"]
        createdAt  <- map["createdAt"]
        isDeleted  <- map["isDeleted"]
        updatedAt  <- map["updatedAt"]
    }
}
