//
//  ForgotPasswordViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 15/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class ForgotPasswordViewModel {
    var isInvalid = BehaviorRelay<Bool>(value: false)
    var countryCode = BehaviorRelay<String?>(value: nil)
    var name = BehaviorRelay<String?>(value: nil)
    var phoneNumber = BehaviorRelay<String?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var token: Int?
    var request: ForgotPasswordTokenRequest?
    
    func submit() {
        guard let countryCode = countryCode.value,
            let phoneNumber = phoneNumber.value else {
                isInvalid.accept(true)
                return
        }
        
        let request = ForgotPasswordTokenRequest(
            codePhone: countryCode,
            phoneNumber: phoneNumber
        )
        
        isLoading.accept(true)
        AuthOperation.forgotPasswordToken(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.token = data.token
                self.request = request
                self.isSuccess.accept(true)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
