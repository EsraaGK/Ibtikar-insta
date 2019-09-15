//
//  PeopleTableViewCellModel.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/12/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
class PeopleTableViewCellModel {
    
    
    let cache:NSCache<AnyObject , AnyObject>! = NSCache()
    
    func loadImg(stringUrl: String , completionHandler: @escaping (Data?)->Void){
        var task: URLSessionDownloadTask! = URLSessionDownloadTask()
     
        
        if stringUrl != "noPath"  {
            
            if (cache.object(forKey: stringUrl as AnyObject) != nil){
                // 2
                // Use cache
                print("Cached image used, no need to download it")
                completionHandler(cache.object(forKey: (stringUrl) as AnyObject) as? Data)
                
            }else{
                // 3
                
                let url:URL! = URL(string:stringUrl)
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
    
    
}
