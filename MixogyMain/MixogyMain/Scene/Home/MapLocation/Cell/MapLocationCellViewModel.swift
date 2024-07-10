//
//  MapLocationCellViewModel.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 20/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class MapLocationCellViewModel {
    let id: Int
    let title: String
    let distance: String
    let latitude: String
    let longitude: String
    let count: String
        
    init(id: Int, title: String, distance: String, lattitude: String, longitude: String, count: String) {
        self.id = id
        self.title = title
        self.distance = distance
        self.latitude = lattitude
        self.longitude = longitude
        self.count = count
    }
}
