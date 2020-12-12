//
//  ItemModel.swift
//  Buzzni
//
//  Created by yoon tae soo on 2020/12/11.
//

import Foundation

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
    let data : [ItemModel]
    
}

struct dataModel : Codable{
    
    let data : [ItemModel]?
    
    let time : String?
    let month : Int?
    let day : Int?
    let weekday_eng : String?
    let type : String?
    
}

struct ItemModel : Codable {
        
    let name : String?
    let url : String?
    let shop : String?
    let start_datetime : String?
    let end_datetime : String?
    let price : Int?
    let sametime : [LittleItemModel]?
    let image_list : [String]?

}

struct LittleItemModel : Codable {
    
    let name : String
    let image : String

    
}
