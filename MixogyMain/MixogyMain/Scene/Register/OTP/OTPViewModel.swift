//
//  OTPViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 08/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import FirebaseAuth
import RxCocoa
import RxSwift

enum OTPViewModelType {
    case register(RegisterRequest?)
    case forgot(ForgotPasswordTokenRequest?, Int?)
}

class OTPViewModel {
    
    var phoneNumber = BehaviorRelay<String?>(value: nil)
    var isInvalid = BehaviorRelay<Bool>(value: false)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var type: OTPViewModelType = .register(nil)
    
    var forgotTokenRequest: ForgotPasswordTokenRequest?
    var forgotToken: Int?
    
    func sendOTPSMS() {
        switch type {
        case .register(let request):
            sendRegisterOTP(registerRequest: request)
            phoneNumber.accept("\(request?.countryCode ?? "")\(request?.phoneNumber ?? "")")
            
        case .forgot(let request, let token):
            forgotTokenRequest = request
            forgotToken = token
            sendForgotOTP(changePasswordRequest: request)
            phoneNumber.accept("\(request?.codePhone ?? "")\(request?.phoneNumber ?? "")")
        }
    }
    
    func verifyOTP(code: String) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: Preference.otpKey ?? "",
            verificationCode: code
        )
        
        isLoading.accept(true)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            self.isLoading.accept(false)
            
            if let error = error {
                self.errorMessage.accept(error.localizedDescription)
                return
            }
            
            self.isSuccess.accept(true)
        }
    }
    
    private func sendRegisterOTP(registerRequest: RegisterRequest?) {
        guard let registerRequest = registerRequest else {
            return
        }
        
        isLoading.accept(true)
        let phoneNumber = registerRequest.countryCode + registerRequest.phoneNumber
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            self.isLoading.accept(false)
            
            if let error = error {
              print("error = \(error.localizedDescription)")
              return
            }
            
            Preference.otpKey = verificationID
        }
    }
    
    private func sendForgotOTP(changePasswordRequest: ForgotPasswordTokenRequest?) {
        guard let forgotTokenRequest = forgotTokenRequest else {
            return
        }
        
        isLoading.accept(true)
        let phoneNumber = forgotTokenRequest.codePhone + forgotTokenRequest.phoneNumber
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            self.isLoading.accept(false)
            
            if let error = error {
              print("error = \(error.localizedDescription)")
              return
            }
            
            Preference.otpKey = verificationID
        }
    }
}
