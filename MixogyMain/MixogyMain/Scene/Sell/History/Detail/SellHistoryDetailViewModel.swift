//
//  SellHistoryDetailViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class SellHistoryDetailViewModel {
    
    enum SellHistoryDetailViewModelType {
        case history
        case paymentStatus
    }
    
    var data = BehaviorRelay<SelltemHistoryDetailResponse?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var type: SellHistoryDetailViewModelType = .history
    
    var id: Int?
    
    func fetchData() {
        guard let id = id else {
            return
        }
        
        let request = SelltemDetailRequest(id: id)

        isLoading.accept(true)
        SellOperation.historyDetail(request: request) { result in
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
