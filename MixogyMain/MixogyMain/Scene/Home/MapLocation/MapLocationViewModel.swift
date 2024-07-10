//
//  MapLocationViewModel.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 20/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

class MapLocationViewModel {

    var data = BehaviorRelay<[MapLocationCellViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var userCoordinate: CLLocationCoordinate2D?
    var keywords = BehaviorRelay<String?>(value: nil)
    
    func fetchData() {
        guard let userCoordinate = userCoordinate else {
            return
        }
        
        let request = LocationRequest(
            latitude: "\(userCoordinate.latitude)",
            longitude: "\(userCoordinate.longitude)",
            search: keywords.value?.lowercased() ?? ""
        )
        
        isLoading.accept(true)
        LocationOperation.list(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.data.accept(data.map { (location) -> MapLocationCellViewModel in
                    return MapLocationCellViewModel(
                        id: location.id,
                        title: location.name,
                        distance: Distance.format(distance: Double(location.distance)),
                        lattitude: location.latitude,
                        longitude: location.longitude,
                        count: "\(location.totalCustomerItems)"
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
