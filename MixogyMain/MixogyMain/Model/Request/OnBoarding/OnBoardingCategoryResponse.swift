//
//  OnBoardingCategoryResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class OnBoardingCategoryResponse: Codable {
    let id: Int
    let name: String
    let backgroundURL: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case backgroundURL = "background_url"
    }
}
