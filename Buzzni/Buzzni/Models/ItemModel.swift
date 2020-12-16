//
//  ItemModel.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/11.
//

import Foundation

//4일차 - JSON Type이 Multi 일 경우에 해결 하는 방법 Enum
enum DynamicJsonProperty : Codable {
    
    case string(String)
    case int(Int)
    
    init(from decoder : Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        //Decode the property
        do {
            let stringValue = try container.decode(String.self)
            self = .string(stringValue)
        }
        catch DecodingError.typeMismatch{
            let intValue = try container.decode(Int.self)
            self = .int(intValue)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        }
    }
    
}


struct resultModel : Codable{
    
    let result : after_liveModel
}

struct after_liveModel : Codable {
    let live : [liveModel]
    let after_live : [dataModel]
    let is_continues : Int
    
}

struct liveModel : Codable {
    
    let count : Int
    let time : String
    var data : [ItemModel]
    
}

struct dataModel : Codable{
    
    let data : [ItemModel]?
    
    let time : String?
    let month : Int?
    let day : Int?
    let weekday_kor : String?
    let type : String?
    
}

struct ItemModel : Codable {
        
    let name : String?
    let url : String?
    let shop : String?
    let start_datetime : DynamicJsonProperty?
    let end_datetime : String?
    let price : Int?
    let sametime : [LittleItemModel]?
    let image_list : [String]?

}

struct LittleItemModel : Codable {
    
    let name : String
    let image : String

    
}
