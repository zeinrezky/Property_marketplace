//
//  OurAgentCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class OurAgentCellViewModel {
    
    let id: Int
    let name: String
    let photoURL: String?
    let address: String
    let locationPickUp: String?
    let distance: String
    let phone: String
    let latitude: String
    let longitude: String
    
    init(
        id: Int,
        name: String,
        photoURL: String?,
        address: String,
        distance: String,
        phone: String,
        latitude: String,
        longitude: String,
        locationPickUp: String) {
            self.id = id
            self.name = name
            self.photoURL = photoURL
            self.address = address
            self.distance = distance
            self.phone = phone
            self.latitude = latitude
            self.longitude = longitude
            self.locationPickUp = locationPickUp
    }
}
