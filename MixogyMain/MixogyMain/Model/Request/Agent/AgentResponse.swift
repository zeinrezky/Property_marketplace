//
//  AgentResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 17/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class AgentResponse: Codable {
    let id: Int
    let name: String
    let location: String
    let status: String
    let code: String
    let createdAt: String
    let locationLongitude: String
    let locationLatitude: String
    let statusId: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, location, status, code
        case createdAt = "created_at"
        case statusId = "status_id"
        case locationLongitude = "location_longitude"
        case locationLatitude = "location_latitude"
    }}
