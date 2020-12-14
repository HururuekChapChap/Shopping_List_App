//
//  Ex+INT.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/14.
//

import Foundation

extension Int {
    
    var currencyKR : String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "ko_KR")
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
        
    }
    
}
