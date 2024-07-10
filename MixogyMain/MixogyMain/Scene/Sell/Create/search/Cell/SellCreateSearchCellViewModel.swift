//
//  SellCreateSearchCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

class SellCreateSearchCellViewModel {
    
    let name: String
    let category: String
    let photo: String?
    
    init(
        name: String,
        category: String,
        photo: String) {
            self.name = name
            self.category = category
            self.photo = photo
    }
}
