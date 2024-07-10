//
//  HomePromoResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 03/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class HomePromoResponse: Codable {
    let id: Int
    let itemId: Int
    let name: String
    let photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case photoUrl = "photo_url"
        case itemId = "item_id"
    }
}
