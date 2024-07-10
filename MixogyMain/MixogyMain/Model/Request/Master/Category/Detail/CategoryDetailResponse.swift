//
//  CategoryDetailResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 25/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class CategoryDetailResponse: Codable {
    let id: Int
    let name: String
    let active: Bool
    let count: Int
    let levelId: Int
    let levelName: String
    let gracePeriodType: String
    let gracePeriodValue: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, active, count
        case levelId = "level_id"
        case levelName = "level_name"
        case gracePeriodType = "grace_period_type"
        case gracePeriodValue = "grace_period_value"
    }
}
