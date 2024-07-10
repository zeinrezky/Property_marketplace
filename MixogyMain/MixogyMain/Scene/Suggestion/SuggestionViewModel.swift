//
//  SuggestionViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 25/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire
import RxCocoa
import RxSwift

class SuggestionViewModel {

    var description = BehaviorRelay<String?>(value: nil)
    var name = BehaviorRelay<String?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isInvalid = BehaviorRelay<Bool>(value: false)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    
    func submit() {
        guard let name = name.value,
            let description = description.value else {
                isInvalid.accept(true)
            return
        }
        
        let request = SuggestionRequest(title: name, description: description)
        
        isLoading.accept(true)
        SellOperation.suggestion(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success:
                self.isSuccess.accept(true)
                
            case .failure(let error):
                self.isLoading.accept(false)
                self.errorMessage.accept(error.message)
                
            case .error:
                self.isLoading.accept(false)
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
