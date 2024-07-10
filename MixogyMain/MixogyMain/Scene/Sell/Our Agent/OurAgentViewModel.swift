//
//  OurAgentViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

enum OurAgentViewModelType {
    case general
    case select
}

class OurAgentViewModel {

    var data = BehaviorRelay<[OurAgentCellViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var userCoordinate: CLLocationCoordinate2D?
    var type = BehaviorRelay<OurAgentViewModelType>(value: .general)
    
    func fetchData() {
        guard let distance = Preference.profile?.nearbyRadius,
            let latitude = userCoordinate?.latitude,
            let longitude = userCoordinate?.longitude else {
            return
        }
        
        let request = OurAgentRequest(
            distance: "\(distance)",
            latitude: "\(latitude)",
            longitude: "\(longitude)"
        )

        isLoading.accept(true)
        SellOperation.ourAgent(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data.map {(ourAgent) -> OurAgentCellViewModel in
                    var distance = "0 m"
                    if let userCoordinate = self.userCoordinate,
                        let lattitude = CLLocationDegrees(ourAgent.locationPickUpLatitude ?? "0"),
                        let longitude = CLLocationDegrees(ourAgent.locationPickUpLongitude ?? "0") {
                        let agentCoordinate = CLLocationCoordinate2D(
                            latitude: lattitude,
                            longitude: longitude
                        )
                        
                        distance = Distance.calculateDistance(
                            userCoordinate: userCoordinate,
                            destinationCoordinate: agentCoordinate)
                    }
                    
                    return OurAgentCellViewModel(
                        id: ourAgent.id,
                        name: ourAgent.name,
                        photoURL: ourAgent.ktpImage,
                        address: ourAgent.address,
                        distance: distance,
                        phone: ourAgent.phoneNumber,
                        latitude: ourAgent.locationPickUpLatitude,
                        longitude: ourAgent.locationPickUpLatitude,
                        locationPickUp: ourAgent.locationPickUp
                    )
                })

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
