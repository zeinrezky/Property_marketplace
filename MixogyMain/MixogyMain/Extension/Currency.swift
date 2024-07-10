//
//  Currency.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 08/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

public protocol Currency {}
public extension Currency {
    
    /// Change to Indonesia's currency format. e.g: Rp 100.000
    var currencyFormat: String {
        return "Rp " + thousandSeparatorFormat
    }
    
    var thousandSeparatorFormat: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "id_ID")
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .decimal
        
        guard let number = self as? NSNumber else {
            fatalError("this type \(self) is not convertable to NSNumber")
        }
        
        return numberFormatter.string(from: number)!
    }
}

extension Int: Currency {}
extension Int64: Currency {}
extension Double: Currency {}

public extension String {
    
    /// Remove Indonesia's currency format
    var removeCurrencyFormat: String {
        if hasPrefix("Rp ") {
            return replacingOccurrences(of: "Rp ", with: "")
                .replacingOccurrences(of: ".", with: "")
        }
        
        return replacingOccurrences(of: ".", with: "")
    }
}
