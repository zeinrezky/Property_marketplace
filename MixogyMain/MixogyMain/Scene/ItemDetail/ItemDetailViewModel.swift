//
//  ItemDetailViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

class ItemDetailViewModel {

    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var data = BehaviorRelay<ItemDetailResponse?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var cartCount = BehaviorRelay<String?>(value: nil)
    
    var userCoordinate: CLLocationCoordinate2D?
    var id: Int?
    var level: Int?
    
    func fetchData() {
        guard let id = id, let userCoordinate = userCoordinate else {
            return
        }
        
        let request = ItemDetailRequest(
            id: id,
            latitude: "\(userCoordinate.latitude)",
            longitude: "\(userCoordinate.longitude)"
        )
        
        isLoading.accept(true)
        ItemOperation.detail(request: request) { result in
            switch result {
            case .success(let data):
                self.fetchCartData {
                    self.data.accept(data)
                }
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchCartData(completion: @escaping (() -> Void)) {
        guard Preference.auth != nil else {
            self.isLoading.accept(false)
            completion()
            return
        }
        
        let request = CartRequest()
        
        CartOperation.detail(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                NotificationCenter.default.post(
                    name: Notification.Name(Constants.CartCountKey),
                    object: nil,
                    userInfo: ["count": data.customerItems.count]
                )
                let count = data.customerItems.count
                self.cartCount.accept(count > 0 ? "\(count)" : "")
                Preference.cartCount = count
                Preference.cart = data
                completion()
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func addToCart(id: Int) {
        let request = CartAddRequest(customerItemId: id)
        
        isLoading.accept(true)
        CartOperation.add(request: request) { result in
            switch result {
            case .success:
                self.fetchData()
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func removeCart(id: Int) {
        let request = CartRemoveRequest(customerItemId: [id])
        
        CartOperation.remove(request: request) { result in
            switch result {
            case .success:
                self.fetchData()
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
