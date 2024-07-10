//
//  CancelReasonViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 25/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class CancelReasonViewModel {

    var reasonId: Int?
    var data = BehaviorRelay<[CancelReasonCellViewModel]>(value: [])
    var comment = BehaviorRelay<String?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    func fetchData() {
        let request = CancelReasonRequest()
        isLoading.accept(true)
        SellOperation.reason(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.data.accept(data.map { (reason) -> CancelReasonCellViewModel in
                    return CancelReasonCellViewModel(id: reason.id, title: reason.title)
                })
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func selectReason(index: Int) {
        let data = self.data.value
        reasonId = data[index].id
        
        for i in 0..<data.count {
            data[i].selected = i == index
        }
        
        self.data.accept(data)
    }
}
