//
//  UtilityViewModelTest.swift
//  BuzzniTests
//
//  Created by yoon tae soo on 2020/12/12.
//

import XCTest
@testable import Buzzni

class UtilityViewModelTest: XCTestCase {

    var utilityViewModel : UtilityViewModel!
    
    override func setUp() {
        super.setUp()
        utilityViewModel = UtilityViewModel()
    }
    
    override func tearDown() {
        utilityViewModel = nil
        super.tearDown()
    }
    
    func test_check_noDataSection(){
        
        let itemModel_single : [ItemModel] = [
            
            ItemModel(name: "★우리아이 신나는 목욕시간!★ 버블버블액션클렌저 10종", url: "http://m.gongyoungshop.kr/gate/selectAliance.do?alcLnkCd=hsmoa&tgUrl=/goods/selectGoodsDetail.do?prdId=11469828", shop: "immall", start_datetime: DynamicJsonProperty.string("20201212172000"), end_datetime: "20201212182500", price: 62820, sametime:[ LittleItemModel(name: "★우리아이 신나는 목욕시간!★ 버블버블액션클렌저 5종", image: "http://cdn.image.buzzni.com/2020/12/02/lW5WqkqPz7.jpg"), LittleItemModel(name: "버블버블액션 1개", image: "http://cdn.image.buzzni.com/2020/12/11/ak582CmwkA.jpg")], image_list: ["http://cdn.image.buzzni.com/2020/12/02/vLCi5kX30s.jpg"])
        
        ]
        
        let itemModel_multi : [ItemModel] = [
            ItemModel(name: "★우리아이 신나는 목욕시간!★ 버블버블액션클렌저 10종", url: "http://m.gongyoungshop.kr/gate/selectAliance.do?alcLnkCd=hsmoa&tgUrl=/goods/selectGoodsDetail.do?prdId=11469828", shop: "immall", start_datetime: DynamicJsonProperty.string("20201212172000"), end_datetime: "20201212182500", price: 62820, sametime:[ LittleItemModel(name: "★우리아이 신나는 목욕시간!★ 버블버블액션클렌저 5종", image: "http://cdn.image.buzzni.com/2020/12/02/lW5WqkqPz7.jpg"), LittleItemModel(name: "버블버블액션 1개", image: "http://cdn.image.buzzni.com/2020/12/11/ak582CmwkA.jpg")], image_list: ["http://cdn.image.buzzni.com/2020/12/02/vLCi5kX30s.jpg"]),
            ItemModel(name: "★우리아이 신나는 목욕시간!★ 버블버블액션클렌저 10종", url: "http://m.gongyoungshop.kr/gate/selectAliance.do?alcLnkCd=hsmoa&tgUrl=/goods/selectGoodsDetail.do?prdId=11469828", shop: "immall", start_datetime: DynamicJsonProperty.string("20201212172000"), end_datetime: "20201212182500", price: 62820, sametime:[ LittleItemModel(name: "★우리아이 신나는 목욕시간!★ 버블버블액션클렌저 5종", image: "http://cdn.image.buzzni.com/2020/12/02/lW5WqkqPz7.jpg"), LittleItemModel(name: "버블버블액션 1개", image: "http://cdn.image.buzzni.com/2020/12/11/ak582CmwkA.jpg")], image_list: ["http://cdn.image.buzzni.com/2020/12/02/vLCi5kX30s.jpg"]),
            ItemModel(name: "★우리아이 신나는 목욕시간!★ 버블버블액션클렌저 10종", url: "http://m.gongyoungshop.kr/gate/selectAliance.do?alcLnkCd=hsmoa&tgUrl=/goods/selectGoodsDetail.do?prdId=11469828", shop: "immall", start_datetime: DynamicJsonProperty.string("20201212172000"), end_datetime: "20201212182500", price: 62820, sametime:[ LittleItemModel(name: "★우리아이 신나는 목욕시간!★ 버블버블액션클렌저 5종", image: "http://cdn.image.buzzni.com/2020/12/02/lW5WqkqPz7.jpg"), LittleItemModel(name: "버블버블액션 1개", image: "http://cdn.image.buzzni.com/2020/12/11/ak582CmwkA.jpg")], image_list: ["http://cdn.image.buzzni.com/2020/12/02/vLCi5kX30s.jpg"])
        
        ]
        
        let itemData : [dataModel] = [
            dataModel(data: itemModel_single , time: "202012121700", month: nil, day: nil, weekday_kor: nil, type: nil),
            dataModel(data: itemModel_multi , time: "202012121700", month: nil, day: nil, weekday_kor: nil, type: nil),
            dataModel(data: nil , time: nil, month: 12, day: 13, weekday_kor: "wen", type: "anyThing"),
            dataModel(data: itemModel_single , time: "202012121700", month: nil, day: nil, weekday_kor: nil, type: nil)
            
        ]
        
        let noDataSectionList : [Int] = utilityViewModel.check_noDataSection(itemData: itemData)
        
        XCTAssertEqual(1, noDataSectionList.count)
        
    }
    
    func test_get_lastTime(){
        
        let expectedResult : String = "202012122100"
        
        let itemData : [dataModel] = [
            dataModel(data: nil , time: "202012121700", month: nil, day: nil, weekday_kor: nil, type: nil),
            dataModel(data: nil , time: "202012121900", month: nil, day: nil, weekday_kor: nil, type: nil),
            dataModel(data: nil , time: "202012122000", month: 12, day: 13, weekday_kor: "wen", type: "anyThing"),
            dataModel(data: nil , time: "202012122100", month: nil, day: nil, weekday_kor: nil, type: nil)
            
        ]
        
        let lastTime = utilityViewModel.get_lastTime(itemData: itemData)
        
        XCTAssertEqual(expectedResult, lastTime)
        
        
    }
    
    
    func test_make_Date2TimeString(){
        
        let inputTime : String = "202012131825"
        let outputTime : String = "18:25"
        
        let dateType = utilityViewModel.make_String2Date(inputTime: inputTime)
        let result = utilityViewModel.make_Date2TimeString(inputDate: dateType)
        
        XCTAssertEqual(outputTime, result)
        
    }
    
    func test_make_removeLastTwoZero(){
        
        let inputTime : String = "20201213182500"
        let outputTime : String = "202012131825"
        
        let result = utilityViewModel.make_removeLastTwoZero(inputTime: inputTime)
        
        XCTAssertEqual(outputTime, result)
        
    }
    
    

}
