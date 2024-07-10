//
//  CheckoutPayResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 29/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class CheckoutPayResponse: Codable {
    
    let statusCode: String?
    let actions: [CheckoutPayGopayResponse]?
    let vaNumbers: [CheckoutPayVaResponse]?
    let amount: Int?
    let businessId: String?
    let created: String?
    let ewalletType: String?
    let externalId: String?
    let paymentType: String?
    let phone: String?
    let status: String?
    let transactionTime: String?
    
    enum CodingKeys: String, CodingKey {
        case actions, amount, created, phone, status
        case statusCode = "status_code"
        case vaNumbers = "va_numbers"
        case businessId = "business_id"
        case ewalletType = "ewallet_type"
        case externalId = "external_id"
        case paymentType = "payment_type"
        case transactionTime = "transaction_time"
    }
}

class CheckoutPayVaResponse: Codable {
    let bank: String
    let vaNumber: String
    
    enum CodingKeys: String, CodingKey {
        case bank
        case vaNumber = "va_number"
    }
}

class CheckoutPayGopayResponse: Codable {
    
    let name: String
    let method: String
    let url: String
}
