//
//  PeoplePesenter.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/15/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation

class PeoplePresenter {
    var peopleTableViewModel: PeopleTableViewModelProtocol
    var peopleTableView: PeopleTableViewProtocol
    
    
    var ApiPageNo = 1
    var totalPagesNo = 0
    
    init( ViewObj: PeopleTableViewProtocol, ModelObj: PeopleTableViewModelProtocol) {
        peopleTableViewModel = ModelObj
        peopleTableView = ViewObj
    }
    func removeAllandReload(completionHandler: ()->Void){
        peopleTableViewModel.removeAllinArray(completionHandler: {
          self.peopleTableView.refreshTableView()
        })
        
    
    }
    
    func getObjects(number: Int, urlString: String, completionHandler: ()->Void){
        
        peopleTableViewModel.getJson(pnumber: number, urlString: urlString, completionHandler: {
            self.peopleTableView.refreshTableView()
        })
    }
    func getObjectForCell(index: Int)-> Actor{
        return peopleTableViewModel.getObjectAtIndex(index: index)
    }
    func getArrayCount() -> Int {
        return peopleTableViewModel.getArrayCount()
    }
    
    func setApiPageNo(pageNo: Int){
        self.ApiPageNo = pageNo
    }
    func getApiPageNo() -> Int {
        return ApiPageNo
    }
    func getTotalPageNo() -> Int {
        return totalPagesNo
    }
}
