//
//  ItemDetailsCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/07/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class ItemDetailsCellViewModel {
    
    let id: Int
    let title: String
    let photoURL: String?
    let location: String
    let date: String
    let seat: String
    let price: String
    
    init(
        id: Int,
        title: String,
        photoURL: String?,
        location: String,
        date: String,
        seat: String,
        price: String) {
            self.id = id
            self.title = title
            self.photoURL = photoURL
            self.location = location
            self.date = date
            self.seat = seat
            self.price = price
    }
}
