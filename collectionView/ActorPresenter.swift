//
//  ActorPresenter.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/16/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
class ActorPresenter {
    var collectionModel: ActorCollectionModelProtocol
    var actorCollectionView: ActorCollectionViewProtocol
    
    init(ViewObj: ActorCollectionViewProtocol, ModelObj: ActorCollectionModelProtocol) {
        collectionModel = ModelObj
        actorCollectionView=ViewObj
        
    }
    
    func getResponse( completionHandler: ()->Void){
        
        collectionModel.getResponse ( completionHandler: {
            self.actorCollectionView.refreshActorView()
        })
    }
    func getObjectForCell(index: Int)-> String{
        return collectionModel.getStringUrlAtIndex(index: index)
    }
    func getArrayCount() -> Int {
        return collectionModel.getProfileArrayCount()
    }
//    func loadImageForHeader()->Data?{
//         var datais :Data?
//        collectionModel.loadHeaderImage(){data in
//            if let imgData = data{
//                datais = imgData
//            }else{
//                datais = nil
//            }
//        }
//        return datais
//    }
//    func loadImageForCellAt(index: Int)->Data?{
//        var datais :Data?
//        collectionModel.loadCollectionImage(index: index) {data in
//            if let imgData = data{
//                datais = imgData
//            }else{
//                datais = nil
//            }
//        }
//        return datais
//    }
    func getActorNameAt()->String{
        return collectionModel.getActorNameAt()
    }
    func getActorPopularityAt()->Double
    {
        return collectionModel.getActorPopularityAt()
    }
    func getActorProfilePath() ->String{
     return collectionModel.getActorProfilePath()
    }
}
