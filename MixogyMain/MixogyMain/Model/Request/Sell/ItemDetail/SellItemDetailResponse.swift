//
//  SellItemDetailResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class SellItemDetailResponse: Codable {
    
    let item: SellItemDetailItemResponse
    let types: [SellItemDetailTypeResponse]
}

class SellItemDetailItemResponse: Codable {
    
    let id: Int
    let name: String
    let place: String
    let date: String
    let time: String
    let originalPrice: Int
    let youWillReceive: Int?
    let adminFee: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, place, date, time
        case originalPrice = "original_price"
        case youWillReceive = "you_will_receive"
        case adminFee = "admin_fee"
    }
}

class SellItemDetailTypeResponse: Codable {
    
    let id: Int
    let name: String
}
