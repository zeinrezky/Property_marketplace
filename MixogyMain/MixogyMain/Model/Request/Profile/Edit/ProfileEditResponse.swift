//
//  ProfileEditResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 22/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class ProfileEditResponse: Codable {
    let photoURL: String
    
    enum CodingKeys: String, CodingKey {
        case photoURL = "photo_url"
    }
}
