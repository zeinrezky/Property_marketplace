//
//  SellPaymentMethodResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/04/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import Foundation

class SellPaymentMethodResponse: Codable {
    let id: Int
    let code: String
    let name: String
    let status: Int
    let description: String?
}
