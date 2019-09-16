//
//  collectionModel.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/11/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
class CollectionModel: ActorCollectionModelProtocol{
  
    func getStringUrlAtIndex(index: Int) -> String {
        return profiles[index]
    }
    
    func getProfileArrayCount() -> Int {
           return profiles.count
    }
    
   
  var  profiles = Array<String>()
    var NavActorObj: Actor
    
    init(ActorObj:Actor){
        NavActorObj = ActorObj
    }
    
    func loadHeaderImage(completion:@escaping (Data?)->Void){
        let stringURL = NavActorObj.profile_path!
        if stringURL != "noPath" {
            let url = URL(string: stringURL)!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { adata, response, error in
                if let data = adata{
                    print("this is data \(data)")
                    completion(data)
                }else{
                    completion(nil)
                }
                
            })
            task.resume()
            
        }else{// nopath
            completion(nil)
        }
    }
    
    func loadCollectionImage(index:Int ,completionHandler: @escaping (Data?)->Void){
        if profiles[index] != "noPath" {
            let url = URL(string: profiles[index])!
                let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { adata, response, error in
                    if let data = adata{
                        print("this is data \(data)")
                        completionHandler(data)
                    }else{
                         completionHandler(nil)
                    }
        
            })
            task.resume()
        
        }else{// nopath
             completionHandler(nil)
        }
    }
    
    func getResponse (completionHandler:@escaping ()->Void){
        
        // Obtain Reference to Shared Session
        let sharedSession = URLSession.shared
        
        if let url = URL(string: "https://api.themoviedb.org/3/person/\(NavActorObj.id!)/images?api_key=3955a9144c79cb1fca10185c95080107") {
            // Create Request
            let request = URLRequest(url: url)
            
            // Create Data Task
            let dataTask = sharedSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                if let  dataResponse = data{
                  
                        do{
                            //here dataResponse received from a network request
                            let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse , options:[]) as! NSDictionary
                            print(jsonResponse)
                            
                            let x = jsonResponse.value(forKey: "profiles") as! NSArray
                            for n in x {
                                var tmp :String
                                
                                if let  e = (n as! NSDictionary ).value(forKey: "file_path") as? String{
                                    tmp = "https://image.tmdb.org/t/p/w500\(e)"
                                    print(tmp)
                                }else{
                                    tmp = "noPath"
                                }
                                self.profiles.append(tmp)
                                
                                   print(tmp)
                                completionHandler()
                               // self.collectionView.reloadData()
                                print("the profile img no is\(self.profiles.count)")
                            }
                            // print("\(jsonResponse.value(forKey: "page")!)")
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                  }
            
            })
        
            dataTask.resume()
        }
    }
    
    func getActorNameAt()->String {
        return NavActorObj.name!
    }
    
    func getActorPopularityAt() -> Double {
        return NavActorObj.popularity!
    }
    
    
}

