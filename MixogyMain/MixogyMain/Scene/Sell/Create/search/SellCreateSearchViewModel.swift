//
//  SellCreateSearchViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class SellCreateSearchViewModel {

    var selectedCategoryData: SellItemCategoryResponse?
    var keywords = BehaviorRelay<String?>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var data = BehaviorRelay<[SellCreateSearchCellViewModel]>(value: [])
    var itemCategoryData: [SellCreateFilterResponse] = []
    
    func fetchItemCategory() {
        guard let keywords = keywords.value else {
            return
        }
        
        let request = SellCreateFilterRequest(id: 42, keywords: keywords)

        self.isLoading.accept(true)
        SellOperation.createFilter(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.itemCategoryData = data
                self.data.accept(data.map {(item) -> SellCreateSearchCellViewModel in
                    return SellCreateSearchCellViewModel(
                        name: item.name,
                        category: self.selectedCategoryData?.name ?? "",
                        photo: item.photoURL
                    )
                })

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
