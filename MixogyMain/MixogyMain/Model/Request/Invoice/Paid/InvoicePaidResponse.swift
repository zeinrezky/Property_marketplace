//
//  InvoiceGeneratedResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 09/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class InvoicePaidResponse: Codable {
    let invoices: [InvoicePaidInvoicesResponse]?
    let totalPaid: Int
    
    enum CodingKeys: String, CodingKey {
        case invoices
        case totalPaid = "total_paid"
    }
}

class InvoicePaidInvoicesResponse: Codable {
    let id: Int
    let code: String
    let amount: Int
    let createdAt: String
    let photoEvidence: String?
    let categories: [InvoicePaidCategoryResponse]?
    let customerItems: [InvoicePaidItemResponse]?
    let agentItems: [InvoicePaidItemResponse]?
        
    enum CodingKeys: String, CodingKey {
        case id, code, amount, categories
        case createdAt = "created_at"
        case customerItems = "customer_items"
        case agentItems = "agent_items"
        case photoEvidence = "photo_evidence"
    }
}

class InvoicePaidCategoryResponse: Codable {
    let id: Int
    let name: String
    let count: Int
}

class InvoicePaidItemResponse: Codable {
    let id: Int
    let name: String
    let amount: Int
    let commision: Int?
}
