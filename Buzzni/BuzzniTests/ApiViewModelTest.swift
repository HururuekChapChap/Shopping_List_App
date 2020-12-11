//
//  APIViewModelTest.swift
//  BuzzniTests
//
//  Created by yoon tae soo on 2020/12/11.
//

import XCTest
@testable import Buzzni

class APIViewModelTest: XCTestCase {

    var apiViewModel : ApiViewModel!
    
    override func setUp() {
        super.setUp()
        apiViewModel = ApiViewModel()
    }
    
    override func tearDown() {
        apiViewModel = nil
        super.tearDown()
    }
    
    //URL의 존재 여부 판단하는 Unit Test
    func test_makeUrl(){
        
        var inputDate : String? = "202012112000"
        
        if inputDate == "" {
            inputDate = nil
        }
    
        let url = apiViewModel.makeUrl(dateTime: nil)
        
        XCTAssertNotNil(url)

    }
    
}
