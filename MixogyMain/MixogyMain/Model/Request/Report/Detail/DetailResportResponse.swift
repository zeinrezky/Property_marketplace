//
//  DetailResportResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 07/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class DetailResportResponse: Codable {

    let id: Int
    let itemCode: String?
    let description: String
    let solution: String
    let phoneNumber: String?
    let status: String
    let caseId: String
    
    enum CodingKeys: String, CodingKey {
        case id, description, solution, status
        case phoneNumber = "phone_number"
        case itemCode = "item_code"
        case caseId = "case_id"
    }
}
