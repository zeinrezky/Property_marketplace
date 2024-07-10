//
//  OnBoardingViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class OnBoardingPagerViewModel {
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var data = BehaviorRelay<[OnBoardingCategoryResponse]>(value: [])
    
    func fetchData() {
        let request = OnBoardingCategoryRequest()
        isLoading.accept(true)
        OnBoardingOperation.categoryList(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.data.accept(data)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
