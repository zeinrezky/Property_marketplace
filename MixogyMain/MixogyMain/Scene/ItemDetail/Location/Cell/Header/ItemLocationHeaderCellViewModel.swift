//
//  ItemLocationHeaderCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class ItemLocationHeaderCellViewModel {

    let photoURL: String?
    let name: String
    let category: String
    
    init(photoURL: String?, name: String, category: String) {
        self.photoURL = photoURL
        self.name = name
        self.category = category
    }
}
