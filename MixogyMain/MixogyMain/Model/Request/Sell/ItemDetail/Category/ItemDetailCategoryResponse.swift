//
//  ItemDetailCategoryResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class ItemDetailCategoryResponse: Codable {

    let name: String
    let itemTypeId: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case itemTypeId = "item_type_id"
    }
}
