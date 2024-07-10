//
//  RegisterViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 08/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class RegisterViewModel {
    
    var isInvalid = BehaviorRelay<Bool>(value: false)
    var isEmailInvalid = BehaviorRelay<Bool>(value: false)
    var countryCode = BehaviorRelay<String?>(value: nil)
    var name = BehaviorRelay<String?>(value: nil)
    var phoneNumber = BehaviorRelay<String?>(value: nil)
    var email = BehaviorRelay<String?>(value: nil)
    var address = BehaviorRelay<String?>(value: nil)
    var bank = BehaviorRelay<String?>(value: nil)
    var bankNumber = BehaviorRelay<String?>(value: nil)
    var ktpNumber = BehaviorRelay<String?>(value: nil)
    var ktpImage = BehaviorRelay<String?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isSeller = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    
    var registerRequest: RegisterRequest?
    
    func submit() {
        let addressValue = address.value
        let bankValue = bank.value
        let bankNumberValue = bankNumber.value
        let ktpNumberValue = ktpNumber.value
        let ktpImageValue = ktpImage.value
        
        guard let countryCode = countryCode.value,
            let name = name.value,
            let phoneNumber = phoneNumber.value,
            let email = email.value,
            !countryCode.isEmpty,
            !phoneNumber.isEmpty,
            !email.isEmpty else {
                isInvalid.accept(true)
                return
        }
        
        guard isValidEmail(email) else {
            isEmailInvalid.accept(true)
            return
        }
        
        if isSeller.value {
            guard let address = addressValue,
                let bank = bankValue,
                let bankNumber = bankNumberValue,
                let ktpNumber = ktpNumberValue,
                let ktpImage = ktpImageValue,
                !bank.isEmpty,
                !bankNumber.isEmpty,
                !ktpNumber.isEmpty,
                !ktpImage.isEmpty else {
                    isInvalid.accept(true)
                    return
            }
            
            self.registerRequest = RegisterRequest(
                countryCode: countryCode,
                phoneNumber: phoneNumber,
                name: name,
                email: email,
                isSeller: isSeller.value,
                address: address,
                bank: bank,
                bankNumber: bankNumber,
                ktpNumber: ktpNumber,
                password: nil,
                ktpImage: ktpImage
            )
        } else {
            self.registerRequest = RegisterRequest(
                countryCode: countryCode,
                phoneNumber: phoneNumber,
                name: name,
                email: email,
                isSeller: isSeller.value,
                address: nil,
                bank: nil,
                bankNumber: nil,
                ktpNumber: nil,
                password: nil,
                ktpImage: nil
            )
        }
        
        isLoading.accept(true)
        
        let registerValidateRequest = RegisterValidateRequest(
            countryCode: countryCode,
            phoneNumber: phoneNumber,
            name: name,
            email: email
        )
        
        AuthOperation.registerValidate(request: registerValidateRequest) { result in
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
    
    func fetchTermsAndCondition(completion: @escaping (String?) -> Void) {
        let request = StaticRequest()
        isLoading.accept(true)
        StaticOperation.detail(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let response):
                completion(response.termAndConditionRegister)
                
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
