//
//  BatchPickupCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 23/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class BatchPickupCellViewModel {
    
    let id: Int
    let title: String
    let distance: String
    
    init(id: Int, title: String, distance: String) {
        self.id = id
        self.title = title
        self.distance = distance
    }
}
