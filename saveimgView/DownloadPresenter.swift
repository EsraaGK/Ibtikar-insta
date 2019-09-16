//
//  DownloadPresenter.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/16/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation

class DownloadPresenter  {
    var downloadModel: DownloadModelProtocol
    var downloadView: DownloadViewProtocol
    
    init(viewObj:DownloadViewProtocol, modelObj:DownloadModelProtocol) {
       downloadView=viewObj
        downloadModel=modelObj
    }
    func getActorImgPath()->String{
        return downloadModel.getStringURL()
    }
    func downloadActorImg(completion:@escaping (Data?)->Void){
        downloadModel.downloadImg { data in
            completion (data)
        }
    }
}
