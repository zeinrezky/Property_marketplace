//
//  RateAgentViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 25/10/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class RateAgentViewModel {
    
    var comment = BehaviorRelay<String?>(value: "")
    var data = BehaviorRelay<[ItemDetailsCellViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isInvalid = BehaviorRelay<Bool>(value: false)
    
    var id: Int?
    var rating: Int?
    var paramIdType = "transaction_detail_id"
    var type = "purchase"
    
    func submit() {
        guard self.id != nil,
            self.rating != nil,
            self.rating ?? 0 > 0,
            !(self.comment.value ?? "").isEmpty else {
                isInvalid.accept(true)
            return
        }
        
        let request = RateAgentRequest(
            rating: self.rating ?? 0,
            transactionDetailId: self.id ?? 0,
            comment: self.comment.value ?? "",
            type: type,
            paramIdType: paramIdType)

        isLoading.accept(true)
        PurchaseOperation.rateAgent(request: request) { result in
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
