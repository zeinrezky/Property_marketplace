//
//  PurchaseCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class PurchaseCellViewModel {
    
    let id: Int
    let title: String
    let photoURL: String?
    let location: String
    let gracePeriod: String
    let date: String
    let status: String
    let statusId: Int
    
    init(
        id: Int,
        title: String,
        photoURL: String?,
        location: String,
        gracePeriod: String,
        date: String,
        status: String,
        statusId: Int) {
            self.id = id
            self.title = title
            self.photoURL = photoURL
            self.location = location
            self.gracePeriod = gracePeriod
            self.date = date
            self.status = status
            self.statusId = statusId
    }
}
