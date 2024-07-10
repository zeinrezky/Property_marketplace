//
//  AgentDetailResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 18/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class AgentDetailResponse: Codable {
    let id: Int
    let code: String
    let name: String
    let email: String
    let ktpNumber: String
    let phoneNumber: String
    let bank: String
    let bankNumber: String
    let placeOfBirth: String
    let dateOfBirth: String
    let province: String
    let address: String
    let locationId: Int
    let location: String
    let locationLatitude: String
    let locationLongitude: String
    let locationPickUp: String
    let locationPickUpLatitude: String
    let locationPickUpLongitude: String
    let locationPickUpDetail: String?
    let ktpImageUrl: String
    let statusId: Int
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, address, status, code, bank, province, location, email
        case statusId = "status_id"
        case ktpImageUrl = "ktp_image_url"
        case ktpNumber = "ktp_number"
        case phoneNumber = "phone_number"
        case bankNumber = "bank_number"
        case placeOfBirth = "place_of_birth"
        case dateOfBirth = "date_of_birth"
        case locationId = "location_id"
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case locationPickUp = "location_pick_up"
        case locationPickUpLatitude = "location_pick_up_latitude"
        case locationPickUpLongitude = "location_pick_up_longitude"
        case locationPickUpDetail = "location_pick_up_detail"
    }
}
