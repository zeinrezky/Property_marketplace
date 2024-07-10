//
//  ItemLocationTimeCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class ItemLocationTimeCellViewModel {

    let date: String
    let count: String
    let source: ItemLocationCollectionDateResponse
    
    init(date: String, count: String, source: ItemLocationCollectionDateResponse) {
        self.date = date
        self.count = count
        self.source = source
    }
}
