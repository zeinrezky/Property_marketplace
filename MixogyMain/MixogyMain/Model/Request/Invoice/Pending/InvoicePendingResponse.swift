//
//  InvoicePendingResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 04/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class InvoicePendingResponse: Codable {
    let totalPending: Int
    let bankNumber: String
    let items: [InvoicePendingItem]?
    
    enum CodingKeys: String, CodingKey {
        case items
        case totalPending = "total_pending"
        case bankNumber = "bank_number"
    }
}

class InvoicePendingItem: Codable {
    let id: Int
    let date: String
    let amount: Int
}
