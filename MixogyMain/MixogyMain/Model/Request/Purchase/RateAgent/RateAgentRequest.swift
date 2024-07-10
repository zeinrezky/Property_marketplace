//
//  RateAgentRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 25/10/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct RateAgentRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path: String {
        return Constants.Endpoint + "\(type)/rating"
    }
    
    var parameters: [String : Any]? {
        return [
            "rating": rating,
            paramIdType: transactionDetailId,
            "comment": comment
        ]
    }
    
    var rating: Int
    var transactionDetailId: Int
    var comment: String
    var type: String
    var paramIdType: String
    
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
