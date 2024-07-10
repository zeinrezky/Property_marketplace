//
//  CheckoutCancelRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 21/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import Alamofire

struct CheckoutCancelRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path = Constants.Endpoint + "purchase/cancel"
    
    var parameters: [String : Any]? {
        return [
            "transaction_id": transactionCode
        ]
    }
    
    var transactionCode: Int
    
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
