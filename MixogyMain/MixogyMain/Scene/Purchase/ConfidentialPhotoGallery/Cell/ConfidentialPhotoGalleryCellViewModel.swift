//
//  ConfidentialPhotoGalleryCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 30/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//
class ConfidentialPhotoGalleryCellViewModel {
    
    let id: Int
    let photo: String?
    
    init(id: Int, photo: String) {
        self.id = id
        self.photo = photo
    }
}
