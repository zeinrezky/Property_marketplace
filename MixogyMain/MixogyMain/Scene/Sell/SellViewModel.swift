//
//  SellViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

enum SellStatus: Int {
    case giveToAgent = 2
    case canceled = 5
    case listingOnAgent = 1
    case cancelListing = 3
    case gracePeriod = 18
    case waitingPayment = 17
    case sendItem = 4
    case onDelivery = 19
    case pendingPaymmnt = 25
    
    var title: String {
        switch self {
        case .giveToAgent:
            return "give-to-agent".localized()
        case .canceled:
            return "canceled".localized()
        case .listingOnAgent:
            return "listing-on-agent".localized()
        case .cancelListing:
            return "cancel-listing".localized()
        case .gracePeriod:
            return "grace-period".localized()
        case .waitingPayment:
            return "waiting-for-payment".localized()
        case .sendItem:
            return "send-item".localized()
        case .onDelivery:
            return "on-delivery".localized()
        case .pendingPaymmnt:
            return "pending-payment".localized()
        }
    }
    
    var color: String {
        switch self {
        case .giveToAgent, .canceled, .waitingPayment, .sendItem:
            return "#F5800B"
        case .listingOnAgent, .gracePeriod, .onDelivery, .pendingPaymmnt:
            return "#21A99B"
        case.cancelListing:
            return "#F82E2E"
        }
    }
}

class SellViewModel {
    
    enum SellViewModelMode: Int {
        case listing = 0
        case status = 1
        
        var title: String {
            switch self {
            case .listing:
                return "listing-tab".localized()
                
            case .status:
                return "payment-status".localized()
            }
        }
    }
    
    var data = BehaviorRelay<[SellCellViewModel]>(value: [])
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var list = BehaviorRelay<String?>(value: nil)
    var status = BehaviorRelay<String?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var mode = BehaviorRelay<SellViewModelMode>(value: .listing)

    func fetchData() {
        switch mode.value {
        case .status:
            fetchStatuaData()

        case .listing:
            fetchListData()
        }
    }
    
    func fetchStatuaData() {
        let request = SellStatusRequest()

        isLoading.accept(true)
        SellOperation.pendingStatus(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data.map {(pendingStatus) -> SellCellViewModel in
                    let statusType: SellStatus = SellStatus(rawValue: pendingStatus.statusId) ?? .giveToAgent
                    
                    return SellCellViewModel(
                        id: pendingStatus.id,
                        title: pendingStatus.name,
                        photo: pendingStatus.photoURL,
                        status: statusType.title,
                        statusId: pendingStatus.statusId,
                        amount: pendingStatus.price,
                        color: statusType.color
                    )
                })
                self.status.accept("\(data.count) " + "items".localized())

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchListData() {
        let request = SellListRequest()

        isLoading.accept(true)
        SellOperation.listing(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data.map {(pendingStatus) -> SellCellViewModel in
                    let statusType: SellStatus = SellStatus(rawValue: pendingStatus.statusId) ?? .giveToAgent
                    let titleValue: String
                    
                    if pendingStatus.status == "Online - Listing" {
                        titleValue = pendingStatus.status
                    } else {
                        titleValue = statusType == .listingOnAgent ? (pendingStatus.status.lowercased() == "listing" ? "listing-status".localized() : statusType.title) : statusType.title
                    }
                    
                    return SellCellViewModel(
                        id: pendingStatus.id,
                        title: pendingStatus.name,
                        photo: pendingStatus.photoURL,
                        status: titleValue,
                        statusId: pendingStatus.statusId,
                        amount: pendingStatus.price,
                        color: statusType.color
                    )
                })
                self.list.accept("\(data.count) " + "items".localized())

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchCounter() {
        let request = SellStatusRequest()

        isLoading.accept(true)
        SellOperation.pendingStatus(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.status.accept("\(data.count) " + "items".localized())

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
