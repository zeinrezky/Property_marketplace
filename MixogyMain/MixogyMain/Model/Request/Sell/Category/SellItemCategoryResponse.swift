//
//  SellItemCategoryResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class SellItemCategoryResponse: Codable {

    let id: Int
    let name: String
    let levelId: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case levelId = "level_id"
    }
}
