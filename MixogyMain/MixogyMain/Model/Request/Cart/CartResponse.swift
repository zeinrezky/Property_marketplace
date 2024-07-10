//
//  CartResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 09/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class CartResponse: Codable {
    
    let customerItems: [CartCustomerItemResponse]
    let collectionMethods: [CartCollectionMethodResponse]
    
    enum CodingKeys: String, CodingKey {
        case customerItems = "customer_items"
        case collectionMethods = "collection_methods"
    }
}

class CartCollectionMethodResponse: Codable {
    let id: Int
    let name: String
}

class CartCustomerItemResponse: Codable {
    
    let name: String
    let customerItemId: Int
    let originalPrice: Int
    let sellerPrice: Int
    let photoURL: String
    let transactionFee: Int
    let collectionMethods: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case sellerPrice = "seller_price"
        case customerItemId = "customer_item_id"
        case photoURL = "photo_url"
        case originalPrice = "original_price"
        case transactionFee = "transaction_fee"
        case collectionMethods = "collection_methods"
    }
}
