//
//  CartAddressResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class CartAddressResponse: Codable {
    
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "place_name"
    }
}
