//
//  MyPurchaseDetailResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 24/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class MyPurchaseDetailResponse: Codable {
    
    let customerItem: MyPurchaseDetailCustomerItemResponse
    let agent: MyPurchaseDetailAgentResponse?
    let seller: MyPurchaseDetailSellerResponse?
    
    enum CodingKeys: String, CodingKey {
        case agent, seller
        case customerItem = "customer_item"
    }
}

class MyPurchaseDetailCustomerItemResponse: Codable {

    let id: Int
    let code: String
    let name: String
    let qrPhotoUrl: String
    let type: String
    let seat: String?
    let date: String
    let location: String
    let category: String
    let description: String?
    let itemPhotos: MyPurchaseDetailCustomerItemPhotoResponse
    let itemImage: String
    let statusId: Int
    let status: String
    let gracePeriod: MyPurchaseDetailGracePeriodResponse
    let courierName: String?
    let resiNumber: String?
    let contactNumber: String?
    let transactionDetailId: Int?
    let pickupAvailableDate: String?
    let confidentialInformation: String?
    let confidential_photos: [MyPurchaseDetailAgentPhotoResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id, code, name, type, seat, date, location, category, description, status
        case qrPhotoUrl = "qr_photo_url"
        case itemPhotos = "item_photos"
        case itemImage = "item_image"
        case statusId = "status_id"
        case gracePeriod = "grace_period"
        case courierName = "courier_name"
        case resiNumber = "resi_number"
        case contactNumber = "contact_number"
        case transactionDetailId = "transaction_detail_id"
        case pickupAvailableDate = "pickup_available_date"
        case confidentialInformation = "confidential_information"
        case confidential_photos = "confidential_photos"
    }
}

class MyPurchaseDetailAgentResponse: Codable {
    let id: Int
    let name: String
    let rating: String
    let location: String
    let locationLatitude: String
    let locationLongitude: String
    let locationPickUp: String
    let locationPickUpLatitude: String
    let locationPickUpLongitude: String
    let locationPickUpDetail: String?
    let photoUrl: String
    let locationPhotos: [MyPurchaseDetailAgentPhotoResponse]
    
    enum CodingKeys: String, CodingKey {
        case id, name, rating, location
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case locationPickUp = "location_pick_up"
        case locationPickUpLatitude = "location_pick_up_latitude"
        case locationPickUpLongitude = "location_pick_up_longitude"
        case locationPickUpDetail = "location_pick_up_detail"
        case photoUrl = "photo_url"
        case locationPhotos = "location_photos"
    }
}

class MyPurchaseDetailCustomerItemPhotoResponse: Codable {
    
    let frontSide: String?
    let backSide: String?
    
    enum CodingKeys: String, CodingKey {
        case frontSide = "front_side"
        case backSide = "back_side"
    }
}

class MyPurchaseDetailAgentPhotoResponse: Codable {
    
    let id: Int
    let photoURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case photoURL = "photo_url"
    }
}

class MyPurchaseDetailGracePeriodResponse: Codable {
    
    let date: String
    let ended: Bool
}

class MyPurchaseDetailSellerResponse: Codable {
    
    let name: String?
    let phone: String?
    let sellerId: Int?
    let photoUrl: String?
    let address: MyPurchaseDetailSellerAddressResponse?
    
    enum CodingKeys: String, CodingKey {
        case name, phone, address
        case sellerId = "seller_id"
        case photoUrl = "photo_url"
    }
}

class MyPurchaseDetailSellerAddressResponse: Codable {
    
    let id: Int?
    let code: String?
    let longitude: String?
    let langitude: String?
    let placeName: String?
    let cityName: String?
    let provinceName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, code, longitude, langitude
        case placeName = "place_name"
        case cityName = "city_name"
        case provinceName = "province_name"
    }
}
