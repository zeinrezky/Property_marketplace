//
//  ItemCartViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

class ItemCartViewModel {
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var data = BehaviorRelay<ItemDetailCartResponse?>(value: nil)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var cartCount = BehaviorRelay<String?>(value: nil)
    
    var userCoordinate: CLLocationCoordinate2D?
    var id: Int?
    var level: Int?
    
    func fetchData() {
        guard let id = id, let userCoordinate = userCoordinate else {
            return
        }
        
        let request = ItemDetailCartRequest(
            id: id,
            latitude: "\(userCoordinate.latitude)",
            longitude: "\(userCoordinate.longitude)"
        )
        
        isLoading.accept(true)
        ItemOperation.detailCart(request: request) { result in
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
    
    func addToCart() {
        guard let id = id else {
            return
        }
        
        let request = CartAddRequest(customerItemId: id)
        
        isLoading.accept(true)
        CartOperation.add(request: request) { result in
            self.fetchCartData()
            
            switch result {
            case .success:
                self.isSuccess.accept(true)
                self.fetchData()
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func removeCart() {
        guard let id = id else {
            return
        }
        
        let request = CartRemoveRequest(customerItemId: [id])
        
        CartOperation.remove(request: request) { result in
            self.fetchCartData()
            
            switch result {
            case .success:
                self.isSuccess.accept(true)
                self.fetchData()
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchCartData() {
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
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
