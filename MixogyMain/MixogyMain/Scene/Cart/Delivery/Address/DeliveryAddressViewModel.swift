//
//  DeliveryAddressViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class DeliveryAddressViewModel {
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var data = BehaviorRelay<[DeliveryAddressCellViewModel]>(value: [])
    var isSuccess = BehaviorRelay<Bool>(value: false)
    
    func fetchData() {
        let request = CartAddressRequest()
        isLoading.accept(true)
        CartOperation.addressList(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.data.accept(data.map { (address) -> DeliveryAddressCellViewModel in
                    return DeliveryAddressCellViewModel(id: address.id, title: address.name)
                })
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
