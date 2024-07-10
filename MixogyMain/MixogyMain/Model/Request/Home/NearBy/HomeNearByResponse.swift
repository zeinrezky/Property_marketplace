//
//  HomeNearByResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 03/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class HomeNearByResponse: Codable {
    let categoryId: Int
    let categoryName: String
    let items: [HomeNearByIitem]
    
    enum CodingKeys: String, CodingKey {
        case items
        case categoryName = "category_name"
        case categoryId = "category_id"
    }
}

class HomeNearByIitem: Codable {
    let itemId: Int
    let category: String
    let name: String
    let photoUrl: String?
    let originalPrice: Int
    let type: String
    let total: Int
    let levelId: Int
    let lowestPrice: Int?
    
    enum CodingKeys: String, CodingKey {
        case category, type, total, name
        case lowestPrice = "lowest_price"
        case originalPrice = "original_price"
        case photoUrl = "photo_url"
        case itemId = "item_id"
        case levelId = "level_id"
    }
}
