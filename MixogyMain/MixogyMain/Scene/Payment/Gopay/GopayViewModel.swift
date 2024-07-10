//
//  GopayViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 11/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class GopayViewModel {
    
    var id = 0
    var amount = 0
    var qrURL = ""
    var gopayURL = ""
    
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
