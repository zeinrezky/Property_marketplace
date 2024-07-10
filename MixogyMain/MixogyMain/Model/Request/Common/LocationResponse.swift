//
//  LocationResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 25/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class LocationResponse: Codable {
    let id: Int
    let name: String
    let distance: Int
    let satuan: String
    let latitude: String
    let longitude: String
    let totalCustomerItems: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, distance, satuan, latitude, longitude
        case totalCustomerItems = "total_customer_items"
    }
}

