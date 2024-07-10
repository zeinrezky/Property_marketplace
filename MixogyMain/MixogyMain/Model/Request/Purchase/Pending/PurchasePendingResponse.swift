//
//  PurchasePendingResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class PurchasePendingResponse: Codable {
    
    let id: Int
    let orderId: String
    let total: Int
    let itemDetails: [PurchasePendingItemResponse]
    let payloadPayment: PurchasePendingPayloadPaymentResponse?
    
    enum CodingKeys: String, CodingKey {
        case id, total
        case orderId = "order_id"
        case itemDetails = "item_details"
        case payloadPayment = "payload_payment"
    }
}

class PurchasePendingItemResponse: Codable {
    
    let customerItemId: Int
    let itemId: Int
    let name: String
    let amount: Int
    let location: String
    let date: String
    let seat: String?
    let description: String?
    let category: String
    let photoUrl: String
    let status: String
    let duration: String

    enum CodingKeys: String, CodingKey {
        case name, amount, location, seat, category, status, duration, date, description
        case customerItemId = "customer_item_id"
        case itemId = "item_id"
        case photoUrl = "photo_url"
    }
}

class PurchasePendingPayloadPaymentActionResponse: Codable {
    
    let method: String
    let name: String
    let url: String
}

class PurchasePendingPayloadPaymentResponse: Codable {

    let statusCode: String
    let statusMessage: String
    let transactionId: String
    let orderId: String
    let merchantId: String
    let grossAmount: String
    let currency: String
    let paymentType: String
    let transactionTime: String
    let transactionStatus: String
    let vaNumbers: [PurchasePendingPayloadPaymentVaNumberResponse]?
    let fraudStatus: String
    let actions: [PurchasePendingPayloadPaymentActionResponse]?
    
    enum CodingKeys: String, CodingKey {
        case currency, actions
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case transactionId = "transaction_id"
        case orderId = "order_id"
        case merchantId = "merchant_id"
        case grossAmount = "gross_amount"
        case paymentType = "payment_type"
        case transactionTime = "transaction_time"
        case transactionStatus = "transaction_status"
        case vaNumbers = "va_numbers"
        case fraudStatus = "fraud_status"
    }
}

class PurchasePendingPayloadPaymentVaNumberResponse: Codable {
    
    let bank: String
    let vaNumber: String
    
    enum CodingKeys: String, CodingKey {
        case bank
        case vaNumber = "va_number"
    }
}
