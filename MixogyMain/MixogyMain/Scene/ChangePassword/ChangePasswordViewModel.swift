//
//  ChangePasswordViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class ChangePasswordViewModel {

    var oldPassword = BehaviorRelay<String?>(value: "")
    var confirmOldPassword = BehaviorRelay<String?>(value: "")
    var newPassword = BehaviorRelay<String?>(value: "")
    var confirmNewPassword = BehaviorRelay<String?>(value: "")
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isInvalid = BehaviorRelay<Bool>(value: false)
    
    func submit() {
        guard let codePhone = Preference.profile?.codePhone,
            let phoneNumber = Preference.profile?.phoneNumber,
            let oldPassword = oldPassword.value,
            !oldPassword.isEmpty,
            let confirmOldPassword = confirmOldPassword.value,
            !confirmOldPassword.isEmpty,
            let newPassword = newPassword.value,
            !newPassword.isEmpty,
            let confirmNewPassword = confirmNewPassword.value,
            !confirmNewPassword.isEmpty,
            oldPassword == confirmOldPassword,
            newPassword == confirmNewPassword  else {
                isInvalid.accept(true)
            return
        }
        
        let request = ChangePasswordRequest(
            codePhone: codePhone,
            phoneNumber: phoneNumber,
            currentPassword: oldPassword ,
            confirmCurrentPassword: confirmOldPassword,
            newPassword: newPassword,
            confirmNewPassword: confirmNewPassword
        )
        
        isLoading.accept(true)
        AuthOperation.changePassword(request: request) { result in
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
