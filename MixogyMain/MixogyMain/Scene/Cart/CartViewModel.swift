//
//  CartViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 10/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class CartViewModel {
    
    enum CartViewModelDataType {
        case clear
        case cart(CartCustomerItemResponse)
    }
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var selectedData: [CartCustomerItemResponse] = []
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var isRemoveCartSuccess = BehaviorRelay<Bool>(value: false)
    var isPaySuccess = BehaviorRelay<Bool>(value: false)
    var deliveryFee = BehaviorRelay<Int>(value: 0)
    var agentId: Int?
    var collectionMethodId: Int?
    var checkourAddResponse: CheckoutAddResponse?
    
    var data = BehaviorRelay<CartResponse?>(value: nil)
    var cellData = BehaviorRelay<[CartViewModelDataType]>(value: [.clear])
    var total: Int = 0
    var addressId: Int?
    var collectionMethodResponseList: [CollectionMethodResponse] = []
    
    func fetchData() {
        let request = CartRequest()
        isLoading.accept(true)
        selectedData.removeAll()
        
        CartOperation.collectionMethod(request: CollectionMethodRequest()) { result in
            switch result {
            case .success(let data):
                self.collectionMethodResponseList = data
                CartOperation.detail(request: request) { result in
                    self.isLoading.accept(false)
                    switch result {
                    case .success(let data):
                        self.data.accept(data)
                        NotificationCenter.default.post(
                            name: Notification.Name(Constants.CartCountKey),
                            object: nil,
                            userInfo: ["count": data.customerItems.count]
                        )
                        Preference.cartCount = data.customerItems.count
                        Preference.cart = data
                
                    case .failure(let error):
                        self.errorMessage.accept(error.message)
                        
                    case .error:
                        self.errorMessage.accept(Constants.FailedNetworkingMessage)
                    }
                }
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func pay() {
        guard let collectionMethodId = self.collectionMethodId,
            !selectedData.isEmpty else {
            return
        }
        
        let request = CheckoutAddRequest(
            customerItemId: selectedData.map { (customerItem) -> Int in
                return customerItem.customerItemId
            },
            collectionMethodId: collectionMethodId,
            deliveryFee: deliveryFee.value,
            toAgentId: agentId,
            customerAddressId: addressId
        )
        
        isLoading.accept(true)
        CheckoutOperation.add(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.checkourAddResponse = data
                self.isPaySuccess.accept(true)

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchDeliveryFee(addressId: Int) {
        guard let value = data.value else {
            return
        }
        
        self.addressId = addressId
        
        let request = CartFeeRequest(customerItemId: value.customerItems.map { (cart) -> Int in
            return cart.customerItemId
        }, addressDestinationId: addressId)
        
        CartOperation.deliveryFee(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.deliveryFee.accept(data.price)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func clearAll() {
        guard let data = data.value else {
            return
        }
        
        let request = CartRemoveRequest(customerItemId: data.customerItems.map {(item) -> Int in
            return item.customerItemId
        })
        
        CartOperation.remove(request: request) { result in
            switch result {
            case .success:
                self.isRemoveCartSuccess.accept(true)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchTermsAndCondition(completion: @escaping (String?) -> Void) {
        let request = StaticRequest()
        isLoading.accept(true)
        StaticOperation.detail(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let response):
                completion(response.gracePeriod)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
