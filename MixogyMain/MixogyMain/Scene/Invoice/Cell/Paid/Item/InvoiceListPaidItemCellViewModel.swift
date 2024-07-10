//
//  InvoiceListPaidItemCellViewModel.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 09/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class InvoiceListPaidItemCellViewModel {
    let name: String
    let amount: String
    let fee: String?
    var selected = false
    
    init(name: String, amount: String, fee: String? = nil) {
        self.name = name
        self.amount = amount
        self.fee = fee
    }
}
