//
//  CartUtil.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class CartUtil: NSObject {

    static func isExist(id: Int) -> Bool {
        var isExist = false
        
        if let cart = Preference.cart,
        cart.customerItems.map({ (customerItem) -> Int in
            return customerItem.customerItemId
        }).contains(id) {
            isExist = true
        }
        
        return isExist
    }
}
