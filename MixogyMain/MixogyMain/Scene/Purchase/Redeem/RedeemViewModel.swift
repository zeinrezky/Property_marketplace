//
//  RedeemViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 24/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class RedeemViewModel {
    
    var data = BehaviorRelay<MyPurchaseDetailResponse?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var isRedeemed = BehaviorRelay<Bool>(value: false)
    var id: Int?
    
    func submit() {
        if isRedeemed.value {
            deleteCoupon()
        } else {
            redeem()
        }
    }
    
    func fetchData() {
        guard let id = id else {
            return
        }
        
        print("id = \(id)")
        
        let request = MyPurchaseDetailRequest(id: id)
        isLoading.accept(true)
        PurchaseOperation.myPurchaseDetail(request: request) { result in
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
       
    func redeem() {
        guard let id = id else {
            return
        }
        
        let request = RedeemRequest(transactionDetailId: id)
        isLoading.accept(true)
        PurchaseOperation.redeem(request: request) { result in
            self.isLoading.accept(false)
               
            switch result {
            case .success:
                self.isRedeemed.accept(true)
                   
            case .failure(let error):
                self.errorMessage.accept(error.message)
                   
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
       
    func deleteCoupon() {
        guard let id = id else {
            return
        }
           
        let request = DeleteCouponRequest(transactionDetailId: id)
        isLoading.accept(true)
        PurchaseOperation.deleteCoupon(request: request) { result in
            self.isLoading.accept(false)
               
            switch result {
            case .success:
                self.isSuccess.accept(true)
                   
            case .failure(let error):
                self.errorMessage.accept(error.message)
                   
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
