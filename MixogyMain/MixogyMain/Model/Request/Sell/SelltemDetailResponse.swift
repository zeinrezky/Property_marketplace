//
//  SellHistoryDetailResponse.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

class SelltemDetailResponse: Codable {
    
    let customerItem: SelltemDetailCustomerItemResponse
    let agent: SelltemDetailAgentResponse?
    let buyer: SelltemDetailBuyerResponse?
    
    enum CodingKeys: String, CodingKey {
        case agent, buyer
        case customerItem = "customer_item"
    }
}

class SelltemHistoryDetailResponse: Codable {
    
    let customerItem: SelltemDetailCustomerItemResponse
    let agent: SelltemDetailAgentResponse?
    
    enum CodingKeys: String, CodingKey {
        case agent
        case customerItem = "customer_item"
    }
}

class SelltemDetailCustomerItemResponse: Codable {
    
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
    let itemPhotos: SelltemDetailCustomerItemPhotoResponse
    let itemImage: String
    let statusId: Int
    let status: String
    let gracePeriod: SelltemDetailGracePeriodResponse?
    let receive: Int
    let yourPrice: Int
    let courierName: String?
    let resiNumber: String?
    let contactNumber: String?
    let transactionDetailId: Int?
    let confidentialInformation: String?
    let confidential_photos: [MyPurchaseDetailAgentPhotoResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id, code, name, type, seat, date, location, category, description, status, receive
        case qrPhotoUrl = "qr_photo_url"
        case itemPhotos = "item_photos"
        case itemImage = "item_image"
        case statusId = "status_id"
        case gracePeriod = "grace_period"
        case courierName = "courier_name"
        case resiNumber = "resi_number"
        case contactNumber = "contact_number"
        case transactionDetailId = "transaction_detail_id"
        case yourPrice = "your_price"
        case confidentialInformation = "confidential_information"
        case confidential_photos = "confidential_photos"
    }
}

class SelltemDetailAgentResponse: Codable {
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
    let locationPhotos: [SelltemDetailAgentPhotoResponse]
    
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

class SelltemDetailCustomerItemPhotoResponse: Codable {
    
    let frontSide: String?
    let backSide: String?
    
    enum CodingKeys: String, CodingKey {
        case frontSide = "front_side"
        case backSide = "back_side"
    }
}

class SelltemDetailAgentPhotoResponse: Codable {
    
    let photoURL: String
    
    enum CodingKeys: String, CodingKey {
        case photoURL = "photo_url"
    }
}

class SelltemDetailGracePeriodResponse: Codable {
    
    let date: String
    let ended: Bool
}

class SelltemDetailBuyerResponse: Codable {
    
    let name: String?
    let phone: String?
    let buyerId: Int?
    let photoUrl: String?
    let address: SelltemDetailBuyerAddressResponse?
    
    enum CodingKeys: String, CodingKey {
        case name, phone, address
        case buyerId = "buyer_id"
        case photoUrl = "photo_url"
    }
}

class SelltemDetailBuyerAddressResponse: Codable {
    
    let id: Int?
    let code: String?
    let detail: String?
    let phone: String?
    let longitude: String?
    let langitude: String?
    let placeName: String?
    let cityName: String?
    let provinceName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, code, phone, longitude, langitude, detail
        case placeName = "place_name"
        case cityName = "city_name"
        case provinceName = "province_name"
    }
}
