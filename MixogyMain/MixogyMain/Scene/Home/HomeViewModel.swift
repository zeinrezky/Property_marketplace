//
//  HomeViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

class HomeViewModel {
    
    var selectedIndex = 0
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var selectedCategoryValue = BehaviorRelay<String?>(value: nil)
    var isVoucher = BehaviorRelay<Bool>(value: false)
    var selectedCategoryImageValue = BehaviorRelay<String?>(value: nil)
    var categoryList = BehaviorRelay<[String]>(value: [])
    var categoryImageList = BehaviorRelay<[String]>(value: [])
    var categoryItem = BehaviorRelay<[HomeCategoryCellViewModel]>(value: [])
    var nearByItem = BehaviorRelay<[(String, [HomeCategoryCellViewModel])]>(value: [])
    var locationByItem = BehaviorRelay<[(String, [HomeCategoryCellViewModel])]>(value: [])
    var search = BehaviorRelay<Bool>(value: false)
    var locationSearch = BehaviorRelay<Bool>(value: false)
    var promoData = BehaviorRelay<[(Int, String?)]>(value: [])
    var searchItem = BehaviorRelay<[HomeCategoryCellViewModel]>(value: [])
    var nearBySelected = BehaviorRelay<Bool>(value: false)
    var keywords = BehaviorRelay<String?>(value: nil)
    
    var locationSearchId: Int?
    var selectedPromoId: Int?
    var selectedCategoryId: Int?
    var userCoordinate: CLLocationCoordinate2D?
    
    func selectPromoId(index: Int) {
        selectedPromoId = promoData.value[index].0
    }
    
    var isSearch: Bool = false {
        didSet {
            search.accept(isSearch)
            if !isSearch {
                let id = selectedCategory?.id ?? 0
                selectedCategoryValue.accept( id < 99 ? selectedCategory?.name : "nearby".localized())
                
                if id < 99 {
                    fetchDataCategoryItem(id: selectedCategory?.id ?? 0)
                    nearBySelected.accept(false)
                } else {
                    fetchNearByItem()
                    nearBySelected.accept(true)
                }
            }
        }
    }
    
    var isLocationSearch: Bool = false {
        didSet {
            locationSearch.accept(isLocationSearch)
            if !isLocationSearch {
                let id = selectedCategory?.id ?? 0
                selectedCategoryValue.accept( id < 99 ? selectedCategory?.name : "nearby".localized())
                
                if id < 99 {
                    fetchDataCategoryItem(id: selectedCategory?.id ?? 0)
                    nearBySelected.accept(false)
                } else {
                    fetchNearByItem()
                    nearBySelected.accept(true)
                }
            }
        }
    }
    
    var selectedCategory: OnBoardingCategoryResponse? {
        didSet {
            let id = selectedCategory?.id ?? 0
            selectedCategoryValue.accept( id < 99 ? selectedCategory?.name : "nearby".localized())
            selectedCategoryImageValue.accept(selectedCategory?.backgroundURL)
            selectedCategoryId = id
            
            if id < 99 {
                fetchDataCategoryItem(id: selectedCategory?.id ?? 0)
                nearBySelected.accept(false)
            } else {
                fetchNearByItem()
                nearBySelected.accept(true)
            }
        }
    }
    
    var data: [OnBoardingCategoryResponse] = [] {
        didSet {
            categoryList.accept(data.map { (onboardingResponse) -> String in
                return onboardingResponse.name
            })
            
            categoryImageList.accept(data.map { (onboardingResponse) -> String in
                return onboardingResponse.backgroundURL ?? ""
            })
        }
    }
    
    func selectNextCategory() {
        if data.count > selectedIndex + 1 {
            selectedIndex = selectedIndex + 1
        } else {
            selectedIndex = 0
        }
        
        selectedCategory = data[selectedIndex]
    }
    
    func selectBeforeCategory() {
        if selectedIndex > 0 {
            selectedIndex = selectedIndex - 1
        } else {
            selectedIndex = data.count - 1
        }
        
        selectedCategory = data[selectedIndex]
    }
    
