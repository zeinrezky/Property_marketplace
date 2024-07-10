//
//  InvoiceListPaidMainCellViewModel.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 09/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class InvoiceListPaidMainCellViewModel {
    let id: Int
    let date: String
    let amount: String
    let voucherCode: String
    let itemList: String
    var selected = false
    
    init(id: Int, date: String, amount: String, voucherCode: String, itemList: String, selected: Bool = false) {
        self.id = id
        self.date = date
        self.amount = amount
        self.voucherCode = voucherCode
        self.itemList = itemList
        self.selected = selected
    }
}
