//
//  SellItemDetailRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct SellItemDetailRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var parameters: [String : Any]? {
        var params: [String : Any] = [
            "name": name,
            "type_id": typeId ?? 1,
            "category_id": categoryId
        ]
        
        if let yourPrice = yourPrice {
            params["your_price"] = yourPrice
        }
        
        return params
    }
    var path = Constants.Endpoint + "seller/sell-item/item-detail"
    
    var name: String
    var typeId: Int?
    var categoryId: Int
    var yourPrice: Int?
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: path)!
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.method = method
        urlRequest.timeoutInterval = 120
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        return urlRequest;
    }
}
