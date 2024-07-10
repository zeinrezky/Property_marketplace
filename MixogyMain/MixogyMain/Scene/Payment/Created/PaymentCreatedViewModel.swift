//
//  PaymentCreatedViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 29/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class PaymentCreatedViewModel {
    
    var id = 0
    var vaNumber = ""
    var detail = ""
    var amount = 0
    var transactionCode: Int?
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var isSuccessCancel = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    func cancelPayment() {
        guard let transactionId = transactionCode else {
            return
        }
        
        let request = CheckoutCancelRequest(transactionCode: transactionId)
        
        isLoading.accept(true)
        CheckoutOperation.cancel(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success:
                self.isSuccessCancel.accept(true)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
