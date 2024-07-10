//
//  Constants.swift
//  Mixogy
//
//  Created by ABDUL AZIS H on 14/12/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import Foundation

class Constants {
    static let FailedNetworkingMessage = "Something went wrong".localized()
    static let Endpoint = Bundle.main.infoDictionary?["API_END_POINT_URL"] as? String ?? ""
    static let GoogleAPIKey = Bundle.main.infoDictionary?["GOOGLE_API_KEY"] as? String ?? ""
    static let CartCountKey = "CartCountKey"
    static let ItemTypeKey = "ItemTypeKey"
    static let CartHideShowKey = "CartHideShowKey"
    static let ChangeLanguageKey = "ChangeLanguageKey"
}
