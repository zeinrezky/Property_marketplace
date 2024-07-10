//
//  ItemLocatonRsponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class ItemLocatonRsponse: Codable {
        
    let photoURL: String
    let category: String
    let name: String
    let collections: [ItemLocationCollectionRsponse]
    
    enum CodingKeys: String, CodingKey {
        case category, name, collections
        case photoURL = "photo_url"
    }
}

class ItemLocationCollectionRsponse: Codable {
    
    let place: String
    let count: Int
    let dates: [ItemLocationCollectionDateResponse]
}

class ItemLocationCollectionDateResponse: Codable {
    
    let date: String
    let count: Int
    let times: [ItemLocationCollectionDateTimeResponse]
}

class ItemLocationCollectionDateTimeResponse: Codable {
    
    let time: String
    let count: Int
    let types: [ItemLocationCollectionDateTimeTypesResponse]
}

class ItemLocationCollectionDateTimeTypesResponse: Codable {
    
    let type: String
    let itemId: Int
    let typeId: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case itemId = "item_id"
        case typeId = "type_id"
    }
}
