//
//  Data.swift
//  MixogyAgent
//
//  Created by ABDUL AZIS H on 08/09/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}


