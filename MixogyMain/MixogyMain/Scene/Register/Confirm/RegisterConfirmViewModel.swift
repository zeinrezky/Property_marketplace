//
//  RegisterConfirmViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 09/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

enum RegisterConfirmViewModelType {
    case register(RegisterRequest?)
    case forgot(ForgotPasswordTokenRequest?, Int?)
}

class RegisterConfirmViewModel {
    
    var password = BehaviorRelay<String?>(value: "")
    var confirmPassword = BehaviorRelay<String?>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isInvalid = BehaviorRelay<Bool>(value: false)
    
    var type: RegisterConfirmViewModelType = .register(nil) {
        didSet {
            switch type {
            case .register(let request):
                registerRequest = request
                
            case .forgot(let request, let token):
                forgotPasswordRequest = request
                self.token = token
            }
        }
    }
    
    var registerRequest: RegisterRequest?
    var forgotPasswordRequest: ForgotPasswordTokenRequest?
    var token: Int?
    
    func submit() {
        switch type {
        case .register:
            submitRegister()
            
        case .forgot:
            submitForgotPassword()
        }
    }
    
    func submitRegister() {
        guard let confirmPassword = confirmPassword.value,
            !confirmPassword.isEmpty,
            let password = password.value,
            !password.isEmpty,
            password == confirmPassword else {
                isInvalid.accept(true)
            return
        }
        
        registerRequest?.password = password
        isLoading.accept(true)
        
        AuthOperation.register(request: registerRequest!) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success:
                self.isSuccess.accept(true)
                
            case .failure(let error):
                self.isLoading.accept(false)
                self.errorMessage.accept(error.message)
                
            case .error:
                self.isLoading.accept(false)
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func submitForgotPassword() {
        guard let forgotPasswordRequest = forgotPasswordRequest,
            let forgotToken = token,
            let confirmPassword = confirmPassword.value,
            !confirmPassword.isEmpty,
            let password = password.value,
            !password.isEmpty,
            password == confirmPassword else {
                isInvalid.accept(true)
            return
        }
        
        isLoading.accept(true)
        
        let request = ForgotPasswordRequest(
            codePhone: forgotPasswordRequest.codePhone,
            phoneNumber: forgotPasswordRequest.phoneNumber,
            token: "\(forgotToken)",
            password: password)
        
        AuthOperation.forgotPassword(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success:
                self.isSuccess.accept(true)
                
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
