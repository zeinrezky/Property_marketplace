//
//  AgentDeactiveDetailResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 21/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class AgentDeactiveDetailResponse: Codable {
    let expiryDate: String?
    let totalItems: Int
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case totalItems = "total_items"
        case expiryDate = "expiry_date"
    }
}
