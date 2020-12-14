//
//  UtilityViewModel.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/12.
//

import UIKit

class UtilityViewModel {
    
    //2일차 section에 들어갈 뷰 생성 with label
    //3일차 insideView 생성
    func make_sectionView(viewCenter : CGFloat, inputText : String) -> UIView{
        
        let view = UIView()
        view.backgroundColor = .clear
        
        if inputText == "" {
            return view
        }
        
        let insideView = UIView()
        insideView.frame = CGRect(x: viewCenter - 40, y: 10, width: 80, height: 20)
        insideView.layer.cornerRadius = 10
        insideView.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 128/255, alpha: 1)

        let label = UILabel()
        label.text = make_Date2HourString(inputDate: make_String2Date(inputTime: inputText))
        label.frame = CGRect(x: 14, y: 0, width: 55, height: 20)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.sizeToFit()
        
        insideView.addSubview(label)
        
        view.addSubview(insideView)
        
        return view
    }
    
    //2일차 DateInfo인 데이터 찾기
    func check_noDataSection(itemData : [dataModel]) -> [Int]{
        
        var noDatasection : [Int] = []
        
        for (index, element) in itemData.enumerated(){
            
            if element.data != nil {
                print("\(index) , \(element.data!.count) \(element.time!)")
                
            }
            else{
                print("\(index) , \(element.month!)")
                noDatasection.append(index)
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
    func get_lastTime(itemData : [dataModel]) -> String?{
        
        var lastTime : String? = nil
        
        itemData.forEach { (item) in
            lastTime = item.time!
        }
        
        return lastTime
        
    }
    
    //3일차 - String 타입을 Date 타입으로
    func make_String2Date(inputTime : String) -> Date {
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyyMMddHHmm"
        
        return inputDateFormatter.date(from: inputTime)!
    }
    
    //3일차 - Date 타입을 String 타입으로
    func make_Date2HourString(inputDate : Date) -> String {
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "a h'시'"
        outputDateFormatter.amSymbol = "오전"
        outputDateFormatter.pmSymbol = "오후"
        
        return outputDateFormatter.string(from: inputDate)
        
    }
    
    //3일차 - Date 형식을 13:43 형태로 만들어주는 함수
    func make_Date2TimeString(inputDate : Date) -> String {
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "HH:mm"
        
        return outputDateFormatter.string(from: inputDate)

    }
    
    //3일차 - 20201213182500을 202012131825로 변경
    func make_removeLastTwoZero(inputTime : String) -> String {
        
        var tempTime = inputTime
        tempTime.removeLast()
        tempTime.removeLast()
        
        return tempTime
    }
    
}
