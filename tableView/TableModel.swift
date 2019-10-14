//
//  tableModel.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/10/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
import Alamofire

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
        Alamofire.request(urlApi)
            .responseData{ response in
                
                // do stuff with the JSON or error
                // 2
                switch response.result {
                case .success(let data ):
                    
                    let apiObj:ApiObj = try! JSONDecoder().decode(ApiObj.self, from: data)
                    self.results = apiObj.results!
                    completionHandler()
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
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

