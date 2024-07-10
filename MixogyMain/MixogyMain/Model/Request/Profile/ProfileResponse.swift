//
//  ProfileRespoonse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 22/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class ProfileResponse: Codable {
    
    let userId: Int
    let customerId: Int
    let name: String
    let photoURL: String
    let codePhone: String
    let phoneNumber: String
    let nearbyRadius: Int
    let address: [ProfileAddressRespoonse]
    let isSeller: Bool
    let roleId: Int
    let paymentReceive: ProfilePaymentReceiveRespoonse?
    
    enum CodingKeys: String, CodingKey {
        case name, address
        case photoURL = "photo_url"
        case userId = "user_id"
        case customerId = "customer_id"
        case codePhone = "code_phone"
        case phoneNumber = "phone_number"
        case nearbyRadius = "nearby_radius"
        case isSeller = "is_seller"
        case paymentReceive = "payment_receive"
        case roleId = "role_id"
    }
}

class ProfileAddressRespoonse: Codable {
    
    let id: Int
    let placeName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeName = "code"
    }
}

class ProfilePaymentReceiveRespoonse: Codable {
    
    let amount: Int?
    let date: String?
}
