//
//  ActorCollectionProtocol.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/16/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
protocol ActorCollectionModelProtocol {
    func getResponse (completionHandler:@escaping ()->Void)
//    func loadCollectionImage(index:Int, completionHandler:@escaping (Data?)->Void)
//    func loadHeaderImage(completion:@escaping (Data?)->Void)
    func getStringUrlAtIndex(index:Int)->String
    func getProfileArrayCount()->Int
    func getActorNameAt()->String
    func getActorPopularityAt()->Double
    func getActorProfilePath()->String
}
