//
//  PromoAddPhotoResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 02/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class PromoAddPhotoResponse: Codable {
    let id: Int
    let url: String
    let imageName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageName = "image_name"
        case url = "photo_url"
    }
}
