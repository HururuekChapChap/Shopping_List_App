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
    let utilityViewModel = UtilityViewModel()
    
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
        
        //nil일 때 호출한다.
        XCTAssertNotNil(url)

    }
    
    func test_getfetchData(){
        
        let expect = self.expectation(description: "성공적인 네트워크 작업")
        
        let beforeTime : String = utilityViewModel.make_oneHour_before()
        
        apiViewModel.getfetchData(input_url: apiViewModel.makeUrl(dateTime: beforeTime)) { (result) in
            
            switch result {
            
            case .success:
                expect.fulfill()
            case .failure(let error):
                //실패 호출
                XCTFail(error.rawValue)
            }
            
        }
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    
}
