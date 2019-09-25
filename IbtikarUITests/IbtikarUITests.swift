//
//  IbtikarUITests.swift
//  IbtikarUITests
//
//  Created by EsraaGK on 9/25/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import XCTest

class IbtikarUITests: XCTestCase {

     private let app = XCUIApplication()
    
    
    override func setUp() {
        app.launch()
       

  }
    func testPeopleTableViewExists(){
        let peopleTableView = app.tables["PeopleTableView"]
        XCTAssert(peopleTableView.cells.count == 20)
       
    }
    func testCPeopleTableHasCell(){
        let peopleTableView = app.tables["PeopleTableView"]
        let peopleTableViewCell = peopleTableView.cells.element(boundBy: 0)
        XCTAssert(peopleTableViewCell.exists)
        //CellLable
    }
    
}
