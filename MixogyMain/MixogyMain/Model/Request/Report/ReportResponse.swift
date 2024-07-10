//
//  ReportResponse.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 06/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class ReportResponse: Codable {
    let id: Int
    let itemCode: String?
    let status: String
    let createdAt: String
    let phoneNumber: String?
    let caseId: String
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case caseId = "case_id"
        case itemCode = "item_code"
        case createdAt = "created_at"
        case phoneNumber = "phone_number"
    }
}
