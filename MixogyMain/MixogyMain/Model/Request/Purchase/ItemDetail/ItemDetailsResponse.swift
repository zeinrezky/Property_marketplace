//
//  ItemDetailResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/07/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class ItemDetailsResponse: Codable {
    let customerItem: ItemDetailsCustomerItemResponse?
    
    enum CodingKeys: String, CodingKey {
        case customerItem = "customer_item"
    }
}

class ItemDetailsCustomerItemResponse: Codable {
    
    let id: Int
    let name: String?
    let seat: String?
    let date: String?
    let location: String?
    let type: String?
    let itemImage: String?
    let payloadPayment: ItemDetailsCustomerItemPayloadPaymentResponse?
    
    enum CodingKeys: String, CodingKey {
        case id, name, seat, date, location, type
        case itemImage = "item_image"
        case payloadPayment = "payload_payment"
    }
}

class ItemDetailsCustomerItemPayloadPaymentResponse: Codable {
    
    let grossAmount: String?
    
    enum CodingKeys: String, CodingKey {
        case grossAmount = "gross_amount"
    }
}
