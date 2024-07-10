//
//  CheckoutAddRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 29/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct CheckoutAddRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path = Constants.Endpoint + "checkout"
    
    var parameters: [String : Any]? {
        var params: [String: Any] = [
            "customer_item_id": customerItemId,
            "collection_method_id": collectionMethodId,
            "delivery_fee": deliveryFee
        ]
        
        if let toAgentId = toAgentId {
            params["to_agent_id"] = toAgentId
        }
        
        if let customerAddressId = customerAddressId {
            params["customer_address_id"] = customerAddressId
        }
        
        return params
    }
    
    var customerItemId: [Int]
    var collectionMethodId: Int
    var deliveryFee: Int
    var toAgentId: Int?
    var customerAddressId: Int?
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: path)!
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.method = method
        urlRequest.timeoutInterval = 120
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
