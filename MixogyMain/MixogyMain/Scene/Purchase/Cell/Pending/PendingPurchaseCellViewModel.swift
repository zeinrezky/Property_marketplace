//
//  PendingPurchaseCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 24/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class PendingPurchaseCellViewModel {

    let id: Int
    let title: String
    let category: String
    let duration: String
    let status: String
    let orderId: String
    let amount: Int
    let vaNumber: String?
    let cover: String?
    let detail: String?
    let isGopay: Bool
    let gopayQR: String?
    let gopayURL: String?
    
    init(
        id: Int,
        title: String,
        category: String,
        duration: String,
        status: String,
        orderId: String,
        amount: Int,
        vaNumber: String?,
        cover: String?,
        detail: String?,
        isGopay: Bool,
        gopayQR: String?,
        gopayURL: String?) {
            self.id = id
            self.title = title
            self.category = category
            self.duration = duration
            self.status = status
            self.orderId = orderId
            self.amount = amount
            self.vaNumber = vaNumber
            self.cover = cover
            self.detail = detail
            self.isGopay = isGopay
            self.gopayQR = gopayQR
            self.gopayURL = gopayURL
    }
}
