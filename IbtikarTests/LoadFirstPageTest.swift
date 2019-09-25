//
//  IbtikarTests.swift
//  IbtikarTests
//
//  Created by EsraaGK on 9/25/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import XCTest
@testable import Ibtikar
class LoadFirstPageTest: XCTestCase {
   
    let viewObj = PeopleView()
    let  modelObj = PeopleModel()
 lazy var presenterObj = PeoplePresenter(ViewObj: viewObj, ModelObj: modelObj )
    override func setUp() {
        
    }
    
    func testFetchPeopleFirstPage(){
        //in the very first beginning the array count mus be o
        XCTAssertEqual(presenterObj.getArrayCount(), 0)
       presenterObj.getObjects(number: 1, urlString: viewObj.peopleUrl, completionHandler: {})
        XCTAssertEqual(presenterObj.getArrayCount(), 20)
        
    }
    
    

}
class PeopleModel: PeopleTableViewModelProtocol {
    var results = [Actor]()
    func search() {
        //
    }
    
    func removeAllinArray(completionHandler: () -> Void) {
        results.removeAll()
    }
    
    func loadImg(index: Int, completionHandler: @escaping (Data?) -> Void) {
        
    }
    
    func getJson(pnumber: Int, urlString: String, completionHandler: @escaping () -> Void) {
     var fileName = ""
        if pnumber == 1{
            fileName = "firstPage"
        }
        else{
            fileName = "twoPages"
        }
        if let path = Bundle.main.path(forResource: fileName , ofType:  "json"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options:[])
                let jsonResult = try JSONSerialization.jsonObject(with: data, options:[]) as! NSDictionary
                if let persons = jsonResult.value(forKey:"results") as? NSArray{
                for n in persons {
                        let tmp = Actor ()
                        tmp.adult = (n as! NSDictionary ).value(forKey: "adult") as! Bool
                        tmp.name = (n as! NSDictionary ).value(forKey: "name") as! String
                        tmp.id = (n as! NSDictionary ).value(forKey: "id") as! Int
                        
                        if let  e = (n as! NSDictionary ).value(forKey: "profile_path") as? String{
                            tmp.profile_path = "https://image.tmdb.org/t/p/w500\(e)"
                        }else{
                            tmp.profile_path = "noPath"
                        }
                        tmp.popularity = (n as! NSDictionary ).value(forKey: "popularity") as! Double
                        var tmp_known_for = (n as! NSDictionary ).value(forKey: "known_for") as! NSArray
                        
                        for w in tmp_known_for {
                            var temp_film = Film()
                            
                            temp_film.id = (n as! NSDictionary ).value(forKey: "id") as! Int
                            if let y = (n as! NSDictionary).value(forKey: "poster_path" )  {
                                temp_film.poster_path = ( "https://image.tmdb.org/t/p/w500\(y)" as! String)
                            } else {
                                
                                temp_film.poster_path = "noPath"
                            }
                            
                            if let y = (n as! NSDictionary).value(forKey: "title" )  {
                                temp_film.title = y as! String
                            } else {
                                
                                temp_film.title = "no path"
                            }
                            
                            tmp.known_for?.append(temp_film)
                        }
                        
                        self.results.append(tmp)
                        print("test")
    
                    }
                 completionHandler()
                }
                
            } catch {
                // handle error
                print ("can't find url")
            }
        }
    }
    
    func getObjectAtIndex(index: Int) -> Actor {
        return Actor()
    }
    
    func getArrayCount() -> Int {
        return results.count
    }
    
    func getTotalPagesNo() -> Int {
        return  1
    }
    
    
}
class PeopleView: PeopleTableViewProtocol{
    let peopleUrl = "https://api.themoviedb.org/3/person/popular?api_key=1a45f741aada87874aacfbeb73119bae&language=en-US"
    
    func refreshTableView() {
        
    }
    
    
}
