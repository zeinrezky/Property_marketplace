//
//  SellStatusResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class SellStatusResponse: Codable {
    
    let id: Int
    let name: String
    let photoURL: String
    let statusId: Int
    let status: String
    let price: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, price
        case photoURL = "photo_url"
        case statusId = "status_id"
    }
}
