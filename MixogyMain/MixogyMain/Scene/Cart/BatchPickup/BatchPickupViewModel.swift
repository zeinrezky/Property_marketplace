//
//  BatchPickupViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 23/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

class BatchPickupViewModel {
    
    var data = BehaviorRelay<[BatchPickupCellViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var userCoordinate: CLLocationCoordinate2D?
    
    func fetchData() {
        guard let userCoordinate = userCoordinate else {
            return
        }
        
        let request = BatchPickupRequest(
            latitude: "\(userCoordinate.latitude)",
            longitude: "\(userCoordinate.longitude)",
            distance: "1000"
        )

        isLoading.accept(true)
        CartOperation.batchPickup(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data.map {(batchPickup) -> BatchPickupCellViewModel in
                    return BatchPickupCellViewModel(
                        id: batchPickup.id,
                        title: batchPickup.name,
                        distance: Distance.format(distance: Double(batchPickup.distance))
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
