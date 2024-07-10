//
//  LocationPhotoCellViewModel.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 26/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class LocationPhotoCellViewModel {

    let id: Int
    let url: String
    let image: String
        
    init(id: Int, url: String, image: String) {
        self.id = id
        self.url = url
        self.image = image
    }
}
