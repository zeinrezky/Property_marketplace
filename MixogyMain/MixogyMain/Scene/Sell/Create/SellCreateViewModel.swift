//
//  SellCreateViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class SellCreateViewModel {
    
    var data = BehaviorRelay<SellItemDetailResponse?>(value: nil)
    var description = BehaviorRelay<String?>(value: nil)
    var confidental = BehaviorRelay<String?>(value: nil)
    var quantity = BehaviorRelay<String?>(value: nil)
    var keywords = BehaviorRelay<String?>(value: nil)
    var sellTypeId = BehaviorRelay<Int?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isInvalid = BehaviorRelay<Bool>(value: false)
    var itemCategoryOptions = BehaviorRelay<[SellCreateFilterResponse]>(value: [])
    var locationOptions: [SellCreateFilterDetailCollectionResponse] = []
    var dateOptions: [SellCreateFilterDetailCollectionDateResponse] = []
    var typeOptions: [SellCreateFilterDetailCollectionDateTimeTypesResponse] = []
    var timeOptions: [SellCreateFilterDetailCollectionDateTimeResponse] = []
    var collectionMethodResponseList = BehaviorRelay<[CollectionMethodResponse]>(value: [])
    var photos = BehaviorRelay<[(Data?, String?, Int)]>(value: [])
    var mainPhotos = BehaviorRelay<[(Data?, String?, Int)]>(value: [])
    var isUploadSuccess = BehaviorRelay<Bool>(value: false)
    
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var id: Int?
    var levelId: Int?
    var yourPrice: Int?
    var frontPhoto: String?
    var selectedCategoryId: Int?
    let multipleValue = BehaviorRelay<[MultipleValue]>(value: [.value(""), .plus])
    
    enum MultipleValue {
        case value(String)
        case plus
    }
    
    var selectedItemCategoryData: SellCreateFilterResponse? {
        didSet {
            fetchFilterDetail()
        }
    }
    
    var selectedLocation: SellCreateFilterDetailCollectionResponse? {
        didSet {
            if let value = selectedLocation {
                dateOptions = value.dates
                self.typeId = value.dates.first?.times.first?.types.first?.typeId
                self.type = value.dates.first?.times.first?.types.first?.type
                self.typeOptions = value.dates.first?.times.first?.types ?? []
            }
        }
    }
    
    var selectedDate: SellCreateFilterDetailCollectionDateResponse? {
        didSet {
            if let value = selectedDate {
                timeOptions = value.times
            }
        }
    }
    
    var typeId: Int?
    var type: String?
    
    func submit() {
        guard let data = data.value,
            let description = description.value,
            !description.isEmpty,
            let sellTypeId = sellTypeId.value,
            let levelId = levelId else {
                isInvalid.accept(true)
                return
        }
        
        if yourPrice == nil {
            isInvalid.accept(true)
            return
        }
        
        if levelId == 4 {
            guard !(data.item.date).isEmpty else {
                isInvalid.accept(true)
                return
            }
            
            if quantity.value == nil {
                isInvalid.accept(true)
                return
            }
        }
        
        let confidentalValue = confidental.value
        let confidentalPhoto = photos.value.map { (photo) -> Int in
            return photo.2
        }
        
        let mainPhoto = mainPhotos.value.map { (photo) -> Int in
            return photo.2
        }
        
        if sellTypeId == 4 && (confidentalValue == nil || (confidentalValue ?? "").isEmpty) {
            isInvalid.accept(true)
            return
        }
        
        let filteredMulti = multipleValue.value.filter {
           switch $0 {
             case .value:
               return true
             default:
               return false
           }
        }
        
        var multi: [String] = []
        
        if !filteredMulti.isEmpty && (levelId == 1 || levelId == 2) {
            for filteredMultiValue in filteredMulti {
                switch filteredMultiValue {
                case .value(let data):
                    if data.isEmpty {
                        self.isInvalid.accept(true)
                        return
                    }
                    multi.append(data)
                    
                default:
                    continue
                }
            }
        }
        
        var studioNumber: String?
        
        if levelId == 2 {
            if quantity.value == nil {
                isInvalid.accept(true)
                return
            }
            
            studioNumber = quantity.value
        }
        
        
        let request = SellCreateRequest(
            itemId: data.item.id,
            yourPrice: yourPrice,
            description: description,
            sellTypeId: sellTypeId,
            validUntilDate: data.item.date,
            confidental: confidentalValue,
            quantity: quantity.value == nil ? nil : Int(quantity.value ?? "0"),
            confidentalPhoto: confidentalPhoto.isEmpty ? nil : confidentalPhoto,
            itemPhotos: mainPhoto.isEmpty ? nil : mainPhoto,
            customerItemsValue: multi.isEmpty ? nil : multi,
            studioNNumber: studioNumber
        )
        
        isLoading.accept(true)
        SellOperation.create(request: request) { result in
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
    
    func fetchItemCategory() {
        guard let categoryId = selectedCategoryId,
            let keywords = keywords.value else {
            return
        }
        
        let request = SellCreateFilterRequest(id: categoryId, keywords: keywords)

        SellOperation.createFilter(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.itemCategoryOptions.accept(data)

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchDetail() {
        guard let name = selectedItemCategoryData?.name,
            let categoryId = selectedCategoryId,
            let typeId = typeId else {
            return
        }
        
        let request = SellItemDetailRequest(
            name: name,
            typeId: typeId,
            categoryId: categoryId,
            yourPrice: yourPrice
        )

        SellOperation.itemDetaillist(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.type = self.type ?? data.types.first(where: { $0.id == self.sellTypeId.value })?.name
                self.selectedLocation = self.locationOptions.first
                self.selectedDate = self.locationOptions.first?.dates.first
                self.data.accept(data)

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchFilterDetail() {
        guard let categoryId = selectedCategoryId,
            let keywords = selectedItemCategoryData?.name else {
            return
        }
        
        let request = SellCreateFilterDetailRequest(
            id: categoryId,
            keywords: keywords
        )

        isLoading.accept(true)
        SellOperation.createFilterDetail(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.locationOptions = data.collections
                self.typeId = data.collections.first?.dates.first?.times.first?.types.first?.typeId
                self.typeOptions = data.collections.first?.dates.first?.times.first?.types ?? []
                self.fetchDetail()

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchCollectionMethod() {
        CartOperation.collectionMethod(request: CollectionMethodRequest()) { result in
            switch result {
            case .success(let data):
                self.collectionMethodResponseList.accept(data)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func uploadPhoto(imageData: Data, tag: Int) {
        isLoading.accept(true)
        let request = SellUploadPhotoRequest(photo: imageData.base64EncodedString())
        
        SellOperation.uploadPhoto(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                if tag == 0 {
                    var photos = self.mainPhotos.value
                    photos.append((nil, data.urlPhoto, data.id))
                    self.mainPhotos.accept(photos)
                } else {
                    var photos = self.photos.value
                    photos.append((nil, data.urlPhoto, data.id))
                    self.photos.accept(photos)
                }
                
                self.isUploadSuccess.accept(true)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func addMultipleValue() {
        var data = multipleValue.value
        data.insert(.value(""), at: data.count - 1)
        multipleValue.accept(data)
    }
    
    func setMultipleValue(value: String, index: Int) {
        var data = multipleValue.value
        data[index] = .value(value)
        multipleValue.accept(data)
    }
    
    func resetMultiple(value: String, index: Int) {
        multipleValue.accept([.value(""), .plus])
    }
}
