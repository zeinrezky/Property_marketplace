//
//  RequestAcceptRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 14/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct RequestAcceptRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var path = Constants.Endpoint + "request/accept"
    
    var parameters: [String : Any]? {
        return [
            "item_ready_date": date,
            "change_request_id": id
        ]
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var id: Int
    var date: String
    
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
