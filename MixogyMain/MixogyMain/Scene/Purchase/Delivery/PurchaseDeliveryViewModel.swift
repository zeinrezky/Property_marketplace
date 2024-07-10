//
//  PurchaseDeliveryViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 11/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

class PurchaseDeliveryViewModel {
    
    var data = BehaviorRelay<MyPurchaseDetailResponse?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var distance = BehaviorRelay<String?>(value: nil)
    var locationImages = BehaviorRelay<[URL?]>(value: [])
    var agentImage = BehaviorRelay<URL?>(value: nil)
    var agentRating = BehaviorRelay<Int>(value: 0)
    var agentName = BehaviorRelay<String?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    
    var userCoordinate: CLLocationCoordinate2D? {
        didSet {
            calculateDistance()
        }
    }
    
    var agentCoordinate: CLLocationCoordinate2D? {
        didSet {
            calculateDistance()
        }
    }
    
    var id: Int?
    
    func fetchData() {
        guard let id = id else {
            return
        }
        
        let request = MyPurchaseDetailRequest(id: id)
        isLoading.accept(true)
        PurchaseOperation.myPurchaseDetail(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.data.accept(data)
                var locationImages: [URL?] = []

                for locationImage in data.agent?.locationPhotos ?? [] {
                    locationImages.append(URL(string: locationImage.photoURL))
                }

                self.locationImages.accept(locationImages)
                self.agentName.accept(data.agent?.name ?? "")
                self.agentRating.accept(Int(data.agent?.rating ?? "0") ?? 0)
                
                if let url = URL(string: data.agent?.photoUrl ?? "") {
                    self.agentImage.accept(url)
                }
                
                if let lattitude = CLLocationDegrees(data.agent?.locationLatitude ?? "0"),
                    let longitude = CLLocationDegrees(data.agent?.locationLongitude ?? "0") {
                    self.agentCoordinate = CLLocationCoordinate2D(
                        latitude: lattitude,
                        longitude: longitude
                    )
                }
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func submit(agentId: Int) {
        guard let id = id else {
            return
        }
        
        let request = ChangeLocationRequest(agentId: agentId, transactionDetailId: id)
        isLoading.accept(true)
        PurchaseOperation.changeLocation(request: request) { result in
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
    
    func submitTakeItem() {
        guard let id = id else {
            return
        }
        
        let request = RequestTakeItemRequest(id: id)
        isLoading.accept(true)
        RequestOperation.takeItem(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success:
                self.fetchData()
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func calculateDistance() {
        guard let userCoordinate = userCoordinate,
            let agentCoordinate = agentCoordinate else {
            return
        }
        
        let userLocation = CLLocation(
            latitude: userCoordinate.latitude,
            longitude: userCoordinate.longitude
        )
        
        let agentLocation = CLLocation(
            latitude: agentCoordinate.latitude,
            longitude: agentCoordinate.longitude
        )
        
        let distanceInMeters = userLocation.distance(from: agentLocation)
        distance.accept(distanceInMeters > 500 ? "\((distanceInMeters/1000).rounded(toPlaces: 1)) km" : "\(Int(distanceInMeters)) m")
    }
    
    func switchLocationImage(index: Int) {
        if locationImages.value.count > index {
            var currentImages = locationImages.value
            let currentFirstImages = currentImages[0]
            currentImages[0] = currentImages[index]
            currentImages[index] = currentFirstImages
            locationImages.accept(currentImages)
        }
    }
 
    func confirm() {
        guard let id = id else {
            return
        }
        
        let request = PurchaseConfirmRequest(transactionDetailId: id)
        isLoading.accept(true)
        PurchaseOperation.confirm(request: request) { result in
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
