//
//  PurchaseHistoryCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 30/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class PurchaseHistoryCellViewModel {

    let id: Int
    let title: String
    let photoURL: String?
    let location: String
    let date: String
    let status: String
    
    init(
        id: Int,
        title: String,
        photoURL: String?,
        location: String,
        date: String,
        status: String) {
            self.id = id
            self.title = title
            self.photoURL = photoURL
            self.location = location
            self.date = date
            self.status = status
    }
}
