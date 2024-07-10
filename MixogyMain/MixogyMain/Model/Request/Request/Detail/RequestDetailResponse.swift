//
//  RequestDetailResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 13/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class RequestDetailResponse: Codable {
    let id: Int
    let buyer: String
    let from: String?
    let to: String?
    let fromAgentId: Int?
    let fromAgentCode: String?
    let fromAgentName: String?
    let fromAgentBackground: [RequestDetailAgentBackground]
    let fromAgentProfileImage: String?
    let fromLocation: String?
    let fromAgentRating: Int?
    let fromLocationLongitude: String?
    let fromLocationLatitude: String?
    let toAgentId: Int?
    let toAgentCode: String?
    let toAgentName: String?
    let toLocation: String?
    let toAgentBackground: [RequestDetailAgentBackground]
    let toAgentProfileImage: String?
    let toAgentRating: Int?
    let toLocationLongitude: String?
    let toLocationLatitude: String?
    let location: String?
    let itemCode: String
    let itemName: String
    let itemDescription: String
    let itemType: String
    let itemSeat: String
    let itemDate: String
    let itemMainPhoto: String
    let status: String
    let itemExpiryDate: String
    let photo: RequestDetailPhotpResponse
    
    enum CodingKeys: String, CodingKey {
        case id, buyer, from, to, location, photo, status
        case fromAgentId = "from_agent_id"
        case fromAgentCode = "from_agent_code"
        case fromAgentName = "from_agent_name"
        case fromAgentBackground = "from_agent_background"
        case fromAgentProfileImage = "from_agent_profile_image"
        case fromLocation = "from_location"
        case fromLocationLongitude = "from_location_longitude"
        case fromLocationLatitude = "from_location_latitude"
        case fromAgentRating = "from_agent_rating"
        case toAgentId = "to_agent_id"
        case toAgentCode = "to_agent_code"
        case toAgentName = "to_agent_name"
        case toAgentBackground = "to_agent_background"
        case toAgentProfileImage = "to_agent_profile_image"
        case toLocation = "to_location"
        case toAgentRating = "to_agent_rating"
        case toLocationLongitude = "to_location_longitude"
        case toLocationLatitude = "to_location_latitude"
        case itemCode = "item_code"
        case itemName = "item_name"
        case itemType = "item_type"
        case itemDescription = "item_description"
        case itemSeat = "item_seat"
        case itemDate = "item_date"
        case itemMainPhoto = "item_main_photo"
        case itemExpiryDate = "item_expiry_date"
    }
}

class RequestDetailPhotpResponse: Codable {
    
    let frontSide: String
    let backSide: String
    
    enum CodingKeys: String, CodingKey {
        case frontSide = "front_side"
        case backSide = "back_side"
    }
}

class RequestDetailAgentBackground: Codable {
    
    let id: Int
    let photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case photoUrl = "photo_url"
    }
}
