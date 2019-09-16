//
//  tableModel.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/10/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
class TableModel: PeopleTableViewModelProtocol{
    
    var results = [Actor]()
      var totalPagesNo = 0
      var  ApiPageNo = 1
     let cache:NSCache<AnyObject , AnyObject>! = NSCache()
    
    func search(){
        results.removeAll()
        cache.removeAllObjects()
        ApiPageNo=1
    }
    
    func removeAllinArray(completionHandler:()->Void){
     ApiPageNo = 1
        results.removeAll()
       cache.removeAllObjects()
        completionHandler()
          print(ApiPageNo)
    }
    
    func loadImg(index :Int , completionHandler :@escaping (Data?)->Void){
        var task: URLSessionDownloadTask! = URLSessionDownloadTask()
        let session: URLSession!
       
       
        if results[index].profile_path! != "noPath"  {
        
            if (cache.object(forKey: (results[index].profile_path! as AnyObject)) != nil){
                // 2
                // Use cache
                print("Cached image used, no need to download it")
                completionHandler(cache.object(forKey: (results[index].profile_path!) as AnyObject) as? Data)
               
            }else{
                // 3
               
                let url:URL! = URL(string:results[index].profile_path!)
                task = URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                       // self.cache.setObject( data as AnyObject, forKey: self.results[index].profile_path! as AnyObject)
                        completionHandler(data)
                        
                            }
                }
            )}
                task.resume()
        }else{
            completionHandler(nil)
          //  cell.cellImg.image = UIImage(named:"Reverb")
        }
    }
    
    
    func getJson(pnumber : Int , urlString:String , completionHandler : @escaping ()->Void){
        // this is made for the pull-to-reload
        
        if pnumber == 1 {
            
            results.removeAll()
            //self.tableView.reloadData()
            
        }
        
        let urlApi = urlString + "&page=\(pnumber)"
        
        if let url = URL(string:urlApi ) {
            // Create Request
            let request = URLRequest(url: url)
            
            // Create Data Task
            let dataTask = URLSession.shared.dataTask(with: request){ (data, response, error) -> Void in
                
                if let  dataResponse = data{
                 
                        
                        do{
                            //here dataResponse received from a network request
                            let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse , options:[]) as! NSDictionary
                            
                            self.totalPagesNo = jsonResponse.value(forKey: "total_pages") as! Int
                            self.ApiPageNo = jsonResponse.value(forKey: "page") as! Int
                            let x = jsonResponse.value(forKey: "results") as! NSArray
                            
                            for n in x {
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
                                print(tmp.name)
                            //    self.tableView.reloadData()
                                
                            }
                            completionHandler()
                            // print("\(jsonResponse.value(forKey: "page")!)")
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                        
                    }
                
            }
            
            dataTask.resume()
        }
        
    }
    
    func getObjectAtIndex(index:Int)->Actor{
        return results[index]
    }
    func getArrayCount()->Int{
        return results.count
    }
    func getTotalPagesNo() -> Int {
        return totalPagesNo
    }
}

