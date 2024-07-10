//
//  SellCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class SellCellViewModel {
    
    let id: Int
    let title: String
    let status: String
    let statusId: Int
    let amount: Int
    let photo: String?
    let color: String
    
    init(
        id: Int,
        title: String,
        photo: String?,
        status: String,
        statusId: Int,
        amount: Int,
        color: String) {
            self.id = id
            self.title = title
            self.status = status
            self.statusId = statusId
            self.amount = amount
            self.color = color
            self.photo = photo
    }
}
