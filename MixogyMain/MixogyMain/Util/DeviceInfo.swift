//
//  DeviceInfo.swift
//  Mixogy
//
//  Created by ABDUL AZIS H on 12/12/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import UIKit

class DeviceInfo {
    static let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
}
