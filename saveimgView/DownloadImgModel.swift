//
//  DownloadImgModel.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/11/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
import SDWebImage

class DownloadImgModel: DownloadModelProtocol{
   
    var stringUrl : String
    
    init(urlString: String) {
        stringUrl = urlString
    }
    
    func getStringURL() -> String {
        return stringUrl
    }
    
    func downloadImg(completionHandler: @escaping (Data?) -> Void) {
        let fullpath = "https://image.tmdb.org/t/p/w500" + stringUrl
        if let url = URL(string: fullpath),
            let data = try? Data(contentsOf: url){
            completionHandler (data)
        }
    }
    
    
}
