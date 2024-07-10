//
//  CollectionMethodResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 10/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import Foundation

struct CollectionMethodResponse: Codable {
    let code: String
    let id: Int
    let name: String
    let description: String
    let status: Int
}
