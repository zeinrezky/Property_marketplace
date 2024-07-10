//
//  SellCreateFilterResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 11/09/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class SellCreateFilterResponse: Codable {
    let categoryId: Int
    let levelId: Int
    let name: String
    let photoURL: String
    let categoryName: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case levelId = "level_id"
        case categoryId = "category_id"
        case photoURL = "photo_url"
        case categoryName = "category_name"
    }
}
