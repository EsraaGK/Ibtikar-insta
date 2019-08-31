//
//  ApiObj.swift
//  Ibtikar
//
//  Created by Esraa Mohamed on 8/29/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
class ApiObj {
    var   page : Int?
    var results :[Actor]? = Array() //
}

class Actor {
    var   profile_path : String?
    var  adult : Bool?
    var   id :Int?
    var   name : String?
   var popularity : Double?
    var  known_for :Array? = Array<Film>() //
}

class Film{
    var id : Int? //
    var poster_path : String? //
    var  title : String? //
    
//    
//     var original_title : String?
//    var  adult:Bool?
//  var overview : String?
// var release_date : String?
//   
//    var genre_ids : Array<Int>?
//   var media_type : String?
//     var original_language : String?
// 
//   var backdrop_path : String?
//    var popularity : Double?
//   var vote_count : Int?
//    var video :Bool?
//    var  vote_average : Double?

}
