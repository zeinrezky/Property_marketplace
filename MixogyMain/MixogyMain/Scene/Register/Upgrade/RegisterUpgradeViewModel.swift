//
//  RegisterUpgradeViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class RegisterUpgradeViewModel {
    
    var isInvalid = BehaviorRelay<Bool>(value: false)
    var address = BehaviorRelay<String?>(value: nil)
    var bank = BehaviorRelay<String?>(value: nil)
    var bankNumber = BehaviorRelay<String?>(value: nil)
    var ktpNumber = BehaviorRelay<String?>(value: nil)
    var ktpImage = BehaviorRelay<String?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    
    func submit() {
        let addressValue = address.value
        let bankValue = bank.value
        let bankNumberValue = bankNumber.value
        let ktpNumberValue = ktpNumber.value
        let ktpImageValue = ktpImage.value
        
        guard let bank = bankValue,
            let bankNumber = bankNumberValue,
            let ktpNumber = ktpNumberValue,
            let ktpImage = ktpImageValue else {
                isInvalid.accept(true)
                return
        }
        
        let registerRequest = RegisterUpgradeRequest(
            address: addressValue,
            bank: bank,
            bankNumber: bankNumber,
            ktpNumber: ktpNumber,
            ktpImage: ktpImage
        )
        
        isLoading.accept(true)
        
        AuthOperation.upgrade(request: registerRequest) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success:
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
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchBank(completion: @escaping ([String]) -> Void) {
        let request = BankRequest()
        isLoading.accept(true)
        BankOperation.list(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let response):
                completion(response.map {(bank) -> String in
                    return bank.name
                })
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
