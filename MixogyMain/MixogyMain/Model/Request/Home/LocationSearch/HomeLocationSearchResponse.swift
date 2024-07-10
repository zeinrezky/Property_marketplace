//
//  HomeLocationSearchResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class HomeLocationSearchResponse: Codable {
    
    let itemId: Int
    let name: String
    let category: String
    let photoUrl: String?
    let originalPrice: Int
    let typeId: Int
    let categoryId: Int
    let levelId: Int
    let type: String
    let total: Int
    let lowestPrice: Int
    
    enum CodingKeys: String, CodingKey {
        case category, type, total, name
        case lowestPrice = "lowest_price"
        case originalPrice = "original_price"
        case photoUrl = "photo_url"
        case itemId = "item_id"
        case typeId = "type_id"
        case categoryId = "category_id"
        case levelId = "level_id"
    }
}
