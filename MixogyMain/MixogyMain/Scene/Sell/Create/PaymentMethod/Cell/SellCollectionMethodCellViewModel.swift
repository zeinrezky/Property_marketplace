//
//  SellCollectionMethodCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/04/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import UIKit

class SellCollectionMethodCellViewModel {
    
    let id: Int
    let name: String
    let status: Int
        
    init(id: Int, name: String, status: Int) {
        self.id = id
        self.name = name
        self.status = status
    }
}
