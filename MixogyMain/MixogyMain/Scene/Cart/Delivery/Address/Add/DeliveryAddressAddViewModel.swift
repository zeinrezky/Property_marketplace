//
//  DeliveryAddressAddViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 18/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class DeliveryAddressAddViewModel {
    
    enum DeliveryAddressAddViewModelType {
        case add
        case edit
        case see
    }
    
    var code = BehaviorRelay<String?>(value: nil)
    var phoneNumber = BehaviorRelay<String?>(value: nil)
    var detail = BehaviorRelay<String?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var provinceData = BehaviorRelay<[CartProvinceResponse]>(value: [])
    var data = BehaviorRelay<CartAddressDetailResponse?>(value: nil)
    var cityData = BehaviorRelay<[CartCityResponse]>(value: [])
    var isSuccess = BehaviorRelay<Bool>(value: false)
    
    var placeName: String?
    var lattitude: String?
    var longitude: String?
    var provinceId: Int?
    var cityId: Int?
    
    var type: DeliveryAddressAddViewModelType = .add
    var id: Int?
    
    func fetchData() {
        guard let id = id else {
            return
        }
        
        let request = CartAddressDetailRequest(id: id)
        isLoading.accept(true)
        CartOperation.addressDetail(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.data.accept(data)
                self.provinceId = data.city.provinceId
                self.code.accept(data.code)
                self.phoneNumber.accept(data.phone)
                self.detail.accept(data.detail)
                self.placeName = data.placeName
                self.lattitude = data.latitude
                self.longitude = data.longitude
                self.cityId = data.cityId
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchProvince() {
        let request = CartProvinceRequest()
        isLoading.accept(true)
        CartOperation.provinceList(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.provinceData.accept(data)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchCity() {
        guard let id = provinceId else {
            return
        }
        
        let request = CartCityRequest(id: id)
        isLoading.accept(true)
        CartOperation.cityList(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.cityData.accept(data)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func submit() {
        switch type {
        case .add:
            addAddress()
            
        default:
            editAddress()
        }
    }
    
    func addAddress() {
        guard let code = code.value,
            let phone = phoneNumber.value,
            let placeName = placeName,
            let latitude = lattitude,
            let longitude = longitude,
            let detail = detail.value,
            let cityId = cityId else {
            return
        }
        
        let request = CartAddressAddRequest(
            code: code,
            phone: phone,
            placeName: placeName,
            detail: detail,
            latitude: latitude,
            longitude: longitude,
            cityId: cityId
        )
        
        isLoading.accept(true)
        CartOperation.addAddress(request: request) { result in
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
    
    func editAddress() {
        guard let id = id,
            let code = code.value,
            let phone = phoneNumber.value,
            let placeName = placeName,
            let latitude = lattitude,
            let longitude = longitude,
            let detail = detail.value,
            let cityId = cityId else {
            return
        }
        
        let request = CartAddressEditRequest(
            id: id,
            code: code,
            phone: phone,
            placeName: placeName,
            detail: detail,
            latitude: latitude,
            longitude: longitude,
            cityId: cityId
        )
        
        isLoading.accept(true)
        CartOperation.editAddress(request: request) { result in
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
}
