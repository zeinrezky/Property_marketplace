//
//  PromoDetailResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 02/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class PromoDetailResponse: Codable {
    
    let id: Int
    let itemId: Int?
    let name: String
    let mainImageURL: String?
    let placeName: String?
    let latitude: String
    let longitude: String
    let website: String?
    let photos: [PromoDetailMediaResponse]
    let videos: [PromoDetailVideoResponse]
    let sectionTop: [PromoDetailSectionResponse]
    let sectionBottom: [PromoDetailSectionResponse]
    let available: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude, website, photos, videos, available
        case itemId = "item_id"
        case placeName = "place_name"
        case mainImageURL = "main_image"
        case sectionTop = "section_top"
        case sectionBottom = "section_bottom"
    }
}

class PromoDetailMediaResponse: Codable {
    let id: Int
    let name: String
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case url = "photo_url"
    }
}

class PromoDetailVideoResponse: Codable {
    let id: Int
    let name: String
    let url: String?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id, thumbnail, name
        case url = "video_url"
    }
}

class PromoDetailSectionResponse: Codable {
    let id: Int
    let title: String?
    let text: String?
}
