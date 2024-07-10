//
//  ProfileInfoCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class ProfileInfoCellViewModel {
    
    let name: String
    let phone: String
    let cover: String
    
    init(name: String, phone: String, cover: String) {
        self.name = name
        self.phone = phone
        self.cover = cover
    }
}
