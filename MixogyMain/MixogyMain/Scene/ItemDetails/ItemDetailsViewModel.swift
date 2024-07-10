//
//  ItemDetailsViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/07/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class ItemDetailsViewModel {
    
    var data = BehaviorRelay<[ItemDetailsCellViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var id: Int?
    
    func fetchData() {
        guard let id = id else {
            return
        }
        
        let request = ItemDetailsRequest(id: id)

        isLoading.accept(true)
        PurchaseOperation.itemDetail(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                let value = ItemDetailsCellViewModel(
                    id: data.customerItem?.id ?? 0,
                    title: data.customerItem?.name ?? "",
                    photoURL: data.customerItem?.itemImage,
                    location: data.customerItem?.location ?? "",
                    date: data.customerItem?.date ?? "",
                    seat: data.customerItem?.seat ?? "-",
                    price: data.customerItem?.payloadPayment?.grossAmount ?? ""
                )
                
                self.data.accept([value])

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
