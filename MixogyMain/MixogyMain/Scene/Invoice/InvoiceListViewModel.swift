//
//  InvoiceListViewModel.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 08/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class InvoiceListViewModel {
    enum InvoiceListViewModelMode: Int {
        case pending = 0
        case generated = 1
        case paid = 2
        
        var title: String {
            switch self {
            case .pending:
                return "Total Pending"
                
            case .generated:
                return "Total Generated"
                
            case .paid:
                return "Total Paid"
            }
        }
    }
    
    enum InvoiceListDataType {
        case pending(InvoiceListPendingCellViewModel)
        case generated(InvoiceListGeneratedCellViewModel)
        case paidMain(InvoiceListPaidMainCellViewModel)
        case paidItem(InvoiceListPaidItemCellViewModel)
        case paidEvidence(InvoiceEvidenceCellViewModel)
    }
    
    var mode = BehaviorRelay<InvoiceListViewModelMode>(value: .pending)
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    var data = BehaviorRelay<[InvoiceListDataType]>(value: [])
    var paidData = BehaviorRelay<InvoicePaidResponse?>(value: nil)
    var total = BehaviorRelay<String?>(value: 0.currencyFormat)
    
    func fetchData() {
        switch mode.value {
        case .pending:
            fetchPendingData()
            
        case .generated:
            fetchGeneratedData()
            
        case .paid:
            fetchPaidData()
        }
    }
    
    func fetchPendingData() {
        let request = InvoicePendingRequest()
        
        isLoading.accept(true)
        InvoiceOperation.listPending(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.total.accept(data.totalPending.currencyFormat)
                if let items = data.items {
                    self.data.accept(items.map { (item) -> InvoiceListDataType in
                        return .pending(InvoiceListPendingCellViewModel(
                            id: item.id,
                            date: item.date,
                            amount: item.amount.currencyFormat
                        ))
                    })
                } else {
                    self.data.accept([])
                }
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchGeneratedData() {
        let request = InvoiceGeneratedRequest()
        
        isLoading.accept(true)
        InvoiceOperation.listGenerated(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.total.accept(data.totalGenerated.currencyFormat)
                if let items = data.generated {
                    self.data.accept(items.map { (item) -> InvoiceListDataType in
                        var itemList = ""
                        
                        if let categories = item.categories {
                            for category in categories {
                                if !itemList.isEmpty {
                                    itemList += ","
                                }
                                
                                itemList += "\(category.name) x\(category.count)"
                            }
                        }
                        
                        return .generated(InvoiceListGeneratedCellViewModel(
                            id: item.id,
                            date: item.date,
                            amount: item.amount.currencyFormat,
                            bank: item.bankNumber,
                            categories: itemList
                        ))
                    })
                } else {
                    self.data.accept([])
                }
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func fetchPaidData() {
        let request = InvoicePaidRequest()
        
        isLoading.accept(true)
        InvoiceOperation.listPaid(request: request) { result in
            self.isLoading.accept(false)
            
            switch result {
            case .success(let data):
                self.total.accept(data.totalPaid.currencyFormat)
                
                if let invoices = data.invoices {
                    var paidListData: [InvoiceListDataType] = []
                    
                    for invoice in invoices {
                        var itemList = ""
                        
                        if let categories = invoice.categories {
                            for category in categories {
                                if !itemList.isEmpty {
                                    itemList += ","
                                }
                                
                                itemList += "\(category.name)(\(category.count))"
                            }
                        }
                        
                        let paidDataValue: InvoiceListDataType = .paidMain(InvoiceListPaidMainCellViewModel(
                            id: invoice.id,
                            date: invoice.createdAt,
                            amount: invoice.amount.currencyFormat,
                            voucherCode: invoice.code,
                            itemList: itemList
                        ))
                        
                        paidListData.append(paidDataValue)
                        paidListData.append(.paidEvidence(InvoiceEvidenceCellViewModel(imageURL: invoice.photoEvidence)))
                    }
                    
                    self.data.accept(paidListData)
                }
                
                self.paidData.accept(data)
                
            case .failure(let error):
                self.errorMessage.accept(error.message)
                
            case .error:
                self.errorMessage.accept(Constants.FailedNetworkingMessage)
            }
        }
    }
    
    func selectData(index: Int) {
        switch data.value[index] {
        case .paidMain(let viewModel):
            self.data.accept(buildPaidViewModel(selectedData: viewModel))
            
        default:
            break
        }
    }
    
    func buildPaidViewModel(selectedData: InvoiceListPaidMainCellViewModel) -> [InvoiceListDataType] {
        var viewModel: [InvoiceListDataType] = []
        
        guard let data = self.paidData.value,
            let invoices = data.invoices else {
            return viewModel
        }
        
        for invoice in invoices {
            var itemList = ""
            
            if let categories = invoice.categories {
                for category in categories {
                    if !itemList.isEmpty {
                        itemList += ","
                    }
                    
                    itemList += "\(category.name)(\(category.count))"
                }
            }
            
            let selected = !selectedData.selected
            
            let mainData: InvoiceListDataType = .paidMain(InvoiceListPaidMainCellViewModel(
                id: invoice.id,
                date: invoice.createdAt,
                amount: invoice.amount.currencyFormat,
                voucherCode: invoice.code,
                itemList: itemList,
                selected: selectedData.id == invoice.id ? selected : false
            ))
            
            viewModel.append(mainData)
            
            if let items = invoice.customerItems,
                selectedData.id == invoice.id,
                selected {
                for item in items {
                    let itemData: InvoiceListDataType = .paidItem(
                        InvoiceListPaidItemCellViewModel(
                            name: item.name,
                            amount: item.amount.currencyFormat
                        )
                    )
                    
                    viewModel.append(itemData)
                }
            } else if let items = invoice.agentItems,
                selectedData.id == invoice.id,
                selected {
                for item in items {
                    let itemData: InvoiceListDataType = .paidItem(
                        InvoiceListPaidItemCellViewModel(
                            name: item.name,
                            amount: item.amount.currencyFormat,
                            fee: item.commision?.currencyFormat
                        )
                    )
                    
                    viewModel.append(itemData)
                }
            }
            
            viewModel.append(.paidEvidence(InvoiceEvidenceCellViewModel(imageURL: invoice.photoEvidence)))
        }
        
        return viewModel
    }
}
