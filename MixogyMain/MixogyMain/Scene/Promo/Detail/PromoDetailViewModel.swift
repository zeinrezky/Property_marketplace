//
//  PromoDetailViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class PromoDetailViewModel {
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var data = BehaviorRelay<PromoDetailResponse?>(value: nil)
    
    var id: Int?
    
    func fetchData() {
        guard let id = id else {
            return
        }
        
        let request = PromoDetailRequest(id: id)
        
        isLoading.accept(true)
        PromoOperation.detail(request: request) { result in
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
}
