//
//  InvoiceListPendingCellViewModel.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 09/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class InvoiceListPendingCellViewModel {

    let id: Int
    let date: String
    let amount: String
    
    init(id: Int, date: String, amount: String) {
        self.id = id
        self.date = date
        self.amount = amount
    }
}
