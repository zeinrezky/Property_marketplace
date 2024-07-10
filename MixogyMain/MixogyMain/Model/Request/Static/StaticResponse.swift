//
//  StaticResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/07/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class StaticResponse: Codable {
    
    let termAndConditionRegister: String?
    let termAndConditionSellList: String?
    let gracePeriod: String?
    let haveQuestion: String?
    let contactUsPhoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case termAndConditionRegister = "term_and_condition_register"
        case termAndConditionSellList = "term_and_condition_sell_list"
        case gracePeriod = "grace_period"
        case haveQuestion = "have_question"
        case contactUsPhoneNumber = "contact_us_phone_number"
    }
}