    func fetchDataCategory() {
        let request = OnBoardingCategoryRequest()
        isLoading.accept(true)
        OnBoardingOperation.categoryList(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.data = data
                if let selectedCategories = data.first(where: { $0.id == self.selectedCategoryId ?? 0 }) {
                    self.selectedCategory = selectedCategories
                }
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchDataCategoryItem(id: Int) {
        let request = HomeCategoryItemRequest(id: id)
        isLoading.accept(true)
        HomeOperation.categoryItemList(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.categoryItem.accept(data.map {(categoryItem) -> HomeCategoryCellViewModel in
                    return HomeCategoryCellViewModel(
                        id: categoryItem.itemId,
                        categoryId: id,
                        typeId: categoryItem.typeId ?? 0,
                        name: categoryItem.name,
                        count: "\(categoryItem.total)",
                        category: categoryItem.category,
                        type: categoryItem.type ?? "",
                        originalPrice: categoryItem.originalPrice.currencyFormat,
                        lowestPrice: categoryItem.lowestPrice?.currencyFormat ?? "",
                        photo: categoryItem.photoUrl ?? "",
                        color: (categoryItem.lowestPrice ?? 0) > (categoryItem.originalPrice) ? "#E25D5D" : "#21A99B",
                        levelId: categoryItem.levelId
                    )
                })
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchNearByItem() {
        guard let userCoordinate = userCoordinate else {
            return
        }
        
        let request = HomeNearByRequest(
            latitude: "\(userCoordinate.latitude)",
            longitude: "\(userCoordinate.longitude)",
            distance: Preference.profile?.nearbyRadius ?? 2500,
            keywords: keywords.value ?? ""
        )
        
        isLoading.accept(true)
        HomeOperation.nearByList(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.nearByItem.accept(data.map {(nearByIitem) -> (String, [HomeCategoryCellViewModel]) in
                    return (nearByIitem.categoryName, nearByIitem.items.map {(categoryItem) -> HomeCategoryCellViewModel in
                        return HomeCategoryCellViewModel(
                            id: categoryItem.itemId,
                            categoryId: nearByIitem.categoryId,
                            typeId: 0,
                            name: categoryItem.name,
                            count: "\(categoryItem.total)",
                            category: categoryItem.category,
                            type: categoryItem.type,
                            originalPrice: categoryItem.originalPrice.currencyFormat,
                            lowestPrice: (categoryItem.lowestPrice ?? 0).currencyFormat,
                            photo: categoryItem.photoUrl ?? "",
                            color: (categoryItem.lowestPrice ?? 0) > (categoryItem.originalPrice) ? "#E25D5D" : "#21A99B",
                            levelId: categoryItem.levelId
                        )
                    })
                })
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchPromoData() {
        let request = HomePromoRequest()
        HomeOperation.promoList(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                guard !data.isEmpty else {
                    return
                }
                
                self.promoData.accept(data.map {(promo) -> (Int, String?) in
                    return (promo.id, promo.photoUrl)
                })
                
                self.selectPromoId(index: 0)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchSearchData() {
        guard let selectedCategory = selectedCategory,
            let keyword = keywords.value else {
                return
        }
        
        if selectedCategory.id < 99 {
            let request = HomeSearchRequest(
                search: keyword.lowercased(),
                id: selectedCategory.id
            )
            
            HomeOperation.searchList(request: request) { result in
                self.isLoading.accept(false)
                
                switch result {
                case .success(let data):
                    self.searchItem.accept(data.map {(searchIitem) -> HomeCategoryCellViewModel in
                        return HomeCategoryCellViewModel(
                            id: searchIitem.itemId,
                            categoryId: 0,
                            typeId: 0,
                            name: searchIitem.name,
                            count: "\(searchIitem.total)",
                            category: searchIitem.category,
                            type: searchIitem.type,
                            originalPrice: searchIitem.originalPrice.currencyFormat,
                            lowestPrice: ((searchIitem.lowestPrice ?? 0).currencyFormat),
                            photo: searchIitem.photoUrl ?? "",
                            color: (searchIitem.lowestPrice ?? 0) > (searchIitem.originalPrice) ? "#E25D5D" : "#21A99B",
                            levelId: searchIitem.levelId
                        )
                    })
                    
                case .failure(let error):
                    self.errorMessage.accept(error.message)
                    
                case .error:
                    self.errorMessage.accept(Constants.FailedNetworkingMessage)
                }
            }
        } else {
            fetchNearByItem()
        }
    }
    
    func fetchLocationData() {
        guard let locationSearchId = locationSearchId else {
            return
        }
        
        let request = HomeLocationSearchRequest(
            search: "",
            id: locationSearchId
        )
        
        HomeOperation.locationSearchList(request: request) { result in
            self.isLoading.accept(false)
            self.locationSearch.accept(true)
            
            switch result {
            case .success(let data):
                self.locationByItem.accept(data.map {(nearByIitem) -> (String, [HomeCategoryCellViewModel]) in
                    return (nearByIitem.categoryName, nearByIitem.items.map {(categoryItem) -> HomeCategoryCellViewModel in
                        return HomeCategoryCellViewModel(
                            id: categoryItem.itemId,
                            categoryId: nearByIitem.categoryId,
                            typeId: 0,
                            name: categoryItem.name,
                            count: "\(categoryItem.total)",
                            category: categoryItem.category,
                            type: categoryItem.type,
                            originalPrice: categoryItem.originalPrice.currencyFormat,
                            lowestPrice: (categoryItem.lowestPrice ?? 0).currencyFormat,
                            photo: categoryItem.photoUrl ?? "",
                            color: (categoryItem.lowestPrice ?? 0) > (categoryItem.originalPrice) ? "#E25D5D" : "#21A99B",
                            levelId: categoryItem.levelId
                        )
                    })
                })
                
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
                
                Preference.cartCount = data.customerItems.count
                Preference.cart = data
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
