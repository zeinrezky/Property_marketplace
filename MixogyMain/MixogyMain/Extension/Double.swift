//
//  Double.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 26/02/20.
//  Copyright © 2020 Mixogi. All rights reserved.
//

import Darwin

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
