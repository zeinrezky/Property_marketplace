//
//  HomeCategoryCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class HomeCategoryCellViewModel {
    let id: Int
    let categoryId: Int
    let typeId: Int
    let name: String
    let count: String
    let category: String
    let type: String
    let originalPrice: String
    let lowestPrice: String
    let photo: String?
    let color: String
    let levelId: Int
        
    init(
        id: Int,
        categoryId: Int,
        typeId: Int,
        name: String,
        count: String,
        category: String,
        type: String,
        originalPrice: String,
        lowestPrice: String,
        photo: String,
        color: String,
        levelId: Int) {
        self.id = id
        self.categoryId = categoryId
        self.typeId = typeId
        self.name = name
        self.count = count
        self.category = category
        self.type = type
        self.originalPrice = originalPrice
        self.lowestPrice = lowestPrice
        self.photo = photo
        self.color = color
        self.levelId = levelId
    }
}
