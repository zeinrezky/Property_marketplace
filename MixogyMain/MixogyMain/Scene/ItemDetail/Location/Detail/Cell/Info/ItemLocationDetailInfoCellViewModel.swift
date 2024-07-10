//
//  ItemLocationDetailInfoCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class ItemLocationDetailInfoCellViewModel {

    let time: String
    let count: String
    let id: Int
    
    init(time: String, count: String, id: Int) {
        self.time = time
        self.count = count
        self.id = id
    }
}
