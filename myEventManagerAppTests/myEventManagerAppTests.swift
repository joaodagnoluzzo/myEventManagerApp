//
//  myEventManagerAppTests.swift
//  myEventManagerAppTests
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 15/11/19.
//  Copyright © 2019 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import myEventManagerApp

class myEventManagerAppTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    let eventViewModel = EventViewModel()
    
    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFormatPrice() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertTrue(self.eventViewModel.formatPrice(price: 12.01) == "R$ 12.01")
        XCTAssertFalse(self.eventViewModel.formatPrice(price: 102.10) == "102.10")
        XCTAssertTrue(self.eventViewModel.formatPrice(price: nil) == "R$ --.--")
        XCTAssertTrue(self.eventViewModel.formatPrice(price: 0.10) == "R$ 0.1")
        
    }
    
    func testFormatDate() {
        
        XCTAssertTrue(self.eventViewModel.formatDate(dateInMilliseconds: 1571886000000) == "24/10/2019")
        XCTAssertFalse(self.eventViewModel.formatDate(dateInMilliseconds: 1571886000000) == "10/24/2019")
        XCTAssertTrue(self.eventViewModel.formatDate(dateInMilliseconds: nil) == "--/--/----")
        XCTAssertTrue(self.eventViewModel.formatDate(dateInMilliseconds: 1613962800000) == "22/02/2021")
        
        
    }

//    func testPerformanceExample() {
//         This is an example of a performance test case.
//        self.measure {
//             Put the code you want to measure the time of here.
//        }
//    }

}
