//
//  InboxViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 31/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class InboxViewModel {
    
    var data = BehaviorRelay<[InboxCellViewModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    func fetchData() {
        let request = InboxRequest()

        isLoading.accept(true)
        InboxOperation.list(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data.map {(inbox) -> InboxCellViewModel in
                    return InboxCellViewModel(
                        id: inbox.id,
                        status: inbox.title,
                        date: inbox.createdAt,
                        title: inbox.description,
                        color: inbox.color)
                })

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
