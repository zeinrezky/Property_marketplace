//
//  PromoResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 01/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class PromoResponse: Codable {
    let id: Int
    let name: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "photo_url"
    }
}
