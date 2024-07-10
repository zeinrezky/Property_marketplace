//
//  ProfileViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 21/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class ProfileViewModel {
    
    enum ProfileDataType {
        case info(ProfileInfoCellViewModel)
        case addressTitle
        case address(ProfileAddressCellViewModel)
        case receipt(ProfilePaymentReceiveRespoonse)
        case transaction
        case setting(Float)
    }
    
    var data = BehaviorRelay<[ProfileDataType]>(value: [])
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var photo: String?
    var radius: Int?
    
    func editPhoto() {
        guard let photo = photo else {
            return
        }
        
        let request = ProfileEditRequest(photo: photo)
        isLoading.accept(true)
        ProfileOperation.edit(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success:
                self.isSuccess.accept(true)
                self.fetchData()
                self.photo = nil
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func editRadius() {
        guard let radius = radius else {
            return
        }
        
        let request = ProfileEditRequest(radius: radius)
        isLoading.accept(true)
        ProfileOperation.edit(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success:
                self.isSuccess.accept(true)
                self.fetchData()
                self.radius = nil
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchData() {
        let request = ProfileRequest()
        isLoading.accept(true)
        ProfileOperation.detail(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let response):
                var data = self.data.value
                Preference.profile = response
                data.removeAll()
                self.data.accept(data)
                let profileInfoCellViewModel = ProfileInfoCellViewModel(
                    name: response.name,
                    phone: response.codePhone + response.phoneNumber,
                    cover: response.photoURL
                )
                data.append(.info(profileInfoCellViewModel))
                data.append(.addressTitle)
                data.append(contentsOf: response.address.map { (address) -> ProfileDataType in
                    return .address(ProfileAddressCellViewModel(id: address.id, name: address.placeName))
                })
                
                if response.isSeller || response.roleId == 5 {
                    if let paymentReceive = response.paymentReceive {
                        data.append(.receipt(paymentReceive))
                    }
                    
                    data.append(.transaction)
                }
                
                data.append(.setting(Float(response.nearbyRadius)))
                self.data.accept(data)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func logout() {
        Preference.resetDefaults()
    }
}
