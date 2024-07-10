//
//  MyPurchaseViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 24/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class MyPurchaseViewModel {
    
    var data = BehaviorRelay<MyPurchaseDetailResponse?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var id: Int?
    
    func fetchData() {
        guard let id = id else {
            return
        }
        
        let request = MyPurchaseDetailRequest(id: id)

        isLoading.accept(true)
        PurchaseOperation.myPurchaseDetail(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data)

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchTermsAndCondition(completion: @escaping (String?) -> Void) {
        let request = StaticRequest()
        isLoading.accept(true)
        StaticOperation.detail(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let response):
                completion(response.gracePeriod)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
