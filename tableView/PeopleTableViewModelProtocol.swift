//
//  ModelProtocol.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/15/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
protocol PeopleTableViewModelProtocol {
    func search()
    func removeAllinArray(completionHandler:()->Void)
    func loadImg(index :Int , completionHandler :@escaping (Data?)->Void)
    func getJson(pnumber : Int , urlString:String , completionHandler : @escaping ()->Void)
    func getObjectAtIndex(index:Int)->Actor
    func getArrayCount()->Int
}
