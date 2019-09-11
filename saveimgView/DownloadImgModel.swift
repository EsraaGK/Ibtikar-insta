//
//  DownloadImgModel.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/11/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
class DownloadImgModel{
    
    func loadImg(stringURL :String , completionHandler:@escaping (Data?)->Void){
        if stringURL != "noPath" {
            let url = URL(string: stringURL)!
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
    
    func downloadImg(StringUrl :String ,completionHandler:(Data?)->Void){
        if let url = URL(string: StringUrl),
            let data = try? Data(contentsOf: url){
            completionHandler (data)
        }
        
        
    }
    
    
}
