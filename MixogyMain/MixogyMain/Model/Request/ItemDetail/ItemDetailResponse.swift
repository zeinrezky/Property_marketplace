//
//  ItemDetailResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class ItemDetailResponse: Codable {
    
    let itemId: Int
    let photoUrl: String?
    let category: String
    let name: String
    let location: String
    let date: String
    let type: String
    let available: Int
    let sold: Int
    let originalPrice: Int
    let customerItems: [CustomerItem]
    
    enum CodingKeys: String, CodingKey {
        case category, name, location, date, type, available, sold
        case itemId = "item_id"
        case photoUrl = "photo_url"
        case originalPrice = "original_price"
        case customerItems = "customer_items"
    }
}

class CustomerItem: Codable {
    
    let id: Int
    let sellerPrice: Int?
    let addedOn: String?
    let itemSeat: String?
    let collectionMethods: [String]?
    let distanceToAgent: Int?
    let status: String?
    let locationPickUp: String?
    let sellerStatusId: Int?
    let sellTypeId: Int?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id, status, description
        case sellerPrice = "seller_price"
        case addedOn = "added_on"
        case itemSeat = "seat"
        case collectionMethods = "collection_methods"
        case distanceToAgent = "distance_to_agent"
        case locationPickUp = "location_pick_up"
        case sellerStatusId = "seller_status_id"
        case sellTypeId = "sell_type_id"
    }
}
