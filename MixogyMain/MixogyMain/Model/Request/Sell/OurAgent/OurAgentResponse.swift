//
//  OurAgentResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class OurAgentResponse: Codable {
    
    let id: Int
    let code: String?
    let locationPickUp: String
    let locationPickUpLatitude: String
    let locationPickUpLongitude: String
    let ktpImage: String
    let distance: Int
    let name: String
    let phoneNumber: String
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case id, code, distance, name, address
        case ktpImage = "photo_url"
        case locationPickUp = "location_pick_up"
        case locationPickUpLatitude = "location_pick_up_latitude"
        case locationPickUpLongitude = "location_pick_up_longitude"
        case phoneNumber = "phone_number"
    }
}
