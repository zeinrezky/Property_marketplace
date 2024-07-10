//
//  PurchaseViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

enum PurchaseStatus: Int {
    case giveToAgent = 2
    case canceled = 5
    case listingOnAgent = 1
    case cancelListing = 3
    case gracePeriod = 18
    case waitingPayment = 17
    case sendItem = 4
    case onDelivery = 19
    case onHand = 10
    
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
        case .onHand:
            return "on-hand".localized()
        }
    }
    
    var color: String {
        switch self {
        case .giveToAgent, .canceled, .waitingPayment, .sendItem:
            return "#F5800B"
        case .listingOnAgent, .gracePeriod, .onDelivery, .onHand:
            return "#21A99B"
        case.cancelListing:
            return "#F82E2E"
        }
    }
}

class PurchaseViewModel {
    
    enum PurchaseViewModelCellType {
        case myPurchase(PurchaseCellViewModel)
        case pending(PendingPurchaseCellViewModel)
    }
    
    enum PurchaseViewModelMode: Int {
        case pending = 1
        case myPurchase = 0
        
        var title: String {
            switch self {
            case .pending:
                return "pending-payment".localized()
                
            case .myPurchase:
                return "my-purchase".localized()
            }
        }
    }
    
    var data = BehaviorRelay<[PurchaseViewModelCellType]>(value: [])
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var myPurchase = BehaviorRelay<String?>(value: nil)
    var pending = BehaviorRelay<String?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var mode = BehaviorRelay<PurchaseViewModelMode>(value: .myPurchase)
    
    func fetchData() {
        switch mode.value {
        case .pending:
            fetchPendingData()
            
        case .myPurchase:
            fetchMyPurchaseData()
        }
    }
    
    func fetchPendingData() {
        let request = PurchasePendingRequest()

        isLoading.accept(true)
        PurchaseOperation.pending(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data.map {(purchase) -> PurchaseViewModelCellType in
                    let gopayQrCoode = purchase.payloadPayment?.actions?.first(where: { $0.name == "generate-qr-code" })?.url
                    let gopayURL = purchase.payloadPayment?.actions?.first(where: { $0.name == "deeplink-redirect" })?.url ?? ""
                    
                    return .pending(
                        PendingPurchaseCellViewModel(
                            id: purchase.id,
                            title: purchase.itemDetails.count == 1 ? purchase.itemDetails.first?.name ?? "" : "\(purchase.itemDetails.count) " + "items".localized(),
                            category: purchase.itemDetails.first?.category ?? "",
                            duration: purchase.itemDetails.first?.duration ?? "",
                            status: purchase.itemDetails.first?.status ?? "",
                            orderId: purchase.orderId,
                            amount: purchase.total,
                            vaNumber: purchase.payloadPayment?.vaNumbers?.first?.vaNumber,
                            cover: purchase.itemDetails.count == 1 ? purchase.itemDetails.first?.photoUrl ?? "" : nil,
                            detail: purchase.payloadPayment?.vaNumbers?.first?.bank,
                            isGopay: purchase.payloadPayment?.paymentType ?? "" == "gopay",
                            gopayQR: gopayQrCoode,
                            gopayURL: gopayURL
                        )
                    )
                })
                self.pending.accept("\(data.count) " + "items".localized())

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchMyPurchaseData() {
        let request = MyPurchaseRequest()

        isLoading.accept(true)
        PurchaseOperation.myPurchase(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.data.accept(data.map {(purchase) -> PurchaseViewModelCellType in
                    return .myPurchase(
                        PurchaseCellViewModel(
                            id: purchase.transactionDetailId,
                            title: purchase.name,
                            photoURL: purchase.photoUrl,
                            location: purchase.location,
                            gracePeriod: purchase.gracePeriod.ended ? "Grace Period Ended" : purchase.gracePeriod.date,
                            date: purchase.date.replacingOccurrences(of: " : ", with: " :\n"),
                            status: purchase.status,
                            statusId: purchase.statusId
                        )
                    )
                })
                self.myPurchase.accept("\(data.count) " + "items".localized())

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchPendingDataCounter() {
        let request = PurchasePendingRequest()

        isLoading.accept(true)
        PurchaseOperation.pending(request: request) { result in
            self.isLoading.accept(false)

            switch result {
            case .success(let data):
                self.pending.accept("\(data.count) " + "items".localized())

            case .failure(let error):
                self.errorMessage.accept(error.message)

            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
}
