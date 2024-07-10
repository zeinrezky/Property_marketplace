//
//  ItemLocationViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 19/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class ItemLocationViewModel {

    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var data = BehaviorRelay<[ItemLocationDataType]>(value: [])
    var serverData = BehaviorRelay<ItemLocatonRsponse?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var cartCount = BehaviorRelay<String?>(value: nil)
    var id: Int?
    var levelId: Int?
    var typeId: Int?
    var name: String?
    
    enum ItemLocationDataType {
        case header(ItemLocationHeaderCellViewModel)
        case info(ItemLocationInfoCellViewModel)
        case time([ItemLocationTimeCellViewModel])
    }
    
    func fetchData() {
        guard let id = id,
            let typeId = typeId,
            let name = name else {
            return
        }
        
        let request = ItemLocationRequest(id: id, typeId: typeId, name: name)
        
        isLoading.accept(true)
        ItemOperation.location(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.serverData.accept(data)
                self.data.accept(self.constructData(data: data))
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                break
            }
        }
    }
    
    func selectData(index: Int) {
        guard let serverData = serverData.value else {
            return
        }
        
        self.data.accept(constructData(data: serverData, index: index))
    }
    
    func constructData(data: ItemLocatonRsponse, index: Int = 0) -> [ItemLocationDataType] {
        var builder = [ItemLocationDataType]()
        
        let header = ItemLocationHeaderCellViewModel(
            photoURL: data.photoURL,
            name: data.name,
            category: data.category
        )
        
        builder.append(.header(header))
        
        for i in 0..<data.collections.count {
            let collection = data.collections[i]
            
            let info = ItemLocationInfoCellViewModel(
                location: collection.place,
                count: "\(collection.count) " + "items".localized(),
                index: i
            )
            
            info.selected = i == index
            builder.append(.info(info))
            
            if let levelId = levelId, levelId == 4 {
                continue
            }
            
            if i == index {
                let count = collection.dates.count % 2 == 0 ? collection.dates.count : collection.dates.count + 1
                
                for i in 0..<count/2 {
                    var times = [ItemLocationTimeCellViewModel]()
                    let time1 = collection.dates[(i*2) + 0]
                    times.append(ItemLocationTimeCellViewModel(
                        date: time1.date,
                        count: "\(time1.count)",
                        source: collection.dates[(i*2) + 0]
                    ))
                    
                    if collection.dates.count > ((i*2) + 1) {
                        let time2 = collection.dates[(i*2) + 1]
                        times.append(ItemLocationTimeCellViewModel(
                            date: time2.date,
                            count: "\(time2.count)",
                            source: collection.dates[(i*2) + 1]
                        ))
                    }
                    
                    builder.append(.time(times))
                }
            }
        }
        
        return builder
    }
}
