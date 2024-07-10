//
//  CancelReasonCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 25/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class CancelReasonCellViewModel {
    
    let id: Int
    let title: String
    var selected = false
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
