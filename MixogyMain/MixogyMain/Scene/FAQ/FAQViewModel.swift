//
//  FAQViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/07/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class FAQViewModel {

    var data = BehaviorRelay<String>(value: "")
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    func fetchData() {
        let request = StaticRequest()
        isLoading.accept(true)
        StaticOperation.detail(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let response):
                self.data.accept(response.haveQuestion ?? "")
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
