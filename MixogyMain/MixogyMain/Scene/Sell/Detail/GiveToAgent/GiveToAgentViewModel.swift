//
//  GiveToAgentViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 11/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class GiveToAgentViewModel {
    
    var data = BehaviorRelay<SelltemDetailResponse?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var qrImage = BehaviorRelay<URL?>(value: nil)
    
    var id: Int?
    
    func fetchData() {
        guard let id = id else {
            return
        }
        
        let request = SelltemDetailRequest(id: id)

        isLoading.accept(true)
        SellOperation.detail(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data)
                
                if let qrUrl = URL(string: data.customerItem.qrPhotoUrl) {
                    self.qrImage.accept(qrUrl)
                }

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func cancelListing() {
        guard let data = data.value else {
            return
        }
        
        let request = CancelListingRequest(customerItemId: data.customerItem.id)

        isLoading.accept(true)
        SellOperation.cancelListing(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success:
                self.isSuccess.accept(true)

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
