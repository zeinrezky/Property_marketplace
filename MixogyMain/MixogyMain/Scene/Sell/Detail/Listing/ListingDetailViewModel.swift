//
//  ListingDetailViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class ListingDetailViewModel {
    
    var data = BehaviorRelay<SelltemDetailResponse?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var yourPrice = BehaviorRelay<String?>(value: nil)
    var description = BehaviorRelay<String?>(value: nil)
    var confidentialInformation = BehaviorRelay<String?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var isEdit = BehaviorRelay<Bool>(value: false)
    var isOnlineMethod = BehaviorRelay<Bool>(value: false)
    var isOnlineMethodEdit = BehaviorRelay<Bool>(value: false)
    var photos = BehaviorRelay<[(Data?, String?, Int)]>(value: [])
    var isUploadSuccess = BehaviorRelay<Bool>(value: false)
    var isInvalid = BehaviorRelay<Bool>(value: false)
    
    var id: Int?
    
    func fetchData() {
        guard let id = id else {
            return
        }
        
        let request = SelltemDetailRequest(id: id)

        isLoading.accept(true)
        SellOperation.detail(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                if data.customerItem.status == "Online - Listing" {
                    self.confidentialInformation.accept(data.customerItem.confidentialInformation)
                    self.isOnlineMethod.accept(true)
                    
                    self.photos.accept((data.customerItem.confidential_photos ?? []).map { (photo) -> (Data?, String?, Int) in
                        return (nil, photo.photoURL, photo.id)
                    })
                }
                
                self.yourPrice.accept("\(data.customerItem.yourPrice)")
                self.data.accept(data)

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func cancelListing(reasonId: Int, comment: String?) {
        guard let data = data.value else {
            return
        }
        
        let request = CancelListingRequest(
            customerItemId: data.customerItem.id,
            reasonId: reasonId,
            comment: comment
        )

        isLoading.accept(true)
        SellOperation.cancelListing(request: request) { result in
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
    
    func edit() {
        guard let id = id,
            let yourPrice = Int(yourPrice.value ?? "0"),
            let description = description.value else {
                isInvalid.accept(true)
            return
        }
        
        let request: SellEditRequest
        
        if isOnlineMethodEdit.value, isOnlineMethod.value {
            guard let confidentialInformation = confidentialInformation.value, !confidentialInformation.isEmpty else {
                isInvalid.accept(true)
                return
            }
            
            let photos = self.photos.value.map { (photo) -> Int in
                return photo.2
            }
                
            request = SellEditRequest(id: id, yourPrice: yourPrice, description: description, confidentialnformation: confidentialInformation, multiplePhotos: photos)
        } else {
            request = SellEditRequest(id: id, yourPrice: yourPrice, description: description)
        }

        isLoading.accept(true)
        
        SellOperation.edit(request: request) { result in
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
    
    func uploadPhoto(imageData: Data) {
        isLoading.accept(true)
        let request = SellUploadPhotoRequest(photo: imageData.base64EncodedString())
        
        SellOperation.uploadPhoto(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                var photos = self.photos.value
                photos.append((nil, data.urlPhoto, data.id))
                self.photos.accept(photos)
                self.isUploadSuccess.accept(true)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
