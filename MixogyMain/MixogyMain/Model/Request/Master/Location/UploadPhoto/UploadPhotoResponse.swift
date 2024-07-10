//
//  UploadPhotoResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 26/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class UploadPhotoResponse: Codable {
    let id: Int
    let urlPhoto: String
    let imageName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageName = "image_name"
        case urlPhoto = "photo_url"
    }
}
