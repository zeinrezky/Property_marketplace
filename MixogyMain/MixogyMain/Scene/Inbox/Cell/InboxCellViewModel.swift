//
//  InboxCellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 31/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

class InboxCellViewModel {
    
    let id: Int
    let status: String
    let date: String
    let title: String
    let color: String
    
    init(id: Int, status: String, date: String, title: String, color: String) {
        self.id = id
        self.status = status
        self.date = date
        self.title = title
        self.color = color
    }
}
