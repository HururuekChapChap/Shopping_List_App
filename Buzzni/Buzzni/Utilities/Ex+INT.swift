//
//  Ex+INT.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/14.
//

import Foundation

//4일차 - 원으로 표시
extension Int {
    
    //4일차 - 원으로 형태 변환
    var currencyKR : String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "ko_KR")
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
        
    }
    
}
