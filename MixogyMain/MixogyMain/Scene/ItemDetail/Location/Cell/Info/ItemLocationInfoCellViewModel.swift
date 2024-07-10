//
//  ItemLocationInfoCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class ItemLocationInfoCellViewModel {

    let location: String
    let count: String
    var selected = false
    var index = 0
    
    init(location: String, count: String, index: Int) {
        self.location = location
        self.count = count
        self.index = index
    }
}
