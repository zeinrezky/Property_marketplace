//
//  CategoryResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 24/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class CategoryResponse: Codable {
    let id: Int
    let name: String
    let active: Bool
    let count: Int
    let levelId: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, active, count
        case levelId = "level_id"
    }
}
