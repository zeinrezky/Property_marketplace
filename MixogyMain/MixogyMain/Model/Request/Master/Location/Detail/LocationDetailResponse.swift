//
//  LocationDetailResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 26/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class LocationDetailResponse: Codable {
    let id: Int
    let name: String
    let latitude: String
    let longitude: String
    let start: String
    let until: String
    let placeName: String?
    let photos: [LocationPhotoResponse]
    
    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude, start, until, photos
        case placeName = "place_name"
    }
}

class LocationPhotoResponse: Codable {
    let id: Int
    let photo: String
    let locationId: Int
    let urlPhoto: String
    
    enum CodingKeys: String, CodingKey {
        case id, photo
        case locationId = "location_id"
        case urlPhoto = "photo_url"
    }
}
