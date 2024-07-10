//
//  SellCreatePaymentMethodViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/04/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class SellCreatePaymentMethodViewModel {
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var data = BehaviorRelay<[SellCollectionMethodCellViewModel]>(value: [])
    var selectedData: (Int, String)?
    
    func fetchData() {
        let request = SellPaymentMethodRequest()

        self.isLoading.accept(true)
        SellOperation.paymentMethod(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data.map {(collectionMethod) -> SellCollectionMethodCellViewModel in
                    
                    return SellCollectionMethodCellViewModel(
                        id: collectionMethod.id,
                        name: collectionMethod.name,
                        status: collectionMethod.status
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
