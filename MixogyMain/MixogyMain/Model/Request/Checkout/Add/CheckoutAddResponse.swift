//
//  CheckoutAddResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 29/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class CheckoutAddResponse: Codable {
    
    let transactionId: Int
    let orderId: String
    
    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case orderId = "order_id"
    }
}
