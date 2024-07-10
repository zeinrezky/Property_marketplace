//
//  PaymentMethodViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 29/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class PaymentMethodViewModel {
    
    enum PaymentMethodViewModelType {
        case bank
        case gopay
        case ovo
        case internals
    }
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var isSuccessCancel = BehaviorRelay<Bool>(value: false)
    var isInternalVisible = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var transactionCode: String?
    var orderid: Int?
    var transactionId: Int?
    var paymentMethod: String?
    var vendor: String?
    var amount: Int?
    var vaNumber: String?
    var phone: String?
    var bank: String?
    var qrURL: String?
    var gopayURL: String?
    var type: PaymentMethodViewModelType = .bank
    
    func submit() {
        guard let transactionCode = transactionCode,
            let paymentMethod = paymentMethod,
            let vendor = vendor,
            let amount = amount else {
            return
        }
        
        let request = CheckoutPayRequest(
            transactionCode: transactionCode,
            paymentMethod: paymentMethod,
            vendor: vendor,
            amount: amount
        )
        
        isLoading.accept(true)
        CheckoutOperation.pay(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.vaNumber = data.vaNumbers?.first?.vaNumber ?? ""
                self.bank = data.vaNumbers?.first?.bank ?? ""
                self.phone = data.phone ?? ""
                
                for action in data.actions ?? [] {
                    if action.name == "generate-qr-code" {
                        self.qrURL = action.url
                    } else if action.name == "deeplink-redirect" {
                        self.gopayURL = action.url
                    }
                }
                
                self.isSuccess.accept(true)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }

    func detail() {
        guard let transactionCode = transactionId else {
            return
        }
        
        let request = CheckoutDetailRequest(transactionCode: transactionCode)
        isLoading.accept(true)
        CheckoutOperation.detail(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                if let internalActive = data.paymentMethods.first(where: { $0.code == "internal" }) {
                    self.isInternalVisible.accept(true)
                }
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    func cancelPayment() {
        guard let transactionId = orderid else {
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
