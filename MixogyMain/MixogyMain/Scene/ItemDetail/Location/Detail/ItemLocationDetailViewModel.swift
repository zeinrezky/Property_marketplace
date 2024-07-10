//
//  ItemLocationDetailViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class ItemLocationDetailViewModel {
    
    enum ItemLocationDataType {
        case header(ItemLocationDetailHeaderCellViewModel)
        case info([ItemLocationDetailInfoCellViewModel])
    }
    
    var sourceData = BehaviorRelay<ItemLocationCollectionDateResponse?>(value: nil)
    var data = BehaviorRelay<[ItemLocationDataType]>(value: [])
    
    func setup() {
        guard let sourceData = sourceData.value else {
            return
        }
        
        let header = ItemLocationDetailHeaderCellViewModel(title: sourceData.date)
        var rows = [ItemLocationDataType]()
        rows.append(.header(header))
        
        let count = sourceData.times.count % 2 == 0 ? sourceData.times.count : sourceData.times.count + 1
        
        for i in 0..<count/2 {
            var times = [ItemLocationDetailInfoCellViewModel]()
            let time1 = sourceData.times[(i*2) + 0]
            times.append(ItemLocationDetailInfoCellViewModel(
                time: time1.time,
                count: "\(time1.count)",
                id: sourceData.times[(i*2) + 0].types.first?.itemId ?? 0
            ))
            
            if sourceData.times.count > ((i*2) + 1) {
                let time2 = sourceData.times[(i*2) + 1]
                times.append(ItemLocationDetailInfoCellViewModel(
                    time: time2.time,
                    count: "\(time2.count)",
                    id: sourceData.times[(i*2) + 1].types.first?.itemId ?? 0
                ))
            }
            
            rows.append(.info(times))
        }
        
        data.accept(rows)
    }
}
