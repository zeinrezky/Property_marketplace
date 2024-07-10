//
//  PurchaseHistoryViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 30/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class PurchaseHistoryViewModel {
    
    var data = BehaviorRelay<[PurchaseHistoryCellViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var id: Int?
    
    func fetchData() {
        let request = PurchaseHistoryRequest()

        isLoading.accept(true)
        PurchaseOperation.history(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data.map {(purchase) -> PurchaseHistoryCellViewModel in
                    return PurchaseHistoryCellViewModel(
                        id: purchase.transactionDetailId,
                        title: purchase.name,
                        photoURL: purchase.photoURL,
                        location: purchase.location,
                        date: purchase.date,
                        status: purchase.status
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
