//
//  CartAddressDetailResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 28/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class CartAddressDetailResponse: Codable {
    
    let id: Int
    let code: String
    let phone: String
    let longitude: String
    let latitude: String
    let placeName: String
    let detail: String
    let cityId: Int
    let customerId: Int
    let cityName: String
    let provinceName: String
    let city: CartAddressDetailCityResponse
    
    enum CodingKeys: String, CodingKey {
        case id, code, phone, longitude, latitude, city, detail
        case placeName = "place_name"
        case cityId = "city_id"
        case customerId = "customer_id"
        case cityName = "city_name"
        case provinceName = "province_name"
    }
}

class CartAddressDetailCityResponse: Codable {
    
    let id: Int
    let provinceId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case provinceId = "province_id"
    }
}
