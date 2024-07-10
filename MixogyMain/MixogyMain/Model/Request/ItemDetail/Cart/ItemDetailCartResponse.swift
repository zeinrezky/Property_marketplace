//
//  ItemDetailCartResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class ItemDetailCartResponse: Codable {
        
    let id: Int
    let photoUrl: String?
    let category: String
    let name: String
    let originalPrice: Int
    let sellerPrice: Int
    let itemSeat: String?
    let collectionMethods: [String]
    let locationPickUp: String?
    let date: String
    let type: String
    let location: String
    let distance: Int
    let description: String?
    let photos: ItemDetailCartPhotoResponse
    let locationPickUpLatitude: String?
    let locationPickUpLongitude: String?
    
    enum CodingKeys: String, CodingKey {
        case id, category, name, date, type, distance, description, photos, location
        case sellerPrice = "seller_price"
        case photoUrl = "photo_url"
        case originalPrice = "original_price"
        case itemSeat = "item_seat"
        case collectionMethods = "collection_methods"
        case locationPickUp = "location_pick_up"
        case locationPickUpLatitude = "location_pick_up_latitude"
        case locationPickUpLongitude = "location_pick_up_longitude"
    }
}

class ItemDetailCartPhotoResponse: Codable {
    
    let frontSide: String?
    let backSide: String?
    
    enum CodingKeys: String, CodingKey {
        case frontSide = "front_side"
        case backSide = "back_side"
    }
}
