//
//  UtilityViewModel.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/12.
//

import UIKit

class UtilityViewModel {
    
    //2일차 section에 들어갈 뷰 생성
    func make_sectionView(viewCenter : CGFloat, inputText : String) -> UIView{
        
        let view = UIView()
        view.backgroundColor = .orange
        
        let label = UILabel()
        label.text = inputText
        label.frame = CGRect(x: viewCenter - 50, y: 5, width: 100, height: 30)
        label.sizeToFit()
        
        view.addSubview(label)
        
        return view
    }
    
    //2일차 DateInfo인 데이터 찾기
    func check_noDataSection(itemData : [dataModel]) -> Int?{
        
        var noDatasection : Int?
        
        for (index, element) in itemData.enumerated(){
            
            if element.data != nil {
                print("\(index) , \(element.data!.count) \(element.time!)")
                
            }
            else{
                print("\(index) , \(element.month!)")
                noDatasection = index
            }
            
        }
        
        return noDatasection
        
    }
    
    //2일차 원하는 형식의 날짜로 만듬
    func make_Date(inputDate : Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        
        return dateFormatter.string(from: inputDate)
    }
    
    //2일차 현재시간 부터 한시간 전
    func make_oneHour_before() -> String {
        
        let now = Date()
        let oneHourBefore = now.addingTimeInterval(-3600)
        
        let result = make_Date(inputDate: oneHourBefore)
        
        return result
    }
    
    //2일차 마지막 시간 출력
    func get_lastTime(itemData : [dataModel]) -> String{
        
        var lastTime : String = ""
        
        itemData.forEach { (item) in
            lastTime = item.time!
        }
        
        return lastTime
        
    }
    
}
