//
//  TutorialViewModel.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 10/09/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift

class TutorialViewModel {
    enum TutorialViewModelMode: Int {
        case buy = 0
        case sell = 1
        
        var images: [String] {
            switch self {
            case .buy:
                return [
                    "Buy0", "Buy1", "Buy2", "Buy3", "Buy4", "Buy5", "Buy6"
                ]
                
            case .sell:
                return [
                    "Sell0", "Sell1", "Sell2", "Sell3", "Sell4", "Sell5", "Sell6"
                ]
            }
        }
        
        var infos: [String] {
            switch self {
            case .buy:
                return [
                    "buy1".localized(),
                    "buy2".localized(),
                    "buy3".localized(),
                    "buy4".localized(),
                    "buy5".localized(),
                    "buy6".localized(),
                    "buy7".localized()
                ]
                
            case .sell:
                return [
                    "sell1".localized(),
                    "sell2".localized(),
                    "sell3".localized(),
                    "sell4".localized(),
                    "sell5".localized(),
                    "sell6".localized(),
                    "sell7".localized()
                ]
            }
        }
        
        var title: String {
            switch self {
            case .buy:
                return "Buy"
                
            case .sell:
                return "Sell"
            }
        }
    }
    
    var mode = BehaviorRelay<TutorialViewModelMode>(value: .buy)
}
