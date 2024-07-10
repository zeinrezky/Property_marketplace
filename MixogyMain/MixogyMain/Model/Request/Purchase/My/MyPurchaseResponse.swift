//
//  MyPurchaseResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class MyPurchaseResponse: Codable {
    
    let transactionDetailId: Int
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
    let statusId: Int
    let gracePeriod: MyPurchaseGracePeriodResponse
    
    enum CodingKeys: String, CodingKey {
        case name, amount, location, seat, category, status, description, date
        case transactionDetailId = "transaction_detail_id"
        case customerItemId = "customer_item_id"
        case itemId = "item_id"
        case photoUrl = "photo_url"
        case gracePeriod = "grace_period"
        case statusId = "status_id"
    }
}

class MyPurchaseGracePeriodResponse: Codable {
    
    let date: String
    let ended: Bool
}
