//
//  InvoiceGeneratedResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 09/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class InvoiceGeneratedResponse: Codable {
    let totalGenerated: Int
    let generated: [InvoiceGeneratedItem]?
    
    enum CodingKeys: String, CodingKey {
        case generated
        case totalGenerated = "total_generated"
    }
}

class InvoiceGeneratedItem: Codable {
    let id: Int
    let date: String
    let amount: Int
    let bankNumber: String
    let categories: [InvoiceGeneratedCategory]?
    
    enum CodingKeys: String, CodingKey {
        case id, date, amount, categories
        case bankNumber = "bank_number"
    }
}

class InvoiceGeneratedCategory: Codable {
    let id: Int
    let name: String
    let count: Int
}
