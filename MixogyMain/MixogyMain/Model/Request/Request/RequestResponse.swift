//
//  RequestResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 12/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class RequestResponse: Codable {
    let id: Int
    let buyer: String?
    let agent: String?
    let from: String?
    let to: String?
    let status: String
    let date: String?
}
