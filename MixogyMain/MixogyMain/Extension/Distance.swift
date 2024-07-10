//
//  Distance.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 12/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import Foundation

class Distance {
    
    static func calculateDistance(
        userCoordinate: CLLocationCoordinate2D,
        destinationCoordinate: CLLocationCoordinate2D) -> String {
        let userLocation = CLLocation(
            latitude: userCoordinate.latitude,
            longitude: userCoordinate.longitude
        )
        
        let destinationLocation = CLLocation(
            latitude: destinationCoordinate.latitude,
            longitude: destinationCoordinate.longitude
        )
        
        let distance = userLocation.distance(from: destinationLocation)
        return distance > 500 ? "\(String(format: "%.2f", distance/1000)) km" : "\(Int(distance)) m"
    }
    
    static func format(distance: Double) -> String {
        return distance > 500 ? "\(String(format: "%.2f", distance/1000)) km" : "\(Int(distance)) m"
    }
}
