//
//  SellCreateRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct SellCreateRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path = Constants.Endpoint + "seller/sell-item/create"
    
    var parameters: [String : Any]? {
        var params: [String : Any] = [
            "item_id": itemId,
            "description": description,
            "sell_type_id": sellTypeId
        ]
        
        if let yourPrice = yourPrice {
            params["your_price"] = yourPrice
        }
        
        if let validUntilDate = validUntilDate {
            params["valid_until_date"] = validUntilDate
        }
        
        if let confidental = confidental {
            params["confidential_information"] = confidental
        }
        
        if let confidentalPhoto = confidentalPhoto {
            params["multiple_photos"] = confidentalPhoto
        }
        
        if let itemPhotos = itemPhotos {
            params["item_photos"] = itemPhotos
        }
        
        if let quantity = quantity {
            params["quantity"] = quantity
        }
        
        if let customerItemsValue = customerItemsValue {
            params["customer_items_value"] = customerItemsValue
        }
        
        if let studioNNumber = studioNNumber {
            params["studio_number"] = studioNNumber
        }
        
        return params
    }
    
    var itemId: Int
    var yourPrice: Int?
    var description: String
    var sellTypeId: Int
    var validUntilDate: String?
    var confidental: String?
    var quantity: Int?
    var confidentalPhoto: [Int]?
    var itemPhotos: [Int]?
    var customerItemsValue: [String]?
    var studioNNumber: String?
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: path)!
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.method = method
        urlRequest.timeoutInterval = 120000
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest;
    }
}
