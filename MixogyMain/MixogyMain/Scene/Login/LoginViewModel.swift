//
//  LoginViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class LoginViewModel {
    var countryCode = BehaviorRelay<String?>(value: "")
    var phone = BehaviorRelay<String?>(value: "")
    var password = BehaviorRelay<String?>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isInvalid = BehaviorRelay<Bool>(value: false)
    
    func loginUser() {
        guard let countryCode = countryCode.value,
            !countryCode.isEmpty,
            let phone = phone.value,
            !phone.isEmpty,
            let password = password.value,
            !password.isEmpty else {
                isInvalid.accept(true)
            return
        }
        
        let request = LoginRequest(countryCode: countryCode, phone: phone, password: password, deviceToken: Preference.deviceToken ?? "")
        isLoading.accept(true)
        AuthOperation.login(request: request) { result in
            switch result {
            case .success(let data):
                Preference.auth = data
                let request = ProfileRequest()
                self.isLoading.accept(true)
                
                ProfileOperation.detail(request: request) { result in
                    self.isLoading.accept(false)
                    
                    switch result {
                    case .success(let response):
                        Preference.profile = response
                        self.isSuccess.accept(true)
                        
                    case .failure(let error):
                        self.errorMessage.accept(error.message)
                        
                    case .error:
                        self.errorMessage.accept(Constants.FailedNetworkingMessage)
                    }
                }
                
            case .failure(let error):
                self.isLoading.accept(false)
                self.errorMessage.accept(error.message)
                
            case .error:
                self.isLoading.accept(false)
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
