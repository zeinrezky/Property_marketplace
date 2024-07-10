//
//  SellHistoryViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class SellHistoryViewModel {
    
    var data = BehaviorRelay<[SellHistoryCellViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var id: Int?
    
    func fetchData() {
        let request = SellHistoryRequest()

        isLoading.accept(true)
        SellOperation.history(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data.map {(history) -> SellHistoryCellViewModel in
                    let statusType: SellStatus = SellStatus(rawValue: history.statusId) ?? .giveToAgent
                    
                    return SellHistoryCellViewModel(
                        id: history.id,
                        title: history.name,
                        photoURL: history.photoURL,
                        location: history.location,
                        date: history.date,
                        status: statusType.title
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
