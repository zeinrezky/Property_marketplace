//
//  CancelListingRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct CancelListingRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path = Constants.Endpoint + "seller/cancel-listing"
    
    var parameters: [String : Any]? {
        var params: [String: Any] = [
            "customer_item_id": customerItemId
        ]
        
        if let reasonId = reasonId {
            params["reason_id"] = reasonId
        }
        
        if let comment = comment {
            params["comment"] = comment
        }
        
        return params
    }
    
    var customerItemId: Int
    var reasonId: Int?
    var comment: String?
    
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
