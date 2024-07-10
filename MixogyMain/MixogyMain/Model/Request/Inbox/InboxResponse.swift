//
//  InboxResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 03/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class InboxResponse: Codable {
    let id: Int
    let title: String
    let description: String
    let color: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, color
        case createdAt = "created_at"
    }
}
