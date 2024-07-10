//
//  PurchaseHistoryResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 30/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class PurchaseHistoryResponse: Codable {
    
    let transactionDetailId: Int
    let customerItemIId: Int
    let itemId: Int
    let name: String
    let amount: Int
    let location: String
    let date: String
    let seat: String?
    let description: String?
    let category: String
    let photoURL: String?
    let statusId: Int
    let status: String
    let gracePeriod: PurchaseHistoryGracePeriodResponse
    
    enum CodingKeys: String, CodingKey {
        case name, amount, location, date, seat, description, category, status
        case transactionDetailId = "transaction_detail_id"
        case customerItemIId = "customer_item_id"
        case itemId = "item_id"
        case photoURL = "photo_url"
        case statusId = "status_id"
        case gracePeriod = "grace_period"
    }
}

class PurchaseHistoryGracePeriodResponse: Codable {
    
    let date: String?
    let ended: Bool
}
