//
//  ApiObj.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/29/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
import ObjectMapper
class ApiObj: Decodable {
    var   page : Int?
    var results :[Actor]? //
}

class Actor: Decodable {
    var   profile_path : String?
    var  adult : Bool?
    var   id :Int?
    var   name : String?
   var popularity : Double?
    var  known_for :Array<Film>? //
}

class Film: Decodable{
    var id : Int? //
    var poster_path : String? //
    var  title : String? //

}


class Picture: Mappable {
    var profiles:[Path]?
    
    required init?(map: Map) {
        
    }
    
     func mapping(map: Map) {
        profiles         <- map["profiles"]
       
    }
}
class Path: Mappable {
var file_path: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        file_path       <- map["file_path"]
    }
    
    
}
