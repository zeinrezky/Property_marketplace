//
//  CheckoutDetailResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 28/03/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import Foundation

class CheckoutDetailResponse: Codable {
    
    let paymentMethods: [CheckoutDetailPaymentMethodResponse]
    
    enum CodingKeys: String, CodingKey {
        case paymentMethods = "payment_methods"
    }
}

class CheckoutDetailPaymentMethodResponse: Codable {
    
    let code: String
    let name: String
    let vendor: String
}
