//
//  CancelListingDetailViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

class CancelListingDetailViewModel {

    var data = BehaviorRelay<SelltemDetailResponse?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var distance = BehaviorRelay<String?>(value: nil)
    var locationImages = BehaviorRelay<[URL?]>(value: [])
    var agentImage = BehaviorRelay<URL?>(value: nil)
    var agentRating = BehaviorRelay<Int>(value: 0)
    var agentName = BehaviorRelay<String?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var qrImage = BehaviorRelay<URL?>(value: nil)
    
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
        
        let request = SelltemDetailRequest(id: id)
        isLoading.accept(true)
        SellOperation.detail(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.data.accept(data)
                var locationImages: [URL?] = []

                for locationImage in data.agent?.locationPhotos ?? [] {
                    locationImages.append(URL(string: locationImage.photoURL))
                }

                self.locationImages.accept(locationImages)
                self.agentName.accept(data.agent?.name)
                self.agentRating.accept(Int(data.agent?.rating ?? "0") ?? 0)
                
                if let qrUrl = URL(string: data.customerItem.qrPhotoUrl) {
                    self.qrImage.accept(qrUrl)
                }

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
    
    func calculateDistance() {
        guard let userCoordinate = userCoordinate,
            let agentCoordinate = agentCoordinate else {
            return
        }
        
        distance.accept(Distance.calculateDistance(
            userCoordinate: userCoordinate,
            destinationCoordinate: agentCoordinate)
        )
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
    
}
