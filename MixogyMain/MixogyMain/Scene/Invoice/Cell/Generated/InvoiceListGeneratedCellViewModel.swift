//
//  InvoiceListGeneratedCellViewModel.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 09/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class InvoiceListGeneratedCellViewModel {

    let id: Int
    let date: String
    let amount: String
    let bank: String
    let categories: String?
    
    init(id: Int, date: String, amount: String, bank: String, categories: String?) {
        self.id = id
        self.date = date
        self.amount = amount
        self.bank = bank
        self.categories = categories
    }
}
