//
//  SellCreateFilterDetailResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 11/09/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

struct SellCreateFilterDetailResponse: Codable {
    
    let name: String
    let category: String
    let photoURL: String
    let collections: [SellCreateFilterDetailCollectionResponse]
    
    enum CodingKeys: String, CodingKey {
        case name, collections, category
        case photoURL = "photo_url"
    }
}

struct SellCreateFilterDetailCollectionResponse: Codable {
    
    let dates: [SellCreateFilterDetailCollectionDateResponse]
    let place: String
}

struct SellCreateFilterDetailCollectionDateResponse: Codable {
    
    let date: String
    let times: [SellCreateFilterDetailCollectionDateTimeResponse]
}

struct SellCreateFilterDetailCollectionDateTimeResponse: Codable {
    let time: String
    let types: [SellCreateFilterDetailCollectionDateTimeTypesResponse]
}

struct SellCreateFilterDetailCollectionDateTimeTypesResponse: Codable {
    
    let itemId: Int
    let type: String
    let typeId: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case itemId = "item_id"
        case typeId = "type_id"
    }
}
