//
//  SellHistoryResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class SellHistoryResponse: Codable {

    let id: Int
    let name: String
    let photoURL: String
    let statusId: Int
    let status: String
    let location: String
    let date: String
    let price: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, price, location, date
        case photoURL = "photo_url"
        case statusId = "status_id"
    }
}
